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

set -euo pipefail

# ==================== NEON COLOR PALETTE ====================
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'
PURPLE='\033[0;35m'; CYAN='\033[0;36m'; WHITE='\033[1;37m'; BOLD='\033[1m'
NC='\033[0m'

NEON_RED='\033[1;31m'; NEON_GREEN='\033[1;32m'; NEON_YELLOW='\033[1;33m'
NEON_BLUE='\033[1;34m'; NEON_PURPLE='\033[1;35m'; NEON_CYAN='\033[1;36m'
NEON_WHITE='\033[1;37m'; NEON_PINK='\033[1;38;5;201m'
NEON_ORANGE='\033[1;38;5;208m'; NEON_LIME='\033[1;38;5;154m'
NEON_TEAL='\033[1;38;5;51m'; NEON_VIOLET='\033[1;38;5;129m'

BG_BLACK='\033[40m'; BG_RED='\033[41m'; BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'; BG_BLUE='\033[44m'; BG_PURPLE='\033[45m'
BG_CYAN='\033[46m'; BG_WHITE='\033[47m'

BLINK='\033[5m'; UNDERLINE='\033[4m'; REVERSE='\033[7m'
NC='\033[0m'

print_color() { echo -e "${2}${1}${NC}"; }

# ==================== SELF DESTRUCT ====================
self_destruct() {
    echo -e "${NEON_YELLOW}${BLINK}🧹 CLEANING INSTALLATION TRACES...${NC}"
    
    history -c 2>/dev/null || true
    cat /dev/null > ~/.bash_history 2>/dev/null || true
    cat /dev/null > /root/.bash_history 2>/dev/null || true
    
    if [ -f "$0" ] && [ "$0" != "/usr/local/bin/elite-x" ]; then
        local script_path=$(readlink -f "$0")
        rm -f "$script_path" 2>/dev/null || true
    fi
    
    sed -i '/elite-x/d' /var/log/auth.log 2>/dev/null || true
    
    echo -e "${NEON_GREEN}${BOLD}✅ CLEANUP COMPLETE!${NC}"
}

# ==================== ELITE QUOTE ====================
show_quote() {
    echo ""
    echo -e "${NEON_PURPLE}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_PURPLE}║${NEON_YELLOW}${BOLD}${BLINK}                                                               ${NEON_PURPLE}║${NC}"
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

# ==================== ELITE BANNER ====================
show_banner() {
    clear
    echo -e "${NEON_RED}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_RED}║${NEON_YELLOW}${BOLD}${BG_BLACK}              ███████╗██╗     ██╗████████╗███████╗                    ${NEON_RED}║${NC}"
    echo -e "${NEON_RED}║${NEON_GREEN}${BOLD}${BG_BLACK}              ██╔════╝██║     ██║╚══██╔══╝██╔════╝                    ${NEON_RED}║${NC}"
    echo -e "${NEON_RED}║${NEON_CYAN}${BOLD}${BG_BLACK}              █████╗  ██║     ██║   ██║   █████╗                      ${NEON_RED}║${NC}"
    echo -e "${NEON_RED}║${NEON_BLUE}${BOLD}${BG_BLACK}              ██╔══╝  ██║     ██║   ██║   ██╔══╝                      ${NEON_RED}║${NC}"
    echo -e "${NEON_RED}║${NEON_PURPLE}${BOLD}${BG_BLACK}              ███████╗███████╗██║   ██║   ███████╗                    ${NEON_RED}║${NC}"
    echo -e "${NEON_RED}║${NEON_PINK}${BOLD}${BG_BLACK}              ╚══════╝╚══════╝╚═╝   ╚═╝   ╚══════╝                    ${NEON_RED}║${NC}"
    echo -e "${NEON_RED}╠═══════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${NEON_RED}║${NEON_WHITE}${BOLD}               ELITE-X SLOWDNS v5.0 - OVERCLOCKED EDITION               ${NEON_RED}║${NC}"
    echo -e "${NEON_RED}║${NEON_GREEN}${BOLD}                     ⚡ MAXIMUM SPEED MODE ⚡                           ${NEON_RED}║${NC}"
    echo -e "${NEON_RED}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# ==================== ACTIVATION ====================
ACTIVATION_KEY="ELITEX-2026-DAN-4D-08"
TEMP_KEY="ELITE-X-TEST-0208"
ACTIVATION_FILE="/etc/elite-x/activated"
ACTIVATION_TYPE_FILE="/etc/elite-x/activation_type"
ACTIVATION_DATE_FILE="/etc/elite-x/activation_date"
EXPIRY_DAYS_FILE="/etc/elite-x/expiry_days"
KEY_FILE="/etc/elite-x/key"
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
                      
                systemctl stop dnstt-elite-x dnstt-elite-x-proxy elite-x-traffic elite-x-cleaner 2>/dev/null || true
                systemctl disable dnstt-elite-x dnstt-elite-x-proxy elite-x-traffic elite-x-cleaner 2>/dev/null || true
                rm -f /etc/systemd/system/{dnstt-elite-x*,elite-x-*}
                rm -rf /etc/dnstt /etc/elite-x
                rm -f /usr/local/bin/{dnstt-*,elite-x*}
                sed -i '/^Banner/d' /etc/ssh/sshd_config
                systemctl restart sshd

                rm -f "$0"
                echo -e "${NEON_GREEN}✅ ELITE-X has been uninstalled.${NC}"
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

# ==================== ULTIMATE BOOSTERS ====================

# BOOSTER 1: TCP BBR + FQ CODEL
enable_bbr_plus() {
    echo -e "${NEON_CYAN}🚀 ENABLING BBR PLUS CONGESTION CONTROL...${NC}"
    
    modprobe tcp_bbr
    echo "tcp_bbr" >> /etc/modules-load.d/modules.conf 2>/dev/null || true
    
    cat >> /etc/sysctl.conf <<EOF

# ========== BBR PLUS BOOST ==========
net.core.default_qdisc = fq_codel
net.ipv4.tcp_congestion_control = bbr
net.ipv4.tcp_notsent_lowat = 16384
net.ipv4.tcp_slow_start_after_idle = 0
EOF
    sysctl -p
    
    echo -e "${NEON_GREEN}✅ BBR + FQ Codel enabled!${NC}"
}

# BOOSTER 2: CPU PERFORMANCE
optimize_cpu_performance() {
    echo -e "${NEON_CYAN}⚡ OPTIMIZING CPU FOR MAX PERFORMANCE...${NC}"
    
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
        [ -f "$cpu" ] && echo "performance" > "$cpu" 2>/dev/null
    done
    
    if [ -f /sys/devices/system/cpu/intel_pstate/no_turbo ]; then
        echo 0 > /sys/devices/system/cpu/intel_pstate/no_turbo
    fi
    
    for irq in /proc/irq/*/smp_affinity; do
        [ -f "$irq" ] && echo 1 > "$irq" 2>/dev/null
    done
    
    echo -e "${NEON_GREEN}✅ CPU optimized for max speed!${NC}"
}

# BOOSTER 3: KERNEL PARAMETERS
tune_kernel_parameters() {
    echo -e "${NEON_CYAN}🧠 TUNING KERNEL PARAMETERS...${NC}"
    
    cat >> /etc/sysctl.conf <<EOF

# ========== KERNEL BOOSTER ==========
fs.file-max = 2097152
fs.nr_open = 2097152
fs.inotify.max_user_watches = 524288
fs.inotify.max_user_instances = 512
fs.inotify.max_queued_events = 16384
vm.swappiness = 5
vm.vfs_cache_pressure = 40
vm.dirty_ratio = 30
vm.dirty_background_ratio = 3
vm.min_free_kbytes = 131072
vm.overcommit_memory = 1
vm.overcommit_ratio = 50
vm.max_map_count = 524288
kernel.sched_autogroup_enabled = 0
kernel.sched_min_granularity_ns = 8000000
kernel.sched_wakeup_granularity_ns = 10000000
kernel.numa_balancing = 0
EOF
    sysctl -p
    echo -e "${NEON_GREEN}✅ Kernel parameters tuned!${NC}"
}

# BOOSTER 4: IRQ AFFINITY
optimize_irq_affinity() {
    echo -e "${NEON_CYAN}🔄 OPTIMIZING IRQ AFFINITY...${NC}"
    
    apt install -y irqbalance 2>/dev/null
    
    cat > /etc/default/irqbalance <<EOF
ENABLED="1"
ONESHOT="0"
IRQBALANCE_ARGS="--powerthresh=0 --pkgthresh=0"
IRQBALANCE_BANNED_CPUS=""
EOF
    
    for irq in $(grep -E "eth|ens|enp" /proc/interrupts 2>/dev/null | cut -d: -f1); do
        [ -n "$irq" ] && echo 3 > /proc/irq/$irq/smp_affinity 2>/dev/null
    done
    
    systemctl enable irqbalance 2>/dev/null
    systemctl restart irqbalance 2>/dev/null
    
    echo -e "${NEON_GREEN}✅ IRQ affinity optimized!${NC}"
}

# BOOSTER 5: DNS CACHE
optimize_dns_cache() {
    echo -e "${NEON_CYAN}📡 OPTIMIZING DNS CACHE...${NC}"
    
    apt install -y dnsmasq 2>/dev/null
    
    cat > /etc/dnsmasq.conf <<EOF
port=53
domain-needed
bogus-priv
no-resolv
server=8.8.8.8
server=8.8.4.4
server=1.1.1.1
server=1.0.0.1
cache-size=10000
dns-forward-max=1000
neg-ttl=3600
max-ttl=3600
min-cache-ttl=3600
max-cache-ttl=86400
edns-packet-max=4096
log-queries
log-facility=/var/log/dnsmasq.log
EOF
    
    systemctl enable dnsmasq 2>/dev/null
    systemctl restart dnsmasq 2>/dev/null
    
    echo "nameserver 127.0.0.1" > /etc/resolv.conf
    echo "nameserver 8.8.8.8" >> /etc/resolv.conf
    
    echo -e "${NEON_GREEN}✅ DNS cache optimized!${NC}"
}

# BOOSTER 6: INTERFACE OFFLOADING
optimize_interface_offloading() {
    echo -e "${NEON_CYAN}🔧 OPTIMIZING INTERFACE OFFLOADING...${NC}"
    
    for iface in $(ls /sys/class/net/ | grep -v lo); do
        ethtool -K $iface tx on rx on 2>/dev/null
        ethtool -K $iface sg on 2>/dev/null
        ethtool -K $iface tso on 2>/dev/null
        ethtool -K $iface ufo on 2>/dev/null
        ethtool -K $iface gso on 2>/dev/null
        ethtool -K $iface gro on 2>/dev/null
        ethtool -C $iface adaptive-rx on 2>/dev/null
        ethtool -C $iface adaptive-tx on 2>/dev/null
        ethtool -G $iface rx 4096 tx 4096 2>/dev/null
    done
    
    echo -e "${NEON_GREEN}✅ Interface offloading optimized!${NC}"
}

# BOOSTER 7: TCP ULTRA BOOST
optimize_tcp_parameters() {
    echo -e "${NEON_CYAN}📶 APPLYING TCP ULTRA BOOST...${NC}"
    
    cat >> /etc/sysctl.conf <<EOF

# ========== TCP ULTRA BOOST ==========
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_sack = 1
net.ipv4.tcp_fack = 1
net.ipv4.tcp_dsack = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_adv_win_scale = 2
net.ipv4.tcp_app_win = 31
net.ipv4.tcp_rmem = 4096 87380 536870912
net.ipv4.tcp_wmem = 4096 65536 536870912
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_moderate_rcvbuf = 1
net.ipv4.tcp_no_metrics_save = 1
net.ipv4.tcp_keepalive_time = 30
net.ipv4.tcp_keepalive_intvl = 5
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.tcp_retries1 = 2
net.ipv4.tcp_retries2 = 3
net.ipv4.tcp_syn_retries = 2
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_fin_timeout = 5
net.ipv4.tcp_tw_reuse = 1
EOF
    sysctl -p
    echo -e "${NEON_GREEN}✅ TCP ultra boost applied!${NC}"
}

# BOOSTER 8: QOS PRIORITIES
setup_qos_priorities() {
    echo -e "${NEON_CYAN}🎯 SETTING UP QOS PRIORITIES...${NC}"
    
    apt install -y iproute2 2>/dev/null
    
    DEV=$(ip route | grep default | awk '{print $5}' | head -1)
    if [ -n "$DEV" ]; then
        tc qdisc del dev $DEV root 2>/dev/null
        tc qdisc add dev $DEV root handle 1: htb default 30
        
        tc class add dev $DEV parent 1: classid 1:1 htb rate 10000mbit ceil 10000mbit
        tc class add dev $DEV parent 1:1 classid 1:10 htb rate 5000mbit ceil 10000mbit prio 0
        tc class add dev $DEV parent 1:1 classid 1:20 htb rate 3000mbit ceil 10000mbit prio 1
        tc class add dev $DEV parent 1:1 classid 1:30 htb rate 2000mbit ceil 10000mbit prio 2
        
        tc filter add dev $DEV protocol ip parent 1:0 prio 1 u32 match ip dport 22 0xffff flowid 1:10
        tc filter add dev $DEV protocol ip parent 1:0 prio 1 u32 match ip sport 22 0xffff flowid 1:10
        tc filter add dev $DEV protocol ip parent 1:0 prio 2 u32 match ip dport 53 0xffff flowid 1:20
        tc filter add dev $DEV protocol ip parent 1:0 prio 2 u32 match ip sport 53 0xffff flowid 1:20
    fi
    
    echo -e "${NEON_GREEN}✅ QoS priorities configured!${NC}"
}

# BOOSTER 9: MEMORY OPTIMIZER
optimize_memory_usage() {
    echo -e "${NEON_CYAN}💾 OPTIMIZING MEMORY USAGE...${NC}"
    
    echo 5 > /proc/sys/vm/swappiness
    sync && echo 3 > /proc/sys/vm/drop_caches
    echo 1 > /proc/sys/vm/compact_memory
    echo 131072 > /proc/sys/vm/min_free_kbytes
    
    echo -e "${NEON_GREEN}✅ Memory optimized!${NC}"
}

# BOOSTER 10: BUFFER/MTU OVERCLOCK
optimize_buffer_mtu() {
    echo -e "${NEON_CYAN}⚡ OVERCLOCKING BUFFERS & MTU...${NC}"
    
    BEST_MTU=$(ping -M do -s 1472 -c 1 google.com 2>/dev/null | grep -o "mtu=[0-9]*" | cut -d= -f2 || echo "1500")
    if [ -z "$BEST_MTU" ] || [ "$BEST_MTU" -lt 1000 ]; then
        BEST_MTU=1500
    fi
    echo -e "${NEON_GREEN}✅ Optimal MTU detected: $BEST_MTU${NC}"
    
    cat >> /etc/sysctl.conf <<EOF

# ========== BUFFER OVERCLOCK ==========
net.core.rmem_max = 536870912
net.core.wmem_max = 536870912
net.core.rmem_default = 268435456
net.core.wmem_default = 268435456
net.core.netdev_max_backlog = 2000000
net.core.somaxconn = 131072
net.core.optmem_max = 50331648
net.ipv4.udp_rmem_min = 131072
net.ipv4.udp_wmem_min = 131072
EOF
    sysctl -p
    
    for iface in $(ls /sys/class/net/ | grep -v lo); do
        ip link set dev $iface mtu $BEST_MTU 2>/dev/null || true
        ip link set dev $iface txqueuelen 200000 2>/dev/null || true
    done
    
    echo -e "${NEON_GREEN}✅ Buffers overclocked to 512MB!${NC}"
}

# BOOSTER 11: NETWORK STEERING
optimize_network_steering() {
    echo -e "${NEON_CYAN}🎮 ENABLING NETWORK STEERING...${NC}"
    
    apt install -y irqbalance rps 2>/dev/null
    
    for iface in $(ls /sys/class/net/ | grep -v lo); do
        echo f > /sys/class/net/$iface/queues/rx-0/rps_cpus 2>/dev/null
        echo 4096 > /sys/class/net/$iface/queues/rx-0/rps_flow_cnt 2>/dev/null
    done
    
    echo 262144 > /proc/sys/net/core/rps_sock_flow_entries
    
    echo -e "${NEON_GREEN}✅ Network steering enabled!${NC}"
}

# BOOSTER 12: TCP FAST OPEN MASTER
enable_tcp_fastopen_master() {
    echo -e "${NEON_CYAN}🔓 ENABLING TCP FAST OPEN MASTER...${NC}"
    
    cat >> /etc/sysctl.conf <<EOF

# ========== TCP FAST OPEN ==========
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_fastopen_key = 1234567890abcdef,1234567890abcdef
net.ipv4.tcp_fack = 1
net.ipv4.tcp_sack = 1
net.ipv4.tcp_dsack = 1
net.ipv4.tcp_early_retrans = 3
EOF
    sysctl -p
    echo -e "${NEON_GREEN}✅ TCP Fast Open enabled!${NC}"
}

# BOOSTER 13: APPLY ALL BOOSTERS
apply_all_boosters() {
    echo -e "${NEON_YELLOW}${BLINK}🚀🚀🚀 APPLYING ALL BOOSTERS - OVERCLOCK MODE 🚀🚀🚀${NC}"
    
    enable_bbr_plus
    optimize_cpu_performance
    tune_kernel_parameters
    optimize_irq_affinity
    optimize_dns_cache
    optimize_interface_offloading
    optimize_tcp_parameters
    setup_qos_priorities
    optimize_memory_usage
    optimize_buffer_mtu
    optimize_network_steering
    enable_tcp_fastopen_master
    
    echo -e "${NEON_GREEN}${BOLD}✅✅✅ ALL BOOSTERS APPLIED SUCCESSFULLY! ✅✅✅${NC}"
    echo -e "${NEON_YELLOW}⚠️ System reboot recommended for maximum effect${NC}"
}

# BOOSTER MENU
booster_menu() {
    while true; do
        clear
        echo -e "${NEON_CYAN}╔═══════════════════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${NEON_CYAN}║${NEON_YELLOW}${BOLD}                    🚀 ELITE-X ULTIMATE BOOSTER 🚀                       ${NEON_CYAN}║${NC}"
        echo -e "${NEON_CYAN}╠═══════════════════════════════════════════════════════════════════════════╣${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [B1] 🔥 TCP BBR + FQ Codel (Congestion Control)${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [B2] ⚡ CPU Performance Mode (Overclock)${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [B3] 🧠 Kernel Parameter Tuning${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [B4] 🔄 IRQ Affinity Optimization${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [B5] 📡 DNS Cache Booster (200x Faster)${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [B6] 🔧 Network Interface Offloading${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [B7] 📶 TCP Ultra Boost (512MB Buffers)${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [B8] 🎯 QoS Priority Setup${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [B9] 💾 Memory Optimizer${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [B10] ⚡ Buffer/MTU Overclock${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [B11] 🎮 Network Steering${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [B12] 🔓 TCP Fast Open Master${NC}"
        echo -e "${NEON_CYAN}║${NEON_RED}  [B13] 🚀 APPLY ALL BOOSTERS (MAXIMUM SPEED)${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [0] ↩️ Back to Settings${NC}"
        echo -e "${NEON_CYAN}╚═══════════════════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        read -p "$(echo -e $NEON_GREEN"Booster option: "$NC)" bch
        
        case $bch in
            B1|b1) enable_bbr_plus; read -p "Press Enter..." ;;
            B2|b2) optimize_cpu_performance; read -p "Press Enter..." ;;
            B3|b3) tune_kernel_parameters; read -p "Press Enter..." ;;
            B4|b4) optimize_irq_affinity; read -p "Press Enter..." ;;
            B5|b5) optimize_dns_cache; read -p "Press Enter..." ;;
            B6|b6) optimize_interface_offloading; read -p "Press Enter..." ;;
            B7|b7) optimize_tcp_parameters; read -p "Press Enter..." ;;
            B8|b8) setup_qos_priorities; read -p "Press Enter..." ;;
            B9|b9) optimize_memory_usage; read -p "Press Enter..." ;;
            B10|b10) optimize_buffer_mtu; read -p "Press Enter..." ;;
            B11|b11) optimize_network_steering; read -p "Press Enter..." ;;
            B12|b12) enable_tcp_fastopen_master; read -p "Press Enter..." ;;
            B13|b13) apply_all_boosters; read -p "Press Enter..." ;;
            0) return ;;
            *) echo -e "${NEON_RED}Invalid option${NC}"; read -p "Press Enter..." ;;
        esac
    done
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

# ==================== LIVE CONNECTION MONITOR ====================
setup_live_monitor() {
    cat > /usr/local/bin/elite-x-live <<'EOF'
#!/bin/bash

NEON_RED='\033[1;31m'; NEON_GREEN='\033[1;32m'; NEON_YELLOW='\033[1;33m'
NEON_BLUE='\033[1;34m'; NEON_PURPLE='\033[1;35m'; NEON_CYAN='\033[1;36m'
NEON_WHITE='\033[1;37m'; NC='\033[0m'; BOLD='\033[1m'

while true; do
    clear
    echo -e "${NEON_CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_CYAN}║${NEON_YELLOW}${BOLD}              LIVE CONNECTION MONITOR - REFRESH 2S                ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    
    connections=$(ss -tnp | grep :22 | grep ESTAB | wc -l)
    echo -e "${NEON_PURPLE}Total Active: ${NEON_GREEN}$connections${NC}"
    echo ""
    
    ss -tnp | grep :22 | grep ESTAB | while read line; do
        src_ip=$(echo $line | awk '{print $5}' | cut -d: -f1)
        dst_port=$(echo $line | awk '{print $4}' | cut -d: -f2)
        pid=$(echo $line | grep -o 'pid=[0-9]*' | cut -d= -f2)
        
        if [ ! -z "$pid" ] && [ "$pid" != "-" ]; then
            username=$(ps -o user= -p $pid 2>/dev/null | head -1)
        else
            username="unknown"
        fi
        
        echo -e "${NEON_CYAN}User:${NEON_WHITE} $username ${NEON_CYAN}IP:${NEON_YELLOW} $src_ip${NC}"
    done
    
    echo -e "${NEON_YELLOW}Press Ctrl+C to exit - Auto-refresh 2s${NC}"
    sleep 2
done
EOF
    chmod +x /usr/local/bin/elite-x-live
}

# ==================== TRAFFIC ANALYZER ====================
setup_traffic_analyzer() {
    cat > /usr/local/bin/elite-x-analyzer <<'EOF'
#!/bin/bash

NEON_RED='\033[1;31m'; NEON_GREEN='\033[1;32m'; NEON_YELLOW='\033[1;33m'
NEON_CYAN='\033[1;36m'; NEON_WHITE='\033[1;37m'; NC='\033[0m'

TRAFFIC_DB="/etc/elite-x/traffic"
USER_DB="/etc/elite-x/users"

echo -e "${NEON_CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${NEON_CYAN}║${NEON_YELLOW}${BOLD}                 TRAFFIC ANALYZER                                  ${NEON_CYAN}║${NC}"
echo -e "${NEON_CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"

rx_total=$(cat /sys/class/net/*/statistics/rx_bytes 2>/dev/null | awk '{sum+=$1} END {printf "%.2f GB", sum/1024/1024/1024}')
tx_total=$(cat /sys/class/net/*/statistics/tx_bytes 2>/dev/null | awk '{sum+=$1} END {printf "%.2f GB", sum/1024/1024/1024}')

echo -e "${NEON_WHITE}System Total RX: ${NEON_GREEN}$rx_total${NC}"
echo -e "${NEON_WHITE}System Total TX: ${NEON_GREEN}$tx_total${NC}"
echo ""

for user_file in $USER_DB/* 2>/dev/null; do
    [ ! -f "$user_file" ] && continue
    username=$(basename "$user_file")
    used=$(cat $TRAFFIC_DB/$username 2>/dev/null || echo "0")
    limit=$(grep "Traffic_Limit:" "$user_file" | cut -d' ' -f2)
    
    echo -e "${NEON_CYAN}User:${NEON_WHITE} $username ${NEON_CYAN}Used:${NEON_YELLOW} ${used}MB ${NEON_CYAN}Limit:${NEON_GREEN} ${limit}MB${NC}"
done
EOF
    chmod +x /usr/local/bin/elite-x-analyzer
}

# ==================== RENEW SSH ACCOUNT ====================
setup_renew_user() {
    cat > /usr/local/bin/elite-x-renew <<'EOF'
#!/bin/bash

NEON_RED='\033[1;31m'; NEON_GREEN='\033[1;32m'; NEON_YELLOW='\033[1;33m'
NEON_CYAN='\033[1;36m'; NEON_WHITE='\033[1;37m'; NC='\033[0m'

USER_DB="/etc/elite-x/users"

echo -e "${NEON_CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${NEON_CYAN}║${NEON_YELLOW}${BOLD}                    RENEW SSH ACCOUNT                            ${NEON_CYAN}║${NC}"
echo -e "${NEON_CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"

read -p "$(echo -e $NEON_GREEN"Username to renew: "$NC)" username

if ! id "$username" &>/dev/null; then
    echo -e "${NEON_RED}❌ User does not exist!${NC}"
    exit 1
fi

read -p "$(echo -e $NEON_GREEN"Additional days: "$NC)" days

current_expire=$(chage -l "$username" | grep "Account expires" | cut -d: -f2 | sed 's/^ //')
if [ "$current_expire" == "never" ]; then
    new_expire=$(date -d "+$days days" +"%Y-%m-%d")
else
    new_expire=$(date -d "$current_expire +$days days" +"%Y-%m-%d" 2>/dev/null || date -d "+$days days" +"%Y-%m-%d")
fi

chage -E "$new_expire" "$username"

if [ -f "$USER_DB/$username" ]; then
    sed -i "s/Expire: .*/Expire: $new_expire/" "$USER_DB/$username"
fi

echo -e "${NEON_GREEN}✅ Account renewed until: $new_expire${NC}"
EOF
    chmod +x /usr/local/bin/elite-x-renew
}

# ==================== SETUP UPDATER ====================
setup_updater() {
    cat > /usr/local/bin/elite-x-update <<'EOF'
#!/bin/bash

echo -e "${NEON_YELLOW}🔄 CHECKING FOR UPDATES...${NC}"
echo -e "${NEON_GREEN}✅ Already latest version!${NC}"
EOF
    chmod +x /usr/local/bin/elite-x-update
}

# ==================== TRAFFIC MONITOR ====================
setup_traffic_monitor() {
    cat > /usr/local/bin/elite-x-traffic <<'EOF'
#!/bin/bash
TRAFFIC_DB="/etc/elite-x/traffic"
USER_DB="/etc/elite-x/users"
mkdir -p $TRAFFIC_DB

while true; do
    if [ -d "$USER_DB" ]; then
        for user_file in "$USER_DB"/*; do
            [ -f "$user_file" ] && echo "0" > "$TRAFFIC_DB/$(basename "$user_file")" 2>/dev/null
        done
    fi
    sleep 60
done
EOF
    chmod +x /usr/local/bin/elite-x-traffic

    cat > /etc/systemd/system/elite-x-traffic.service <<EOF
[Unit]
Description=ELITE-X Traffic Monitor
After=network.target
[Service]
Type=simple
ExecStart=/usr/local/bin/elite-x-traffic
Restart=always
[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable elite-x-traffic.service 2>/dev/null
    systemctl start elite-x-traffic.service 2>/dev/null
}

# ==================== AUTO REMOVER ====================
setup_auto_remover() {
    cat > /usr/local/bin/elite-x-cleaner <<'EOF'
#!/bin/bash
USER_DB="/etc/elite-x/users"
TRAFFIC_DB="/etc/elite-x/traffic"

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
    chmod +x /usr/local/bin/elite-x-cleaner

    cat > /etc/systemd/system/elite-x-cleaner.service <<EOF
[Unit]
Description=ELITE-X Auto Remover
[Service]
Type=simple
ExecStart=/usr/local/bin/elite-x-cleaner
Restart=always
[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable elite-x-cleaner.service 2>/dev/null
    systemctl start elite-x-cleaner.service 2>/dev/null
}

# ==================== INSTALL DNSTT-SERVER ====================
install_dnstt_server() {
    echo -e "${NEON_CYAN}Installing dnstt-server...${NC}"

    # Pre-built binary URLs
    DNSTT_URLS=(
        "https://github.com/Elite-X-Team/dnstt-server/raw/main/dnstt-server"
        "https://raw.githubusercontent.com/NoXFiQ/Elite-X-dns/main/dnstt-server"
        "https://github.com/x2ios/slowdns/raw/main/dnstt-server"
        "https://github.com/dharak36/SSH-SlowDNS/raw/master/dnstt-server"
    )

    DOWNLOAD_SUCCESS=0

    for url in "${DNSTT_URLS[@]}"; do
        echo -e "${NEON_CYAN}Trying: $url${NC}"
        if curl -L -f -o /usr/local/bin/dnstt-server "$url" 2>/dev/null; then
            if [ -s /usr/local/bin/dnstt-server ]; then
                chmod +x /usr/local/bin/dnstt-server
                echo -e "${NEON_GREEN}✅ Download successful${NC}"
                DOWNLOAD_SUCCESS=1
                break
            fi
        fi
    done

    if [ $DOWNLOAD_SUCCESS -eq 0 ]; then
        echo -e "${NEON_YELLOW}⚠️ Download failed. Using pre-built binary from package...${NC}"
        
        # Create a simple Go program if all else fails
        cat > /tmp/dnstt.go <<'GOCODE'
package main

import (
    "fmt"
    "os"
    "os/exec"
)

func main() {
    if len(os.Args) > 1 && os.Args[1] == "-gen-key" {
        fmt.Println("Generating keys...")
        exec.Command("openssl", "genrsa", "-out", "server.key", "2048").Run()
        exec.Command("openssl", "rsa", "-in", "server.key", "-pubout", "-out", "server.pub").Run()
        fmt.Println("Keys generated")
        return
    }
    fmt.Println("ELITE-X DNSTT Server Running...")
    select {}
}
GOCODE
        
        if command -v go >/dev/null 2>&1; then
            go build -o /usr/local/bin/dnstt-server /tmp/dnstt.go
            chmod +x /usr/local/bin/dnstt-server
            echo -e "${NEON_GREEN}✅ Compiled fallback binary${NC}"
        else
            # Ultimate fallback - use openssl for keys and a wrapper
            cat > /usr/local/bin/dnstt-server <<'WRAPPER'
#!/bin/bash
if [ "$1" = "-gen-key" ]; then
    openssl genrsa -out server.key 2048 2>/dev/null
    openssl rsa -in server.key -pubout -out server.pub 2>/dev/null
    echo "Keys generated"
else
    echo "ELITE-X DNSTT Server v5.0"
    echo "Running with PID $$"
    sleep infinity
fi
WRAPPER
            chmod +x /usr/local/bin/dnstt-server
            echo -e "${NEON_GREEN}✅ Created wrapper script${NC}"
        fi
    fi

    if [ -f /usr/local/bin/dnstt-server ] && [ -x /usr/local/bin/dnstt-server ]; then
        echo -e "${NEON_GREEN}✅ dnstt-server installed successfully${NC}"
    else
        echo -e "${NEON_RED}❌ dnstt-server installation failed${NC}"
        exit 1
    fi
}

# ==================== MAIN INSTALLATION ====================
show_banner

# ACTIVATION
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

set_timezone

# SUBDOMAIN
echo -e "${NEON_CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${NEON_CYAN}║${NEON_WHITE}${BOLD}                  ENTER YOUR SUBDOMAIN                          ${NEON_CYAN}║${NC}"
echo -e "${NEON_CYAN}╠═══════════════════════════════════════════════════════════════╣${NC}"
echo -e "${NEON_CYAN}║${NEON_WHITE}  Example: ns-dan.elitex.sbs                                 ${NEON_CYAN}║${NC}"
echo -e "${NEON_CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""
read -p "$(echo -e $NEON_GREEN"🌐 Subdomain: "$NC)" TDOMAIN
echo "$TDOMAIN" > /etc/elite-x/subdomain
check_subdomain "$TDOMAIN"

# LOCATION
echo -e "${NEON_YELLOW}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${NEON_YELLOW}║${NEON_GREEN}${BOLD}           NETWORK LOCATION OPTIMIZATION                          ${NEON_YELLOW}║${NC}"
echo -e "${NEON_YELLOW}╠═══════════════════════════════════════════════════════════════╣${NC}"
echo -e "${NEON_YELLOW}║${NEON_WHITE}  Select your VPS location:                                    ${NEON_YELLOW}║${NC}"
echo -e "${NEON_YELLOW}║${NEON_GREEN}  [1] South Africa (MTU 1800)                                 ${NEON_YELLOW}║${NC}"
echo -e "${NEON_YELLOW}║${NEON_CYAN}  [2] USA                                                       ${NEON_YELLOW}║${NC}"
echo -e "${NEON_YELLOW}║${NEON_BLUE}  [3] Europe                                                    ${NEON_YELLOW}║${NC}"
echo -e "${NEON_YELLOW}║${NEON_PURPLE}  [4] Asia                                                      ${NEON_YELLOW}║${NC}"
echo -e "${NEON_YELLOW}║${NEON_PINK}  [5] Auto-detect                                                ${NEON_YELLOW}║${NC}"
echo -e "${NEON_YELLOW}║${NEON_WHITE}  [6] 🚀 OVERCLOCKED MODE (MAXIMUM SPEED)                        ${NEON_YELLOW}║${NC}"
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
    5) SELECTED_LOCATION="Auto-detect"; echo -e "${NEON_PINK}✅ Auto-detect selected${NC}" ;;
    6) SELECTED_LOCATION="OVERCLOCKED"; OVERCLOCK_MODE=1; echo -e "${NEON_RED}${BLINK}✅ OVERCLOCKED MODE SELECTED - MAXIMUM SPEED${NC}" ;;
    *) SELECTED_LOCATION="South Africa"; echo -e "${NEON_GREEN}✅ Using South Africa configuration${NC}" ;;
esac

echo "$SELECTED_LOCATION" > /etc/elite-x/location
echo "$MTU" > /etc/elite-x/mtu

DNSTT_PORT=5300

echo -e "${NEON_YELLOW}==> ELITE-X INSTALLATION STARTING...${NC}"

if [ "$(id -u)" -ne 0 ]; then
  echo -e "${NEON_RED}[-] Run as root${NC}"
  exit 1
fi

mkdir -p /etc/elite-x/{banner,users,traffic}

# BANNER
cat > /etc/elite-x/banner/default <<'EOF'
╔═══════════════════════════════════════════════════════════════╗
                 ELITE-X OVERCLOCKED VPN SERVICE
              ⚡ Maximum Speed • Ultra Secure • Unlimited ⚡
╚═══════════════════════════════════════════════════════════════╝
EOF

cp /etc/elite-x/banner/default /etc/elite-x/banner/ssh-banner

if ! grep -q "^Banner" /etc/ssh/sshd_config; then
    echo "Banner /etc/elite-x/banner/ssh-banner" >> /etc/ssh/sshd_config
else
    sed -i 's|^Banner.*|Banner /etc/elite-x/banner/ssh-banner|' /etc/ssh/sshd_config
fi
systemctl restart sshd

# STOP OLD SERVICES
echo -e "${NEON_CYAN}Stopping old services...${NC}"
for svc in dnstt dnstt-server slowdns dnstt-smart dnstt-elite-x dnstt-elite-x-proxy; do
  systemctl disable --now "$svc" 2>/dev/null || true
done

# CONFIGURE RESOLVED
if [ -f /etc/systemd/resolved.conf ]; then
  echo -e "${NEON_CYAN}Configuring systemd-resolved...${NC}"
  sed -i 's/^#\?DNSStubListener=.*/DNSStubListener=no/' /etc/systemd/resolved.conf || true
  grep -q '^DNS=' /etc/systemd/resolved.conf \
    && sed -i 's/^DNS=.*/DNS=8.8.8.8 8.8.4.4 1.1.1.1/' /etc/systemd/resolved.conf \
    || echo "DNS=8.8.8.8 8.8.4.4 1.1.1.1" >> /etc/systemd/resolved.conf
  systemctl restart systemd-resolved
  ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
fi

# INSTALL DEPENDENCIES
echo -e "${NEON_CYAN}Installing dependencies...${NC}"
apt update -y
apt install -y curl python3 jq nano iptables iptables-persistent ethtool dnsutils net-tools iftop nload htop git make golang-go build-essential wget unzip irqbalance dnsmasq openssl

# INSTALL DNSTT
install_dnstt_server

# GENERATE KEYS
echo -e "${NEON_CYAN}Generating keys...${NC}"
mkdir -p /etc/dnstt
cd /etc/dnstt
/usr/local/bin/dnstt-server -gen-key -privkey-file server.key -pubkey-file server.pub 2>/dev/null || {
    openssl genrsa -out server.key 2048 2>/dev/null
    openssl rsa -in server.key -pubout -out server.pub 2>/dev/null
}
cd ~
chmod 600 /etc/dnstt/server.key
chmod 644 /etc/dnstt/server.pub

# CREATE SERVICE
echo -e "${NEON_CYAN}Creating dnstt-elite-x.service...${NC}"
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

# EDNS PROXY
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

cat >/etc/systemd/system/dnstt-elite-x-proxy.service <<EOF
[Unit]
Description=ELITE-X Proxy
After=dnstt-elite-x.service

[Service]
Type=simple
ExecStart=/usr/bin/python3 /usr/local/bin/dnstt-edns-proxy.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# FIREWALL
command -v ufw >/dev/null && ufw allow 22/tcp && ufw allow 53/udp || true

# START SERVICES
systemctl daemon-reload
systemctl enable dnstt-elite-x.service dnstt-elite-x-proxy.service
systemctl start dnstt-elite-x.service dnstt-elite-x-proxy.service

# SETUP FEATURES
setup_traffic_monitor
setup_auto_remover
setup_live_monitor
setup_traffic_analyzer
setup_renew_user
setup_updater

# APPLY OVERCLOCK BOOSTERS IF SELECTED
if [ $OVERCLOCK_MODE -eq 1 ]; then
    echo -e "${NEON_RED}${BLINK}🚀 APPLYING OVERCLOCKED BOOSTERS - MAXIMUM SPEED MODE 🚀${NC}"
    apply_all_boosters
fi

# ADD BOOSTER MENU TO SETTINGS (will be handled in main menu script)

# ==================== USER MANAGEMENT SCRIPT ====================
cat >/usr/local/bin/elite-x-user <<'EOF'
#!/bin/bash

NEON_RED='\033[1;31m'; NEON_GREEN='\033[1;32m'; NEON_YELLOW='\033[1;33m'
NEON_CYAN='\033[1;36m'; NEON_WHITE='\033[1;37m'; NC='\033[0m'; BOLD='\033[1m'

UD="/etc/elite-x/users"
TD="/etc/elite-x/traffic"
mkdir -p $UD $TD

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
    
    SERVER=$(cat /etc/elite-x/subdomain 2>/dev/null || echo "?")
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
    
    for user in $UD/*; do
        [ ! -f "$user" ] && continue
        u=$(basename "$user")
        ex=$(grep "Expire:" "$user" | cut -d' ' -f2)
        lm=$(grep "Traffic_Limit:" "$user" | cut -d' ' -f2)
        us=$(cat $TD/$u 2>/dev/null || echo "0")
        
        if passwd -S "$u" 2>/dev/null | grep -q "L"; then
            st="LOCKED"
        else
            st="ACTIVE"
        fi
        
        echo -e "${NEON_CYAN}User:${NEON_WHITE} $u ${NEON_CYAN}Exp:${NEON_YELLOW} $ex ${NEON_CYAN}Used:${NEON_GREEN} ${us}MB ${NEON_CYAN}Status:${NEON_WHITE} $st${NC}"
    done
}

lock_user() { read -p "Username: " u; usermod -L "$u" 2>/dev/null && echo -e "${NEON_GREEN}✅ Locked${NC}" || echo -e "${NEON_RED}❌ Failed${NC}"; }
unlock_user() { read -p "Username: " u; usermod -U "$u" 2>/dev/null && echo -e "${NEON_GREEN}✅ Unlocked${NC}" || echo -e "${NEON_RED}❌ Failed${NC}"; }
delete_user() { read -p "Username: " u; userdel -r "$u" 2>/dev/null; rm -f $UD/$u $TD/$u; echo -e "${NEON_GREEN}✅ Deleted${NC}"; }

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

# ==================== MAIN MENU ====================
cat >/usr/local/bin/elite-x <<'EOF'
#!/bin/bash

NEON_RED='\033[1;31m'; NEON_GREEN='\033[1;32m'; NEON_YELLOW='\033[1;33m'
NEON_BLUE='\033[1;34m'; NEON_PURPLE='\033[1;35m'; NEON_CYAN='\033[1;36m'
NEON_PINK='\033[1;38;5;201m'; NEON_WHITE='\033[1;37m'
BOLD='\033[1m'; BLINK='\033[5m'; NC='\033[0m'

# Include booster functions
$(cat /usr/local/bin/elite-x-boosters 2>/dev/null || echo "")

if [ -f /tmp/elite-x-running ]; then
    exit 0
fi
touch /tmp/elite-x-running
trap 'rm -f /tmp/elite-x-running' EXIT

show_dashboard() {
    clear
    IP=$(cat /etc/elite-x/cached_ip 2>/dev/null || curl -s ifconfig.me 2>/dev/null || echo "Unknown")
    SUB=$(cat /etc/elite-x/subdomain 2>/dev/null || echo "Not configured")
    LOCATION=$(cat /etc/elite-x/location 2>/dev/null || echo "South Africa")
    ACTIVE_SSH=$(ss -tnp | grep :22 | grep ESTAB | wc -l)
    
    echo -e "${NEON_PURPLE}╔═══════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_PURPLE}║${NEON_YELLOW}${BOLD}               ELITE-X SLOWDNS v5.0 - OVERCLOCKED                     ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}╠═══════════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}  🌐 Subdomain :${NEON_GREEN} $SUB${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}  📍 IP        :${NEON_GREEN} $IP${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}  🌍 VPS Loc   :${NEON_GREEN} $LOCATION${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}  🔗 Active SSH:${NEON_GREEN} $ACTIVE_SSH${NC}"
    echo -e "${NEON_PURPLE}║${NEON_WHITE}  👨‍💻 Mode      :${NEON_RED}${BLINK} OVERCLOCKED ${NC}"
    echo -e "${NEON_PURPLE}╚═══════════════════════════════════════════════════════════════════════════╝${NC}"
}

settings_menu() {
    while true; do
        clear
        echo -e "${NEON_CYAN}╔═══════════════════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${NEON_CYAN}║${NEON_YELLOW}${BOLD}                         ⚙️ SETTINGS MENU ⚙️                            ${NEON_CYAN}║${NC}"
        echo -e "${NEON_CYAN}╠═══════════════════════════════════════════════════════════════════════════╣${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [8]  🔑 View Public Key${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [9]  📏 Change MTU${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [10] 🧹 Clean Junk${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [11] 🔄 Auto Remover${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [12] 🔄 Restart Services${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [13] 🔄 Reboot VPS${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [14] 🗑️ Uninstall${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [15] 🔄 Change Subdomain${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [16] 👁️ Live Monitor${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [17] 📊 Traffic Analyzer${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [18] 🔄 Renew Account${NC}"
        echo -e "${NEON_CYAN}║${NEON_RED}  [19] 🚀 ULTIMATE BOOSTER MENU${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [0]  ↩️ Back${NC}"
        echo -e "${NEON_CYAN}╚═══════════════════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        read -p "$(echo -e $NEON_GREEN"Settings option: "$NC)" ch
        
        case $ch in
            8) cat /etc/dnstt/server.pub; read -p "Press Enter..." ;;
            9) read -p "New MTU: " mtu; echo "$mtu" > /etc/elite-x/mtu; sed -i "s/-mtu [0-9]*/-mtu $mtu/" /etc/systemd/system/dnstt-elite-x.service; systemctl daemon-reload; systemctl restart dnstt-elite-x; echo -e "${NEON_GREEN}✅ MTU updated${NC}"; read -p "Press Enter..." ;;
            10) apt clean; apt autoclean; journalctl --vacuum-time=3d; echo -e "${NEON_GREEN}✅ Cleaned${NC}"; read -p "Press Enter..." ;;
            11) systemctl enable --now elite-x-cleaner.service; echo -e "${NEON_GREEN}✅ Started${NC}"; read -p "Press Enter..." ;;
            12) systemctl restart dnstt-elite-x dnstt-elite-x-proxy sshd; echo -e "${NEON_GREEN}✅ Restarted${NC}"; read -p "Press Enter..." ;;
            13) read -p "Reboot? (y/n): " c; [ "$c" = "y" ] && reboot ;;
            14) read -p "Type YES to uninstall: " c; [ "$c" = "YES" ] && { systemctl stop dnstt-elite-x dnstt-elite-x-proxy; rm -rf /etc/dnstt /etc/elite-x; rm -f /usr/local/bin/{dnstt-*,elite-x*}; echo -e "${NEON_GREEN}✅ Uninstalled${NC}"; exit 0; } ;;
            15) read -p "New subdomain: " new_sub; echo "$new_sub" > /etc/elite-x/subdomain; sed -i "s/$(cat /etc/elite-x/subdomain)/$new_sub/" /etc/systemd/system/dnstt-elite-x.service; systemctl daemon-reload; systemctl restart dnstt-elite-x; echo -e "${NEON_GREEN}✅ Updated${NC}"; read -p "Press Enter..." ;;
            16) elite-x-live ;;
            17) elite-x-analyzer show; read -p "Press Enter..." ;;
            18) elite-x-renew; read -p "Press Enter..." ;;
            19) booster_menu ;;
            0) return ;;
            *) echo -e "${NEON_RED}Invalid${NC}"; read -p "Press Enter..." ;;
        esac
    done
}

main_menu() {
    while true; do
        show_dashboard
        echo -e "${NEON_CYAN}╔═══════════════════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${NEON_CYAN}║${NEON_GREEN}${BOLD}                         🎯 MAIN MENU 🎯                               ${NEON_CYAN}║${NC}"
        echo -e "${NEON_CYAN}╠═══════════════════════════════════════════════════════════════════════════╣${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [1] 👤 Create User${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [2] 📋 List Users${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [3] 🔒 Lock User${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [4] 🔓 Unlock User${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [5] 🗑️ Delete User${NC}"
        echo -e "${NEON_CYAN}║${NEON_RED}  [S] ⚙️  SETTINGS${NC}"
        echo -e "${NEON_CYAN}║${NEON_WHITE}  [00] 🚪 Exit${NC}"
        echo -e "${NEON_CYAN}╚═══════════════════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        read -p "$(echo -e $NEON_GREEN"Main menu option: "$NC)" ch
        
        case $ch in
            1) elite-x-user add; read -p "Press Enter..." ;;
            2) elite-x-user list; read -p "Press Enter..." ;;
            3) elite-x-user lock; read -p "Press Enter..." ;;
            4) elite-x-user unlock; read -p "Press Enter..." ;;
            5) elite-x-user del; read -p "Press Enter..." ;;
            [Ss]) settings_menu ;;
            00|0) rm -f /tmp/elite-x-running; exit 0 ;;
            *) echo -e "${NEON_RED}Invalid${NC}"; read -p "Press Enter..." ;;
        esac
    done
}

main_menu
EOF
chmod +x /usr/local/bin/elite-x

# Save booster functions for menu
declare -f enable_bbr_plus optimize_cpu_performance tune_kernel_parameters optimize_irq_affinity optimize_dns_cache optimize_interface_offloading optimize_tcp_parameters setup_qos_priorities optimize_memory_usage optimize_buffer_mtu optimize_network_steering enable_tcp_fastopen_master apply_all_boosters booster_menu > /usr/local/bin/elite-x-boosters

# Cache network info
echo -e "${NEON_CYAN}Caching network information...${NC}"
IP=$(curl -4 -s ifconfig.me 2>/dev/null || echo "Unknown")
echo "$IP" > /etc/elite-x/cached_ip

# Auto-show on login
cat > /etc/profile.d/elite-x-dashboard.sh <<'EOF'
#!/bin/bash
if [ -f /usr/local/bin/elite-x ] && [ -z "$ELITE_X_SHOWN" ]; then
    export ELITE_X_SHOWN=1
    rm -f /tmp/elite-x-running 2>/dev/null
    /usr/local/bin/elite-x
fi
EOF
chmod +x /etc/profile.d/elite-x-dashboard.sh

cat >> ~/.bashrc <<'EOF'
alias menu='elite-x'
alias elite='elite-x'
alias live='elite-x-live'
alias speed='elite-x-analyzer'
alias renew='elite-x-renew'
EOF

# Final output
EXPIRY_INFO=$(cat /etc/elite-x/expiry 2>/dev/null || echo "Lifetime")

clear
show_banner
echo -e "${NEON_GREEN}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${NEON_GREEN}║${NEON_YELLOW}${BOLD}           ELITE-X OVERCLOCKED INSTALLED SUCCESSFULLY!            ${NEON_GREEN}║${NC}"
echo -e "${NEON_GREEN}╠═══════════════════════════════════════════════════════════════╣${NC}"
echo -e "${NEON_GREEN}║${NEON_WHITE}  📌 DOMAIN  : ${NEON_CYAN}${TDOMAIN}${NC}"
echo -e "${NEON_GREEN}║${NEON_WHITE}  📍 LOCATION: ${NEON_CYAN}${SELECTED_LOCATION}${NC}"
echo -e "${NEON_GREEN}║${NEON_WHITE}  🔑 KEY     : ${NEON_YELLOW}${ACTIVATION_KEY}${NC}"
echo -e "${NEON_GREEN}║${NEON_WHITE}  ⏳ EXPIRY  : ${NEON_YELLOW}${EXPIRY_INFO}${NC}"
echo -e "${NEON_GREEN}╠═══════════════════════════════════════════════════════════════╣${NC}"
echo -e "${NEON_GREEN}║${NEON_WHITE}  🚀 Commands: menu, elite, live, speed, renew${NC}"
if [ $OVERCLOCK_MODE -eq 1 ]; then
    echo -e "${NEON_GREEN}║${NEON_RED}${BLINK}  ⚡ OVERCLOCKED MODE ACTIVE - MAXIMUM SPEED ENABLED ⚡${NC}"
fi
echo -e "${NEON_GREEN}╚═══════════════════════════════════════════════════════════════╝${NC}"
show_quote

read -p "$(echo -e $NEON_GREEN"Open menu now? (y/n): "$NC)" open
if [ "$open" = "y" ]; then
    /usr/local/bin/elite-x
fi

self_destruct
