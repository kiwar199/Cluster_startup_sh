#!/bin/bash
# 停止旧进程
kill $(jps | grep RunJar | awk '{print $1}') 2>/dev/null

# 启动 Metastore
nohup hive --service metastore >$HIVE_HOME/logs/metastore.log 2>&1 &
sleep 10  # 等待初始化

# 启动 HiveServer2
nohup hiveserver2 >$HIVE_HOME/logs/hiveserver2.log 2>&1 &
sleep 15  # 等待启动

# 验证端口
netstat -ltpn | grep 10000