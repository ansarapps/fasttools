# 🚀 FastTools VPS Deployment Guide

यह guide आपको FastTools application को VPS पर deploy करने की complete process बताती है, जिसमें Nginx configuration, auto-deployment via GitHub Actions, और production-ready setup शामिल है।

## 📋 Prerequisites

### VPS Requirements
- **OS**: Ubuntu 20.04+ या Debian 11+
- **RAM**: कम से कम 2GB (4GB recommended)
- **Storage**: कम से कम 20GB
- **CPU**: 1 vCPU (2+ recommended)
- **Network**: Public IP address

### Domain Requirements
- Domain name (example: `your-domain.com`)
- DNS A record pointing to your VPS IP

### GitHub Requirements
- GitHub repository with your FastTools code
- GitHub Actions enabled

## 🛠️ Step 1: VPS Initial Setup

### 1.1 Connect to VPS
```bash
ssh root@your-vps-ip
```

### 1.2 Create Non-Root User
```bash
adduser deploy
usermod -aG sudo deploy
su - deploy
```

### 1.3 Setup SSH Key Authentication
```bash
# On your local machine
ssh-keygen -t rsa -b 4096 -C "your-email@example.com"
ssh-copy-id deploy@your-vps-ip
```

## 🔧 Step 2: Automated VPS Setup

### 2.1 Download and Run Setup Script
```bash
# Clone your repository
git clone https://github.com/your-username/fasttools.git
cd fasttools

# Make setup script executable
chmod +x scripts/vps-setup.sh

# Run setup script
./scripts/vps-setup.sh
```

### 2.2 Manual Setup (Alternative)
यदि automated script काम नहीं करे तो manual steps follow करें:

#### Install Node.js
```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```

#### Install Nginx
```bash
sudo apt update
sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx
```

#### Install PM2
```bash
sudo npm install -g pm2
```

## 🌐 Step 3: Domain and SSL Configuration

### 3.1 Update Nginx Configuration
```bash
# Copy nginx configuration
sudo cp nginx.conf /etc/nginx/sites-available/fasttools

# Update domain name in configuration
sudo nano /etc/nginx/sites-available/fasttools
# Replace 'your-domain.com' with your actual domain

# Enable site
sudo ln -s /etc/nginx/sites-available/fasttools /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### 3.2 Setup SSL Certificate
```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# Get SSL certificate
sudo certbot --nginx -d your-domain.com -d www.your-domain.com

# Auto-renewal setup
sudo crontab -e
# Add this line:
# 0 12 * * * /usr/bin/certbot renew --quiet
```

## ⚙️ Step 4: Environment Configuration

### 4.1 Setup Production Environment
```bash
# Copy environment file
sudo cp frontend/.env.production /etc/fasttools/.env.production

# Edit configuration
sudo nano /etc/fasttools/.env.production
```

### 4.2 Required Environment Variables
Update करने वाले important variables:

```env
# Domain Configuration
NEXT_PUBLIC_APP_URL=https://your-domain.com
NEXT_PUBLIC_API_URL=https://your-domain.com/api
NEXTAUTH_URL=https://your-domain.com

# Security (Generate strong secrets)
JWT_SECRET=your-super-secret-jwt-key
NEXTAUTH_SECRET=your-nextauth-secret
CSRF_SECRET=your-csrf-secret

# Email Configuration
SMTP_HOST=smtp.gmail.com
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password
FROM_EMAIL=noreply@your-domain.com
```

## 🔄 Step 5: GitHub Actions Auto-Deployment

### 5.1 Setup GitHub Secrets
GitHub repository में जाकर Settings > Secrets and variables > Actions में ये secrets add करें:

```
VPS_HOST=your-vps-ip-address
VPS_USER=deploy
VPS_SSH_KEY=your-private-ssh-key-content
```

### 5.2 SSH Key Setup
```bash
# Generate deployment key
ssh-keygen -t rsa -b 4096 -f ~/.ssh/github_deploy

# Add public key to authorized_keys
cat ~/.ssh/github_deploy.pub >> ~/.ssh/authorized_keys

# Copy private key content for GitHub secret
cat ~/.ssh/github_deploy
```

### 5.3 Test Auto-Deployment
```bash
# Push code to main branch
git add .
git commit -m "Initial deployment setup"
git push origin main
```

## 📦 Step 6: Manual Deployment (First Time)

### 6.1 Deploy Application
```bash
# Clone repository to VPS
git clone https://github.com/your-username/fasttools.git /tmp/fasttools-deploy
cd /tmp/fasttools-deploy/frontend

# Install dependencies
npm ci --production

# Build application
npm run build

# Copy to production directory
sudo cp -r /tmp/fasttools-deploy/frontend/* /var/www/fasttools/

# Set permissions
sudo chown -R fasttools:www-data /var/www/fasttools
sudo chmod -R 755 /var/www/fasttools

# Copy environment file
sudo cp /etc/fasttools/.env.production /var/www/fasttools/.env.local

# Start application
sudo systemctl start fasttools
sudo systemctl enable fasttools
```

### 6.2 Verify Deployment
```bash
# Check application status
sudo systemctl status fasttools

# Check logs
sudo journalctl -u fasttools -f

# Test application
curl -f http://localhost:3000
curl -f https://your-domain.com
```

## 🔍 Step 7: Monitoring and Maintenance

### 7.1 Useful Commands
```bash
# Application status
sudo systemctl status fasttools

# View logs
sudo journalctl -u fasttools -f
sudo tail -f /var/log/fasttools/combined.log

# PM2 commands
sudo -u fasttools pm2 status
sudo -u fasttools pm2 logs
sudo -u fasttools pm2 restart fasttools

# Nginx commands
sudo nginx -t
sudo systemctl reload nginx
sudo tail -f /var/log/nginx/fasttools_access.log
```

### 7.2 Backup Commands
```bash
# Manual backup
sudo /usr/local/bin/fasttools-backup

# List backups
ls -la /var/backups/fasttools/

# Restore backup
sudo tar -xzf /var/backups/fasttools/fasttools_backup_YYYYMMDD_HHMMSS.tar.gz -C /var/www/
```

### 7.3 Update Application
```bash
# Manual update
sudo /usr/local/bin/fasttools-deploy

# Or via GitHub Actions (automatic)
git push origin main
```

## 🛡️ Step 8: Security Hardening

### 8.1 Firewall Configuration
```bash
# Check firewall status
sudo ufw status

# Allow specific ports
sudo ufw allow ssh
sudo ufw allow 'Nginx Full'
sudo ufw enable
```

### 8.2 Fail2Ban Configuration
```bash
# Check fail2ban status
sudo fail2ban-client status

# Check specific jail
sudo fail2ban-client status nginx-http-auth
```

### 8.3 Regular Updates
```bash
# System updates
sudo apt update && sudo apt upgrade -y

# Node.js updates
sudo npm update -g

# SSL certificate renewal
sudo certbot renew --dry-run
```

## 🚨 Troubleshooting

### Common Issues और Solutions

#### 1. Application Not Starting
```bash
# Check logs
sudo journalctl -u fasttools -n 50

# Check PM2 status
sudo -u fasttools pm2 logs

# Restart application
sudo systemctl restart fasttools
```

#### 2. Nginx 502 Bad Gateway
```bash
# Check if application is running
curl http://localhost:3000

# Check nginx configuration
sudo nginx -t

# Restart nginx
sudo systemctl restart nginx
```

#### 3. SSL Certificate Issues
```bash
# Check certificate status
sudo certbot certificates

# Renew certificate
sudo certbot renew

# Test SSL
ssl-checker your-domain.com
```

#### 4. Database Issues
```bash
# Check database file permissions
ls -la /var/www/fasttools/database.sqlite

# Fix permissions
sudo chown fasttools:www-data /var/www/fasttools/database.sqlite
sudo chmod 664 /var/www/fasttools/database.sqlite
```

#### 5. GitHub Actions Deployment Fails
```bash
# Check SSH connection
ssh deploy@your-vps-ip

# Check deployment logs in GitHub Actions
# Verify secrets are correctly set
```

## 📊 Performance Optimization

### 1. Enable Gzip Compression
Nginx configuration में already included है।

### 2. Setup Redis Caching (Optional)
```bash
# Install Redis
sudo apt install redis-server -y
sudo systemctl enable redis-server

# Update environment
REDIS_URL=redis://localhost:6379
```

### 3. Database Optimization
```bash
# For SQLite
sudo apt install sqlite3 -y

# Optimize database
sqlite3 /var/www/fasttools/database.sqlite "VACUUM;"
```

## 🔄 Scaling Considerations

### Horizontal Scaling
- Load balancer setup
- Multiple VPS instances
- Shared database

### Vertical Scaling
- Increase VPS resources
- Optimize PM2 cluster mode
- Database performance tuning

## 📞 Support

यदि आपको कोई issue आए तो:

1. Logs check करें
2. GitHub Issues में report करें
3. Documentation को carefully follow करें

---

## ✅ Deployment Checklist

- [ ] VPS setup completed
- [ ] Domain configured
- [ ] SSL certificate installed
- [ ] Environment variables configured
- [ ] GitHub secrets added
- [ ] Application deployed
- [ ] Auto-deployment tested
- [ ] Monitoring setup
- [ ] Backup configured
- [ ] Security hardening done

**🎉 Congratulations! आपका FastTools application successfully deploy हो गया है!**