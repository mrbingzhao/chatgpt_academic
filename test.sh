#!/bin/bash

# 获取主机名
HOSTNAME=$(hostname)
# 日期格式
DATE=$(date +%F)
# 目标目录路径
DEST_DIR="/mnt/disk2/BAK"
# 目标目录路径包含主机名
DEST="$DEST_DIR/$HOSTNAME"

# 备份文件函数
backup_files() {
  local SOURCE_FILES=("$@")  # 接收传递的文件路径数组参数

  # 创建目标目录
  mkdir -p "$2"

  # 备份文件
  for SRC in "${SOURCE_FILES[@]}"; do
    rsync -avzlP "$SRC" "$2/$DATE"
  done
}

# srs备份源文件路径
SRS_FILES=(
  "/usr/local/srs/conf/srs.conf*"
  "/usr/local/srs/objs/*.sh"
  "/usr/local/srs/objs/ffmpeg"
)
# nginx备份源文件路径
NGINX_FILES=(
  "/etc/nginx/nginx.conf"
  "/etc/nginx/conf.d"
  "/etc/nginx/default.d"
)
# uu用户备份文件路径
UU_FILES=(
  "/home/uuwatch/"
)

# 备份srs文件
backup_files "${SRS_FILES[@]}" "$DEST/srs_bak"

# 备份nginx文件
backup_files "${NGINX_FILES[@]}" "$DEST/nginx_bak"

# 备份uu用户文件
backup_files "${UU_FILES[@]}" "$DEST/uu_bak"
