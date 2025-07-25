#! /bin/bash
if (($#==0)); then
  echo -e "请输入参数：\n start  启动doris集群;\n stop  停止doris集群;\n" && exit
fi

case $1 in
  "start")
    for host in lakehouse01 lakehouse02 lakehouse03
      do
        echo "----------启动 $1 $host 的doris FE&BE ----------"
        ssh $host "/opt/module/doris-2.1.10/fe/bin/start_fe.sh --daemon"  #启动fe节点
		ssh $host "/opt/module/doris-2.1.10/be/bin/start_be.sh --daemon"  #启动be节点
      done
      ;;
  "stop")
    for host in lakehouse01 lakehouse02 lakehouse03
      do
        echo "----------停止 $1 $host 的doris FE&BE ----------"
        ssh $host "/opt/module/doris-2.1.10/be/bin/stop_be.sh --daemon"   #停止be节点
		ssh $host "/opt/module/doris-2.1.10/fe/bin/stop_fe.sh --daemon"   #停止fe节点
      done
      ;;
    *)
        echo -e "---------- 请输入正确的参数 ----------\n"
        echo -e "start  启动kafka集群;\n stop  停止kafka集群;\n" && exit
      ;;
esac
