#!/bin/bash

# FastTools VPS Setup Script
# This script sets up the complete environment for FastTools on Ubuntu/Debian VPS

set -e

echo "🚀 Starting FastTools VPS Setup..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root. Please run as a regular user with sudo privileges."
   exit 1
fi

# Update system
print_status "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install required packages
print_status "Installing required packages..."
sudo apt install -y curl wget git nginx certbot python3-certbot-nginx ufw fail2ban htop unzip

# Install Node.js 18.x
print_status "Installing Node.js 18.x..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install PM2 globally
print_status "Installing PM2..."
sudo npm install -g pm2

# Create application user
print_status "Creating application user..."
sudo useradd -m -s /bin/bash fasttools || print_warning "User 'fasttools' already exists"
sudo usermod -aG www-data fasttools

# Create application directories
print_status "Creating application directories..."
sudo mkdir -p /var/www/fasttools
sudo mkdir -p /etc/fasttools
sudo mkdir -p /var/log/fasttools

# Set permissions
sudo chown -R fasttools:www-data /var/www/fasttools
sudo chown -R fasttools:fasttools /etc/fasttools
sudo chown -R fasttools:fasttools /var/log/fasttools
sudo chmod -R 755 /var/www/fasttools

# Configure firewall
print_status "Configuring firewall..."
sudo ufw --force enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 'Nginx Full'
sudo ufw allow 3000/tcp

# Configure fail2ban
print_status "Configuring fail2ban..."
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Create fail2ban configuration for nginx
sudo tee /etc/fail2ban/jail.d/nginx.conf > /dev/null <<EOF
[nginx-http-auth]
enabled = true
filter = nginx-http-auth
logpath = /var/log/nginx/error.log
maxretry = 3
bantime = 3600

[nginx-limit-req]
enabled = true
filter = nginx-limit-req
logpath = /var/log/nginx/error.log
maxretry = 10
bantime = 600
EOF

sudo systemctl enable fail2ban
sudo systemctl restart fail2ban

# Remove default nginx site
print_status "Configuring Nginx..."
sudo rm -f /etc/nginx/sites-enabled/default

# Create nginx configuration for FastTools
sudo tee /etc/nginx/sites-available/fasttools > /dev/null <<'EOF'
server {
    listen 80;
    server_name _;
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        proxy_read_timeout 86400;
    }
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    
    # Logging
    access_log /var/log/nginx/fasttools_access.log;
    error_log /var/log/nginx/fasttools_error.log;
}
EOF

# Enable nginx site
sudo ln -sf /etc/nginx/sites-available/fasttools /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl enable nginx
sudo systemctl restart nginx

# Create PM2 ecosystem file
print_status "Creating PM2 configuration..."
sudo tee /etc/fasttools/ecosystem.config.js > /dev/null <<'EOF'
module.exports = {
  apps: [{
    name: 'fasttools',
    cwd: '/var/www/fasttools',
    script: 'server.js',
    instances: 'max',
    exec_mode: 'cluster',
    env: {
      NODE_ENV: 'production',
      PORT: 3000
    },
    error_file: '/var/log/fasttools/error.log',
    out_file: '/var/log/fasttools/out.log',
    log_file: '/var/log/fasttools/combined.log',
    time: true,
    max_memory_restart: '1G',
    node_args: '--max-old-space-size=1024'
  }]
};
EOF

# Create systemd service for PM2
print_status "Creating systemd service..."
sudo tee /etc/systemd/system/fasttools.service > /dev/null <<'EOF'
[Unit]
Description=FastTools Application
After=network.target

[Service]
Type=forking
User=fasttools
WorkingDirectory=/var/www/fasttools
ExecStart=/usr/bin/pm2 start /etc/fasttools/ecosystem.config.js --no-daemon
ExecReload=/usr/bin/pm2 reload /etc/fasttools/ecosystem.config.js
ExecStop=/usr/bin/pm2 stop /etc/fasttools/ecosystem.config.js
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable fasttools

# Create log rotation
print_status "Setting up log rotation..."
sudo tee /etc/logrotate.d/fasttools > /dev/null <<'EOF'
/var/log/fasttools/*.log {
    daily
    missingok
    rotate 52
    compress
    delaycompress
    notifempty
    create 644 fasttools fasttools
    postrotate
        pm2 reloadLogs
    endscript
}
EOF

# Create backup script
print_status "Creating backup script..."
sudo tee /usr/local/bin/fasttools-backup > /dev/null <<'EOF'
#!/bin/bash

# FastTools Backup Script
BACKUP_DIR="/var/backups/fasttools"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="fasttools_backup_$DATE.tar.gz"

# Create backup directory
mkdir -p $BACKUP_DIR

# Create backup
tar -czf $BACKUP_DIR/$BACKUP_FILE -C /var/www fasttools

# Keep only last 7 backups
find $BACKUP_DIR -name "fasttools_backup_*.tar.gz" -type f -mtime +7 -delete

echo "Backup created: $BACKUP_DIR/$BACKUP_FILE"
EOF

sudo chmod +x /usr/local/bin/fasttools-backup

# Add backup to crontab
print_status "Setting up automated backups..."
(crontab -l 2>/dev/null; echo "0 2 * * * /usr/local/bin/fasttools-backup") | crontab -

# Create deployment script
print_status "Creating deployment script..."
sudo tee /usr/local/bin/fasttools-deploy > /dev/null <<'EOF'
#!/bin/bash

# FastTools Deployment Script
set -e

APP_DIR="/var/www/fasttools"
BACKUP_DIR="/var/backups/fasttools"
DATE=$(date +%Y%m%d_%H%M%S)

echo "Starting deployment..."

# Create backup before deployment
echo "Creating backup..."
/usr/local/bin/fasttools-backup

# Stop application
echo "Stopping application..."
sudo systemctl stop fasttools

# Install dependencies and build
echo "Installing dependencies..."
cd $APP_DIR
npm ci --production

echo "Building application..."
npm run build

# Set permissions
echo "Setting permissions..."
sudo chown -R fasttools:www-data $APP_DIR
sudo chmod -R 755 $APP_DIR

# Start application
echo "Starting application..."
sudo systemctl start fasttools

# Verify deployment
echo "Verifying deployment..."
sleep 5
if curl -f http://localhost:3000 > /dev/null 2>&1; then
    echo "✅ Deployment successful!"
else
    echo "❌ Deployment verification failed!"
    exit 1
fi
EOF

sudo chmod +x /usr/local/bin/fasttools-deploy

# Create environment template
print_status "Creating environment template..."
sudo tee /etc/fasttools/.env.production > /dev/null <<'EOF'
# FastTools Production Environment
NODE_ENV=production
PORT=3000

# Database Configuration
DATABASE_URL=sqlite:///var/www/fasttools/database.sqlite

# JWT Configuration
JWT_SECRET=your-super-secret-jwt-key-change-this
JWT_EXPIRES_IN=7d

# Email Configuration
SMTP_HOST=your-smtp-host
SMTP_PORT=587
SMTP_USER=your-smtp-user
SMTP_PASS=your-smtp-password
FROM_EMAIL=noreply@your-domain.com

# Application Configuration
NEXT_PUBLIC_APP_URL=https://your-domain.com
NEXT_PUBLIC_API_URL=https://your-domain.com/api

# Security
NEXTAUTH_SECRET=your-nextauth-secret-change-this
NEXTAUTH_URL=https://your-domain.com

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100
EOF

print_success "VPS setup completed successfully!"
print_status "Next steps:"
echo "1. Update /etc/fasttools/.env.production with your actual configuration"
echo "2. Copy your application files to /var/www/fasttools"
echo "3. Run: sudo /usr/local/bin/fasttools-deploy"
echo "4. Configure SSL with: sudo certbot --nginx -d your-domain.com"
echo "5. Update nginx configuration in /etc/nginx/sites-available/fasttools"

print_status "Useful commands:"
echo "- Check application status: sudo systemctl status fasttools"
echo "- View logs: sudo journalctl -u fasttools -f"
echo "- PM2 status: sudo -u fasttools pm2 status"
echo "- Create backup: sudo /usr/local/bin/fasttools-backup"
echo "- Deploy application: sudo /usr/local/bin/fasttools-deploy"

print_success "Setup complete! 🎉"