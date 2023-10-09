#!/bin/bash

# ScriptName：backup_sync.sh
# Desc：在多台服务器之间同步备份文件
# Author：mrbingzhao
# Date：2023-06-06

# 定义日期格式
DATE=$(date +%F)
# 备份目录路径
BAK_DIR="/mnt/disk2/BAK"
# 日志文件路径
LOG_FILE="/root/scripts/logs/backup_sync.log"
# 需要同步的服务器列表
SERVERS=("real1.uutv.com" "real2.uutv.com" "real3.uutv.com")
# 中间服务器
MIDDLE_SERVER="real3.uutv.com"

# 同步日志输出函数
log() {
  local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  echo "[$timestamp] $1"
  echo "[$timestamp] $1" >> "$LOG_FILE"
}

# 同步备份文件的函数
sync_backup_files() {
  local SOURCE_SERVER="$1"
  local DEST_SERVER="$2"

  log "开始从 $SOURCE_SERVER 同步备份文件到 ($DEST_SERVER)..."
  if [ "$SOURCE_SERVER" == "$MIDDLE_SERVER" ]; then
    # 如果源服务器是中间服务器，则直接同步到目标服务器
    log "开始从 $SOURCE_SERVER 同步备份文件到目标服务器($DEST_SERVER)..."
    rsync -a "$BAK_DIR/" "$DEST_SERVER:$BAK_DIR/" >> "$LOG_FILE" 2>&1
  else
    # 如果目标服务器是中间服务器，则直接同步到目标服务器
    if [ "$DEST_SERVER" == "$MIDDLE_SERVER" ]; then
      log "开始从 $SOURCE_SERVER 同步备份文件到目标服务器($DEST_SERVER)..."
      rsync -a "$SOURCE_SERVER:$BAK_DIR/" "$BAK_DIR/" >> "$LOG_FILE" 2>&1
    else
      # 否则，先同步到中间服务器，再从中间服务器同步到目标服务器
      log "开始从 $SOURCE_SERVER 同步备份文件到中间服务器($MIDDLE_SERVER)..."
      rsync -a "$SOURCE_SERVER:$BAK_DIR/" "$BAK_DIR/" >> "$LOG_FILE" 2>&1

      log "开始从中间服务器($MIDDLE_SERVER)同步备份文件到 $DEST_SERVER..."
      rsync -a "$BAK_DIR/" "$DEST_SERVER:$BAK_DIR/" >> "$LOG_FILE" 2>&1
    fi
  fi
  log "从 $SOURCE_SERVER 同步备份文件到 $DEST_SERVER 完成。"

}

# 清空日志文件
echo "" > "$LOG_FILE"

# 遍历服务器列表，并进行备份文件同步
for SOURCE_SERVER in "${SERVERS[@]}"; do
  for DEST_SERVER in "${SERVERS[@]}"; do
    # 如果源服务器和目标服务器相同，则跳过
    if [ "$SOURCE_SERVER" != "$DEST_SERVER" ]; then
      sync_backup_files "$SOURCE_SERVER" "$DEST_SERVER"
    fi
  done
done

