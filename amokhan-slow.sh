#!/bin/bash

# ============================================================================
#                     COMPLETE FIXED SLOWDNS INSTALLATION
#                         WITH AUTO-RECOVERY SYSTEM
# ============================================================================

# Ensure running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "\033[0;31m[ERROR]\033[0m Please run this script as root"
    exit 1
fi

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Configuration
SSHD_PORT=22
SLOWDNS_PORT=5300

# ============================================================================
# FIX FUNCTION - Run this first if having issues
# ============================================================================
fix_installation() {
    echo -e "${YELLOW}Running diagnostic and fix...${NC}"
    
    # Stop services
    systemctl stop slowdns dns-proxy 2>/dev/null
    killall dnstt-server socat 2>/dev/null
    
    # Check if binaries exist
    if [ ! -f "/etc/slowdns/dnstt-server" ]; then
        echo -e "${RED}Binaries missing, will reinstall${NC}"
        return 1
    fi
    
    # Generate keys if missing
    if [ ! -f "/etc/slowdns/server.key" ] || [ ! -f "/etc/slowdns/server.pub" ]; then
        echo -e "${YELLOW}Generating missing keys...${NC}"
        cd /etc/slowdns
        ./dnstt-server -gen-key -privkey-file server.key -pubkey-file server.pub
    fi
    
    # Fix permissions
    chmod 600 /etc/slowdns/server.key
    chmod 644 /etc/slowdns/server.pub
    chmod +x /etc/slowdns/dnstt-server
    
    # Fix service files
    if [ -f "/etc/systemd/system/slowdns.service" ]; then
        NAMESERVER=$(grep -oP '(?<=server.key ).*?(?= 127.0.0.1)' /etc/systemd/system/slowdns.service 2>/dev/null)
        if [ -n "$NAMESERVER" ]; then
            cat > /etc/systemd/system/slowdns.service << EOF
[Unit]
Description=SlowDNS Server
After=network.target

[Service]
Type=simple
WorkingDirectory=/etc/slowdns
ExecStart=/etc/slowdns/dnstt-server -udp :$SLOWDNS_PORT -privkey-file /etc/slowdns/server.key $NAMESERVER 127.0.0.1:$SSHD_PORT
Restart=always
RestartSec=5
User=root
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF
        fi
    fi
    
    # Reload systemd
    systemctl daemon-reload
    
    # Clear ports
    fuser -k 53/udp 2>/dev/null
    fuser -k 5300/udp 2>/dev/null
    
    # Start services
    systemctl start slowdns
    systemctl start dns-proxy
    
    sleep 3
    
    # Check status
    if systemctl is-active --quiet slowdns; then
        echo -e "${GREEN}✓ SlowDNS is now running${NC}"
    else
        echo -e "${RED}✗ SlowDNS failed to start${NC}"
    fi
    
    if [ -f "/etc/slowdns/server.pub" ]; then
        echo -e "${GREEN}✓ Public key exists${NC}"
    else
        echo -e "${RED}✗ Public key still missing${NC}"
    fi
}

# ============================================================================
# INSTALLATION FUNCTION
# ============================================================================
install_slowdns() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}           ${WHITE}SLOWDNS INSTALLATION SCRIPT${NC}                  ${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Get nameserver
    echo -e "${YELLOW}Enter your nameserver (e.g., ns.yourdomain.com):${NC}"
    read -p "> " NAMESERVER
    
    if [ -z "$NAMESERVER" ]; then
        echo -e "${RED}Error: Nameserver cannot be empty${NC}"
        return 1
    fi
    
    # Get server IP
    echo -ne "${CYAN}Detecting server IP...${NC}"
    SERVER_IP=$(curl -s --connect-timeout 5 ifconfig.me 2>/dev/null)
    if [ -z "$SERVER_IP" ]; then
        SERVER_IP=$(hostname -I | awk '{print $1}')
    fi
    echo -e " ${GREEN}$SERVER_IP${NC}"
    
    # Update system
    echo -e "${YELLOW}[1/8] Updating system...${NC}"
    apt update -y > /dev/null 2>&1
    apt install -y wget curl build-essential socat dnsutils net-tools iptables psmisc > /dev/null 2>&1
    
    # Clean previous installation
    echo -e "${YELLOW}[2/8] Cleaning previous installation...${NC}"
    systemctl stop slowdns dns-proxy 2>/dev/null
    systemctl disable slowdns dns-proxy 2>/dev/null
    rm -rf /etc/systemd/system/slowdns.service /etc/systemd/system/dns-proxy.service
    rm -rf /etc/slowdns
    mkdir -p /etc/slowdns
    cd /etc/slowdns
    
    # Download binaries with multiple sources
    echo -e "${YELLOW}[3/8] Downloading SlowDNS binaries...${NC}"
    
    # Try multiple download sources
    wget -q -O dnstt-server https://github.com/khairunisya/am/raw/main/dnstt-server || \
    wget -q -O dnstt-server https://github.com/x2ox/dnstt/releases/download/v1.0/dnstt-server.linux.amd64 || \
    curl -L -o dnstt-server https://github.com/x2ox/dnstt/releases/download/v1.0/dnstt-server.linux.amd64
    
    wget -q -O dnstt-client https://github.com/khairunisya/am/raw/main/dnstt-client || \
    wget -q -O dnstt-client https://github.com/x2ox/dnstt/releases/download/v1.0/dnstt-client.linux.amd64 || \
    curl -L -o dnstt-client https://github.com/x2ox/dnstt/releases/download/v1.0/dnstt-client.linux.amd64
    
    # Check if downloads succeeded
    if [ ! -f "dnstt-server" ] || [ ! -s "dnstt-server" ]; then
        echo -e "${RED}Failed to download binaries. Building from source...${NC}"
        apt install -y golang-go git > /dev/null 2>&1
        git clone https://git.torproject.org/boltdistro.git
        cd boltdistro/dnstt
        go build -o dnstt-server dnstt-server/dnstt-server.go
        go build -o dnstt-client dnstt-client/dnstt-client.go
        cp dnstt-server dnstt-client /etc/slowdns/
        cd /etc/slowdns
    fi
    
    chmod +x dnstt-server dnstt-client
    
    # Generate keys
    echo -e "${YELLOW}[4/8] Generating encryption keys...${NC}"
    ./dnstt-server -gen-key -privkey-file server.key -pubkey-file server.pub
    
    # Verify keys were generated
    if [ ! -f "server.pub" ] || [ ! -s "server.pub" ]; then
        echo -e "${RED}Key generation failed. Trying alternative method...${NC}"
        openssl rand -base64 32 > server.key
        openssl rand -base64 32 > server.pub
        echo -e "${YELLOW}Warning: Generated temporary keys${NC}"
    fi
    
    PUBKEY=$(cat server.pub 2>/dev/null || echo "Key generation failed")
    
    # Stop conflicting services
    echo -e "${YELLOW}[5/8] Stopping conflicting services...${NC}"
    systemctl stop systemd-resolved 2>/dev/null
    systemctl disable systemd-resolved 2>/dev/null
    fuser -k 53/udp 2>/dev/null
    fuser -k 5300/udp 2>/dev/null
    
    # Create SlowDNS service
    echo -e "${YELLOW}[6/8] Creating SlowDNS service...${NC}"
    cat > /etc/systemd/system/slowdns.service << EOF
[Unit]
Description=SlowDNS Server
After=network.target

[Service]
Type=simple
WorkingDirectory=/etc/slowdns
ExecStart=/etc/slowdns/dnstt-server -udp :$SLOWDNS_PORT -privkey-file /etc/slowdns/server.key $NAMESERVER 127.0.0.1:$SSHD_PORT
Restart=always
RestartSec=5
User=root
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

    # Create DNS proxy service
    echo -e "${YELLOW}[7/8] Creating DNS proxy service...${NC}"
    cat > /etc/systemd/system/dns-proxy.service << 'EOF'
[Unit]
Description=DNS Proxy Service
After=network.target
Requires=slowdns.service

[Service]
Type=simple
ExecStartPre=/bin/sleep 5
ExecStart=/usr/bin/socat UDP-LISTEN:53,fork,reuseaddr UDP:127.0.0.1:5300
Restart=always
RestartSec=3
User=root

[Install]
WantedBy=multi-user.target
EOF

    # Configure firewall
    echo -e "${YELLOW}[8/8] Configuring firewall...${NC}"
    iptables -F
    iptables -A INPUT -p udp --dport 5300 -j ACCEPT
    iptables -A INPUT -p udp --dport 53 -j ACCEPT
    iptables -A INPUT -p tcp --dport 22 -j ACCEPT
    iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    
    # Save iptables
    apt install -y iptables-persistent > /dev/null 2>&1
    netfilter-persistent save > /dev/null 2>&1
    
    # Start services
    systemctl daemon-reload
    systemctl enable slowdns dns-proxy
    systemctl start slowdns
    sleep 3
    systemctl start dns-proxy
    
    # Final check
    sleep 3
    
    clear
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}              INSTALLATION COMPLETE!                     ${GREEN}║${NC}"
    echo -e "${GREEN}╠══════════════════════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║${NC} Server IP:     ${WHITE}$SERVER_IP${NC}"
    echo -e "${GREEN}║${NC} Nameserver:    ${WHITE}$NAMESERVER${NC}"
    echo -e "${GREEN}║${NC} SlowDNS Port:  ${WHITE}5300 (UDP)${NC}"
    echo -e "${GREEN}║${NC} DNS Port:      ${WHITE}53 (UDP)${NC}"
    echo -e "${GREEN}╠══════════════════════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║${NC} ${YELLOW}PUBLIC KEY:${NC}"
    echo -e "${GREEN}║${NC} ${CYAN}$PUBKEY${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
    
    # Save public key
    echo "$PUBKEY" > /root/slowdns-pubkey.txt
    echo "$PUBKEY" > /etc/slowdns/public-key.txt
    echo -e "${GREEN}Public key saved to: /root/slowdns-pubkey.txt${NC}"
}

# ============================================================================
# MANAGEMENT MENU
# ============================================================================
show_menu() {
    while true; do
        clear
        echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
        echo -e "${BLUE}║${NC}           ${WHITE}SLOWDNS MANAGEMENT DASHBOARD${NC}                 ${BLUE}║${NC}"
        echo -e "${BLUE}╠══════════════════════════════════════════════════════════╣${NC}"
        
        # Get current status
        SLOWDNS_STATUS=$(systemctl is-active slowdns 2>/dev/null)
        DNS_STATUS=$(systemctl is-active dns-proxy 2>/dev/null)
        
        # Check if public key exists
        if [ -f "/etc/slowdns/server.pub" ]; then
            PUBKEY_EXISTS="${GREEN}✓ EXISTS${NC}"
            PUBKEY=$(cat /etc/slowdns/server.pub | head -1)
        else
            PUBKEY_EXISTS="${RED}✗ MISSING${NC}"
            PUBKEY="No public key found"
        fi
        
        # Check port 5300
        if ss -ulpn | grep -q ":5300"; then
            PORT5300="${GREEN}LISTENING${NC}"
        else
            PORT5300="${RED}NOT LISTENING${NC}"
        fi
        
        # Check port 53
        if ss -ulpn | grep -q ":53"; then
            PORT53="${GREEN}LISTENING${NC}"
        else
            PORT53="${RED}NOT LISTENING${NC}"
        fi
        
        echo -e "${BLUE}║${NC} ${WHITE}SlowDNS Service:${NC}  $(if [ "$SLOWDNS_STATUS" = "active" ]; then echo "${GREEN}● RUNNING${NC}"; else echo "${RED}● STOPPED${NC}"; fi)"
        echo -e "${BLUE}║${NC} ${WHITE}DNS Proxy Service:${NC} $(if [ "$DNS_STATUS" = "active" ]; then echo "${GREEN}● RUNNING${NC}"; else echo "${RED}● STOPPED${NC}"; fi)"
        echo -e "${BLUE}║${NC} ${WHITE}Port 5300:${NC}        $PORT5300"
        echo -e "${BLUE}║${NC} ${WHITE}Port 53:${NC}          $PORT53"
        echo -e "${BLUE}║${NC} ${WHITE}Public Key:${NC}       $PUBKEY_EXISTS"
        echo -e "${BLUE}╠══════════════════════════════════════════════════════════╣${NC}"
        echo -e "${BLUE}║${NC} ${YELLOW}1.${NC} Fix All Problems (Run Diagnostic)"
        echo -e "${BLUE}║${NC} ${YELLOW}2.${NC} View SlowDNS Logs"
        echo -e "${BLUE}║${NC} ${YELLOW}3.${NC} Restart Services"
        echo -e "${BLUE}║${NC} ${YELLOW}4.${NC} Stop Services"
        echo -e "${BLUE}║${NC} ${YELLOW}5.${NC} Start Services"
        echo -e "${BLUE}║${NC} ${YELLOW}6.${NC} Show Public Key"
        echo -e "${BLUE}║${NC} ${YELLOW}7.${NC} Regenerate Public Key"
        echo -e "${BLUE}║${NC} ${YELLOW}8.${NC} Test DNS Resolution"
        echo -e "${BLUE}║${NC} ${YELLOW}9.${NC} Check Ports"
        echo -e "${BLUE}║${NC} ${YELLOW}10.${NC} View Connection Stats"
        echo -e "${BLUE}║${NC} ${YELLOW}11.${NC} Reinstall SlowDNS"
        echo -e "${BLUE}║${NC} ${YELLOW}12.${NC} Exit"
        echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
        echo ""
        read -p "Select option [1-12]: " choice

        case $choice in
            1)
                echo -e "${YELLOW}Running diagnostic and fix...${NC}"
                fix_installation
                read -p "Press Enter to continue"
                ;;
            2)
                echo -e "${CYAN}SlowDNS Logs (Ctrl+C to exit):${NC}"
                journalctl -u slowdns -f -n 50
                ;;
            3)
                systemctl restart slowdns
                sleep 2
                systemctl restart dns-proxy
                echo -e "${GREEN}Services restarted${NC}"
                sleep 2
                ;;
            4)
                systemctl stop slowdns dns-proxy
                echo -e "${YELLOW}Services stopped${NC}"
                sleep 2
                ;;
            5)
                systemctl start slowdns
                sleep 2
                systemctl start dns-proxy
                echo -e "${GREEN}Services started${NC}"
                sleep 2
                ;;
            6)
                if [ -f "/etc/slowdns/server.pub" ]; then
                    echo -e "${GREEN}Public Key:${NC}"
                    echo "========================"
                    cat /etc/slowdns/server.pub
                    echo "========================"
                else
                    echo -e "${RED}Public key not found${NC}"
                fi
                read -p "Press Enter to continue"
                ;;
            7)
                echo -e "${YELLOW}Regenerating public key...${NC}"
                cd /etc/slowdns
                mv server.key server.key.bak 2>/dev/null
                mv server.pub server.pub.bak 2>/dev/null
                ./dnstt-server -gen-key -privkey-file server.key -pubkey-file server.pub
                systemctl restart slowdns
                echo -e "${GREEN}New public key generated${NC}"
                sleep 2
                ;;
            8)
                if [ -f "/etc/systemd/system/slowdns.service" ]; then
                    NAMESERVER=$(grep -oP '(?<=server.key ).*?(?= 127.0.0.1)' /etc/systemd/system/slowdns.service 2>/dev/null)
                    if [ -n "$NAMESERVER" ]; then
                        echo -e "${CYAN}Testing DNS for $NAMESERVER...${NC}"
                        dig @127.0.0.1 $NAMESERVER +short
                    else
                        echo -e "${RED}Could not detect nameserver${NC}"
                    fi
                fi
                read -p "Press Enter to continue"
                ;;
            9)
                echo -e "${CYAN}Port Status:${NC}"
                echo "Port 5300: $(ss -ulpn | grep -q ":5300" && echo "${GREEN}LISTENING${NC}" || echo "${RED}NOT LISTENING${NC}")"
                echo "Port 53:   $(ss -ulpn | grep -q ":53" && echo "${GREEN}LISTENING${NC}" || echo "${RED}NOT LISTENING${NC}")"
                read -p "Press Enter to continue"
                ;;
            10)
                echo -e "${CYAN}Connection Statistics:${NC}"
                echo "SlowDNS processes: $(ps aux | grep dnstt-server | grep -v grep | wc -l)"
                echo "Active UDP connections: $(netstat -uan | grep -E ':5300' | wc -l)"
                read -p "Press Enter to continue"
                ;;
            11)
                read -p "Reinstall SlowDNS? (y/n): " confirm
                if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
                    install_slowdns
                fi
                ;;
            12)
                echo -e "${GREEN}Exiting...${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option${NC}"
                sleep 1
                ;;
        esac
    done
}

# ============================================================================
# MAIN
# ============================================================================
clear
echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}           ${WHITE}SLOWDNS INSTALLATION & FIX TOOL${NC}                ${BLUE}║${NC}"
echo -e "${BLUE}╠══════════════════════════════════════════════════════════╣${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}1.${NC} Install SlowDNS (Fresh Install)"
echo -e "${BLUE}║${NC} ${YELLOW}2.${NC} Fix Existing Installation"
echo -e "${BLUE}║${NC} ${YELLOW}3.${NC} Open Management Menu"
echo -e "${BLUE}║${NC} ${YELLOW}4.${NC} Exit"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
read -p "Select option [1-4]: " main_choice

case $main_choice in
    1)
        install_slowdns
        show_menu
        ;;
    2)
        fix_installation
        show_menu
        ;;
    3)
        show_menu
        ;;
    *)
        exit 0
        ;;
esac
