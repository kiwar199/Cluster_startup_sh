#!/bin/bash

case $1 in
"start"){
	for i in hadoop001 hadoop002 hadoop003
	do
        echo ---------- zookeeper $i 启动 ------------
		ssh $i "/opt/module/zookeeper/bin/zkServer.sh start"
	done
};;
"stop"){
	for i in hadoop001 hadoop002 hadoop003
	do
        echo ---------- zookeeper $i 停止 ------------    
		ssh $i "/opt/module/zookeeper/bin/zkServer.sh stop"
	done
};;
"status"){
	for i in hadoop001 hadoop002 hadoop003
	do
        echo ---------- zookeeper $i 状态 ------------    
		ssh $i "/opt/module/zookeeper/bin/zkServer.sh status"
	done
};;
esac
