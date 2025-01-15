#!/bin/bash

# 目标 IP 地址
TARGET_IP="$1"

# 监控间隔时间（秒）
MONITOR_INTERVAL=10

# 使用 ping 检查连通性
if ping -c 5  -W 1 "$TARGET_IP" > /dev/null; then
        echo "$(date): Ping to $TARGET_IP successful."
    else
        echo "$(date): Ping to $TARGET_IP failed."
        echo "$(date): Restarting $2 service..."
        sudo systemctl restart $2
fi

# 等待一段时间后继续监控
sleep "$MONITOR_INTERVAL"
