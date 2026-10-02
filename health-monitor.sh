#!/bin/bash

# Input validation
if [ -z "$1" ]; then
    echo "Usage: $0 <threshold>"
    exit 2
fi

if ! [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "Error: threshold must be a number"
    exit 2
fi

if [ "$1" -lt 0 ] || [ "$1" -gt 100 ]; then
    echo "Error: threshold must be between 0 and 100"
    exit 2
fi

server_status="HEALTHY"
threshold=$1

echo "========================================"
echo "       LINUX SERVER HEALTH CHECK"
echo "========================================"

echo "Hostname: $(hostname)"
echo "User: $(whoami)"

# Apache check
status=$(systemctl is-active apache2)

if [ "$status" = "active" ]; then
    echo "Apache: OK"
else
    echo "Apache: NOT OK"
    server_status="WARNING"
fi

# SSH check
ssh_status=$(systemctl is-active ssh)

if [ "$ssh_status" = "active" ]; then
    echo "SSH: OK"
else
    echo "SSH: NOT OK"
    server_status="WARNING"
fi

# Resource check function
check_threshold() {
    name=$1
    value=$2

    if [ "$value" -lt "$threshold" ]; then
        echo "$name: $value% used — OK"
    else
        echo "$name: $value% used — WARNING"
        server_status="WARNING"
    fi
}

# Disk check
disk=$(df -h / | tail -1 | awk '{print $5}')
disk_number=${disk%\%}

check_threshold "Disk" "$disk_number"

# Memory check
memory=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')

check_threshold "Memory" "$memory"

# CPU check
cpu=$(top -bn1 | awk '/%Cpu/ {print 100 - $8}')
cpu_number=${cpu%.*}

check_threshold "CPU" "$cpu_number"

# Network check
packet_loss=$(ping -c 4 google.com | grep -oP '\d+(?=% packet loss)')

if [ "$packet_loss" -eq 0 ]; then
    echo "Network: $packet_loss% packet loss — OK"
else
    echo "Network: $packet_loss% packet loss — WARNING"
    server_status="WARNING"
fi

# Final status
echo ""
echo "========================================"
echo "SERVER HEALTH: $server_status"
echo "========================================"

if [ "$server_status" = "HEALTHY" ]; then
    exit 0
else
    exit 1
fi

echo "Checked by Jaffar"
echo "Git commit 3 test"
echo "Feature branch test"
# Practicing Git integration with VS Code
# IoT alert feature
# Docker preparation - feature branch version