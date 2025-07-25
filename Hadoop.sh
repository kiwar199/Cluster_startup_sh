#!/bin/bash
if [ $# -lt 1 ]
then
    echo "No Args Input..."
    exit ;
fi
case $1 in
"start")
        echo " =================== 启动 hadoop集群 ==================="

        echo " --------------- 启动 hdfs 服务---------------"
        ssh lakehouse01 "/opt/module/hadoop-3.4.0/sbin/start-dfs.sh"
        echo " --------------- 启动 historyserver 服务---------------"
        ssh lakehouse01 "/opt/module/hadoop-3.4.0/bin/mapred --daemon start historyserver"
	echo " --------------- 启动 yarn 服务 resourcemanager nodemanager---------------"
        ssh lakehouse02 "/opt/module/hadoop-3.4.0/sbin/start-yarn.sh"
;;
"stop")
        echo " =================== 关闭 hadoop集群 ==================="

        echo " --------------- 关闭 historyserver ---------------"
        ssh lakehouse01 "/opt/module/hadoop-3.4.0/bin/mapred --daemon stop historyserver"
	    echo " --------------- 关闭 yarn 服务 ---------------"
        ssh lakehouse02 "/opt/module/hadoop-3.4.0/sbin/stop-yarn.sh"
        echo " --------------- 关闭 hdfs 服务---------------"
        ssh lakehouse01 "/opt/module/hadoop-3.4.0/sbin/stop-hdfs.sh"

;;
*)
    echo "Input Args Error..."
;;
esac
