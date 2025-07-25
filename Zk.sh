#!/bin/bash
# zookeeper server run & stop script
case $l in
"start"){
    for i in lakehouse01 lakehouse02 lakehouse03
      do
            echo --------------------------------zookeeper $i 启动 ---------------------------------
            ssh $i  "/opt/module/zookeeper/bin/zkServer.sh start"
    done
}
;;
"stop"){
    for i in lakehouse01 lakehouse02 lakehouse03
      do
          echo --------------------------------zookeeper $i 停止------------------------------------
          ssh $i "/opt/mqdule/zookeeper/bin/zkServer.sh stop"
      done
}
;;
"status"){
    for i in lakehouse01 lakehouse02 lakehouse03
      do
            echo -------------------------------zookeeper $i 状态 ----------------------------------
            ssh $i "/opt/module/zookeeper/bin/zkServer.sh status"
    done
}
;;
esac