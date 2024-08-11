#!/bin/bash

# 升级系统
UPDATE_SYSTEM=true

# 安装常用软件
INSTALL_SOFTWARE=true

# 安装xfce4
INSTALL_XFCE=true

# 安装并配置远程桌面
INSTALL_XRDP=true

# 更新系统
if [ "$UPDATE_SYSTEM" = true ]; then
    sudo apt update && sudo apt upgrade -y
fi

# 安装常用软件
if [ "$INSTALL_SOFTWARE" = true ]; then
    sudo apt install -y vim   build-essential 
    sudo apt install -y git wget neofetch
fi

# 安装xfce4
if [ "$INSTALL_XFCE" = true ]; then
    sudo apt install -y xrdp xfce4
fi

# 安装并配置远程桌面
if [ "$INSTALL_XRDP" = true ]; then
    # Configure XRDP to use Xfce
    sudo sed -i 's/^test -x/#test -x/' /etc/xrdp/startwm.sh
    sudo bash -c 'echo "startxfce4" >> /etc/xrdp/startwm.sh'
    # Restart XRDP service
    sudo systemctl restart xrdp
    # Enable XRDP to start on boot
    sudo systemctl enable xrdp
    # Allow RDP connections through the firewall
    sudo ufw allow 3389/tcp
    echo "XRDP installation and configuration completed."
fi

# 
if [ "$INSTALL_TEXLIVE_FULL" = true ]; then
    sudo apt install texlive-full fonts-wqy-zenhei
fi