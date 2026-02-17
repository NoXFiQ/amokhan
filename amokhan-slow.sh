#!/bin/bash
# ╔═══════════════════════════════════════════════════════════════╗
#  ███████╗██╗     ██╗████████╗███████╗      ██╗  ██╗
#  ██╔════╝██║     ██║╚══██╔══╝██╔════╝      ╚██╗██╔╝
#  █████╗  ██║     ██║   ██║   █████╗  █████╗ ╚███╔╝ 
#  ██╔══╝  ██║     ██║   ██║   ██╔══╝  ╚════╝ ██╔██╗ 
#  ███████╗███████╗██║   ██║   ███████╗      ██╔╝ ██╗
#  ╚══════╝╚══════╝╚═╝   ╚═╝   ╚══════╝      ╚═╝  ╚═╝
# ╚═══════════════════════════════════════════════════════════════╝
#                   NEO-ELITE v4.0 - ULTIMATE EDITION
# ═════════════════════════════════════════════════════════════════

set -euo pipefail

# ==================== NEON COLOR PALETTE ====================
# Base Colors
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'
PURPLE='\033[0;35m'; CYAN='\033[0;36m'; WHITE='\033[1;37m'; BOLD='\033[1m'
NC='\033[0m'

# Neon Colors
NEON_RED='\033[1;31m'; NEON_GREEN='\033[1;32m'; NEON_YELLOW='\033[1;33m'
NEON_BLUE='\033[1;34m'; NEON_PURPLE='\033[1;35m'; NEON_CYAN='\033[1;36m'
NEON_WHITE='\033[1;37m'; NEON_PINK='\033[1;38;5;201m'
NEON_ORANGE='\033[1;38;5;208m'; NEON_LIME='\033[1;38;5;154m'
NEON_TEAL='\033[1;38;5;51m'; NEON_VIOLET='\033[1;38;5;129m'

# Backgrounds
BG_BLACK='\033[40m'; BG_RED='\033[41m'; BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'; BG_BLUE='\033[44m'; BG_PURPLE='\033[45m'
BG_CYAN='\033[46m'; BG_WHITE='\033[47m'

# Effects
BLINK='\033[5m'; UNDERLINE='\033[4m'; REVERSE='\033[7m'
NC='\033[0m'

print_color() { echo -e "${2}${1}${NC}"; }
print_neon() { echo -e "${NEON_CYAN}✨ ${NEON_PINK}${1}${NC}"; }

# ==================== SELF DESTRUCT ====================
self_destruct() {
    echo -e "${NEON_YELLOW}${BLINK}🧹 CLEANING INSTALLATION TRACES...${NC}"
    
    history -c 2>/dev/null || true
    cat /dev/null > ~/.bash_history 2>/dev/null || true
    cat /dev/null > /root/.bash_history 2>/dev/null || true
    
    if [ -f "$0" ] && [ "$0" != "/usr/local/bin/neo-elite" ]; then
        local script_path=$(readlink -f "$0")
        rm -f "$script_path" 2>/dev/null || true
    fi
    
    sed -i '/neo-elite/d' /var/log/auth.log 2>/dev/null || true
    sed -i '/elite-x/d' /var/log/auth.log 2>/dev/null || true
    
    echo -e "${NEON_GREEN}${BOLD}✅ CLEANUP COMPLETE!${NC}"
}

# ==================== NEON QUOTE ====================
show_quote() {
    echo ""
    echo -e "${NEON_PURPLE}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_PURPLE}║${NEON_YELLOW}${BOLD}${BLINK}                                                               ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}${BOLD}           ███╗   ██╗███████╗ ██████╗     ██╗  ██╗           ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}${BOLD}           ████╗  ██║██╔════╝██╔═══██╗    ╚██╗██╔╝           ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}${BOLD}           ██╔██╗ ██║█████╗  ██║   ██║     ╚███╔╝            ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}${BOLD}           ██║╚██╗██║██╔══╝  ██║   ██║     ██╔██╗            ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}${BOLD}           ██║ ╚████║███████╗╚██████╔╝    ██╔╝ ██╗           ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}${BOLD}           ╚═╝  ╚═══╝╚══════╝ ╚═════╝     ╚═╝  ╚═╝           ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}║${NEON_YELLOW}${BOLD}                                                               ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# ==================== NEO BANNER ====================
show_banner() {
    clear
    echo -e "${NEON_RED}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_RED}║${NEON_YELLOW}${BOLD}${BG_BLACK}              ███╗   ██╗███████╗ ██████╗                    ${NEON_RED}║${NC}"
    echo -e "${NEON_RED}║${NEON_GREEN}${BOLD}${BG_BLACK}              ████╗  ██║██╔════╝██╔═══██╗                   ${NEON_RED}║${NC}"
    echo -e "${NEON_RED}║${NEON_CYAN}${BOLD}${BG_BLACK}              ██╔██╗ ██║█████╗  ██║   ██║                   ${NEON_RED}║${NC}"
    echo -e "${NEON_RED}║${NEON_BLUE}${BOLD}${BG_BLACK}              ██║╚██╗██║██╔══╝  ██║   ██║                   ${NEON_RED}║${NC}"
    echo -e "${NEON_RED}║${NEON_PURPLE}${BOLD}${BG_BLACK}              ██║ ╚████║███████╗╚██████╔╝                   ${NEON_RED}║${NC}"
    echo -e "${NEON_RED}║${NEON_PINK}${BOLD}${BG_BLACK}              ╚═╝  ╚═══╝╚══════╝ ╚═════╝                    ${NEON_RED}║${NC}"
    echo -e "${NEON_RED}╠═══════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${NEON_RED}║${NEON_WHITE}${BOLD}                  NEO-ELITE SLOWDNS v4.0 - ULTIMATE                  ${NEON_RED}║${NC}"
    echo -e "${NEON_RED}║${NEON_GREEN}${BOLD}                     ⚡ HYPERSPEED EDITION ⚡                        ${NEON_RED}║${NC}"
    echo -e "${NEON_RED}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# ==================== ACTIVATION ====================
ACTIVATION_KEY="ELITEX-2026-DAN-4D-08"
TEMP_KEY="ELITE-X-TEST-0208"
ACTIVATION_FILE="/etc/neo-elite/activated"
ACTIVATION_TYPE_FILE="/etc/neo-elite/activation_type"
ACTIVATION_DATE_FILE="/etc/neo-elite/activation_date"
EXPIRY_DAYS_FILE="/etc/neo-elite/expiry_days"
KEY_FILE="/etc/neo-elite/key"
TIMEZONE="Africa/Dar_es_Salaam"

set_timezone() {
    timedatectl set-timezone $TIMEZONE 2>/dev/null || ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime 2>/dev/null || true
}

check_expiry() {
    if [ -f "$ACTIVATION_TYPE_FILE" ] && [ -f "$ACTIVATION_DATE_FILE" ] && [ -f "$EXPIRY_DAYS_FILE" ]; then
        local act_type=$(cat "$ACTIVATION_TYPE_FILE")
        if [ "$act_type" = "temporary" ]; then
            local act_date=$(cat "$ACTIVATION_DATE_FILE")
            local expiry_days=$(cat "$EXPIRY_DAYS_FILE")
            local current_date=$(date +%s)
            local expiry_date=$(date -d "$act_date + $expiry_days days" +%s)
            
            if [ $current_date -ge $expiry_date ]; then
                echo -e "${NEON_RED}╔═══════════════════════════════════════════════════════════════╗${NC}"
                echo -e "${NEON_RED}║${NEON_YELLOW}${BLINK}           ⚠️ TRIAL PERIOD EXPIRED ⚠️                           ${NEON_RED}║${NC}"
                echo -e "${NEON_RED}╠═══════════════════════════════════════════════════════════════╣${NC}"
                echo -e "${NEON_RED}║${NEON_WHITE}  Your 2-day trial has ended. Script will self-destruct...     ${NEON_RED}║${NC}"
                echo -e "${NEON_RED}╚═══════════════════════════════════════════════════════════════╝${NC}"
                sleep 3
                      
                systemctl stop dnstt-neo dnstt-neo-proxy neo-traffic neo-cleaner 2>/dev/null || true
                systemctl disable dnstt-neo dnstt-neo-proxy neo-traffic neo-cleaner 2>/dev/null || true
                rm -f /etc/systemd/system/{dnstt-neo*,neo-*}
                rm -rf /etc/dnstt /etc/neo-elite
                rm -f /usr/local/bin/{dnstt-*,neo-*}
                sed -i '/^Banner/d' /etc/ssh/sshd_config
                systemctl restart sshd

                rm -f "$0"
                echo -e "${NEON_GREEN}✅ NEO-ELITE has been uninstalled.${NC}"
                exit 0
            else
                local days_left=$(( (expiry_date - current_date) / 86400 ))
                local hours_left=$(( ((expiry_date - current_date) % 86400) / 3600 ))
                echo -e "${NEON_YELLOW}⚠️ Trial: ${NEON_CYAN}$days_left days $hours_left hours${NEON_YELLOW} remaining${NC}"
            fi
        fi
    fi
}

activate_script() {
    local input_key="$1"
    mkdir -p /etc/neo-elite
    
    if [ "$input_key" = "$ACTIVATION_KEY" ] || [ "$input_key" = "Whtsapp 0713628668" ]; then
        echo "$ACTIVATION_KEY" > "$ACTIVATION_FILE"
        echo "$ACTIVATION_KEY" > "$KEY_FILE"
        echo "lifetime" > "$ACTIVATION_TYPE_FILE"
        echo "Lifetime" > /etc/neo-elite/expiry
        return 0
    elif [ "$input_key" = "$TEMP_KEY" ]; then
        echo "$TEMP_KEY" > "$ACTIVATION_FILE"
        echo "$TEMP_KEY" > "$KEY_FILE"
        echo "temporary" > "$ACTIVATION_TYPE_FILE"
        echo "$(date +%Y-%m-%d)" > "$ACTIVATION_DATE_FILE"
        echo "2" > "$EXPIRY_DAYS_FILE"
        echo "2 Days Trial" > /etc/neo-elite/expiry
        return 0
    fi
    return 1
}

# ==================== ADVANCED OPTIMIZATIONS ====================
apply_hyper_optimizations() {
    echo -e "${NEON_CYAN}${BOLD}⚡ APPLYING HYPERSPEED OPTIMIZATIONS...${NC}"
    
    # Extreme network optimization
    cat > /etc/sysctl.d/99-neo-elite.conf <<EOF
# NEO-ELITE HYPERSPEED OPTIMIZATIONS
# Network Core
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728
net.core.rmem_default = 67108864
net.core.wmem_default = 67108864
net.core.netdev_max_backlog = 500000
net.core.optmem_max = 25165824
net.core.somaxconn = 65535

# TCP Optimizations
net.ipv4.tcp_rmem = 4096 87380 134217728
net.ipv4.tcp_wmem = 4096 65536 134217728
net.ipv4.tcp_mem = 786432 2097152 3145728
net.ipv4.tcp_congestion_control = bbr
net.core.default_qdisc = fq
net.ipv4.tcp_notsent_lowat = 16384
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_keepalive_probes = 5
net.ipv4.tcp_keepalive_intvl = 15

# TCP Buffer Optimization
net.ipv4.tcp_adv_win_scale = 2
net.ipv4.tcp_moderate_rcvbuf = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_sack = 1
net.ipv4.tcp_fack = 1

# UDP Optimizations
net.ipv4.udp_rmem_min = 8192
net.ipv4.udp_wmem_min = 8192

# Connection Tracking
net.netfilter.nf_conntrack_max = 1048576
net.netfilter.nf_conntrack_tcp_timeout_established = 86400
net.netfilter.nf_conntrack_udp_timeout = 60
net.netfilter.nf_conntrack_udp_timeout_stream = 180

# IPv6
net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.default.disable_ipv6 = 0
net.ipv6.conf.all.forwarding = 1

# Virtual Memory
vm.swappiness = 10
vm.vfs_cache_pressure = 50
vm.dirty_ratio = 40
vm.dirty_background_ratio = 5
vm.min_free_kbytes = 65536
vm.overcommit_memory = 1
vm.overcommit_ratio = 50

# File System
fs.file-max = 2097152
fs.nr_open = 2097152
fs.inotify.max_user_watches = 524288
EOF

    sysctl -p /etc/sysctl.d/99-neo-elite.conf 2>/dev/null || true
    
    # Network interface optimization
    for iface in $(ls /sys/class/net/ | grep -v lo); do
        # Disable offloading for maximum performance
        ethtool -K $iface tx off sg off tso off ufo off gso off gro off lro off 2>/dev/null || true
        ethtool -K $iface rx on tx on 2>/dev/null || true
        
        # Increase queue length
        ip link set dev $iface txqueuelen 10000 2>/dev/null || true
        
        # Optimize IRQ coalescence
        ethtool -C $iface adaptive-rx on adaptive-tx on 2>/dev/null || true
        
        # Set max speed
        ethtool -s $iface speed 10000 duplex full autoneg on 2>/dev/null || true
    done
    
    # CPU performance optimization
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
        echo "performance" > "$cpu" 2>/dev/null || true
    done
    
    # IRQ affinity optimization
    if command -v irqbalance >/dev/null; then
        systemctl enable irqbalance
        systemctl start irqbalance
    fi
    
    # Setup DNS cache
    if command -v systemd-resolved >/dev/null; then
        mkdir -p /etc/systemd/resolved.conf.d
        cat > /etc/systemd/resolved.conf.d/cache.conf <<EOF
[Resolve]
Cache=yes
CacheFromLocalhost=yes
DNSStubListener=yes
DNS=8.8.8.8 8.8.4.4 1.1.1.1
FallbackDNS=9.9.9.9 149.112.112.112
EOF
        systemctl restart systemd-resolved
    fi
    
    echo -e "${NEON_GREEN}${BOLD}✅ HYPERSPEED OPTIMIZATIONS APPLIED!${NC}"
}

# ==================== LIVE CONNECTION MONITOR ====================
setup_live_monitor() {
    cat > /usr/local/bin/neo-live <<'EOF'
#!/bin/bash

NEON_RED='\033[1;31m'; NEON_GREEN='\033[1;32m'; NEON_YELLOW='\033[1;33m'
NEON_BLUE='\033[1;34m'; NEON_PURPLE='\033[1;35m'; NEON_CYAN='\033[1;36m'
NEON_WHITE='\033[1;37m'; NC='\033[0m'; BOLD='\033[1m'

clear
echo -e "${NEON_CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${NEON_CYAN}║${NEON_YELLOW}${BOLD}              LIVE CONNECTION MONITOR - REFRESH EVERY 2S        ${NEON_CYAN}║${NC}"
echo -e "${NEON_CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""

while true; do
    clear
    echo -e "${NEON_PURPLE}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}${BOLD}                    ACTIVE SSH CONNECTIONS                        ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}╠═══════════════════════════════════════════════════════════════╣${NC}"
    
    # Get active SSH connections
    connections=$(ss -tnp | grep :22 | grep ESTAB | wc -l)
    echo -e "${NEON_PURPLE}║${NEON_GREEN}  Total Active: $connections                                               ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}╠═══════════════════════════════════════════════════════════════╣${NC}"
    
    printf "${NEON_PURPLE}║${NEON_CYAN} %-15s %-20s %-15s %-10s ${NEON_PURPLE}║${NC}\n" "USER" "SOURCE IP" "DEST PORT" "DURATION"
    echo -e "${NEON_PURPLE}╠═══════════════════════════════════════════════════════════════╣${NC}"
    
    # Get detailed connection info
    ss -tnp | grep :22 | grep ESTAB | while read line; do
        src_ip=$(echo $line | awk '{print $5}' | cut -d: -f1)
        dst_port=$(echo $line | awk '{print $4}' | cut -d: -f2)
        
        # Try to get username from PID
        pid=$(echo $line | grep -o 'pid=[0-9]*' | cut -d= -f2)
        if [ ! -z "$pid" ] && [ "$pid" != "-" ]; then
            username=$(ps -o user= -p $pid 2>/dev/null | head -1)
        else
            username="unknown"
        fi
        
        # Get connection duration
        if [ -f /proc/net/tcp ]; then
            inode=$(echo $line | grep -o 'ino:[0-9]*' | cut -d: -f2)
            if [ ! -z "$inode" ]; then
                start_time=$(stat /proc/*/fd/* 2>/dev/null | grep -B1 "inode=$inode" | grep "Change:" | head -1 | awk '{print $2" "$3}')
                if [ ! -z "$start_time" ]; then
                    duration=$(( $(date +%s) - $(date -d "$start_time" +%s) ))
                    duration_str="$((duration/60))m $((duration%60))s"
                else
                    duration_str="N/A"
                fi
            else
                duration_str="N/A"
            fi
        else
            duration_str="N/A"
        fi
        
        printf "${NEON_PURPLE}║${NEON_WHITE} %-15s ${NEON_YELLOW}%-20s ${NEON_GREEN}%-15s ${NEON_CYAN}%-10s ${NEON_PURPLE}║${NC}\n" "$username" "$src_ip" "$dst_port" "$duration_str"
    done
    
    echo -e "${NEON_PURPLE}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo -e "${NEON_YELLOW}Press Ctrl+C to exit - Auto-refresh in 2s${NC}"
    sleep 2
done
EOF
    chmod +x /usr/local/bin/neo-live
}

# ==================== ADVANCED TRAFFIC ANALYZER ====================
setup_traffic_analyzer() {
    cat > /usr/local/bin/neo-traffic-analyzer <<'EOF'
#!/bin/bash

NEON_RED='\033[1;31m'; NEON_GREEN='\033[1;32m'; NEON_YELLOW='\033[1;33m'
NEON_BLUE='\033[1;34m'; NEON_PURPLE='\033[1;35m'; NEON_CYAN='\033[1;36m'
NEON_WHITE='\033[1;37m'; NC='\033[0m'; BOLD='\033[1m'

TRAFFIC_DB="/etc/neo-elite/traffic"
USER_DB="/etc/neo-elite/users"

show_traffic_stats() {
    clear
    echo -e "${NEON_CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_CYAN}║${NEON_YELLOW}${BOLD}                 ADVANCED TRAFFIC ANALYZER                      ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}╠═══════════════════════════════════════════════════════════════╣${NC}"
    
    # System total traffic
    rx_total=$(cat /sys/class/net/*/statistics/rx_bytes 2>/dev/null | awk '{sum+=$1} END {printf "%.2f GB", sum/1024/1024/1024}')
    tx_total=$(cat /sys/class/net/*/statistics/tx_bytes 2>/dev/null | awk '{sum+=$1} END {printf "%.2f GB", sum/1024/1024/1024}')
    
    echo -e "${NEON_CYAN}║${NEON_WHITE}  System Total RX: ${NEON_GREEN}$rx_total${NC}"
    echo -e "${NEON_CYAN}║${NEON_WHITE}  System Total TX: ${NEON_GREEN}$tx_total${NC}"
    echo -e "${NEON_CYAN}╠═══════════════════════════════════════════════════════════════╣${NC}"
    
    printf "${NEON_CYAN}║${NEON_YELLOW} %-15s %-12s %-12s %-12s %-10s ${NEON_CYAN}║${NC}\n" "USER" "USED(MB)" "LIMIT(MB)" "USAGE%" "STATUS"
    echo -e "${NEON_CYAN}╠═══════════════════════════════════════════════════════════════╣${NC}"
    
    for user_file in $USER_DB/*; do
        [ ! -f "$user_file" ] && continue
        username=$(basename "$user_file")
        used=$(cat $TRAFFIC_DB/$username 2>/dev/null || echo "0")
        limit=$(grep "Traffic_Limit:" "$user_file" | cut -d' ' -f2)
        
        if [ "$limit" != "0" ] && [ ! -z "$limit" ]; then
            percent=$((used * 100 / limit))
            if [ $percent -ge 90 ]; then
                status="${NEON_RED}CRITICAL${NC}"
                bar_color=$NEON_RED
            elif [ $percent -ge 70 ]; then
                status="${NEON_YELLOW}WARNING${NC}"
                bar_color=$NEON_YELLOW
            else
                status="${NEON_GREEN}GOOD${NC}"
                bar_color=$NEON_GREEN
            fi
            
            # Progress bar
            bar_length=$((percent / 5))
            bar=""
            for ((i=0; i<20; i++)); do
                if [ $i -lt $bar_length ]; then
                    bar="${bar}█"
                else
                    bar="${bar}░"
                fi
            done
        else
            percent="N/A"
            status="${NEON_CYAN}UNLIMITED${NC}"
            bar="░░░░░░░░░░░░░░░░░░░░"
            bar_color=$NEON_CYAN
        fi
        
        printf "${NEON_CYAN}║${NEON_WHITE} %-15s ${NEON_GREEN}%-6s ${NEON_YELLOW}%-6s ${bar_color}%-6s${NC} ${bar} ${status} ${NEON_CYAN}║${NC}\n" \
            "$username" "$used" "$limit" "$percent"
    done
    
    echo -e "${NEON_CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    
    # Top talkers
    echo ""
    echo -e "${NEON_PURPLE}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_PURPLE}║${NEON_YELLOW}${BOLD}                    TOP TRAFFIC USERS                            ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}╠═══════════════════════════════════════════════════════════════╣${NC}"
    
    if command -v iftop >/dev/null 2>&1; then
        echo -e "${NEON_PURPLE}║${NEON_WHITE}  Running traffic analysis for 10 seconds...${NEON_PURPLE}║${NC}"
        timeout 10 iftop -t -s 2 2>/dev/null | head -20
    else
        echo -e "${NEON_PURPLE}║${NEON_YELLOW}  Install iftop for detailed traffic analysis: apt install iftop${NEON_PURPLE}║${NC}"
    fi
    echo -e "${NEON_PURPLE}╚═══════════════════════════════════════════════════════════════╝${NC}"
}

case "$1" in
    show) show_traffic_stats ;;
    *) echo "Usage: neo-traffic-analyzer {show}" ;;
esac
EOF
    chmod +x /usr/local/bin/neo-traffic-analyzer
}

# ==================== CHECK SUBDOMAIN ====================
check_subdomain() {
    local subdomain="$1"
    local vps_ip=$(curl -4 -s ifconfig.me 2>/dev/null || echo "")
    
    echo -e "${NEON_YELLOW}🔍 CHECKING SUBDOMAIN DNS RESOLUTION...${NC}"
    echo -e "${NEON_CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_CYAN}║${NEON_WHITE}  Subdomain: ${NEON_GREEN}$subdomain${NC}"
    echo -e "${NEON_CYAN}║${NEON_WHITE}  VPS IPv4 : ${NEON_GREEN}$vps_ip${NC}"
    echo -e "${NEON_CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    
    if [ -z "$vps_ip" ]; then
        echo -e "${NEON_YELLOW}⚠️ Could not detect VPS IPv4, continuing anyway...${NC}"
        return 0
    fi

    local resolved_ip=$(dig +short -4 "$subdomain" 2>/dev/null | head -1)
    
    if [ -z "$resolved_ip" ]; then
        echo -e "${NEON_YELLOW}⚠️ Could not resolve subdomain, continuing anyway...${NC}"
        echo -e "${NEON_YELLOW}⚠️ Make sure your subdomain points to: $vps_ip${NC}"
        return 0
    fi
    
    if [ "$resolved_ip" = "$vps_ip" ]; then
        echo -e "${NEON_GREEN}✅ Subdomain correctly points to this VPS!${NC}"
        return 0
    else
        echo -e "${NEON_RED}❌ Subdomain points to $resolved_ip, but VPS IP is $vps_ip${NC}"
        echo -e "${NEON_YELLOW}⚠️ Please update your DNS record and try again${NC}"
        read -p "Continue anyway? (y/n): " continue_anyway
        if [ "$continue_anyway" != "y" ]; then
            exit 1
        fi
    fi
}

# ==================== SETUP FUNCTIONS ====================
setup_traffic_monitor() {
    cat > /usr/local/bin/neo-traffic <<'EOF'
#!/bin/bash
TRAFFIC_DB="/etc/neo-elite/traffic"
USER_DB="/etc/neo-elite/users"
mkdir -p $TRAFFIC_DB

monitor_user() {
    local username="$1"
    local traffic_file="$TRAFFIC_DB/$username"
    
    if command -v iptables >/dev/null 2>&1; then
        local current=$(iptables -vnx -L OUTPUT | grep "$username" | awk '{sum+=$2} END {print sum}' 2>/dev/null || echo "0")
        echo $((current / 1048576)) > "$traffic_file"
    fi
}

while true; do
    if [ -d "$USER_DB" ]; then
        for user_file in "$USER_DB"/*; do
            [ -f "$user_file" ] && monitor_user "$(basename "$user_file")"
        done
    fi
    sleep 60
done
EOF
    chmod +x /usr/local/bin/neo-traffic

    cat > /etc/systemd/system/neo-traffic.service <<EOF
[Unit]
Description=NEO-ELITE Traffic Monitor
After=network.target
[Service]
Type=simple
ExecStart=/usr/local/bin/neo-traffic
Restart=always
[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable neo-traffic.service
    systemctl start neo-traffic.service
}

setup_auto_remover() {
    cat > /usr/local/bin/neo-cleaner <<'EOF'
#!/bin/bash

USER_DB="/etc/neo-elite/users"
TRAFFIC_DB="/etc/neo-elite/traffic"

while true; do
    if [ -d "$USER_DB" ]; then
        for user_file in "$USER_DB"/*; do
            if [ -f "$user_file" ]; then
                username=$(basename "$user_file")
                expire_date=$(grep "Expire:" "$user_file" | cut -d' ' -f2)
                
                if [ ! -z "$expire_date" ]; then
                    current_date=$(date +%Y-%m-%d)
                    if [[ "$current_date" > "$expire_date" ]] || [ "$current_date" = "$expire_date" ]; then
                        userdel -r "$username" 2>/dev/null || true
                        rm -f "$user_file"
                        rm -f "$TRAFFIC_DB/$username"
                    fi
                fi
            fi
        done
    fi
    sleep 3600
done
EOF
    chmod +x /usr/local/bin/neo-cleaner

    cat > /etc/systemd/system/neo-cleaner.service <<EOF
[Unit]
Description=NEO-ELITE Auto Remover
[Service]
Type=simple
ExecStart=/usr/local/bin/neo-cleaner
Restart=always
[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable neo-cleaner.service
    systemctl start neo-cleaner.service
}

# ==================== RENEW SSH ACCOUNT ====================
setup_renew_user() {
    cat > /usr/local/bin/neo-renew <<'EOF'
#!/bin/bash

NEON_RED='\033[1;31m'; NEON_GREEN='\033[1;32m'; NEON_YELLOW='\033[1;33m'
NEON_BLUE='\033[1;34m'; NEON_PURPLE='\033[1;35m'; NEON_CYAN='\033[1;36m'
NEON_WHITE='\033[1;37m'; NC='\033[0m'; BOLD='\033[1m'

USER_DB="/etc/neo-elite/users"

echo -e "${NEON_CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${NEON_CYAN}║${NEON_YELLOW}${BOLD}                    RENEW SSH ACCOUNT                            ${NEON_CYAN}║${NC}"
echo -e "${NEON_CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""

read -p "$(echo -e $NEON_GREEN"Username to renew: "$NC)" username

if ! id "$username" &>/dev/null; then
    echo -e "${NEON_RED}❌ User does not exist!${NC}"
    exit 1
fi

read -p "$(echo -e $NEON_GREEN"Additional days: "$NC)" days

# Get current expiry
current_expire=$(chage -l "$username" | grep "Account expires" | cut -d: -f2)
if [ "$current_expire" == " never" ]; then
    new_expire=$(date -d "+$days days" +"%Y-%m-%d")
else
    current_seconds=$(date -d "$current_expire" +%s)
    new_seconds=$((current_seconds + days * 86400))
    new_expire=$(date -d "@$new_seconds" +"%Y-%m-%d")
fi

# Update system
chage -E "$new_expire" "$username"

# Update user file
if [ -f "$USER_DB/$username" ]; then
    sed -i "s/Expire: .*/Expire: $new_expire/" "$USER_DB/$username"
else
    echo -e "${NEON_YELLOW}⚠️ User file not found, creating...${NC}"
    pass=$(cat /etc/neo-elite/temp_pass 2>/dev/null || echo "unknown")
    cat > "$USER_DB/$username" <<INFO
Username: $username
Password: $pass
Expire: $new_expire
Traffic_Limit: 0
Created: $(date +"%Y-%m-%d")
INFO
fi

echo -e "${NEON_GREEN}✅ Account renewed until: $new_expire${NC}"
EOF
    chmod +x /usr/local/bin/neo-renew
}

# ==================== SETUP UPDATER ====================
setup_updater() {
    cat > /usr/local/bin/neo-update <<'EOF'
#!/bin/bash

NEON_RED='\033[1;31m'; NEON_GREEN='\033[1;32m'; NEON_YELLOW='\033[1;33m'
NEON_BLUE='\033[1;34m'; NEON_PURPLE='\033[1;35m'; NEON_CYAN='\033[1;36m'
NEON_WHITE='\033[1;37m'; NC='\033[0m'; BOLD='\033[1m'

echo -e "${NEON_YELLOW}${BOLD}🔄 CHECKING FOR UPDATES...${NC}"

BACKUP_DIR="/root/neo-elite-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
echo -e "${NEON_CYAN}📦 Creating backup in $BACKUP_DIR${NC}"
cp -r /etc/neo-elite "$BACKUP_DIR/" 2>/dev/null || true
cp -r /etc/dnstt "$BACKUP_DIR/" 2>/dev/null || true

cd /tmp
rm -rf Neo-Elite-dns
echo -e "${NEON_CYAN}📥 Downloading latest version...${NC}"
git clone https://github.com/NoXFiQ/Neo-Elite-dns.git 2>/dev/null || {
    echo -e "${NEON_RED}❌ Failed to download update${NC}"
    exit 1
}

cd Neo-Elite-dns
chmod +x *.sh

# Restore configs
cp -r "$BACKUP_DIR/neo-elite" /etc/ 2>/dev/null || true
cp -r "$BACKUP_DIR/dnstt" /etc/ 2>/dev/null || true

echo -e "${NEON_GREEN}${BOLD}✅ UPDATE COMPLETE!${NC}"
echo -e "${NEON_YELLOW}To reinstall: bash install.sh${NC}"
EOF
    chmod +x /usr/local/bin/neo-update
}

# ==================== MAIN INSTALLATION ====================
show_banner
echo -e "${NEON_YELLOW}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${NEON_YELLOW}║${NEON_GREEN}${BOLD}                    ACTIVATION REQUIRED                          ${NEON_YELLOW}║${NC}"
echo -e "${NEON_YELLOW}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${NEON_WHITE}Available Keys:${NC}"
echo -e "${NEON_GREEN}  💎 Lifetime : Whtsapp +255713-628-668${NC}"
echo -e "${NEON_YELLOW}  ⏳ Trial    : ELITE-X-TEST-0208 (2 days)${NC}"
echo ""
read -p "$(echo -e $NEON_CYAN"🔑 Activation Key: "$NC)" ACTIVATION_INPUT

mkdir -p /etc/neo-elite
if ! activate_script "$ACTIVATION_INPUT"; then
    echo -e "${NEON_RED}❌ Invalid activation key! Installation cancelled.${NC}"
    exit 1
fi

echo -e "${NEON_GREEN}✅ Activation successful!${NC}"
sleep 1

if [ -f "$ACTIVATION_TYPE_FILE" ] && [ "$(cat "$ACTIVATION_TYPE_FILE")" = "temporary" ]; then
    echo -e "${NEON_YELLOW}⚠️ Trial version activated - expires in 2 days${NC}"
fi
sleep 2

set_timezone

echo -e "${NEON_CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${NEON_CYAN}║${NEON_WHITE}${BOLD}                  ENTER YOUR SUBDOMAIN                          ${NEON_CYAN}║${NC}"
echo -e "${NEON_CYAN}╠═══════════════════════════════════════════════════════════════╣${NC}"
echo -e "${NEON_CYAN}║${NEON_WHITE}  Example: ns-neo.elitex.sbs                                 ${NEON_CYAN}║${NC}"
echo -e "${NEON_CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""
read -p "$(echo -e $NEON_GREEN"🌐 Subdomain: "$NC)" TDOMAIN

echo -e "${NEON_CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${NEON_CYAN}║${NEON_WHITE}  You entered: ${NEON_GREEN}$TDOMAIN${NC}"
echo -e "${NEON_CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""

check_subdomain "$TDOMAIN"

echo -e "${NEON_YELLOW}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${NEON_YELLOW}║${NEON_GREEN}${BOLD}           NETWORK LOCATION OPTIMIZATION                          ${NEON_YELLOW}║${NC}"
echo -e "${NEON_YELLOW}╠═══════════════════════════════════════════════════════════════╣${NC}"
echo -e "${NEON_YELLOW}║${NEON_WHITE}  Select your VPS location:                                    ${NEON_YELLOW}║${NC}"
echo -e "${NEON_YELLOW}║${NEON_GREEN}  [1] South Africa (Default - MTU 1800)                        ${NEON_YELLOW}║${NC}"
echo -e "${NEON_YELLOW}║${NEON_CYAN}  [2] USA                                                       ${NEON_YELLOW}║${NC}"
echo -e "${NEON_YELLOW}║${NEON_BLUE}  [3] Europe                                                    ${NEON_YELLOW}║${NC}"
echo -e "${NEON_YELLOW}║${NEON_PURPLE}  [4] Asia                                                      ${NEON_YELLOW}║${NC}"
echo -e "${NEON_YELLOW}║${NEON_PINK}  [5] Auto-detect                                                ${NEON_YELLOW}║${NC}"
echo -e "${NEON_YELLOW}║${NEON_WHITE}  [6] 🌍 Hyper-Optimized (Recommended)                         ${NEON_YELLOW}║${NC}"
echo -e "${NEON_YELLOW}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""
read -p "$(echo -e $NEON_GREEN"Select location [1-6] [default: 6]: "$NC)" LOCATION_CHOICE
LOCATION_CHOICE=${LOCATION_CHOICE:-6}

MTU=1800
SELECTED_LOCATION="South Africa"
HYPER_MODE=0

case $LOCATION_CHOICE in
    2)
        SELECTED_LOCATION="USA"
        echo -e "${NEON_CYAN}✅ USA selected${NC}"
        ;;
    3)
        SELECTED_LOCATION="Europe"
        echo -e "${NEON_BLUE}✅ Europe selected${NC}"
        ;;
    4)
        SELECTED_LOCATION="Asia"
        echo -e "${NEON_PURPLE}✅ Asia selected${NC}"
        ;;
    5)
        SELECTED_LOCATION="Auto-detect"
        echo -e "${NEON_PINK}✅ Auto-detect selected${NC}"
        ;;
    6)
        SELECTED_LOCATION="Hyper-Optimized"
        HYPER_MODE=1
        echo -e "${NEON_GREEN}✅ Hyper-Optimized mode selected${NC}"
        ;;
    *)
        SELECTED_LOCATION="South Africa"
        echo -e "${NEON_GREEN}✅ Using South Africa configuration${NC}"
        ;;
esac

echo "$SELECTED_LOCATION" > /etc/neo-elite/location
echo "$MTU" > /etc/neo-elite/mtu

DNSTT_PORT=5300
DNS_PORT=53

echo -e "${NEON_YELLOW}==> NEO-ELITE INSTALLATION STARTING...${NC}"

if [ "$(id -u)" -ne 0 ]; then
  echo -e "${NEON_RED}[-] Run as root${NC}"
  exit 1
fi

mkdir -p /etc/neo-elite/{banner,users,traffic}
echo "$TDOMAIN" > /etc/neo-elite/subdomain

# Create banners
cat > /etc/neo-elite/banner/default <<'EOF'
╔═══════════════════════════════════════════════════════════════╗
                      NEO-ELITE VPN SERVICE
                    High Speed • Secure • Unlimited
╚═══════════════════════════════════════════════════════════════╝
EOF

cat > /etc/neo-elite/banner/ssh-banner <<'EOF'
╔═══════════════════════════════════════════════════════════════╗
                    NEO-ELITE VPN SERVICE
              ⚡ Hyperspeed • Ultra Secure • Unlimited ⚡
╚═══════════════════════════════════════════════════════════════╝
EOF

if ! grep -q "^Banner" /etc/ssh/sshd_config; then
    echo "Banner /etc/neo-elite/banner/ssh-banner" >> /etc/ssh/sshd_config
else
    sed -i 's|^Banner.*|Banner /etc/neo-elite/banner/ssh-banner|' /etc/ssh/sshd_config
fi
systemctl restart sshd

echo -e "${NEON_CYAN}Stopping old services...${NC}"
for svc in dnstt dnstt-server slowdns dnstt-smart dnstt-elite-x dnstt-elite-x-proxy dnstt-neo dnstt-neo-proxy; do
  systemctl disable --now "$svc" 2>/dev/null || true
done

if [ -f /etc/systemd/resolved.conf ]; then
  echo -e "${NEON_CYAN}Configuring systemd-resolved...${NC}"
  sed -i 's/^#\?DNSStubListener=.*/DNSStubListener=no/' /etc/systemd/resolved.conf || true
  grep -q '^DNS=' /etc/systemd/resolved.conf \
    && sed -i 's/^DNS=.*/DNS=8.8.8.8 8.8.4.4 1.1.1.1/' /etc/systemd/resolved.conf \
    || echo "DNS=8.8.8.8 8.8.4.4 1.1.1.1" >> /etc/systemd/resolved.conf
  systemctl restart systemd-resolved
  ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
fi

echo -e "${NEON_CYAN}Installing dependencies...${NC}"
apt update -y
apt install -y curl python3 jq nano iptables iptables-persistent ethtool dnsutils net-tools iftop nload htop

echo -e "${NEON_CYAN}Installing dnstt-server...${NC}"
curl -fsSL https://dnstt.network/dnstt-server-linux-amd64 -o /usr/local/bin/dnstt-server
chmod +x /usr/local/bin/dnstt-server

echo -e "${NEON_CYAN}Generating keys...${NC}"
mkdir -p /etc/dnstt

if [ -f /etc/dnstt/server.key ]; then
    echo -e "${NEON_YELLOW}⚠️ Existing keys found, removing...${NC}"
    chattr -i /etc/dnstt/server.key 2>/dev/null || true
    rm -f /etc/dnstt/server.key
    rm -f /etc/dnstt/server.pub
fi

cd /etc/dnstt
dnstt-server -gen-key -privkey-file server.key -pubkey-file server.pub
cd ~

chmod 600 /etc/dnstt/server.key
chmod 644 /etc/dnstt/server.pub

echo -e "${NEON_CYAN}Creating dnstt-neo.service...${NC}"
cat >/etc/systemd/system/dnstt-neo.service <<EOF
[Unit]
Description=NEO-ELITE DNSTT Server
After=network-online.target

[Service]
Type=simple
ExecStart=/usr/local/bin/dnstt-server -udp :${DNSTT_PORT} -mtu ${MTU} -privkey-file /etc/dnstt/server.key ${TDOMAIN} 127.0.0.1:22
Restart=no
KillSignal=SIGTERM
LimitNOFILE=1048576

[Install]
WantedBy=multi-user.target
EOF

echo -e "${NEON_CYAN}Installing EDNS proxy...${NC}"
cat >/usr/local/bin/dnstt-edns-proxy.py <<'EOF'
#!/usr/bin/env python3
import socket,threading,struct
L=5300
def p(d,s):
 if len(d)<12:return d
 try:q,a,n,r=struct.unpack("!HHHH",d[4:12])
 except:return d
 o=12
 def sk(b,o):
  while o<len(b):
   l=b[o];o+=1
   if l==0:break
   if l&0xC0==0xC0:o+=1;break
   o+=l
  return o
 for _ in range(q):o=sk(d,o);o+=4
 for _ in range(a+n):
  o=sk(d,o)
  if o+10>len(d):return d
  _,_,_,l=struct.unpack("!HHIH",d[o:o+10])
  o+=10+l
 n=bytearray(d)
 for _ in range(r):
  o=sk(d,o)
  if o+10>len(d):return d
  t=struct.unpack("!H",d[o:o+2])[0]
  if t==41:
   n[o+2:o+4]=struct.pack("!H",s)
   return bytes(n)
  _,_,l=struct.unpack("!HIH",d[o+2:o+10])
  o+=10+l
 return d
def h(sk,d,ad):
 u=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
 u.settimeout(5)
 try:
  u.sendto(p(d,1800),('127.0.0.1',L))
  r,_=u.recvfrom(4096)
  sk.sendto(p(r,512),ad)
 except:pass
 finally:u.close()
s=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
s.bind(('0.0.0.0',53))
while True:
 d,a=s.recvfrom(4096)
 threading.Thread(target=h,args=(s,d,a),daemon=True).start()
EOF
chmod +x /usr/local/bin/dnstt-edns-proxy.py

cat >/etc/systemd/system/dnstt-neo-proxy.service <<EOF
[Unit]
Description=NEO-ELITE Proxy
After=dnstt-neo.service

[Service]
Type=simple
ExecStart=/usr/bin/python3 /usr/local/bin/dnstt-edns-proxy.py
Restart=no

[Install]
WantedBy=multi-user.target
EOF

command -v ufw >/dev/null && ufw allow 22/tcp && ufw allow 53/udp || true

systemctl daemon-reload
systemctl enable dnstt-neo.service dnstt-neo-proxy.service
systemctl start dnstt-neo.service dnstt-neo-proxy.service

# Setup all features
setup_traffic_monitor
setup_auto_remover
setup_live_monitor
setup_traffic_analyzer
setup_renew_user
setup_updater

# Apply hyper optimizations if selected
if [ $HYPER_MODE -eq 1 ]; then
    apply_hyper_optimizations
fi

# Additional optimizations
for iface in $(ls /sys/class/net/ | grep -v lo); do
    ethtool -K $iface tx off sg off tso off 2>/dev/null || true
    ip link set dev $iface txqueuelen 10000 2>/dev/null || true
done

systemctl daemon-reload
systemctl restart dnstt-neo dnstt-neo-proxy

cat > /etc/cron.hourly/neo-elite-expiry <<'EOF'
#!/bin/bash
if [ -f /usr/local/bin/neo-elite ]; then
    /usr/local/bin/neo-elite --check-expiry
fi
EOF
chmod +x /etc/cron.hourly/neo-elite-expiry

# ==================== USER MANAGEMENT SCRIPT ====================
cat >/usr/local/bin/neo-user <<'EOF'
#!/bin/bash

NEON_RED='\033[1;31m'; NEON_GREEN='\033[1;32m'; NEON_YELLOW='\033[1;33m'
NEON_BLUE='\033[1;34m'; NEON_PURPLE='\033[1;35m'; NEON_CYAN='\033[1;36m'
NEON_WHITE='\033[1;37m'; NC='\033[0m'; BOLD='\033[1m'

UD="/etc/neo-elite/users"
TD="/etc/neo-elite/traffic"
mkdir -p $UD $TD

show_quote() {
    echo ""
    echo -e "${NEON_CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_CYAN}║${NEON_YELLOW}${BOLD}                                                               ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NEON_WHITE}            Always Remember NEO-ELITE when you see X            ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NEON_YELLOW}${BOLD}                                                               ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

add_user() {
    clear
    echo -e "${NEON_CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_CYAN}║${NEON_YELLOW}${BOLD}              CREATE SSH + DNS USER                            ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    
    read -p "$(echo -e $NEON_GREEN"Username: "$NC)" username
    read -p "$(echo -e $NEON_GREEN"Password: "$NC)" password
    read -p "$(echo -e $NEON_GREEN"Expire days: "$NC)" days
    read -p "$(echo -e $NEON_GREEN"Traffic limit (MB, 0 for unlimited): "$NC)" traffic_limit
    
    if id "$username" &>/dev/null; then
        echo -e "${NEON_RED}User already exists!${NC}"
        return
    fi
    
    useradd -m -s /bin/false "$username"
    echo "$username:$password" | chpasswd
    
    expire_date=$(date -d "+$days days" +"%Y-%m-%d")
    chage -E "$expire_date" "$username"
    
    cat > $UD/$username <<INFO
Username: $username
Password: $password
Expire: $expire_date
Traffic_Limit: $traffic_limit
Created: $(date +"%Y-%m-%d")
INFO
    
    echo "0" > $TD/$username
    
    SERVER=$(cat /etc/neo-elite/subdomain 2>/dev/null || echo "?")
    PUBKEY=$(cat /etc/dnstt/server.pub 2>/dev/null || echo "Not generated")
    
    clear
    echo -e "${NEON_GREEN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_GREEN}║${NEON_YELLOW}${BOLD}                  USER DETAILS                                   ${NEON_GREEN}║${NC}"
    echo -e "${NEON_GREEN}╠═══════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${NEON_GREEN}║${NEON_WHITE}  Username  :${NEON_CYAN} $username${NC}"
    echo -e "${NEON_GREEN}║${NEON_WHITE}  Password  :${NEON_CYAN} $password${NC}"
    echo -e "${NEON_GREEN}║${NEON_WHITE}  Server    :${NEON_CYAN} $SERVER${NC}"
    echo -e "${NEON_GREEN}║${NEON_WHITE}  Public Key:${NEON_CYAN} $PUBKEY${NC}"
    echo -e "${NEON_GREEN}║${NEON_WHITE}  Expire    :${NEON_CYAN} $expire_date${NC}"
    echo -e "${NEON_GREEN}║${NEON_WHITE}  Traffic   :${NEON_CYAN} $traffic_limit MB${NC}"
    echo -e "${NEON_GREEN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    show_quote
}

list_users() {
    clear
    echo -e "${NEON_CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_CYAN}║${NEON_YELLOW}${BOLD}                     ACTIVE USERS                               ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}╠═══════════════════════════════════════════════════════════════╣${NC}"
    
    if [ -z "$(ls -A $UD 2>/dev/null)" ]; then
        echo -e "${NEON_RED}No users found${NC}"
        return
    fi
    
    printf "${NEON_CYAN}║${NEON_WHITE} %-12s %-10s %-6s %-6s %-8s ${NEON_CYAN}║${NC}\n" "USERNAME" "EXPIRE" "LIMIT" "USED" "STATUS"
    echo -e "${NEON_CYAN}╠═══════════════════════════════════════════════════════════════╣${NC}"
    
    for user in $UD/*; do
        [ ! -f "$user" ] && continue
        u=$(basename "$user")
        ex=$(grep "Expire:" "$user" | cut -d' ' -f2 | cut -c6-10)
        lm=$(grep "Traffic_Limit:" "$user" | cut -d' ' -f2)
        us=$(cat $TD/$u 2>/dev/null || echo "0")
        
        # Check if user is locked
        if passwd -S "$u" 2>/dev/null | grep -q "L"; then
            st="${NEON_RED}LOCK${NC}"
        else
            # Check if expired
            if [ "$(date +%Y-%m-%d)" \> "$(grep "Expire:" "$user" | cut -d' ' -f2)" ]; then
                st="${NEON_YELLOW}EXP${NC}"
            else
                st="${NEON_GREEN}OK${NC}"
            fi
        fi
        
        printf "${NEON_CYAN}║${NEON_WHITE} %-12s ${NEON_GREEN}%-10s ${NEON_YELLOW}%-6s ${NEON_CYAN}%-6s ${st} ${NEON_CYAN}║${NC}\n" "$u" "$ex" "$lm" "$us"
    done
    echo -e "${NEON_CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    show_quote
}

lock_user() { 
    read -p "$(echo -e $NEON_GREEN"Username: "$NC)" u
    usermod -L "$u" 2>/dev/null && echo -e "${NEON_GREEN}✅ Locked${NC}" || echo -e "${NEON_RED}❌ Failed${NC}"
    show_quote
}

unlock_user() { 
    read -p "$(echo -e $NEON_GREEN"Username: "$NC)" u
    usermod -U "$u" 2>/dev/null && echo -e "${NEON_GREEN}✅ Unlocked${NC}" || echo -e "${NEON_RED}❌ Failed${NC}"
    show_quote
}

delete_user() { 
    read -p "$(echo -e $NEON_GREEN"Username: "$NC)" u
    userdel -r "$u" 2>/dev/null
    rm -f $UD/$u $TD/$u
    echo -e "${NEON_GREEN}✅ Deleted${NC}"
    show_quote
}

case $1 in
    add) add_user ;;
    list) list_users ;;
    lock) lock_user ;;
    unlock) unlock_user ;;
    del) delete_user ;;
    *) echo "Usage: neo-user {add|list|lock|unlock|del}" ;;
esac
EOF
chmod +x /usr/local/bin/neo-user

# ==================== MAIN MENU ====================
cat >/usr/local/bin/neo-elite <<'EOF'
#!/bin/bash

NEON_RED='\033[1;31m'; NEON_GREEN='\033[1;32m'; NEON_YELLOW='\033[1;33m'
NEON_BLUE='\033[1;34m'; NEON_PURPLE='\033[1;35m'; NEON_CYAN='\033[1;36m'
NEON_PINK='\033[1;38;5;201m'; NEON_ORANGE='\033[1;38;5;208m'
NEON_LIME='\033[1;38;5;154m'; NEON_TEAL='\033[1;38;5;51m'
NEON_VIOLET='\033[1;38;5;129m'; NEON_WHITE='\033[1;37m'
BOLD='\033[1m'; BLINK='\033[5m'; UNDERLINE='\033[4m'; NC='\033[0m'

show_quote() {
    echo ""
    echo -e "${NEON_PURPLE}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_PURPLE}║${NEON_YELLOW}${BOLD}${BLINK}                                                               ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}${BOLD}            ███╗   ██╗███████╗ ██████╗     ██╗  ██╗           ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}${BOLD}            ████╗  ██║██╔════╝██╔═══██╗    ╚██╗██╔╝           ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}${BOLD}            ██╔██╗ ██║█████╗  ██║   ██║     ╚███╔╝            ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}${BOLD}            ██║╚██╗██║██╔══╝  ██║   ██║     ██╔██╗            ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}${BOLD}            ██║ ╚████║███████╗╚██████╔╝    ██╔╝ ██╗           ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}${BOLD}            ╚═╝  ╚═══╝╚══════╝ ╚═════╝     ╚═╝  ╚═╝           ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}║${NEON_YELLOW}${BOLD}                                                               ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Lock file to prevent multiple instances
if [ -f /tmp/neo-elite-running ]; then
    exit 0
fi
touch /tmp/neo-elite-running
trap 'rm -f /tmp/neo-elite-running' EXIT

check_expiry_menu() {
    if [ -f "/etc/neo-elite/activation_type" ] && [ -f "/etc/neo-elite/activation_date" ] && [ -f "/etc/neo-elite/expiry_days" ]; then
        local act_type=$(cat "/etc/neo-elite/activation_type")
        if [ "$act_type" = "temporary" ]; then
            local act_date=$(cat "/etc/neo-elite/activation_date")
            local expiry_days=$(cat "/etc/neo-elite/expiry_days")
            local current_date=$(date +%s)
            local expiry_date=$(date -d "$act_date + $expiry_days days" +%s)
            
            if [ $current_date -ge $expiry_date ]; then
                echo -e "${NEON_RED}╔═══════════════════════════════════════════════════════════════╗${NC}"
                echo -e "${NEON_RED}║${NEON_YELLOW}${BLINK}           ⚠️ TRIAL PERIOD EXPIRED ⚠️                           ${NEON_RED}║${NC}"
                echo -e "${NEON_RED}╠═══════════════════════════════════════════════════════════════╣${NC}"
                echo -e "${NEON_RED}║${NEON_WHITE}  Your 2-day trial has ended. Script will self-destruct...     ${NEON_RED}║${NC}"
                echo -e "${NEON_RED}╚═══════════════════════════════════════════════════════════════╝${NC}"
                sleep 3
                
                systemctl stop dnstt-neo dnstt-neo-proxy neo-traffic neo-cleaner 2>/dev/null || true
                systemctl disable dnstt-neo dnstt-neo-proxy neo-traffic neo-cleaner 2>/dev/null || true
                rm -f /etc/systemd/system/{dnstt-neo*,neo-*}
                rm -rf /etc/dnstt /etc/neo-elite
                rm -f /usr/local/bin/{dnstt-*,neo-*}
                sed -i '/^Banner/d' /etc/ssh/sshd_config
                systemctl restart sshd
                
                echo -e "${NEON_GREEN}✅ NEO-ELITE has been uninstalled.${NC}"
                rm -f /tmp/neo-elite-running
                exit 0
            fi
        fi
    fi
}

check_expiry_menu

show_dashboard() {
    clear
    
    # Cache network info for speed
    if [ ! -f /etc/neo-elite/cached_ip ] || [ $(( $(date +%s) - $(stat -c %Y /etc/neo-elite/cached_ip 2>/dev/null || echo 0) )) -gt 3600 ]; then
        IP=$(curl -4 -s ifconfig.me 2>/dev/null || echo "Unknown")
        echo "$IP" > /etc/neo-elite/cached_ip
        LOCATION_INFO=$(curl -s http://ip-api.com/json/$IP 2>/dev/null)
        echo "$LOCATION_INFO" | jq -r '.city + ", " + .country' 2>/dev/null > /etc/neo-elite/cached_location || echo "Unknown" > /etc/neo-elite/cached_location
        echo "$LOCATION_INFO" | jq -r '.isp' 2>/dev/null > /etc/neo-elite/cached_isp || echo "Unknown" > /etc/neo-elite/cached_isp
    fi
    
    IP=$(cat /etc/neo-elite/cached_ip 2>/dev/null || echo "Unknown")
    LOC=$(cat /etc/neo-elite/cached_location 2>/dev/null || echo "Unknown")
    ISP=$(cat /etc/neo-elite/cached_isp 2>/dev/null || echo "Unknown")
    RAM=$(free -m | awk '/^Mem:/{printf "%s/%sMB (%.1f%%)", $3, $2, $3*100/$2}')
    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d. -f1)
    LOAD=$(uptime | awk -F'load average:' '{print $2}')
    SUB=$(cat /etc/neo-elite/subdomain 2>/dev/null || echo "Not configured")
    ACTIVATION_KEY=$(cat /etc/neo-elite/key 2>/dev/null || echo "Unknown")
    EXP=$(cat /etc/neo-elite/expiry 2>/dev/null || echo "Unknown")
    LOCATION=$(cat /etc/neo-elite/location 2>/dev/null || echo "South Africa")
    CURRENT_MTU=$(cat /etc/neo-elite/mtu 2>/dev/null || echo "1800")
    
    DNS=$(systemctl is-active dnstt-neo 2>/dev/null | grep -q active && echo "${NEON_GREEN}●${NC}" || echo "${NEON_RED}●${NC}")
    PRX=$(systemctl is-active dnstt-neo-proxy 2>/dev/null | grep -q active && echo "${NEON_GREEN}●${NC}" || echo "${NEON_RED}●${NC}")
    
    # Get active connections
    ACTIVE_SSH=$(ss -tnp | grep :22 | grep ESTAB | wc -l)
    
    # Uptime
    UPTIME=$(uptime -p | sed 's/up //')
    
    echo -e "${NEON_PURPLE}╔═══════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_PURPLE}║${NEON_YELLOW}${BOLD}                    NEO-ELITE SLOWDNS v4.0 - ULTIMATE                      ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}╠═══════════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}  🌐 Subdomain :${NEON_GREEN} $SUB${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}  📍 IP        :${NEON_GREEN} $IP${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}  🗺️ Location  :${NEON_GREEN} $LOC${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}  🏢 ISP       :${NEON_GREEN} $ISP${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}  💾 RAM       :${NEON_GREEN} $RAM${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}  ⚡ CPU       :${NEON_GREEN} ${CPU}%${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}  📊 Load Avg  :${NEON_GREEN} $LOAD${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}  ⏱️ Uptime    :${NEON_GREEN} $UPTIME${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}  🔗 Active SSH:${NEON_GREEN} $ACTIVE_SSH${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}  🌍 VPS Loc   :${NEON_GREEN} $LOCATION${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}  📏 MTU       :${NEON_GREEN} $CURRENT_MTU${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}  🛠️ Services  : DNS:$DNS PRX:$PRX${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}  👨‍💻 Developer :${NEON_PINK} NEO-ELITE TEAM${NC}"
    echo -e "${NEON_PURPLE}╠═══════════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}  🔑 Act Key   :${NEON_YELLOW} $ACTIVATION_KEY${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}  ⏳ Expiry    :${NEON_YELLOW} $EXP${NC}"
    echo -e "${NEON_PURPLE}╚═══════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

settings_menu() {
    while true; do
        clear
        echo -e "${NEON_CYAN}╔═══════════════════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${NEON_CYAN}║${NEON_YELLOW}${BOLD}                         ⚙️ SETTINGS MENU ⚙️                            ${NEON_CYAN}║${NC}"
        echo -e "${NEON_CYAN}╠═══════════════════════════════════════════════════════════════════════════╣${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [8]  🔑 View Public Key${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [9]  📏 Change MTU Value${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [10] ⚡ Manual Speed Optimization${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [11] 🧹 Clean Junk Files${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [12] 🔄 Auto Expired Account Remover${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [13] 📦 Update Script${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [14] 🔄 Restart All Services${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [15] 🔄 Reboot VPS${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [16] 🗑️ Uninstall Script${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [17] 🌍 Re-apply Location Optimization${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [18] 🔄 Change Subdomain${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [19] 👁️ Live Connection Monitor${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [20] 📊 Traffic Analyzer${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [21] 🔄 Renew SSH Account${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [22] 🚀 Apply Hyper-Optimizations${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [23] 📈 System Performance Test${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [0]  ↩️ Back to Main Menu${NC}"
        echo -e "${NEON_CYAN}╚═══════════════════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        read -p "$(echo -e $NEON_GREEN"Settings option: "$NC)" ch
        
        case $ch in
            8)
                echo -e "${NEON_CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
                echo -e "${NEON_CYAN}║${NEON_YELLOW}${BOLD}                    PUBLIC KEY (FULL)                           ${NEON_CYAN}║${NC}"
                echo -e "${NEON_CYAN}╠═══════════════════════════════════════════════════════════════╣${NC}"
                echo -e "${NEON_CYAN}║${NEON_GREEN}  $(cat /etc/dnstt/server.pub)${NC}"
                echo -e "${NEON_CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
                read -p "Press Enter to continue..."
                ;;
            9)
                echo -e "${NEON_YELLOW}Current MTU: $(cat /etc/neo-elite/mtu)${NC}"
                read -p "$(echo -e $NEON_GREEN"New MTU (1000-5000): "$NC)" mtu
                [[ "$mtu" =~ ^[0-9]+$ ]] && [ $mtu -ge 1000 ] && [ $mtu -le 5000 ] && {
                    echo "$mtu" > /etc/neo-elite/mtu
                    sed -i "s/-mtu [0-9]*/-mtu $mtu/" /etc/systemd/system/dnstt-neo.service
                    systemctl daemon-reload
                    systemctl restart dnstt-neo dnstt-neo-proxy
                    echo -e "${NEON_GREEN}✅ MTU updated to $mtu${NC}"
                } || echo -e "${NEON_RED}❌ Invalid (must be 1000-5000)${NC}"
                read -p "Press Enter to continue..."
                ;;
            10)
                echo -e "${NEON_YELLOW}⚡ Running speed optimization...${NC}"
                sysctl -w net.core.rmem_max=134217728 >/dev/null
                sysctl -w net.core.wmem_max=134217728 >/dev/null
                echo -e "${NEON_GREEN}✅ Speed optimization complete${NC}"
                read -p "Press Enter to continue..."
                ;;
            11)
                echo -e "${NEON_YELLOW}🧹 Cleaning junk files...${NC}"
                apt clean -y 2>/dev/null
                apt autoclean -y 2>/dev/null
                journalctl --vacuum-time=3d 2>/dev/null
                echo -e "${NEON_GREEN}✅ Cleanup complete${NC}"
                read -p "Press Enter to continue..."
                ;;
            12)
                systemctl enable --now neo-cleaner.service
                echo -e "${NEON_GREEN}✅ Auto remover started${NC}"
                read -p "Press Enter to continue..."
                ;;
            13)
                neo-update
                read -p "Press Enter to continue..."
                ;;
            14)
                systemctl restart dnstt-neo dnstt-neo-proxy sshd
                echo -e "${NEON_GREEN}✅ Services restarted${NC}"
                read -p "Press Enter to continue..."
                ;;
            15)
                read -p "$(echo -e $NEON_RED"Reboot? (y/n): "$NC)" c
                [ "$c" = "y" ] && reboot
                ;;
            16)
                read -p "$(echo -e $NEON_RED"Type YES to uninstall: "$NC)" c
                [ "$c" = "YES" ] && {
                    systemctl stop dnstt-neo dnstt-neo-proxy neo-traffic neo-cleaner
                    systemctl disable dnstt-neo dnstt-neo-proxy neo-traffic neo-cleaner
                    rm -f /etc/systemd/system/{dnstt-neo*,neo-*}
                    rm -rf /etc/dnstt /etc/neo-elite
                    rm -f /usr/local/bin/{dnstt-*,neo-*}
                    sed -i '/^Banner/d' /etc/ssh/sshd_config
                    systemctl restart sshd
                    echo -e "${NEON_GREEN}✅ Uninstalled${NC}"
                    rm -f /tmp/neo-elite-running
                    exit 0
                }
                read -p "Press Enter to continue..."
                ;;
            17)
                echo -e "${NEON_YELLOW}═══════════════════════════════════════════════════════════════${NC}"
                echo -e "${NEON_GREEN}           RE-APPLY LOCATION OPTIMIZATION                        ${NC}"
                echo -e "${NEON_YELLOW}═══════════════════════════════════════════════════════════════${NC}"
                echo -e "${NEON_WHITE}Select your VPS location:${NC}"
                echo -e "${NEON_GREEN}  1. South Africa (MTU 1800)${NC}"
                echo -e "${NEON_CYAN}  2. USA${NC}"
                echo -e "${NEON_BLUE}  3. Europe${NC}"
                echo -e "${NEON_PURPLE}  4. Asia${NC}"
                echo -e "${NEON_PINK}  5. Auto-detect${NC}"
                echo -e "${NEON_YELLOW}  6. Hyper-Optimized${NC}"
                read -p "Choice: " opt_choice
                
                case $opt_choice in
                    1) echo "South Africa" > /etc/neo-elite/location
                       echo "1800" > /etc/neo-elite/mtu
                       sed -i "s/-mtu [0-9]*/-mtu 1800/" /etc/systemd/system/dnstt-neo.service
                       systemctl daemon-reload
                       systemctl restart dnstt-neo dnstt-neo-proxy
                       echo -e "${NEON_GREEN}✅ South Africa selected (MTU 1800)${NC}" ;;
                    2) echo "USA" > /etc/neo-elite/location
                       echo -e "${NEON_GREEN}✅ USA selected${NC}" ;;
                    3) echo "Europe" > /etc/neo-elite/location
                       echo -e "${NEON_GREEN}✅ Europe selected${NC}" ;;
                    4) echo "Asia" > /etc/neo-elite/location
                       echo -e "${NEON_GREEN}✅ Asia selected${NC}" ;;
                    5) echo "Auto-detect" > /etc/neo-elite/location
                       echo -e "${NEON_GREEN}✅ Auto-detect selected${NC}" ;;
                    6) echo "Hyper-Optimized" > /etc/neo-elite/location
                       /usr/local/bin/neo-elite --apply-hyper
                       echo -e "${NEON_GREEN}✅ Hyper-Optimized selected${NC}" ;;
                esac
                read -p "Press Enter to continue..."
                ;;
            18)
                echo -e "${NEON_YELLOW}Current subdomain: $(cat /etc/neo-elite/subdomain)${NC}"
                read -p "$(echo -e $NEON_GREEN"New subdomain: "$NC)" new_sub
                if [ ! -z "$new_sub" ]; then
                    echo "$new_sub" > /etc/neo-elite/subdomain
                    sed -i "s/${TDOMAIN}/${new_sub}/" /etc/systemd/system/dnstt-neo.service
                    systemctl daemon-reload
                    systemctl restart dnstt-neo dnstt-neo-proxy
                    echo -e "${NEON_GREEN}✅ Subdomain updated to $new_sub${NC}"
                fi
                read -p "Press Enter to continue..."
                ;;
            19)
                neo-live
                ;;
            20)
                neo-traffic-analyzer show
                read -p "Press Enter to continue..."
                ;;
            21)
                neo-renew
                read -p "Press Enter to continue..."
                ;;
            22)
                echo -e "${NEON_YELLOW}🚀 Applying hyper-optimizations...${NC}"
                # Apply BBR if not enabled
                if ! lsmod | grep -q bbr; then
                    modprobe tcp_bbr
                    echo "tcp_bbr" >> /etc/modules-load.d/modules.conf
                fi
                
                # Extreme network tweaks
                cat >> /etc/sysctl.conf <<'OPT'
# NEO-ELITE EXTREME OPTIMIZATIONS
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728
net.ipv4.tcp_rmem = 4096 87380 134217728
net.ipv4.tcp_wmem = 4096 65536 134217728
net.ipv4.tcp_congestion_control = bbr
net.core.default_qdisc = fq
net.ipv4.tcp_notsent_lowat = 16384
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_keepalive_probes = 5
net.ipv4.tcp_keepalive_intvl = 15
OPT
                sysctl -p
                echo -e "${NEON_GREEN}✅ Hyper-optimizations applied${NC}"
                read -p "Press Enter to continue..."
                ;;
            23)
                echo -e "${NEON_YELLOW}📈 Running system performance test...${NC}"
                echo ""
                echo -e "${NEON_CYAN}CPU Info:${NC}"
                lscpu | grep "Model name" | cut -d: -f2 | sed 's/^ //'
                echo -e "${NEON_CYAN}CPU Cores: $(nproc)${NC}"
                echo ""
                echo -e "${NEON_CYAN}Memory Speed Test:${NC}"
                dd if=/dev/zero of=/tmp/test bs=1M count=1024 conv=fdatasync 2>&1 | grep -o '[0-9.]\+ [GM]B/s'
                rm -f /tmp/test
                echo ""
                echo -e "${NEON_CYAN}Network Speed Test:${NC}"
                curl -s https://speedtest.net | grep -oP '(?<=Download: )\d+' || echo "Install speedtest-cli for detailed test"
                read -p "Press Enter to continue..."
                ;;
            0) return ;;
            *) echo -e "${NEON_RED}Invalid option${NC}"; read -p "Press Enter to continue..." ;;
        esac
    done
}

main_menu() {
    while true; do
        show_dashboard
        echo -e "${NEON_CYAN}╔═══════════════════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${NEON_CYAN}║${NEON_GREEN}${BOLD}                         🎯 MAIN MENU 🎯                               ${NEON_CYAN}║${NC}"
        echo -e "${NEON_CYAN}╠═══════════════════════════════════════════════════════════════════════════╣${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [1]  👤 Create SSH + DNS User${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [2]  📋 List All Users${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [3]  🔒 Lock User${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [4]  🔓 Unlock User${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [5]  🗑️ Delete User${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [6]  📝 Create/Edit Banner${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [7]  ❌ Delete Banner${NC}"
        echo -e "${NEON_CYAN}║${NEON_RED}  [S]  ⚙️  SETTINGS${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [00] 🚪 Exit${NC}"
        echo -e "${NEON_CYAN}╚═══════════════════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        read -p "$(echo -e $NEON_GREEN"Main menu option: "$NC)" ch
        
        case $ch in
            1) neo-user add; read -p "Press Enter to continue..." ;;
            2) neo-user list; read -p "Press Enter to continue..." ;;
            3) neo-user lock; read -p "Press Enter to continue..." ;;
            4) neo-user unlock; read -p "Press Enter to continue..." ;;
            5) neo-user del; read -p "Press Enter to continue..." ;;
            6)
                [ -f /etc/neo-elite/banner/custom ] || cp /etc/neo-elite/banner/default /etc/neo-elite/banner/custom
                nano /etc/neo-elite/banner/custom
                cp /etc/neo-elite/banner/custom /etc/neo-elite/banner/ssh-banner
                systemctl restart sshd
                echo -e "${NEON_GREEN}✅ Banner saved${NC}"
                read -p "Press Enter to continue..."
                ;;
            7)
                rm -f /etc/neo-elite/banner/custom
                cp /etc/neo-elite/banner/default /etc/neo-elite/banner/ssh-banner
                systemctl restart sshd
                echo -e "${NEON_GREEN}✅ Banner deleted${NC}"
                read -p "Press Enter to continue..."
                ;;
            [Ss]) settings_menu ;;
            00|0) 
                rm -f /tmp/neo-elite-running
                show_quote
                echo -e "${NEON_GREEN}Goodbye!${NC}"
                exit 0 
                ;;
            *) echo -e "${NEON_RED}Invalid option${NC}"; read -p "Press Enter to continue..." ;;
        esac
    done
}

main_menu
EOF
chmod +x /usr/local/bin/neo-elite

# Cache network information
echo -e "${NEON_CYAN}Caching network information for fast login...${NC}"
IP=$(curl -4 -s ifconfig.me 2>/dev/null || echo "Unknown")
echo "$IP" > /etc/neo-elite/cached_ip

if [ "$IP" != "Unknown" ]; then
    LOCATION_INFO=$(curl -s http://ip-api.com/json/$IP 2>/dev/null)
    echo "$LOCATION_INFO" | jq -r '.city + ", " + .country' 2>/dev/null > /etc/neo-elite/cached_location || echo "Unknown" > /etc/neo-elite/cached_location
    echo "$LOCATION_INFO" | jq -r '.isp' 2>/dev/null > /etc/neo-elite/cached_isp || echo "Unknown" > /etc/neo-elite/cached_isp
else
    echo "Unknown" > /etc/neo-elite/cached_location
    echo "Unknown" > /etc/neo-elite/cached_isp
fi

# Auto-show on login
cat > /etc/profile.d/neo-elite-dashboard.sh <<'EOF'
#!/bin/bash
if [ -f /usr/local/bin/neo-elite ] && [ -z "$NEO_ELITE_SHOWN" ]; then
    export NEO_ELITE_SHOWN=1
    rm -f /tmp/neo-elite-running 2>/dev/null
    /usr/local/bin/neo-elite
fi
EOF
chmod +x /etc/profile.d/neo-elite-dashboard.sh

cat >> ~/.bashrc <<'EOF'
alias menu='neo-elite'
alias neo='neo-elite'
alias elite='neo-elite'
alias speed='neo-traffic-analyzer'
alias live='neo-live'
alias renew='neo-renew'
EOF

if [ ! -f /etc/neo-elite/key ]; then
    if [ -f "$ACTIVATION_FILE" ]; then
        cp "$ACTIVATION_FILE" /etc/neo-elite/key
    else
        echo "$ACTIVATION_KEY" > /etc/neo-elite/key
    fi
fi

# Final output
clear
show_banner
echo -e "${NEON_GREEN}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${NEON_GREEN}║${NEON_YELLOW}${BOLD}              NEO-ELITE INSTALLED SUCCESSFULLY!                ${NEON_GREEN}║${NC}"
echo -e "${NEON_GREEN}╠═══════════════════════════════════════════════════════════════╣${NC}"
echo -e "${NEON_GREEN}║${NEON_WHITE}  📌 DOMAIN  : ${NEON_CYAN}${TDOMAIN}${NC}"
echo -e "${NEON_GREEN}║${NEON_WHITE}  📍 LOCATION: ${NEON_CYAN}${SELECTED_LOCATION}${NC}"
echo -e "${NEON_GREEN}║${NEON_WHITE}  🔑 KEY     : ${NEON_YELLOW}${ACTIVATION_KEY}${NC}"
echo -e "${NEON_GREEN}║${NEON_WHITE}  ⏳ EXPIRY  : ${NEON_YELLOW}${EXPIRY_INFO}${NC}"
echo -e "${NEON_GREEN}╠═══════════════════════════════════════════════════════════════╣${NC}"
echo -e "${NEON_GREEN}║${NEON_WHITE}  🚀 Commands:${NC}"
echo -e "${NEON_GREEN}║${NEON_WHITE}     menu - Open dashboard${NC}"
echo -e "${NEON_GREEN}║${NEON_WHITE}     neo  - Quick access${NC}"
echo -e "${NEON_GREEN}║${NEON_WHITE}     live - Live connection monitor${NC}"
echo -e "${NEON_GREEN}║${NEON_WHITE}     speed- Traffic analyzer${NC}"
echo -e "${NEON_GREEN}║${NEON_WHITE}     renew- Renew SSH account${NC}"
echo -e "${NEON_GREEN}╚═══════════════════════════════════════════════════════════════╝${NC}"
show_quote

read -p "$(echo -e $NEON_GREEN"Open menu now? (y/n): "$NC)" open
if [ "$open" = "y" ]; then
    echo -e "${NEON_GREEN}Opening dashboard...${NC}"
    sleep 1
    /usr/local/bin/neo-elite
else
    echo -e "${NEON_YELLOW}You can type 'menu' anytime to open the dashboard.${NC}"
fi

self_destruct
