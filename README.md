# vps-setup

## Setup
```
git clone https://github.com/tnhoang/vps-setup.git
cd vps-setup
chmod +x run.sh
chmod +x edit-sshd.sh
chmod +x ban-persistent-attackers.sh
sudo ./run.sh
```

## Security Features

### SSH Hardening
The `edit-sshd.sh` script configures SSH for improved security:
- Disables password authentication
- Disables root login
- Configures other security settings

### Fail2Ban
The setup automatically installs and configures fail2ban with the following settings:
- Monitors SSH login attempts
- Bans IPs after 3 failed login attempts for 24 hours
- General ban settings: 5 failures within 10 minutes results in a 1-hour ban

### Permanent IP Banning
The `ban-persistent-attackers.sh` script:
- Runs daily via cron job
- Checks fail2ban logs for IPs that have been banned more than 50 times
- Permanently blocks these IPs using iptables
- Logs operations to `/var/log/ban-persistent-attackers.log`

## Useful Commands

### Check Fail2Ban Status
```
sudo fail2ban-client status
sudo fail2ban-client status sshd
```

### View Current Bans
```
sudo fail2ban-client banned
```

### Manually Unban an IP
```
sudo fail2ban-client unban [IP]
```

### View Persistent Bans
```
sudo iptables -L INPUT -v -n | grep DROP
```

### Manually Run the Permanent Ban Script
```
sudo /usr/local/bin/ban-persistent-attackers.sh
```
