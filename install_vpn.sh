#!/bin/bash
# install_vpn.sh - Auto-install VPN for PayPal system

echo "🔧 Starting Auto-VPN Installation for PayPal System..."
echo "========================================================"

# Check if we're on Kali Linux
if ! grep -q "Kali" /etc/os-release; then
    echo "⚠️  This script is optimized for Kali Linux"
fi

# Update system first
echo "📥 Updating system packages..."
sudo apt update -y

# Install required dependencies
echo "📦 Installing dependencies..."
sudo apt install -y curl wget openvpn network-manager-openvpn

# Install Windscribe VPN (has free tier with US servers)
echo "🌐 Installing Windscribe VPN..."
wget -q https://windscribe.com/install/desktop/linux_deb -O windscribe.deb

if [ -f "windscribe.deb" ]; then
    echo "📦 Installing Windscribe package..."
    sudo dpkg -i windscribe.deb
    sudo apt-get install -f -y
    
    echo "🔐 Windscribe installation complete!"
    echo ""
    echo "📝 NEXT STEPS:"
    echo "1. Create a free account at: https://windscribe.com/signup"
    echo "2. Then run: windscribe login"
    echo "3. Then run: windscribe connect US-Central"
    echo ""
else
    echo "❌ Windscribe download failed, trying alternative VPN..."
    
    # Alternative: Install ProtonVPN CLI
    echo "🔧 Installing ProtonVPN CLI..."
    sudo apt install -y openvpn dialog python3-pip
    sudo pip3 install protonvpn-cli
    
    echo "📝 ProtonVPN installed!"
    echo "Create account at: https://protonvpn.com/free-vpn"
fi

# Install OpenVPN configuration for free US servers
echo "🔧 Setting up free OpenVPN configurations..."
sudo mkdir -p /etc/openvpn/free-us-servers
cd /etc/openvpn/free-us-servers

# Download free VPN configurations (US servers)
echo "📥 Downloading free VPN configurations..."
sudo wget -q https://www.vpnbook.com/free-openvpn-account/vpnbook-openvpn-us1.zip
sudo wget -q https://www.vpnbook.com/free-openvpn-account/vpnbook-openvpn-us2.zip

# Extract configurations
sudo apt install -y unzip
sudo unzip -o vpnbook-openvpn-us1.zip -d us1/
sudo unzip -o vpnbook-openvpn-us2.zip -d us2/

echo "✅ VPN installation completed!"
echo ""
echo "🔌 Available VPN Options:"
echo "1. Windscribe (Recommended): windscribe connect US-Central"
echo "2. OpenVPN: sudo openvpn /etc/openvpn/free-us-servers/us1/vpnbook-us1-tcp443.ovpn"
echo "3. ProtonVPN: sudo protonvpn connect --cc US"
echo ""
echo "🚀 To test VPN connection: curl https://api.ipify.org"
