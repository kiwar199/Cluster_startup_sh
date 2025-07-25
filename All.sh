#!/bin/bash
if [ $# -lt 1 ]
then
  echo Not Enough Arguement!
  exit;
fi
case $1 in
"start")
        echo " =================== 启动集群 ==================="
        echo " --------------- 启动zookeeper集群 ---------------"
        ssh hadoop001 "/root/bin/zk.sh start"

        echo " --------------- 启动hadoop集群 ---------------"
        ssh hadoop001 "/root/bin/hdp.sh start"
	
        echo " --------------- 启动mysql元数据服务 ---------------"
        ssh hadoop001 "service mysql start"
	
	echo " --------------- 启动 hive服务 ---------------"
        ssh hadoop001 "/root/bin/hiveservices.sh start"
        ssh hadoop002 "/root/bin/hiveservices.sh start"
        ssh hadoop003 "/root/bin/hiveservices.sh start"

	echo " --------------- 启动kafka服务 ---------------"
        ssh hadoop001 "/root/bin/kafka.sh start"

	echo " --------------- 启动 presto服务 ---------------"
        ssh hadoop001 "/opt/module/presto/bin/launcher start"
        ssh hadoop002 "/opt/module/presto/bin/launcher start"
        ssh hadoop003 "/opt/module/presto/bin/launcher start"

	echo " --------------- 启动superset ---------------"
        ssh hadoop002 "conda activate superset" 
	    ssh hadoop002 "export FLASK_APP=superset"
        ssh hadoop002 "export SUPERSET_SECRET_KEY=“oh-so-secret”"
        ssh hadoop002 "superset init"
        ssh hadoop002 "/root/bin/superset.sh start"

	echo " --------------- 启动streampark ---------------"
        ssh hadoop003 "/opt/module/streampark/bin/startup.sh" 
		ssh hadoop003 "cp /opt/module/streampark_bak/client_bak/streampark-flink-sqlclient_2.12-2.1.2.jar  /opt/module/streampark/client/" 

	echo " --------------- 启动hue ---------------"
        ssh hadoop003 "conda activate hue"
        ssh hadoop003 "docker start hue"
;;
"stop")

	echo " --------------- 关闭hue ---------------"
        ssh hadoop003 "docker stop hue"

	echo " --------------- 关闭streampark ---------------"
        ssh hadoop003 "/opt/module/streampark/bin/shutdown.sh" 

	echo " --------------- 关闭superset ---------------"
        ssh hadoop002 "/root/bin/superset.sh stop"

	echo " --------------- 关闭 hive服务 ---------------"
        ssh hadoop001 "/root/bin/hiveservices.sh stop"
        ssh hadoop002 "/root/bin/hiveservices.sh stop"
        ssh hadoop003 "/root/bin/hiveservices.sh stop"

	echo " --------------- 关闭kafka服务 ---------------"
        ssh hadoop001 "/root/bin/kafka.sh stop"

        echo " =================== 关闭 hadoop集群 ==================="

        echo " --------------- 关闭 historyserver ---------------"
        ssh hadoop001 "/opt/module/hadoop-3.4.0/bin/mapred --daemon stop historyserver"
        echo " --------------- 关闭 hdfs 和 yarn ---------------"
        ssh hadoop001 "/opt/module/hadoop-3.4.0/sbin/stop-all.sh"
		#停止ResourceManager服务：yarn --daemon stop resourcemanager
		#停止NodeManager服务：yarn --daemon stop nodemanager
	echo " --------------- 关闭 httpfs服务 ---------------"
        ssh hadoop001 "/opt/module/hadoop-3.4.0/sbin/httpfs.sh stop"

	echo " --------------- 启动 presto服务 ---------------"
        ssh hadoop001 "/opt/module/presto/bin/launcher stop"
        ssh hadoop002 "/opt/module/presto/bin/launcher stop"
        ssh hadoop003 "/opt/module/presto/bin/launcher stop"

        echo " --------------- 关闭mysql元数据服务 ---------------"
        ssh hadoop001 "service mysql stop"

        echo " --------------- 关闭zookeeper集群 ---------------"
        ssh hadoop001 "/root/bin/zk.sh stop"
;;
*)
    echo "Input Args Error..."
;;
esac
