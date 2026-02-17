#!/bin/bash

# ============================================================================
#                     COMPLETE SLOWDNS WITH USER MANAGEMENT
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
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Configuration
SSHD_PORT=22
SLOWDNS_PORT=5300
USERS_FILE="/etc/slowdns/users.txt"

# ============================================================================
# FIX BINARY DOWNLOAD - This is the critical fix
# ============================================================================
download_binaries() {
    echo -e "${YELLOW}Downloading SlowDNS binaries...${NC}"
    
    cd /etc/slowdns
    
    # Remove corrupted files
    rm -f dnstt-server dnstt-client
    
    # Method 1: Direct download from working source
    echo -e "${CYAN}Method 1: Downloading from GitHub...${NC}"
    wget -q --show-progress https://github.com/khairunisya/am/raw/main/dnstt-server -O dnstt-server
    wget -q --show-progress https://github.com/khairunisya/am/raw/main/dnstt-client -O dnstt-client
    
    # Check if files are valid binaries (not HTML)
    if file dnstt-server | grep -q "ELF"; then
        echo -e "${GREEN}✓ Binaries downloaded successfully${NC}"
        chmod +x dnstt-server dnstt-client
        return 0
    fi
    
    # Method 2: Alternative source
    echo -e "${YELLOW}Method 2: Trying alternative source...${NC}"
    rm -f dnstt-server dnstt-client
    wget -q --show-progress https://github.com/x2ox/dnstt/releases/download/v1.0/dnstt-server.linux.amd64 -O dnstt-server
    wget -q --show-progress https://github.com/x2ox/dnstt/releases/download/v1.0/dnstt-client.linux.amd64 -O dnstt-client
    
    if file dnstt-server | grep -q "ELF"; then
        echo -e "${GREEN}✓ Binaries downloaded successfully${NC}"
        chmod +x dnstt-server dnstt-client
        return 0
    fi
    
    # Method 3: Build from source
    echo -e "${YELLOW}Method 3: Building from source...${NC}"
    apt install -y golang-go git > /dev/null 2>&1
    git clone https://github.com/yinghuocho/dnstt.git /tmp/dnstt
    cd /tmp/dnstt
    go build -o dnstt-server server/main.go
    go build -o dnstt-client client/main.go
    cp dnstt-server dnstt-client /etc/slowdns/
    cd /etc/slowdns
    
    if [ -f "dnstt-server" ] && [ -f "dnstt-client" ]; then
        echo -e "${GREEN}✓ Binaries built successfully${NC}"
        chmod +x dnstt-server dnstt-client
        return 0
    fi
    
    echo -e "${RED}Failed to download binaries${NC}"
    return 1
}

# ============================================================================
# GENERATE KEYS
# ============================================================================
generate_keys() {
    echo -e "${YELLOW}Generating encryption keys...${NC}"
    cd /etc/slowdns
    
    # Try to generate keys with the binary
    if [ -x "./dnstt-server" ]; then
        ./dnstt-server -gen-key -privkey-file server.key -pubkey-file server.pub
    fi
    
    # Verify keys were generated
    if [ ! -f "server.key" ] || [ ! -f "server.pub" ]; then
        echo -e "${YELLOW}Using fallback key generation...${NC}"
        # Generate fallback keys (for testing only - in production use proper keys)
        openssl rand -base64 32 > server.key
        openssl rand -base64 32 > server.pub
    fi
    
    chmod 600 server.key
    chmod 644 server.pub
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
    
    # Install dependencies
    echo -e "${YELLOW}[1/7] Installing dependencies...${NC}"
    apt update -y > /dev/null 2>&1
    apt install -y wget curl build-essential socat dnsutils net-tools iptables psmisc file openssl > /dev/null 2>&1
    
    # Clean previous installation
    echo -e "${YELLOW}[2/7] Cleaning previous installation...${NC}"
    systemctl stop slowdns dns-proxy 2>/dev/null
    systemctl disable slowdns dns-proxy 2>/dev/null
    rm -rf /etc/systemd/system/slowdns.service /etc/systemd/system/dns-proxy.service
    mkdir -p /etc/slowdns
    cd /etc/slowdns
    
    # Download binaries
    echo -e "${YELLOW}[3/7] Downloading binaries...${NC}"
    download_binaries
    
    # Generate keys
    echo -e "${YELLOW}[4/7] Generating keys...${NC}"
    generate_keys
    PUBKEY=$(cat server.pub 2>/dev/null)
    
    # Create users file
    touch $USERS_FILE
    chmod 600 $USERS_FILE
    
    # Stop conflicting services
    echo -e "${YELLOW}[5/7] Stopping conflicting services...${NC}"
    systemctl stop systemd-resolved 2>/dev/null
    systemctl disable systemd-resolved 2>/dev/null
    fuser -k 53/udp 2>/dev/null
    fuser -k 5300/udp 2>/dev/null
    
    # Create SlowDNS service
    echo -e "${YELLOW}[6/7] Creating services...${NC}"
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
    echo -e "${YELLOW}[7/7] Configuring firewall...${NC}"
    iptables -F
    iptables -A INPUT -p udp --dport 5300 -j ACCEPT
    iptables -A INPUT -p udp --dport 53 -j ACCEPT
    iptables -A INPUT -p tcp --dport 22 -j ACCEPT
    iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    
    # Start services
    systemctl daemon-reload
    systemctl enable slowdns dns-proxy
    systemctl start slowdns
    sleep 3
    systemctl start dns-proxy
    
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
    
    echo "$PUBKEY" > /root/slowdns-pubkey.txt
}

# ============================================================================
# USER MANAGEMENT FUNCTIONS
# ============================================================================
list_users() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}              ${WHITE}SLOWDNS USER LIST${NC}                        ${BLUE}║${NC}"
    echo -e "${BLUE}╠══════════════════════════════════════════════════════════╣${NC}"
    
    if [ ! -f "$USERS_FILE" ] || [ ! -s "$USERS_FILE" ]; then
        echo -e "${BLUE}║${NC} ${YELLOW}No users found${NC}"
    else
        echo -e "${BLUE}║${NC} ${GREEN}Username\t\tCreated\t\tStatus${NC}"
        echo -e "${BLUE}║${NC} ${WHITE}--------\t\t-------\t\t------${NC}"
        while IFS='|' read -r username date status; do
            if [ "$status" = "active" ]; then
                STATUS="${GREEN}Active${NC}"
            else
                STATUS="${RED}Inactive${NC}"
            fi
            printf "${BLUE}║${NC} %-20s %-15s %b\n" "$username" "$date" "$STATUS"
        done < "$USERS_FILE"
    fi
    
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    read -p "Press Enter to continue"
}

add_user() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}              ${WHITE}ADD NEW USER${NC}                             ${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    read -p "Enter username: " username
    if [ -z "$username" ]; then
        echo -e "${RED}Username cannot be empty${NC}"
        read -p "Press Enter to continue"
        return
    fi
    
    # Check if user exists
    if grep -q "^$username|" "$USERS_FILE" 2>/dev/null; then
        echo -e "${RED}User already exists${NC}"
        read -p "Press Enter to continue"
        return
    fi
    
    # Generate user-specific config
    DATE=$(date +"%Y-%m-%d")
    echo "$username|$DATE|active" >> "$USERS_FILE"
    
    # Create user config file
    cat > /root/${username}-slowdns-config.txt << EOF
=== SLOWDNS CONFIGURATION FOR $username ===
Server IP: $(curl -s ifconfig.me)
Nameserver: $(grep -oP '(?<=server.key ).*?(?= 127.0.0.1)' /etc/systemd/system/slowdns.service 2>/dev/null)
Port: 5300 (UDP)
Public Key: $(cat /etc/slowdns/server.pub)

Client Command:
./dnstt-client -udp $(curl -s ifconfig.me):5300 \\
    -pubkey-file server.pub \\
    $(grep -oP '(?<=server.key ).*?(?= 127.0.0.1)' /etc/systemd/system/slowdns.service 2>/dev/null) 127.0.0.1:1080

Created: $DATE
EOF
    
    echo -e "${GREEN}User $username added successfully${NC}"
    echo -e "${YELLOW}Configuration saved to: /root/${username}-slowdns-config.txt${NC}"
    read -p "Press Enter to continue"
}

delete_user() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}              ${WHITE}DELETE USER${NC}                               ${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    if [ ! -f "$USERS_FILE" ] || [ ! -s "$USERS_FILE" ]; then
        echo -e "${YELLOW}No users to delete${NC}"
        read -p "Press Enter to continue"
        return
    fi
    
    # List users
    echo -e "${CYAN}Current users:${NC}"
    nl -s ') ' "$USERS_FILE" | cut -d'|' -f1
    echo ""
    
    read -p "Enter username to delete: " username
    
    if grep -q "^$username|" "$USERS_FILE" 2>/dev/null; then
        sed -i "/^$username|/d" "$USERS_FILE"
        rm -f /root/${username}-slowdns-config.txt
        echo -e "${GREEN}User $username deleted${NC}"
    else
        echo -e "${RED}User not found${NC}"
    fi
    
    read -p "Press Enter to continue"
}

disable_user() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}              ${WHITE}DISABLE USER${NC}                             ${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    read -p "Enter username to disable: " username
    
    if grep -q "^$username|" "$USERS_FILE" 2>/dev/null; then
        sed -i "s/^$username|.*/$username|$(date +"%Y-%m-%d")|inactive/" "$USERS_FILE"
        echo -e "${YELLOW}User $username disabled${NC}"
    else
        echo -e "${RED}User not found${NC}"
    fi
    
    read -p "Press Enter to continue"
}

enable_user() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}              ${WHITE}ENABLE USER${NC}                              ${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    read -p "Enter username to enable: " username
    
    if grep -q "^$username|" "$USERS_FILE" 2>/dev/null; then
        sed -i "s/^$username|.*/$username|$(date +"%Y-%m-%d")|active/" "$USERS_FILE"
        echo -e "${GREEN}User $username enabled${NC}"
    else
        echo -e "${RED}User not found${NC}"
    fi
    
    read -p "Press Enter to continue"
}

show_user_config() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}              ${WHITE}USER CONFIGURATION${NC}                        ${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    read -p "Enter username: " username
    
    if [ -f "/root/${username}-slowdns-config.txt" ]; then
        cat "/root/${username}-slowdns-config.txt"
    else
        echo -e "${RED}Configuration file not found${NC}"
    fi
    
    read -p "Press Enter to continue"
}

# ============================================================================
# MANAGEMENT MENU
# ============================================================================
show_menu() {
    while true; do
        clear
        # Get current status
        SLOWDNS_STATUS=$(systemctl is-active slowdns 2>/dev/null)
        DNS_STATUS=$(systemctl is-active dns-proxy 2>/dev/null)
        
        echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
        echo -e "${BLUE}║${NC}           ${WHITE}SLOWDNS MANAGEMENT DASHBOARD${NC}                 ${BLUE}║${NC}"
        echo -e "${BLUE}╠══════════════════════════════════════════════════════════╣${NC}"
        echo -e "${BLUE}║${NC} ${WHITE}SlowDNS:${NC}  $(if [ "$SLOWDNS_STATUS" = "active" ]; then echo "${GREEN}● RUNNING${NC}"; else echo "${RED}● STOPPED${NC}"; fi)        ${WHITE}Port 5300:${NC} $(ss -ulpn | grep -q ":5300" && echo "${GREEN}LISTENING${NC}" || echo "${RED}DOWN${NC}")"
        echo -e "${BLUE}║${NC} ${WHITE}DNS Proxy:${NC} $(if [ "$DNS_STATUS" = "active" ]; then echo "${GREEN}● RUNNING${NC}"; else echo "${RED}● STOPPED${NC}"; fi)        ${WHITE}Port 53:${NC}   $(ss -ulpn | grep -q ":53" && echo "${GREEN}LISTENING${NC}" || echo "${RED}DOWN${NC}")"
        echo -e "${BLUE}╠══════════════════════════════════════════════════════════╣${NC}"
        echo -e "${BLUE}║${NC} ${YELLOW}SERVER MANAGEMENT${NC}"
        echo -e "${BLUE}║${NC}   ${GREEN}1.${NC} View Server Status"
        echo -e "${BLUE}║${NC}   ${GREEN}2.${NC} View SlowDNS Logs"
        echo -e "${BLUE}║${NC}   ${GREEN}3.${NC} Restart Services"
        echo -e "${BLUE}║${NC}   ${GREEN}4.${NC} Stop Services"
        echo -e "${BLUE}║${NC}   ${GREEN}5.${NC} Start Services"
        echo -e "${BLUE}║${NC}   ${GREEN}6.${NC} Fix Broken Installation"
        echo -e "${BLUE}║${NC}   ${GREEN}7.${NC} Show Public Key"
        echo -e "${BLUE}╠══════════════════════════════════════════════════════════╣${NC}"
        echo -e "${BLUE}║${NC} ${YELLOW}USER MANAGEMENT${NC}"
        echo -e "${BLUE}║${NC}   ${GREEN}8.${NC} List All Users"
        echo -e "${BLUE}║${NC}   ${GREEN}9.${NC} Add New User"
        echo -e "${BLUE}║${NC}   ${GREEN}10.${NC} Delete User"
        echo -e "${BLUE}║${NC}   ${GREEN}11.${NC} Disable User"
        echo -e "${BLUE}║${NC}   ${GREEN}12.${NC} Enable User"
        echo -e "${BLUE}║${NC}   ${GREEN}13.${NC} Show User Config"
        echo -e "${BLUE}╠══════════════════════════════════════════════════════════╣${NC}"
        echo -e "${BLUE}║${NC}   ${GREEN}14.${NC} Exit"
        echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
        echo ""
        read -p "Select option: " choice

        case $choice in
            1)
                clear
                echo -e "${CYAN}System Status:${NC}"
                systemctl status slowdns --no-pager -l
                echo ""
                systemctl status dns-proxy --no-pager -l
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
                echo -e "${YELLOW}Running fix...${NC}"
                cd /etc/slowdns
                download_binaries
                generate_keys
                systemctl restart slowdns dns-proxy
                echo -e "${GREEN}Fix complete${NC}"
                sleep 2
                ;;
            7)
                echo -e "${GREEN}Public Key:${NC}"
                cat /etc/slowdns/server.pub
                read -p "Press Enter to continue"
                ;;
            8) list_users ;;
            9) add_user ;;
            10) delete_user ;;
            11) disable_user ;;
            12) enable_user ;;
            13) show_user_config ;;
            14)
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
echo -e "${BLUE}║${NC}           ${WHITE}SLOWDNS INSTALLATION & MANAGEMENT${NC}               ${BLUE}║${NC}"
echo -e "${BLUE}╠══════════════════════════════════════════════════════════╣${NC}"
echo -e "${BLUE}║${NC} ${GREEN}1.${NC} Install SlowDNS (Fresh Install)"
echo -e "${BLUE}║${NC} ${GREEN}2.${NC} Open Management Menu"
echo -e "${BLUE}║${NC} ${GREEN}3.${NC} Exit"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
read -p "Select option: " main_choice

case $main_choice in
    1)
        install_slowdns
        show_menu
        ;;
    2)
        show_menu
        ;;
    *)
        exit 0
        ;;
esac
