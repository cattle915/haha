#!/bin/bash

# 目标 IP 地址
TARGET_IP="$1"

# 监控间隔时间（秒）
MONITOR_INTERVAL=10

# 最大失败次数
MAX_FAILURES=3

# 失败计数器
fail_count=0

while true; do
    # 使用 ping 检查连通性
    if ping -c 1 -W 1 "$TARGET_IP" > /dev/null; then
        echo "$(date): Ping to $TARGET_IP successful."
        fail_count=0  # 重置失败计数器
    else
        echo "$(date): Ping to $TARGET_IP failed."
        fail_count=$((fail_count + 1))  # 增加失败计数器

        # 如果失败次数达到最大值，则重启 zerotier 服务
        if [[ $fail_count -ge $MAX_FAILURES ]]; then
            echo "$(date): Restarting $2 service..."
            sudo systemctl restart $2

            # 重置失败计数器
            fail_count=0
        fi
    fi

    # 等待一段时间后继续监控
    sleep "$MONITOR_INTERVAL"
done
