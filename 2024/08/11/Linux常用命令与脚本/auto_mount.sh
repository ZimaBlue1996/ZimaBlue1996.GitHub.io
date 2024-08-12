#!/bin/bash

# 检查是否具有超级用户权限
if [ "$EUID" -ne 0 ]; then
  echo "请以超级用户权限运行该脚本"
  exit 1
fi

# 获取所有未挂载的磁盘分区
unmounted_disks=$(lsblk -nr -o NAME,MOUNTPOINT | awk '$2 == "" {print "/dev/" $1}')

# 遍历所有未挂载的磁盘分区
for disk in $unmounted_disks; do
  # 确定文件系统类型
  fs_type=$(blkid -o value -s TYPE $disk)
  
  if [ -z "$fs_type" ]; then
    echo "无法确定 $disk 的文件系统类型，跳过"
    continue
  fi

  # 创建挂载点目录
  mount_point="/mnt/$(basename $disk)"
  mkdir -p $mount_point

  # 检查是否已经在 /etc/fstab 中
  if grep -q "$disk" /etc/fstab; then
    echo "$disk 已存在于 /etc/fstab 中，跳过"
    continue
  fi

  # 添加到 /etc/fstab
  echo "$disk    $mount_point    $fs_type    defaults,nofail    0    2" >> /etc/fstab
  echo "已将 $disk 添加到 /etc/fstab 中，将挂载点设置为 $mount_point"

  # 挂载分区
  mount $mount_point
done

echo "脚本执行完毕"
