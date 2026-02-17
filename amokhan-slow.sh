#!/bin/bash
# ╔═══════════════════════════════════════════════════════════════╗
#  ███████╗██╗     ██╗████████╗███████╗      ██╗  ██╗
#  ██╔════╝██║     ██║╚══██╔══╝██╔════╝      ╚██╗██╔╝
#  █████╗  ██║     ██║   ██║   █████╗  █████╗ ╚███╔╝ 
#  ██╔══╝  ██║     ██║   ██║   ██╔══╝  ╚════╝ ██╔██╗ 
#  ███████╗███████╗██║   ██║   ███████╗      ██╔╝ ██╗
#  ╚══════╝╚══════╝╚═╝   ╚═╝   ╚══════╝      ╚═╝  ╚═╝
# ╚═══════════════════════════════════════════════════════════════╝
#              ELITE-X SLOWDNS v5.0 - OVERCLOCKED EDITION
# ═════════════════════════════════════════════════════════════════

# Color definitions
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'
PURPLE='\033[0;35m'; CYAN='\033[0;36m'; WHITE='\033[1;37m'; BOLD='\033[1m'
NC='\033[0m'
NEON_RED='\033[1;31m'; NEON_GREEN='\033[1;32m'; NEON_YELLOW='\033[1;33m'
NEON_BLUE='\033[1;34m'; NEON_PURPLE='\033[1;35m'; NEON_CYAN='\033[1;36m'
NEON_WHITE='\033[1;37m'; NEON_PINK='\033[1;38;5;201m'
BLINK='\033[5m'; UNDERLINE='\033[4m'

# Activation variables
ACTIVATION_KEY="ELITEX-2026-DAN-4D-08"
TEMP_KEY="ELITE-X-TEST-0208"
ACTIVATION_FILE="/etc/elite-x/activated"
ACTIVATION_TYPE_FILE="/etc/elite-x/activation_type"
ACTIVATION_DATE_FILE="/etc/elite-x/activation_date"
EXPIRY_DAYS_FILE="/etc/elite-x/expiry_days"
KEY_FILE="/etc/elite-x/key"
TIMEZONE="Africa/Dar_es_Salaam"

# Function to show banner
show_banner() {
    clear
    echo -e "${NEON_RED}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_RED}║${NEON_YELLOW}${BOLD}              ███████╗██╗     ██╗████████╗███████╗                    ${NEON_RED}║${NC}"
    echo -e "${NEON_RED}║${NEON_GREEN}${BOLD}              ██╔════╝██║     ██║╚══██╔══╝██╔════╝                    ${NEON_RED}║${NC}"
    echo -e "${NEON_RED}║${NEON_CYAN}${BOLD}              █████╗  ██║     ██║   ██║   █████╗                      ${NEON_RED}║${NC}"
    echo -e "${NEON_RED}║${NEON_BLUE}${BOLD}              ██╔══╝  ██║     ██║   ██║   ██╔══╝                      ${NEON_RED}║${NC}"
    echo -e "${NEON_RED}║${NEON_PURPLE}${BOLD}              ███████╗███████╗██║   ██║   ███████╗                    ${NEON_RED}║${NC}"
    echo -e "${NEON_RED}║${NEON_PINK}${BOLD}              ╚══════╝╚══════╝╚═╝   ╚═╝   ╚══════╝                    ${NEON_RED}║${NC}"
    echo -e "${NEON_RED}╠═══════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${NEON_RED}║${NEON_WHITE}${BOLD}               ELITE-X SLOWDNS v5.0 - OVERCLOCKED EDITION               ${NEON_RED}║${NC}"
    echo -e "${NEON_RED}║${NEON_GREEN}${BOLD}                     ⚡ MAXIMUM SPEED MODE ⚡                           ${NEON_RED}║${NC}"
    echo -e "${NEON_RED}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Function to show quote
show_quote() {
    echo ""
    echo -e "${NEON_PURPLE}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_PURPLE}║${NEON_YELLOW}${BOLD}                                                               ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}${BOLD}           ███████╗██╗     ██╗████████╗███████╗     ██╗  ██╗           ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}${BOLD}           ██╔════╝██║     ██║╚══██╔══╝██╔════╝     ╚██╗██╔╝           ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}${BOLD}           █████╗  ██║     ██║   ██║   █████╗  █████╗╚███╔╝            ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}${BOLD}           ██╔══╝  ██║     ██║   ██║   ██╔══╝  ╚════╝██╔██╗            ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}${BOLD}           ███████╗███████╗██║   ██║   ███████╗     ██╔╝ ██╗           ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}${BOLD}           ╚══════╝╚══════╝╚═╝   ╚═╝   ╚══════╝     ╚═╝  ╚═╝           ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}║${NEON_YELLOW}${BOLD}                                                               ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Activation function
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

# BOOSTER FUNCTIONS
enable_bbr_plus() {
    echo -e "${NEON_CYAN}🚀 ENABLING BBR PLUS CONGESTION CONTROL...${NC}"
    modprobe tcp_bbr 2>/dev/null || true
    echo "tcp_bbr" >> /etc/modules-load.d/modules.conf 2>/dev/null || true
    cat >> /etc/sysctl.conf <<EOF
net.core.default_qdisc = fq_codel
net.ipv4.tcp_congestion_control = bbr
net.ipv4.tcp_notsent_lowat = 16384
net.ipv4.tcp_slow_start_after_idle = 0
EOF
    echo -e "${NEON_GREEN}✅ BBR + FQ Codel enabled!${NC}"
}

optimize_cpu_performance() {
    echo -e "${NEON_CYAN}⚡ OPTIMIZING CPU FOR MAX PERFORMANCE...${NC}"
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
        [ -f "$cpu" ] && echo "performance" > "$cpu" 2>/dev/null || true
    done
    echo -e "${NEON_GREEN}✅ CPU optimized!${NC}"
}

tune_kernel_parameters() {
    echo -e "${NEON_CYAN}🧠 TUNING KERNEL PARAMETERS...${NC}"
    cat >> /etc/sysctl.conf <<EOF
fs.file-max = 2097152
fs.nr_open = 2097152
vm.swappiness = 5
vm.vfs_cache_pressure = 40
vm.dirty_ratio = 30
vm.dirty_background_ratio = 3
vm.min_free_kbytes = 131072
vm.overcommit_memory = 1
EOF
    echo -e "${NEON_GREEN}✅ Kernel tuned!${NC}"
}

optimize_dns_cache() {
    echo -e "${NEON_CYAN}📡 OPTIMIZING DNS CACHE...${NC}"
    apt install -y dnsmasq 2>/dev/null || true
    cat > /etc/dnsmasq.conf <<EOF
port=53
cache-size=10000
server=8.8.8.8
server=1.1.1.1
EOF
    systemctl restart dnsmasq 2>/dev/null || true
    echo -e "${NEON_GREEN}✅ DNS cache optimized!${NC}"
}

optimize_tcp_parameters() {
    echo -e "${NEON_CYAN}📶 APPLYING TCP ULTRA BOOST...${NC}"
    cat >> /etc/sysctl.conf <<EOF
net.ipv4.tcp_rmem = 4096 87380 536870912
net.ipv4.tcp_wmem = 4096 65536 536870912
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 5
EOF
    echo -e "${NEON_GREEN}✅ TCP ultra boost applied!${NC}"
}

optimize_buffer_mtu() {
    echo -e "${NEON_CYAN}⚡ OVERCLOCKING BUFFERS & MTU...${NC}"
    cat >> /etc/sysctl.conf <<EOF
net.core.rmem_max = 536870912
net.core.wmem_max = 536870912
net.core.netdev_max_backlog = 2000000
net.core.somaxconn = 131072
EOF
    echo -e "${NEON_GREEN}✅ Buffers overclocked!${NC}"
}

apply_all_boosters() {
    echo -e "${NEON_RED}${BLINK}🚀 APPLYING ALL BOOSTERS - OVERCLOCK MODE 🚀${NC}"
    enable_bbr_plus
    optimize_cpu_performance
    tune_kernel_parameters
    optimize_dns_cache
    optimize_tcp_parameters
    optimize_buffer_mtu
    sysctl -p 2>/dev/null || true
    echo -e "${NEON_GREEN}✅ ALL BOOSTERS APPLIED!${NC}"
}

# BOOSTER MENU
booster_menu() {
    while true; do
        clear
        echo -e "${NEON_CYAN}╔═══════════════════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${NEON_CYAN}║${NEON_YELLOW}${BOLD}                    🚀 ELITE-X ULTIMATE BOOSTER 🚀                       ${NEON_CYAN}║${NC}"
        echo -e "${NEON_CYAN}╠═══════════════════════════════════════════════════════════════════════════╣${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [B1] 🔥 TCP BBR + FQ Codel${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [B2] ⚡ CPU Performance${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [B3] 🧠 Kernel Tuning${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [B4] 📡 DNS Cache${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [B5] 📶 TCP Ultra Boost${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [B6] ⚡ Buffer/MTU Overclock${NC}"
        echo -e "${NEON_CYAN}║${NEON_RED}  [B13] 🚀 APPLY ALL BOOSTERS${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [0] ↩️ Back${NC}"
        echo -e "${NEON_CYAN}╚═══════════════════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        read -p "$(echo -e $NEON_GREEN"Booster option: "$NC)" bch
        
        case $bch in
            B1|b1) enable_bbr_plus; sysctl -p 2>/dev/null; read -p "Press Enter..." ;;
            B2|b2) optimize_cpu_performance; read -p "Press Enter..." ;;
            B3|b3) tune_kernel_parameters; sysctl -p 2>/dev/null; read -p "Press Enter..." ;;
            B4|b4) optimize_dns_cache; read -p "Press Enter..." ;;
            B5|b5) optimize_tcp_parameters; sysctl -p 2>/dev/null; read -p "Press Enter..." ;;
            B6|b6) optimize_buffer_mtu; sysctl -p 2>/dev/null; read -p "Press Enter..." ;;
            B13|b13) apply_all_boosters; read -p "Press Enter..." ;;
            0) return ;;
            *) echo -e "${NEON_RED}Invalid${NC}"; read -p "Press Enter..." ;;
        esac
    done
}

# ==================== MAIN SCRIPT ====================
show_banner

# Activation
echo -e "${NEON_YELLOW}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${NEON_YELLOW}║${NEON_GREEN}${BOLD}                    ACTIVATION REQUIRED                          ${NEON_YELLOW}║${NC}"
echo -e "${NEON_YELLOW}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${NEON_WHITE}Available Keys:${NC}"
echo -e "${NEON_GREEN}  💎 Lifetime : Whtsapp +255713-628-668${NC}"
echo -e "${NEON_YELLOW}  ⏳ Trial    : ELITE-X-TEST-0208 (2 days)${NC}"
echo ""
read -p "$(echo -e $NEON_CYAN"🔑 Activation Key: "$NC)" ACTIVATION_INPUT

mkdir -p /etc/elite-x
if ! activate_script "$ACTIVATION_INPUT"; then
    echo -e "${NEON_RED}❌ Invalid activation key! Installation cancelled.${NC}"
    exit 1
fi

echo -e "${NEON_GREEN}✅ Activation successful!${NC}"
sleep 1

# Subdomain input
echo -e "${NEON_CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${NEON_CYAN}║${NEON_WHITE}${BOLD}                  ENTER YOUR SUBDOMAIN                          ${NEON_CYAN}║${NC}"
echo -e "${NEON_CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""
read -p "$(echo -e $NEON_GREEN"🌐 Subdomain: "$NC)" TDOMAIN
echo "$TDOMAIN" > /etc/elite-x/subdomain

# Location selection
echo -e "${NEON_YELLOW}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${NEON_YELLOW}║${NEON_GREEN}${BOLD}           NETWORK LOCATION OPTIMIZATION                          ${NEON_YELLOW}║${NC}"
echo -e "${NEON_YELLOW}╠═══════════════════════════════════════════════════════════════╣${NC}"
echo -e "${NEON_YELLOW}║${NEON_WHITE}  Select your VPS location:                                    ${NEON_YELLOW}║${NC}"
echo -e "${NEON_YELLOW}║${NEON_GREEN}  [1] South Africa (MTU 1800)                                 ${NEON_YELLOW}║${NC}"
echo -e "${NEON_YELLOW}║${NEON_CYAN}  [2] USA                                                       ${NEON_YELLOW}║${NC}"
echo -e "${NEON_YELLOW}║${NEON_BLUE}  [3] Europe                                                    ${NEON_YELLOW}║${NC}"
echo -e "${NEON_YELLOW}║${NEON_PURPLE}  [4] Asia                                                      ${NEON_YELLOW}║${NC}"
echo -e "${NEON_YELLOW}║${NEON_RED}${BLINK}  [6] 🚀 OVERCLOCKED MODE (MAXIMUM SPEED)                        ${NEON_YELLOW}║${NC}"
echo -e "${NEON_YELLOW}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""
read -p "$(echo -e $NEON_GREEN"Select location [1-6] [default: 6]: "$NC)" LOCATION_CHOICE
LOCATION_CHOICE=${LOCATION_CHOICE:-6}

MTU=1800
SELECTED_LOCATION="South Africa"
OVERCLOCK_MODE=0

case $LOCATION_CHOICE in
    2) SELECTED_LOCATION="USA"; echo -e "${NEON_CYAN}✅ USA selected${NC}" ;;
    3) SELECTED_LOCATION="Europe"; echo -e "${NEON_BLUE}✅ Europe selected${NC}" ;;
    4) SELECTED_LOCATION="Asia"; echo -e "${NEON_PURPLE}✅ Asia selected${NC}" ;;
    6) SELECTED_LOCATION="OVERCLOCKED"; OVERCLOCK_MODE=1; echo -e "${NEON_RED}${BLINK}✅ OVERCLOCKED MODE SELECTED${NC}" ;;
    *) SELECTED_LOCATION="South Africa"; echo -e "${NEON_GREEN}✅ South Africa selected${NC}" ;;
esac

echo "$SELECTED_LOCATION" > /etc/elite-x/location
echo "$MTU" > /etc/elite-x/mtu

# Main menu function
main_menu() {
    while true; do
        clear
        echo -e "${NEON_PURPLE}╔═══════════════════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${NEON_PURPLE}║${NEON_YELLOW}${BOLD}               ELITE-X SLOWDNS v5.0 - OVERCLOCKED                     ${NEON_PURPLE}║${NC}"
        echo -e "${NEON_PURPLE}╠═══════════════════════════════════════════════════════════════════════════╣${NC}"
        echo -e "${NEON_PURPLE}║${NEON_WHITE}  🌐 Subdomain :${NEON_GREEN} $(cat /etc/elite-x/subdomain 2>/dev/null)${NC}"
        echo -e "${NEON_PURPLE}║${NEON_WHITE}  🌍 Location  :${NEON_GREEN} $SELECTED_LOCATION${NC}"
        if [ $OVERCLOCK_MODE -eq 1 ]; then
            echo -e "${NEON_PURPLE}║${NEON_WHITE}  ⚡ Mode      :${NEON_RED}${BLINK} OVERCLOCKED ACTIVE${NC}"
        fi
        echo -e "${NEON_PURPLE}╠═══════════════════════════════════════════════════════════════════════════╣${NC}"
        echo -e "${NEON_PURPLE}║${NEON_GREEN}${BOLD}                         🎯 MAIN MENU 🎯                               ${NEON_PURPLE}║${NC}"
        echo -e "${NEON_PURPLE}╠═══════════════════════════════════════════════════════════════════════════╣${NC}"
        echo -e "${NEON_PURPLE}║${NEON_WHITE}  [1] 👤 Create SSH User${NC}"
        echo -e "${NEON_PURPLE}║${NEON_WHITE}  [2] 📋 List Users${NC}"
        echo -e "${NEON_PURPLE}║${NEON_WHITE}  [3] 🔒 Lock User${NC}"
        echo -e "${NEON_PURPLE}║${NEON_WHITE}  [4] 🔓 Unlock User${NC}"
        echo -e "${NEON_PURPLE}║${NEON_WHITE}  [5] 🗑️ Delete User${NC}"
        echo -e "${NEON_PURPLE}║${NEON_RED}  [S] ⚙️  SETTINGS${NC}"
        echo -e "${NEON_PURPLE}║${NEON_WHITE}  [00] 🚪 Exit${NC}"
        echo -e "${NEON_PURPLE}╚═══════════════════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        read -p "$(echo -e $NEON_GREEN"Main menu option: "$NC)" ch
        
        case $ch in
            1) 
                read -p "Username: " username
                read -p "Password: " password
                read -p "Expire days: " days
                useradd -m -s /bin/false "$username" 2>/dev/null
                echo "$username:$password" | chpasswd
                expire_date=$(date -d "+$days days" +"%Y-%m-%d")
                chage -E "$expire_date" "$username"
                echo -e "${NEON_GREEN}✅ User $username created until $expire_date${NC}"
                read -p "Press Enter..." 
                ;;
            2)
                echo -e "${NEON_CYAN}Active Users:${NC}"
                awk -F: '$3>=1000 && $3<=60000 {print $1}' /etc/passwd
                read -p "Press Enter..."
                ;;
            3)
                read -p "Username to lock: " u
                passwd -l "$u" 2>/dev/null && echo -e "${NEON_GREEN}✅ Locked${NC}" || echo -e "${NEON_RED}❌ Failed${NC}"
                read -p "Press Enter..."
                ;;
            4)
                read -p "Username to unlock: " u
                passwd -u "$u" 2>/dev/null && echo -e "${NEON_GREEN}✅ Unlocked${NC}" || echo -e "${NEON_RED}❌ Failed${NC}"
                read -p "Press Enter..."
                ;;
            5)
                read -p "Username to delete: " u
                userdel -r "$u" 2>/dev/null && echo -e "${NEON_GREEN}✅ Deleted${NC}" || echo -e "${NEON_RED}❌ Failed${NC}"
                read -p "Press Enter..."
                ;;
            [Ss])
                while true; do
                    clear
                    echo -e "${NEON_CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
                    echo -e "${NEON_CYAN}║${NEON_YELLOW}${BOLD}                    SETTINGS MENU                              ${NEON_CYAN}║${NC}"
                    echo -e "${NEON_CYAN}╠═══════════════════════════════════════════════════════════════╣${NC}"
                    echo -e "${NEON_CYAN}║${NEON_WHITE}  [1] View Public Key${NC}"
                    echo -e "${NEON_CYAN}║${NEON_WHITE}  [2] Restart Services${NC}"
                    echo -e "${NEON_CYAN}║${NEON_WHITE}  [3] Reboot VPS${NC}"
                    echo -e "${NEON_CYAN}║${NEON_WHITE}  [4] Uninstall${NC}"
                    echo -e "${NEON_CYAN}║${NEON_RED}  [19] 🚀 BOOSTER MENU${NC}"
                    echo -e "${NEON_CYAN}║${NEON_WHITE}  [0] Back${NC}"
                    echo -e "${NEON_CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
                    echo ""
                    read -p "$(echo -e $NEON_GREEN"Settings option: "$NC)" s_ch
                    
                    case $s_ch in
                        1) cat /etc/dnstt/server.pub 2>/dev/null || echo "No key found"; read -p "Press Enter..." ;;
                        2) systemctl restart sshd; echo -e "${NEON_GREEN}✅ Restarted${NC}"; read -p "Press Enter..." ;;
                        3) reboot ;;
                        4) rm -rf /etc/elite-x; rm -f /usr/local/bin/elite-x*; echo -e "${NEON_GREEN}✅ Uninstalled${NC}"; exit 0 ;;
                        19) booster_menu ;;
                        0) break ;;
                        *) echo -e "${NEON_RED}Invalid${NC}"; read -p "Press Enter..." ;;
                    esac
                done
                ;;
            00|0) 
                show_quote
                exit 0 
                ;;
            *) echo -e "${NEON_RED}Invalid${NC}"; read -p "Press Enter..." ;;
        esac
    done
}

# Start main menu
main_menu
