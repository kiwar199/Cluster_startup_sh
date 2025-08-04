#!/bin/bash
# supersetBI工具启停管理脚本
superset_status(){
result=`ps -ef | awk '/gunicorn/ && !/awk/{print $2}' |wc -l`
If [[ $result -eq 0 ]] ; then
return 0
 else 
return 1
fi
}

superset_start(){
source ~/.bashrc
superset_status >/dev/null 2>&1
if [[ $? -eq 0 ]]; then 
conda activate superset; gunicorn --workers 5 --timeout 120 --bind lakehouse04:8787 "superset.app:app_create()" --daemon
else
  echo "superset 正在运行"
fi
}

superset_stop(){
superset_status >/dev/null 2>&1
if [[ $? -eq 0 ]]; then 
 echo "superset 未运行"
else
  ps -ef | awk '/gunicorn/ && !/awk {print $2}' |xargs kill -9
fi
}

case $1 in 
   start) 
   echo "启动superset"
   superset_start
;;
   stop) 
   echo "停止superset"
   superset_stop
;;
restart) 
   echo "重启superset"
   superset_stop
   superset_start
;;
status) 
   superset_stauts>dev/null 2>&1
   if [[ $? -eq 0 ]] ; then
echo "superset 未运行"
else
echo "superset 正在运行"
fi
esac
