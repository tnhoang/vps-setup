#!/bin/bash

# This script finds IPs that have been banned multiple times by fail2ban
# and adds them to a permanent ban list in iptables

# Ensure script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root or with sudo."
  exit 1
fi

# Threshold for permanent ban (number of times an IP has been banned)
BAN_THRESHOLD=50
LOG_FILE="/var/log/fail2ban.log"

echo "Checking for persistent attackers in fail2ban logs..."

# Find IPs that have been banned more than the threshold
PERSISTENT_ATTACKERS=$(awk '($(NF-1) == "Ban"){print $NF}' $LOG_FILE | sort | uniq -c | sort -n | awk -v threshold=$BAN_THRESHOLD '$1 > threshold {print $2}')

if [ -z "$PERSISTENT_ATTACKERS" ]; then
  echo "No persistent attackers found exceeding the threshold of $BAN_THRESHOLD bans."
  exit 0
fi

# Add persistent attackers to permanent ban list
echo "Found $(echo "$PERSISTENT_ATTACKERS" | wc -l) persistent attackers. Adding them to permanent ban list..."

echo "$PERSISTENT_ATTACKERS" | while read IP; do
  # Check if IP is already in the ban list
  if sudo iptables -L INPUT -v -n | grep -q "$IP"; then
    echo "IP $IP is already permanently banned."
  else
    sudo iptables -A INPUT -s $IP -j DROP
    echo "Permanently banned IP: $IP"
  fi
done

# Save iptables rules to persist after reboot
if command -v netfilter-persistent &> /dev/null; then
  echo "Saving iptables rules with netfilter-persistent..."
  sudo netfilter-persistent save
elif command -v iptables-save &> /dev/null; then
  echo "Saving iptables rules with iptables-save..."
  sudo iptables-save > /etc/iptables/rules.v4
else
  echo "WARNING: Could not find a way to persist iptables rules."
  echo "Manual action required to save the rules for persistence after reboot."
fi

echo "Ban operation completed."
echo "To view all permanently banned IPs, run: sudo iptables -L INPUT -v -n | grep DROP" 