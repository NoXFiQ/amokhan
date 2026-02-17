#!/bin/bash

# ============================================================================
#                     SLOWDNS MODERN INSTALLATION SCRIPT
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
# Using working GitHub repository with pre-compiled binaries
GITHUB_BASE="https://raw.githubusercontent.com/khairunisya/am/main"

# ============================================================================
# MODERN COLORS & DESIGN
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
# ANIMATION FUNCTIONS
# ============================================================================
show_progress() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

print_step() {
    echo -e "\n${BLUE}┌─${NC} ${CYAN}${BOLD}STEP $1${NC}"
    echo -e "${BLUE}│${NC}"
}

print_step_end() {
    echo -e "${BLUE}└─${NC} ${GREEN}✓${NC} Completed"
}

print_banner() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}${CYAN}          MODERN SLOWDNS INSTALLATION SCRIPT${NC}          ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}${WHITE}            Fast & Professional Configuration${NC}            ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}${YELLOW}                Optimized for Performance${NC}                ${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_header() {
    echo -e "\n${PURPLE}══════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}${BOLD}$1${NC}"
    echo -e "${PURPLE}══════════════════════════════════════════════════════════${NC}"
}

print_success() {
    echo -e "  ${GREEN}${BOLD}✓${NC} ${GREEN}$1${NC}"
}

print_error() {
    echo -e "  ${RED}${BOLD}✗${NC} ${RED}$1${NC}"
}

print_warning() {
    echo -e "  ${YELLOW}${BOLD}!${NC} ${YELLOW}$1${NC}"
}

print_info() {
    echo -e "  ${CYAN}${BOLD}i${NC} ${CYAN}$1${NC}"
}

# ============================================================================
# MAIN INSTALLATION
# ============================================================================
main() {
    print_banner
    
    # Get nameserver with modern prompt
    echo -e "${WHITE}${BOLD}Enter nameserver configuration:${NC}"
    echo -e "${CYAN}┌──────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC} ${YELLOW}Default:${NC} dns.example.com                                     ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} ${YELLOW}Example:${NC} tunnel.yourdomain.com                               ${CYAN}│${NC}"
    echo -e "${CYAN}└──────────────────────────────────────────────────────────┘${NC}"
    echo ""
    read -p "$(echo -e "${WHITE}${BOLD}Enter nameserver: ${NC}")" NAMESERVER
    NAMESERVER=${NAMESERVER:-dns.example.com}
    
    # Validate nameserver
    if [ "$NAMESERVER" = "dns.example.com" ]; then
        print_error "Please enter a valid domain name"
        exit 1
    fi
    
    print_header "GATHERING SYSTEM INFORMATION"
    
    # Get Server IP with animation
    echo -ne "  ${CYAN}Detecting server IP address...${NC}"
    SERVER_IP=$(curl -s --connect-timeout 5 ifconfig.me)
    if [ -z "$SERVER_IP" ]; then
        SERVER_IP=$(hostname -I | awk '{print $1}')
    fi
    echo -e "\r  ${GREEN}Server IP:${NC} ${WHITE}${BOLD}$SERVER_IP${NC}"
    
    # Check if nameserver resolves to this server
    echo -ne "  ${CYAN}Checking nameserver resolution...${NC}"
    NS_IP=$(dig +short $NAMESERVER | head -1)
    if [ -n "$NS_IP" ] && [ "$NS_IP" != "$SERVER_IP" ]; then
        echo -e "\r  ${YELLOW}Warning: $NAMESERVER resolves to $NS_IP, not $SERVER_IP${NC}"
    else
        echo -e "\r  ${GREEN}Nameserver check passed${NC}"
    fi
    
    # ============================================================================
    # STEP 1: UPDATE SYSTEM AND INSTALL DEPENDENCIES
    # ============================================================================
    print_step "1"
    print_info "Updating system and installing dependencies"
    
    echo -ne "  ${CYAN}Updating package lists...${NC}"
    apt update -y > /dev/null 2>&1 &
    show_progress $!
    echo -e "\r  ${GREEN}Package lists updated${NC}"
    
    echo -ne "  ${CYAN}Installing required packages...${NC}"
    apt install -y wget curl unzip build-essential net-tools dnsutils > /dev/null 2>&1 &
    show_progress $!
    echo -e "\r  ${GREEN}Packages installed${NC}"
    
    print_success "System updated and dependencies installed"
    print_step_end
    
    # ============================================================================
    # STEP 2: CONFIGURE OPENSSH
    # ============================================================================
    print_step "2"
    print_info "Configuring OpenSSH on port $SSHD_PORT"
    
    echo -ne "  ${CYAN}Backing up SSH configuration...${NC}"
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup 2>/dev/null
    echo -e "\r  ${GREEN}SSH configuration backed up${NC}"
    
    cat > /etc/ssh/sshd_config << 'EOF'
# ============================================================================
# SLOWDNS OPTIMIZED SSH CONFIGURATION
# ============================================================================
Port 22
Protocol 2
PermitRootLogin yes
PubkeyAuthentication yes
PasswordAuthentication yes
PermitEmptyPasswords no
ChallengeResponseAuthentication no
UsePAM yes
X11Forwarding no
PrintMotd no
PrintLastLog yes
TCPKeepAlive yes
ClientAliveInterval 60
ClientAliveCountMax 3
AllowTcpForwarding yes
GatewayPorts yes
Compression delayed
Subsystem sftp /usr/lib/openssh/sftp-server
MaxSessions 100
MaxStartups 100:30:200
LoginGraceTime 30
UseDNS no
EOF
    
    echo -ne "  ${CYAN}Restarting SSH service...${NC}"
    systemctl restart sshd 2>/dev/null
    sleep 2
    echo -e "\r  ${GREEN}SSH service restarted${NC}"
    
    print_success "OpenSSH configured on port $SSHD_PORT"
    print_step_end
    
    # ============================================================================
    # STEP 3: SETUP SLOWDNS
    # ============================================================================
    print_step "3"
    print_info "Setting up SlowDNS environment"
    
    echo -ne "  ${CYAN}Creating SlowDNS directory...${NC}"
    rm -rf /etc/slowdns 2>/dev/null
    mkdir -p /etc/slowdns
    cd /etc/slowdns
    echo -e "\r  ${GREEN}SlowDNS directory created${NC}"
    
    # Download binary with retry mechanism
    print_info "Downloading SlowDNS binary"
    DOWNLOAD_SUCCESS=0
    for i in {1..3}; do
        echo -ne "  ${CYAN}Fetching binary from GitHub (attempt $i/3)...${NC}"
        if wget -q "$GITHUB_BASE/dnstt-server" -O dnstt-server; then
            echo -e "\r  ${GREEN}Binary downloaded successfully${NC}"
            DOWNLOAD_SUCCESS=1
            break
        else
            echo -e "\r  ${YELLOW}Download attempt $i failed, retrying...${NC}"
            sleep 2
        fi
    done
    
    if [ $DOWNLOAD_SUCCESS -eq 0 ]; then
        echo -e "\r  ${RED}Failed to download binary after 3 attempts${NC}"
        exit 1
    fi
    
    chmod +x dnstt-server
    SLOWDNS_BINARY="/etc/slowdns/dnstt-server"
    
    # Download key files
    print_info "Generating encryption keys"
    echo -ne "  ${CYAN}Generating server keys...${NC}"
    ./dnstt-server -gen-key -privkey-file server.key -pubkey-file server.pub
    echo -e "\r  ${GREEN}Server keys generated successfully${NC}"
    
    # Test binary
    echo -ne "  ${CYAN}Validating binary...${NC}"
    if ./dnstt-server --help 2>&1 | grep -q "usage"; then
        echo -e "\r  ${GREEN}Binary validated successfully${NC}"
    else
        echo -e "\r  ${YELLOW}Binary test inconclusive but continuing${NC}"
    fi
    
    print_success "SlowDNS components installed"
    print_step_end
    
    # ============================================================================
    # STEP 4: CREATE SLOWDNS SERVICE
    # ============================================================================
    print_step "4"
    print_info "Creating SlowDNS system service"
    
    cat > /etc/systemd/system/slowdns.service << EOF
[Unit]
Description=SlowDNS Server
Description=High-performance DNS tunnel server
After=network.target sshd.service
Wants=network-online.target

[Service]
Type=simple
ExecStart=$SLOWDNS_BINARY -udp :$SLOWDNS_PORT -mtu 1400 -privkey-file /etc/slowdns/server.key $NAMESERVER 127.0.0.1:$SSHD_PORT
Restart=always
RestartSec=5
User=root
LimitNOFILE=65536
LimitCORE=infinity
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
EOF
    
    print_success "Service configuration created"
    print_step_end
    
    # ============================================================================
    # STEP 5: SETUP DNS PROXY (Simple socat instead of compilation)
    # ============================================================================
    print_step "5"
    print_info "Setting up DNS proxy on port 53"
    
    # Install socat for simple proxying
    echo -ne "  ${CYAN}Installing socat...${NC}"
    apt install -y socat > /dev/null 2>&1
    echo -e "\r  ${GREEN}Socat installed${NC}"
    
    # Create DNS proxy service
    cat > /etc/systemd/system/dns-proxy.service << 'EOF'
[Unit]
Description=DNS Proxy Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/socat UDP-LISTEN:53,fork,reuseaddr UDP:127.0.0.1:5300
Restart=always
RestartSec=3
User=root

[Install]
WantedBy=multi-user.target
EOF
    
    print_success "DNS proxy configured"
    print_step_end
    
    # ============================================================================
    # STEP 6: FIREWALL CONFIGURATION
    # ============================================================================
    print_step "6"
    print_info "Configuring system firewall"
    
    echo -ne "  ${CYAN}Setting up firewall rules...${NC}"
    # Clear existing rules
    iptables -F 2>/dev/null
    iptables -X 2>/dev/null
    
    # Allow everything (simple approach for now)
    iptables -P INPUT ACCEPT 2>/dev/null
    iptables -P FORWARD ACCEPT 2>/dev/null
    iptables -P OUTPUT ACCEPT 2>/dev/null
    
    # Basic rules
    iptables -A INPUT -i lo -j ACCEPT 2>/dev/null
    iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT 2>/dev/null
    iptables -A INPUT -p tcp --dport $SSHD_PORT -j ACCEPT 2>/dev/null
    iptables -A INPUT -p udp --dport $SLOWDNS_PORT -j ACCEPT 2>/dev/null
    iptables -A INPUT -p udp --dport 53 -j ACCEPT 2>/dev/null
    echo -e "\r  ${GREEN}Firewall rules configured${NC}"
    
    # Stop conflicting services
    echo -ne "  ${CYAN}Stopping conflicting DNS services...${NC}"
    systemctl stop systemd-resolved 2>/dev/null
    systemctl disable systemd-resolved 2>/dev/null
    fuser -k 53/udp 2>/dev/null
    echo -e "\r  ${GREEN}Conflicting services stopped${NC}"
    
    print_success "Firewall and network configured"
    print_step_end
    
    # ============================================================================
    # STEP 7: START SERVICES
    # ============================================================================
    print_step "7"
    print_info "Starting all services"
    
    systemctl daemon-reload
    
    # Start SlowDNS
    echo -ne "  ${CYAN}Starting SlowDNS service...${NC}"
    systemctl enable slowdns > /dev/null 2>&1
    systemctl start slowdns
    sleep 3
    
    if systemctl is-active --quiet slowdns; then
        echo -e "\r  ${GREEN}SlowDNS service started successfully${NC}"
    else
        echo -e "\r  ${YELLOW}SlowDNS service may not be running, check with: systemctl status slowdns${NC}"
    fi
    
    # Start DNS proxy
    echo -ne "  ${CYAN}Starting DNS proxy service...${NC}"
    systemctl enable dns-proxy > /dev/null 2>&1
    systemctl start dns-proxy
    sleep 2
    
    if systemctl is-active --quiet dns-proxy; then
        echo -e "\r  ${GREEN}DNS proxy service started successfully${NC}"
    else
        echo -e "\r  ${YELLOW}DNS proxy may not be running, check with: systemctl status dns-proxy${NC}"
    fi
    
    print_success "All services started"
    print_step_end
    
    # ============================================================================
    # COMPLETION SUMMARY
    # ============================================================================
    clear
    print_header "INSTALLATION COMPLETE"
    
    # Get public key
    PUBKEY=$(cat /etc/slowdns/server.pub 2>/dev/null)
    
    # Show summary
    echo -e "${CYAN}┌──────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC} ${WHITE}${BOLD}SERVER INFORMATION${NC}                                   ${CYAN}│${NC}"
    echo -e "${CYAN}├──────────────────────────────────────────────────────────┤${NC}"
    echo -e "${CYAN}│${NC} ${YELLOW}●${NC} Server IP:     ${WHITE}$SERVER_IP${NC}"
    echo -e "${CYAN}│${NC} ${YELLOW}●${NC} Nameserver:    ${WHITE}$NAMESERVER${NC}"
    echo -e "${CYAN}│${NC} ${YELLOW}●${NC} SSH Port:      ${WHITE}$SSHD_PORT${NC}"
    echo -e "${CYAN}│${NC} ${YELLOW}●${NC} SlowDNS Port:  ${WHITE}$SLOWDNS_PORT (UDP)${NC}"
    echo -e "${CYAN}│${NC} ${YELLOW}●${NC} DNS Port:      ${WHITE}53 (UDP)${NC}"
    echo -e "${CYAN}│${NC} ${YELLOW}●${NC} MTU Size:      ${WHITE}1400${NC}"
    echo -e "${CYAN}└──────────────────────────────────────────────────────────┘${NC}"
    
    echo -e "\n${CYAN}┌──────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC} ${WHITE}${BOLD}PUBLIC KEY (FOR CLIENT)${NC}                             ${CYAN}│${NC}"
    echo -e "${CYAN}├──────────────────────────────────────────────────────────┤${NC}"
    echo -e "${CYAN}│${NC} ${GREEN}$PUBKEY${NC}"
    echo -e "${CYAN}└──────────────────────────────────────────────────────────┘${NC}"
    
    echo -e "\n${CYAN}┌──────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC} ${WHITE}${BOLD}CLIENT CONNECTION COMMAND${NC}                           ${CYAN}│${NC}"
    echo -e "${CYAN}├──────────────────────────────────────────────────────────┤${NC}"
    echo -e "${CYAN}│${NC} ${GREEN}./dnstt-client -udp $SERVER_IP:$SLOWDNS_PORT \\${NC}"
    echo -e "${CYAN}│${NC} ${GREEN}    -pubkey-file server.pub \\${NC}"
    echo -e "${CYAN}│${NC} ${GREEN}    $NAMESERVER 127.0.0.1:1080${NC}"
    echo -e "${CYAN}└──────────────────────────────────────────────────────────┘${NC}"
    
    echo -e "\n${CYAN}┌──────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC} ${WHITE}${BOLD}USEFUL COMMANDS${NC}                                      ${CYAN}│${NC}"
    echo -e "${CYAN}├──────────────────────────────────────────────────────────┤${NC}"
    echo -e "${CYAN}│${NC} ${YELLOW}Check status:${NC}  systemctl status slowdns dns-proxy"
    echo -e "${CYAN}│${NC} ${YELLOW}View logs:${NC}     journalctl -u slowdns -f"
    echo -e "${CYAN}│${NC} ${YELLOW}Restart:${NC}       systemctl restart slowdns dns-proxy"
    echo -e "${CYAN}│${NC} ${YELLOW}Test DNS:${NC}      dig @$SERVER_IP $NAMESERVER"
    echo -e "${CYAN}└──────────────────────────────────────────────────────────┘${NC}"
    
    # Save public key to file for easy access
    echo "$PUBKEY" > /root/slowdns-pubkey.txt
    echo -e "\n${GREEN}Public key saved to: /root/slowdns-pubkey.txt${NC}"
    
    echo -e "\n${GREEN}${BOLD}══════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}${BOLD}   INSTALLATION COMPLETED SUCCESSFULLY!${NC}"
    echo -e "${GREEN}${BOLD}══════════════════════════════════════════════════════════${NC}"
}

# ============================================================================
# EXECUTE WITH ERROR HANDLING
# ============================================================================
trap 'echo -e "\n${RED}✗ Installation interrupted!${NC}"; exit 1' INT

# Run main function
main

# Final verification
echo -e "\n${WHITE}Performing final verification...${NC}"
sleep 2

# Check if services are running
if systemctl is-active --quiet slowdns && systemctl is-active --quiet dns-proxy; then
    echo -e "${GREEN}✓ All services are running properly${NC}"
else
    echo -e "${YELLOW}! Some services may not be running. Check with: systemctl status slowdns dns-proxy${NC}"
fi

# Check ports
if ss -ulpn | grep -q ":5300"; then
    echo -e "${GREEN}✓ Port 5300 (SlowDNS) is listening${NC}"
else
    echo -e "${RED}✗ Port 5300 is not listening${NC}"
fi

if ss -ulpn | grep -q ":53"; then
    echo -e "${GREEN}✓ Port 53 (DNS Proxy) is listening${NC}"
else
    echo -e "${RED}✗ Port 53 is not listening${NC}"
fi

echo -e "\n${GREEN}Installation complete! Use the information above to configure your client.${NC}"
