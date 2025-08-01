#!/bin/bash
#集群文件分发工具
# 判断断参数个数
if [ $# -lt 1 ]
then
    echo Not Enough Arguement!
    exit;
fi
# 遍历集群所有机器
for host in hadoop102 hadoop103 hadoop104
do
    echo ======================== $host ===================================
    # 遍历所有目录，挨个发送
    for file in $@
        do
            # 判断文件是否存在
            if [ -e $file ]
               then
                  # 获取父目录
                   pdir=$(cd -P $(dirname $file); pwd)
                  # 获取当前文件的名称
                  fname=$(basename $file)
                  ssh $host "mkdir -p $pdir"
                  rsync -av $pdir/$fname $host:$pdir
              else
                  echo $file does not exists!
          fi
      done
done

