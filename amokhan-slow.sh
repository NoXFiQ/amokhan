#!/bin/bash
# ╔═══════════════════════════════════════════════════════════════╗
#  ███████╗██╗     ██╗████████╗███████╗      ██╗  ██╗
#  ██╔════╝██║     ██║╚══██╔══╝██╔════╝      ╚██╗██╔╝
#  █████╗  ██║     ██║   ██║   █████╗  █████╗ ╚███╔╝ 
#  ██╔══╝  ██║     ██║   ██║   ██╔══╝  ╚════╝ ██╔██╗ 
#  ███████╗███████╗██║   ██║   ███████╗      ██╔╝ ██╗
#  ╚══════╝╚══════╝╚═╝   ╚═╝   ╚══════╝      ╚═╝  ╚═╝
# ╚═══════════════════════════════════════════════════════════════╝
#                   ELITE-X SLOWDNS v3.0
# ═════════════════════════════════════════════════════════════════

set -euo pipefail

# Colors
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; PURPLE='\033[0;35m'; CYAN='\033[0;36m'
WHITE='\033[1;37m'; BOLD='\033[1m'; NC='\033[0m'

# Activation
ACTIVATION_KEY="ELITEX-2026-DAN-4D-08"
TEMP_KEY="ELITE-X-TEST-0208"
ACTIVATION_FILE="/etc/elite-x/activated"
ACTIVATION_TYPE_FILE="/etc/elite-x/activation_type"
ACTIVATION_DATE_FILE="/etc/elite-x/activation_date"
EXPIRY_DAYS_FILE="/etc/elite-x/expiry_days"
KEY_FILE="/etc/elite-x/key"
TIMEZONE="Africa/Dar_es_Salaam"

# Functions
show_banner() {
    clear
    echo -e "${RED}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║${YELLOW}${BOLD}                   ELITE-X SLOWDNS v3.0                        ${RED}║${NC}"
    echo -e "${RED}║${GREEN}${BOLD}                    Stable Edition                              ${RED}║${NC}"
    echo -e "${RED}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

show_quote() {
    echo ""
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${YELLOW}${BOLD}                                                               ${CYAN}║${NC}"
    echo -e "${CYAN}║${WHITE}            Always Remember ELITE-X when you see X            ${CYAN}║${NC}"
    echo -e "${CYAN}║${YELLOW}${BOLD}                                                               ${CYAN}║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

set_timezone() {
    timedatectl set-timezone $TIMEZONE 2>/dev/null || ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime 2>/dev/null || true
}

activate_script() {
    local input_key="$1"
    mkdir -p /etc/elite-x
    
    if [ "$input_key" = "$ACTIVATION_KEY" ] || [ "$input_key" = "Whtsapp 0713628668" ]; then
        echo "$ACTIVATION_KEY" > "$ACTIVATION_FILE"
        echo "$ACTIVATION_KEY" > "$KEY_FILE"
        echo "lifetime" > "$ACTIVATION_TYPE_FILE"
        echo "Lifetime" > /etc/elite-x/expiry
        return 0
    elif [ "$input_key" = "$TEMP_KEY" ]; then
        echo "$TEMP_KEY" > "$ACTIVATION_FILE"
        echo "$TEMP_KEY" > "$KEY_FILE"
        echo "temporary" > "$ACTIVATION_TYPE_FILE"
        echo "$(date +%Y-%m-%d)" > "$ACTIVATION_DATE_FILE"
        echo "2" > "$EXPIRY_DAYS_FILE"
        echo "2 Days Trial" > /etc/elite-x/expiry
        return 0
    fi
    return 1
}

check_subdomain() {
    local subdomain="$1"
    local vps_ip=$(curl -4 -s ifconfig.me 2>/dev/null || echo "")
    
    echo -e "${YELLOW}🔍 Checking if subdomain points to this VPS...${NC}"
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${WHITE}  Subdomain: $subdomain${NC}"
    echo -e "${CYAN}║${WHITE}  VPS IPv4 : $vps_ip${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    
    local resolved_ip=$(dig +short -4 "$subdomain" 2>/dev/null | head -1)
    
    if [ "$resolved_ip" = "$vps_ip" ]; then
        echo -e "${GREEN}✅ Subdomain correctly points to this VPS!${NC}"
        return 0
    else
        echo -e "${RED}❌ Subdomain points to $resolved_ip, but VPS IP is $vps_ip${NC}"
        read -p "Continue anyway? (y/n): " continue_anyway
        [ "$continue_anyway" != "y" ] && exit 1
    fi
}

# ==================== MAIN INSTALLATION ====================
show_banner

# Activation
echo -e "${YELLOW}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║${GREEN}                    ACTIVATION REQUIRED                          ${YELLOW}║${NC}"
echo -e "${YELLOW}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${WHITE}Available Keys:${NC}"
echo -e "${GREEN}  Lifetime : Whtsapp +255713-628-668${NC}"
echo -e "${YELLOW}  Trial    : ELITE-X-TEST-0208 (2 days)${NC}"
echo ""
read -p "$(echo -e $CYAN"Activation Key: "$NC)" ACTIVATION_INPUT

mkdir -p /etc/elite-x
if ! activate_script "$ACTIVATION_INPUT"; then
    echo -e "${RED}❌ Invalid activation key! Installation cancelled.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Activation successful!${NC}"
sleep 1
set_timezone

# Subdomain input
echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${WHITE}                  ENTER YOUR SUBDOMAIN                          ${CYAN}║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""
read -p "$(echo -e $GREEN"Subdomain: "$NC)" TDOMAIN
echo -e "${GREEN}You entered: $TDOMAIN${NC}"
check_subdomain "$TDOMAIN"

# Location selection
echo -e "${YELLOW}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║${GREEN}           NETWORK LOCATION OPTIMIZATION                          ${YELLOW}║${NC}"
echo -e "${YELLOW}╠═══════════════════════════════════════════════════════════════╣${NC}"
echo -e "${YELLOW}║${WHITE}  [1] South Africa (Default - MTU 1800)                        ${YELLOW}║${NC}"
echo -e "${YELLOW}║${CYAN}  [2] USA                                                       ${YELLOW}║${NC}"
echo -e "${YELLOW}║${BLUE}  [3] Europe                                                    ${YELLOW}║${NC}"
echo -e "${YELLOW}║${PURPLE}  [4] Asia                                                      ${YELLOW}║${NC}"
echo -e "${YELLOW}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""
read -p "$(echo -e $GREEN"Select location [1-4] [default: 1]: "$NC)" LOCATION_CHOICE
LOCATION_CHOICE=${LOCATION_CHOICE:-1}

MTU=1800
case $LOCATION_CHOICE in
    2) SELECTED_LOCATION="USA"; echo -e "${CYAN}✅ USA selected${NC}" ;;
    3) SELECTED_LOCATION="Europe"; echo -e "${BLUE}✅ Europe selected${NC}" ;;
    4) SELECTED_LOCATION="Asia"; echo -e "${PURPLE}✅ Asia selected${NC}" ;;
    *) SELECTED_LOCATION="South Africa"; echo -e "${GREEN}✅ South Africa selected${NC}" ;;
esac

echo "$SELECTED_LOCATION" > /etc/elite-x/location
echo "$MTU" > /etc/elite-x/mtu

DNSTT_PORT=5300
DNS_PORT=53

echo -e "${YELLOW}==> ELITE-X INSTALLATION STARTING...${NC}"

# Root check
[ "$(id -u)" -ne 0 ] && { echo "[-] Run as root"; exit 1; }

# Create directories
mkdir -p /etc/elite-x/{banner,users,traffic}
echo "$TDOMAIN" > /etc/elite-x/subdomain

# Banner
cat > /etc/elite-x/banner/ssh-banner <<'EOF'
╔═════════════════════════════════════════╗
           ELITE-X VPN SERVICE             
    High Speed • Secure • Unlimited     
╚═════════════════════════════════════════╝
EOF

if ! grep -q "^Banner" /etc/ssh/sshd_config; then
    echo "Banner /etc/elite-x/banner/ssh-banner" >> /etc/ssh/sshd_config
else
    sed -i 's|^Banner.*|Banner /etc/elite-x/banner/ssh-banner|' /etc/ssh/sshd_config
fi
systemctl restart sshd

# Stop old services
for svc in dnstt dnstt-server slowdns dnstt-smart dnstt-elite-x dnstt-elite-x-proxy; do
    systemctl disable --now "$svc" 2>/dev/null || true
done

# Configure systemd-resolved
if [ -f /etc/systemd/resolved.conf ]; then
    sed -i 's/^#\?DNSStubListener=.*/DNSStubListener=no/' /etc/systemd/resolved.conf
    grep -q '^DNS=' /etc/systemd/resolved.conf \
        && sed -i 's/^DNS=.*/DNS=8.8.8.8 8.8.4.4/' /etc/systemd/resolved.conf \
        || echo "DNS=8.8.8.8 8.8.4.4" >> /etc/systemd/resolved.conf
    systemctl restart systemd-resolved
    ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
fi

# Install dependencies
apt update -y
apt install -y curl python3 jq nano iptables iptables-persistent ethtool dnsutils

# Install dnstt-server
echo "Installing dnstt-server..."
curl -fsSL https://dnstt.network/dnstt-server-linux-amd64 -o /usr/local/bin/dnstt-server
chmod +x /usr/local/bin/dnstt-server

# Generate keys
mkdir -p /etc/dnstt
cd /etc/dnstt
dnstt-server -gen-key -privkey-file server.key -pubkey-file server.pub
cd ~
chmod 600 /etc/dnstt/server.key
chmod 644 /etc/dnstt/server.pub

# Create DNSTT service
cat >/etc/systemd/system/dnstt-elite-x.service <<EOF
[Unit]
Description=ELITE-X DNSTT Server
After=network-online.target

[Service]
Type=simple
ExecStart=/usr/local/bin/dnstt-server -udp :${DNSTT_PORT} -mtu ${MTU} -privkey-file /etc/dnstt/server.key ${TDOMAIN} 127.0.0.1:22
Restart=always
KillSignal=SIGTERM
LimitNOFILE=1048576

[Install]
WantedBy=multi-user.target
EOF

# Install EDNS proxy (FIXED VERSION)
echo "Installing EDNS proxy..."
cat >/usr/local/bin/dnstt-edns-proxy.py <<'EOF'
#!/usr/bin/env python3
import socket
import threading
import struct
import time

# Configuration
LISTEN_PORT = 53
DNSTT_PORT = 5300
MTU = 1800
BUFFER_SIZE = 4096

def modify_packet(data, max_size):
    """Modify DNS packet to include EDNS0 with specified max size"""
    if len(data) < 12:
        return data
    
    try:
        # Parse DNS header
        q, a, n, r = struct.unpack("!HHHH", data[4:12])
    except:
        return data
    
    offset = 12
    
    def skip_name(data, offset):
        while offset < len(data):
            length = data[offset]
            offset += 1
            if length == 0:
                break
            if length & 0xC0 == 0xC0:  # Compression pointer
                offset += 1
                break
            offset += length
        return offset
    
    # Skip questions
    for _ in range(q):
        offset = skip_name(data, offset)
        offset += 4  # Skip QTYPE and QCLASS
    
    # Skip answers and authorities
    for _ in range(a + n):
        offset = skip_name(data, offset)
        if offset + 10 > len(data):
            return data
        _, _, _, rdlength = struct.unpack("!HHIH", data[offset:offset+10])
        offset += 10 + rdlength
    
    # Look for EDNS0 OPT record in additional section
    new_data = bytearray(data)
    found_edns = False
    
    for _ in range(r):
        if offset + 2 > len(data):
            break
        name_len = data[offset]
        if name_len != 0:  # Not the root
            offset = skip_name(data, offset)
            if offset + 10 > len(data):
                break
        
        if offset + 10 <= len(data):
            record_type = struct.unpack("!H", data[offset:offset+2])[0]
            if record_type == 41:  # OPT record
                # Modify UDP payload size
                new_data[offset+2:offset+4] = struct.pack("!H", max_size)
                found_edns = True
                break
            
            _, _, rdlength = struct.unpack("!HIH", data[offset+2:offset+10])
            offset += 10 + rdlength
    
    if not found_edns and r > 0:
        # Add EDNS0 record if not present
        # This is simplified - in production you'd need full DNS packet manipulation
        pass
    
    return bytes(new_data)

def handle_client(server_socket, data, client_addr):
    """Handle DNS query and forward to dnstt"""
    try:
        # Forward to dnstt server
        dnstt_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        dnstt_socket.settimeout(5)
        
        modified_data = modify_packet(data, 4096)
        dnstt_socket.sendto(modified_data, ('127.0.0.1', DNSTT_PORT))
        
        response, _ = dnstt_socket.recvfrom(BUFFER_SIZE)
        modified_response = modify_packet(response, 512)
        server_socket.sendto(modified_response, client_addr)
    except Exception as e:
        print(f"Error: {e}")
    finally:
        dnstt_socket.close()

def main():
    """Main function to run DNS proxy"""
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server_socket.bind(('0.0.0.0', LISTEN_PORT))
    
    print(f"ELITE-X Proxy listening on port {LISTEN_PORT}")
    
    while True:
        try:
            data, client_addr = server_socket.recvfrom(BUFFER_SIZE)
            thread = threading.Thread(target=handle_client, 
                                     args=(server_socket, data, client_addr),
                                     daemon=True)
            thread.start()
        except Exception as e:
            print(f"Main loop error: {e}")
            time.sleep(1)

if __name__ == "__main__":
    main()
EOF

chmod +x /usr/local/bin/dnstt-edns-proxy.py

# Create proxy service
cat >/etc/systemd/system/dnstt-elite-x-proxy.service <<EOF
[Unit]
Description=ELITE-X DNS Proxy
After=dnstt-elite-x.service
Requires=dnstt-elite-x.service

[Service]
Type=simple
User=root
ExecStart=/usr/bin/python3 /usr/local/bin/dnstt-edns-proxy.py
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# Firewall
command -v ufw >/dev/null && ufw allow 22/tcp && ufw allow 53/udp || true

# Start services
systemctl daemon-reload
systemctl enable dnstt-elite-x.service dnstt-elite-x-proxy.service
systemctl start dnstt-elite-x.service
sleep 2
systemctl start dnstt-elite-x-proxy.service

# Create user management script
cat >/usr/local/bin/elite-x-user <<'EOF'
#!/bin/bash
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; WHITE='\033[1;37m'; NC='\033[0m'

UD="/etc/elite-x/users"
TD="/etc/elite-x/traffic"
mkdir -p $UD $TD

add_user() {
    read -p "Username: " username
    read -p "Password: " password
    read -p "Expire days: " days
    
    useradd -m -s /bin/false "$username" 2>/dev/null || { echo "User exists"; return; }
    echo "$username:$password" | chpasswd
    
    expire_date=$(date -d "+$days days" +"%Y-%m-%d")
    chage -E "$expire_date" "$username"
    
    cat > $UD/$username <<INFO
Username: $username
Password: $password
Expire: $expire_date
Created: $(date +"%Y-%m-%d")
INFO
    
    echo -e "${GREEN}✅ User created until $expire_date${NC}"
}

list_users() {
    echo -e "${CYAN}Active Users:${NC}"
    awk -F: '$3>=1000 && $3<=60000 {print $1}' /etc/passwd
}

lock_user() { read -p "Username: " u; passwd -l "$u" 2>/dev/null && echo -e "${GREEN}✅ Locked${NC}" || echo -e "${RED}❌ Failed${NC}"; }
unlock_user() { read -p "Username: " u; passwd -u "$u" 2>/dev/null && echo -e "${GREEN}✅ Unlocked${NC}" || echo -e "${RED}❌ Failed${NC}"; }
delete_user() { read -p "Username: " u; userdel -r "$u" 2>/dev/null; rm -f $UD/$u; echo -e "${GREEN}✅ Deleted${NC}"; }

case $1 in
    add) add_user ;;
    list) list_users ;;
    lock) lock_user ;;
    unlock) unlock_user ;;
    del) delete_user ;;
    *) echo "Usage: elite-x-user {add|list|lock|unlock|del}" ;;
esac
EOF
chmod +x /usr/local/bin/elite-x-user

# Create main menu
cat >/usr/local/bin/elite-x <<'EOF'
#!/bin/bash
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; PURPLE='\033[0;35m'; WHITE='\033[1;37m'
NC='\033[0m'

show_status() {
    DNS=$(systemctl is-active dnstt-elite-x 2>/dev/null | grep -q active && echo "${GREEN}●${NC}" || echo "${RED}●${NC}")
    PRX=$(systemctl is-active dnstt-elite-x-proxy 2>/dev/null | grep -q active && echo "${GREEN}●${NC}" || echo "${RED}●${NC}")
    echo -e "Services: DNS:$DNS PRX:$PRX"
}

main_menu() {
    while true; do
        clear
        echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║${YELLOW}${BOLD}                    ELITE-X SLOWDNS v3.0                      ${CYAN}║${NC}"
        echo -e "${CYAN}╠═══════════════════════════════════════════════════════════════╣${NC}"
        echo -e "${CYAN}║                      $(show_status)                         ${CYAN}║${NC}"
        echo -e "${CYAN}╠═══════════════════════════════════════════════════════════════╣${NC}"
        echo -e "${CYAN}║${WHITE}  [1] Create User${NC}"
        echo -e "${CYAN}║${WHITE}  [2] List Users${NC}"
        echo -e "${CYAN}║${WHITE}  [3] Lock User${NC}"
        echo -e "${CYAN}║${WHITE}  [4] Unlock User${NC}"
        echo -e "${CYAN}║${WHITE}  [5] Delete User${NC}"
        echo -e "${CYAN}║${WHITE}  [6] View Public Key${NC}"
        echo -e "${CYAN}║${WHITE}  [7] Restart Services${NC}"
        echo -e "${CYAN}║${WHITE}  [8] Exit${NC}"
        echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        read -p "$(echo -e $GREEN"Choose: "$NC)" ch
        
        case $ch in
            1) elite-x-user add; read -p "Press Enter..." ;;
            2) elite-x-user list; read -p "Press Enter..." ;;
            3) elite-x-user lock; read -p "Press Enter..." ;;
            4) elite-x-user unlock; read -p "Press Enter..." ;;
            5) elite-x-user del; read -p "Press Enter..." ;;
            6) cat /etc/dnstt/server.pub; read -p "Press Enter..." ;;
            7) systemctl restart dnstt-elite-x dnstt-elite-x-proxy; echo "Restarted"; read -p "Press Enter..." ;;
            8) exit 0 ;;
            *) echo "Invalid"; read -p "Press Enter..." ;;
        esac
    done
}

main_menu
EOF
chmod +x /usr/local/bin/elite-x

# Final output
clear
show_banner
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${YELLOW}${BOLD}              ELITE-X INSTALLED SUCCESSFULLY!                    ${GREEN}║${NC}"
echo -e "${GREEN}╠═══════════════════════════════════════════════════════════════╣${NC}"
echo -e "${GREEN}║${WHITE}  DOMAIN  : ${CYAN}$TDOMAIN${NC}"
echo -e "${GREEN}║${WHITE}  LOCATION: ${CYAN}$SELECTED_LOCATION${NC}"
echo -e "${GREEN}║${WHITE}  KEY     : ${YELLOW}$ACTIVATION_KEY${NC}"
echo -e "${GREEN}║${WHITE}  STATUS  : ${GREEN}Services installed${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════╝${NC}"
show_quote

echo -e "${YELLOW}Type 'elite-x' to open menu${NC}"
