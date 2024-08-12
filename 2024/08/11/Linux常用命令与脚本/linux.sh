#!/bin/bash

# 定义变量
UPDATE_SYSTEM=true
INSTALL_XRDP=true
INSTALL_XFCE=true
CONFIGURE_XRDP=true
RESTART_XRDP=true
ENABLE_XRDP=true
ALLOW_RDP=true

# 更新系统
if [ "$UPDATE_SYSTEM" = true ]; then
    sudo apt update && sudo apt upgrade -y
fi

# 安装XRDP
if [ "$INSTALL_XRDP" = true ]; then
    sudo apt install -y xrdp
fi

# 安装Xfce桌面环境
if [ "$INSTALL_XFCE" = true ]; then
    sudo apt install -y xfce4
fi

# 配置XRDP以使用Xfce
if [ "$CONFIGURE_XRDP" = true ]; then
    sudo sed -i 's/^test -x/#test -x/' /etc/xrdp/startwm.sh
    sudo bash -c 'echo "startxfce4" >> /etc/xrdp/startwm.sh'
fi

# 重新启动XRDP服务
if [ "$RESTART_XRDP" = true ]; then
    sudo systemctl restart xrdp
fi

# 启用XRDP自启动
if [ "$ENABLE_XRDP" = true ]; then
    sudo systemctl enable xrdp
fi

# 允许RDP连接通过防火墙
if [ "$ALLOW_RDP" = true ]; then
    sudo ufw allow 3389/tcp
fi

echo "XRDP installation and configuration completed."
