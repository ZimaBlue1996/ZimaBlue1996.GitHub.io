#!/bin/bash

# 更新软件包列表
sudo apt-get update

# 安装NFS服务器
echo "安装NFS服务器..."
sudo apt-get install -y nfs-kernel-server

# 安装TFTP服务器和TFTP客户端
echo "安装TFTP服务器和客户端..."
sudo apt-get install -y tftpd-hpa tftp-hpa

# 配置NFS服务器
echo "配置NFS服务器..."

# 定义要共享的目录和访问权限
NFS_EXPORT_DIR="/srv/nfs"
CLIENT_IP="192.168.1.0/24"  # 修改为你的客户端IP范围

# 创建NFS共享目录
sudo mkdir -p $NFS_EXPORT_DIR
sudo chown nobody:nogroup $NFS_EXPORT_DIR
sudo chmod 755 $NFS_EXPORT_DIR

# 添加NFS共享配置到 /etc/exports
echo "$NFS_EXPORT_DIR $CLIENT_IP(rw,sync,no_subtree_check)" | sudo tee -a /etc/exports

# 重新导出NFS目录
sudo exportfs -a

# 启动NFS服务器
sudo systemctl restart nfs-kernel-server

# 确保NFS服务器在启动时自动启动
sudo systemctl enable nfs-kernel-server

# 配置TFTP服务器
echo "配置TFTP服务器..."

# 定义TFTP根目录
TFTP_ROOT_DIR="/srv/tftp"

# 创建TFTP根目录
sudo mkdir -p $TFTP_ROOT_DIR
sudo chown -R tftp:tftp $TFTP_ROOT_DIR
sudo chmod -R 755 $TFTP_ROOT_DIR

# 修改TFTP配置文件 /etc/default/tftpd-hpa
sudo tee /etc/default/tftpd-hpa <<EOF
TFTP_USERNAME="tftp"
TFTP_DIRECTORY="$TFTP_ROOT_DIR"
TFTP_ADDRESS="0.0.0.0:69"
TFTP_OPTIONS="--secure"
EOF

# 启动TFTP服务器
sudo systemctl restart tftpd-hpa

# 确保TFTP服务器在启动时自动启动
sudo systemctl enable tftpd-hpa

# 打印服务状态
echo "NFS和TFTP服务状态:"
sudo systemctl status nfs-kernel-server
sudo systemctl status tftpd-hpa

echo "NFS和TFTP服务安装和配置完成。"

# 提示用户重启系统
echo "建议重启系统以确保所有配置生效。"
