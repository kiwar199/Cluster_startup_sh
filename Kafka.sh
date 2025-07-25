#! /bin/bash
if (($#==0)); then
  echo -e "请输入参数：\n start  启动kafka集群;\n stop  停止kafka集群;\n" && exit
fi

case $1 in
  "start")
    for host in lakehouse01 lakehouse02 lakehouse03
      do
        echo "---------- $1 $host 的kafka ----------"
        ssh $host "/opt/module/kafka/bin/kafka-server-start.sh -daemon /opt/module/kafka/config/server.properties"
      done
      ;;
  "stop")
    for host in lakehouse01 lakehouse02 lakehouse03
      do
        echo "---------- $1 $host 的kafka ----------"
        ssh $host "/opt/module/kafka/bin/kafka-server-stop.sh /opt/module/kafka/config/server.properties"
      done
      ;;
    *)
        echo -e "---------- 请输入正确的参数 ----------\n"
        echo -e "start  启动kafka集群;\n stop  停止kafka集群;\n" && exit
      ;;
esac
