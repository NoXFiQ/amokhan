#!/bin/bash

# ============================================================================
#                     COMPLETE SLOWDNS INSTALLATION SCRIPT
#                         WITH MANAGEMENT DASHBOARD
# ============================================================================

# Ensure running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "\033[0;31m[ERROR]\033[0m Please run this script as root"
    exit 1
fi

# ============================================================================
# CONFIGURATION
# ============================================================================
SSHD_PORT=22
SLOWDNS_PORT=5300
GITHUB_BASE="https://github.com/khairunisya/am/raw/main"

# ============================================================================
# COLORS
# ============================================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

# ============================================================================
# INSTALLATION FUNCTION
# ============================================================================
install_slowdns() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}         ${YELLOW}SLOWDNS INSTALLATION WIZARD${NC}                  ${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Get nameserver
    echo -e "${WHITE}Enter your nameserver (e.g., ns.yourdomain.com):${NC}"
    read -p "> " NAMESERVER
    
    if [ -z "$NAMESERVER" ]; then
        echo -e "${RED}Error: Nameserver cannot be empty${NC}"
        return 1
    fi
    
    # Get server IP
    echo -ne "${CYAN}Detecting server IP...${NC}"
    SERVER_IP=$(curl -s --connect-timeout 5 ifconfig.me)
    if [ -z "$SERVER_IP" ]; then
        SERVER_IP=$(hostname -I | awk '{print $1}')
    fi
    echo -e " ${GREEN}$SERVER_IP${NC}"
    
    # Update system
    echo -e "${YELLOW}[1/8] Updating system...${NC}"
    apt update -y > /dev/null 2>&1
    apt install -y wget curl build-essential socat dnsutils net-tools iptables > /dev/null 2>&1
    
    # Create directory
    echo -e "${YELLOW}[2/8] Creating SlowDNS directory...${NC}"
    rm -rf /etc/slowdns
    mkdir -p /etc/slowdns
    cd /etc/slowdns
    
    # Download binaries
    echo -e "${YELLOW}[3/8] Downloading SlowDNS binaries...${NC}"
    wget -q -O dnstt-server $GITHUB_BASE/dnstt-server
    wget -q -O dnstt-client $GITHUB_BASE/dnstt-client
    
    if [ ! -f "dnstt-server" ] || [ ! -s "dnstt-server" ]; then
        echo -e "${RED}Failed to download binaries. Trying alternative source...${NC}"
        curl -L -o dnstt-server https://github.com/x2ox/dnstt/releases/download/v1.0/dnstt-server.linux.amd64
        curl -L -o dnstt-client https://github.com/x2ox/dnstt/releases/download/v1.0/dnstt-client.linux.amd64
    fi
    
    chmod +x dnstt-server dnstt-client
    
    # Generate keys
    echo -e "${YELLOW}[4/8] Generating encryption keys...${NC}"
    ./dnstt-server -gen-key -privkey-file server.key -pubkey-file server.pub
    PUBKEY=$(cat server.pub)
    
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

[Service]
Type=simple
ExecStart=/usr/bin/socat UDP-LISTEN:53,fork,reuseaddr UDP:127.0.0.1:5300
Restart=always
RestartSec=3

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
    systemctl start slowdns dns-proxy
    
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
    echo -e "${GREEN}║${NC} ${YELLOW}PUBLIC KEY (save this):${NC}"
    echo -e "${GREEN}║${NC} ${CYAN}$PUBKEY${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
    
    # Save public key to file
    echo "$PUBKEY" > /root/slowdns-pubkey.txt
    echo -e "${GREEN}Public key saved to: /root/slowdns-pubkey.txt${NC}"
    
    read -p "Press Enter to continue to management menu..."
}

# ============================================================================
# MANAGEMENT MENU
# ============================================================================
show_menu() {
    while true; do
        clear
        echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
        echo -e "${BLUE}║${NC}           ${YELLOW}SLOWDNS MANAGEMENT DASHBOARD${NC}                ${BLUE}║${NC}"
        echo -e "${BLUE}╠══════════════════════════════════════════════════════════╣${NC}"
        
        # Get current status
        SLOWDNS_STATUS=$(systemctl is-active slowdns 2>/dev/null)
        DNS_STATUS=$(systemctl is-active dns-proxy 2>/dev/null)
        SERVER_IP=$(curl -s --connect-timeout 2 ifconfig.me 2>/dev/null || hostname -I | awk '{print $1}')
        
        # Status indicators
        if [ "$SLOWDNS_STATUS" = "active" ]; then
            SLOWDNS_ICON="${GREEN}● RUNNING${NC}"
        else
            SLOWDNS_ICON="${RED}● STOPPED${NC}"
        fi
        
        if [ "$DNS_STATUS" = "active" ]; then
            DNS_ICON="${GREEN}● RUNNING${NC}"
        else
            DNS_ICON="${RED}● STOPPED${NC}"
        fi
        
        echo -e "${BLUE}║${NC} ${WHITE}Server IP:${NC} $SERVER_IP"
        echo -e "${BLUE}║${NC} ${WHITE}SlowDNS:${NC}   $SLOWDNS_ICON"
        echo -e "${BLUE}║${NC} ${WHITE}DNS Proxy:${NC}  $DNS_ICON"
        echo -e "${BLUE}╠══════════════════════════════════════════════════════════╣${NC}"
        echo -e "${BLUE}║${NC} ${YELLOW}1.${NC} View SlowDNS Logs"
        echo -e "${BLUE}║${NC} ${YELLOW}2.${NC} View DNS Proxy Logs"
        echo -e "${BLUE}║${NC} ${YELLOW}3.${NC} Restart All Services"
        echo -e "${BLUE}║${NC} ${YELLOW}4.${NC} Stop All Services"
        echo -e "${BLUE}║${NC} ${YELLOW}5.${NC} Start All Services"
        echo -e "${BLUE}║${NC} ${YELLOW}6.${NC} Show Public Key"
        echo -e "${BLUE}║${NC} ${YELLOW}7.${NC} Test DNS Resolution"
        echo -e "${BLUE}║${NC} ${YELLOW}8.${NC} Check Listening Ports"
        echo -e "${BLUE}║${NC} ${YELLOW}9.${NC} Show Connection Statistics"
        echo -e "${BLUE}║${NC} ${YELLOW}10.${NC} View Active Connections"
        echo -e "${BLUE}║${NC} ${YELLOW}11.${NC} Reinstall SlowDNS"
        echo -e "${BLUE}║${NC} ${YELLOW}12.${NC} Exit"
        echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
        echo ""
        read -p "Select option [1-12]: " choice

        case $choice in
            1)
                echo -e "${CYAN}SlowDNS Logs (Ctrl+C to exit):${NC}"
                journalctl -u slowdns -f -n 50
                ;;
            2)
                echo -e "${CYAN}DNS Proxy Logs (Ctrl+C to exit):${NC}"
                journalctl -u dns-proxy -f -n 50
                ;;
            3)
                systemctl restart slowdns dns-proxy
                echo -e "${GREEN}Services restarted successfully${NC}"
                sleep 2
                ;;
            4)
                systemctl stop slowdns dns-proxy
                echo -e "${YELLOW}Services stopped${NC}"
                sleep 2
                ;;
            5)
                systemctl start slowdns dns-proxy
                echo -e "${GREEN}Services started${NC}"
                sleep 2
                ;;
            6)
                if [ -f /etc/slowdns/server.pub ]; then
                    echo -e "${GREEN}Public Key:${NC}"
                    cat /etc/slowdns/server.pub
                else
                    echo -e "${RED}Public key not found${NC}"
                fi
                echo ""
                read -p "Press Enter to continue"
                ;;
            7)
                if [ -f /etc/systemd/system/slowdns.service ]; then
                    NAMESERVER=$(grep -oP '(?<=server.key ).*?(?= 127.0.0.1)' /etc/systemd/system/slowdns.service 2>/dev/null)
                    echo -e "${CYAN}Testing DNS for $NAMESERVER...${NC}"
                    echo -e "${YELLOW}Using dig:${NC}"
                    dig @127.0.0.1 $NAMESERVER +short
                    echo -e "\n${YELLOW}Using nslookup:${NC}"
                    nslookup $NAMESERVER 127.0.0.1
                else
                    echo -e "${RED}SlowDNS not installed${NC}"
                fi
                read -p "Press Enter to continue"
                ;;
            8)
                echo -e "${CYAN}Listening Ports:${NC}"
                echo -e "${YELLOW}UDP Ports:${NC}"
                ss -ulpn | grep -E ':53|:5300'
                echo -e "\n${YELLOW}TCP Ports:${NC}"
                ss -tlnp | grep -E ':22'
                read -p "Press Enter to continue"
                ;;
            9)
                echo -e "${CYAN}Service Statistics:${NC}"
                echo -e "${YELLOW}SlowDNS Processes:${NC}"
                ps aux | grep dnstt-server | grep -v grep
                echo -e "\n${YELLOW}DNS Proxy Processes:${NC}"
                ps aux | grep socat | grep -v grep
                echo -e "\n${YELLOW}Memory Usage:${NC}"
                ps aux | grep -E 'dnstt-server|socat' | grep -v grep | awk '{print $4"% CPU - " $5"% MEM"}'
                read -p "Press Enter to continue"
                ;;
            10)
                echo -e "${CYAN}Active UDP Connections:${NC}"
                netstat -uan | grep -E ':53|:5300' | grep ESTABLISHED
                echo -e "\n${YELLOW}Total connections: $(netstat -uan | grep -E ':53|:5300' | wc -l)"
                read -p "Press Enter to continue"
                ;;
            11)
                read -p "Are you sure you want to reinstall? (y/n): " confirm
                if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
                    systemctl stop slowdns dns-proxy
                    install_slowdns
                fi
                ;;
            12)
                echo -e "${GREEN}Exiting management menu. Goodbye!${NC}"
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
# MAIN FUNCTION
# ============================================================================
main() {
    # Check if already installed
    if [ -f /etc/systemd/system/slowdns.service ] && [ -f /etc/slowdns/server.pub ]; then
        clear
        echo -e "${YELLOW}SlowDNS appears to be already installed.${NC}"
        echo -e "1) Open Management Menu"
        echo -e "2) Reinstall"
        echo -e "3) Exit"
        read -p "Select option [1-3]: " opt
        
        case $opt in
            1)
                show_menu
                ;;
            2)
                install_slowdns
                show_menu
                ;;
            *)
                exit 0
                ;;
        esac
    else
        install_slowdns
        show_menu
    fi
}

# ============================================================================
# TRAP AND RUN
# ============================================================================
trap 'echo -e "\n${RED}Script interrupted${NC}"; exit 1' INT

# Start main function
main
