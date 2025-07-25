#!/bin/bash
# 查找日期小于某个时间日志文件，如：2025-05-20
hdfs dfs -ls -R /tmp/logs/root/bucket-logs-tfile | awk -v cutoff="2025-05-20" '{if ($6 <= cutoff && $7 ~ /^[0-9:]+$/) {print $8}}' > /tmp/to_delete_`date +%F`.txt

# 方式一
while IFS= read -r line; do
  echo "hdfs dfs -ls $line"
  # hdfs dfs -rm -r $line  # 删除hdfs日志文件
done < /tmp/to_delete_`date +%F`.txt


# 方式二
cat /tmp/to_delete_`date +%F`.txt | while IFS= read -r line; do
    echo "hdfs dfs -ls $line"
done


# 以下程序是一个完整的删除程序脚本。
#!/usr/bin/env bash
set -euo pipefail

# 配置参数
BASE_HDFS_DIR="/tmp/logs/root/bucket-logs-tfile"
START_NUM=336
END_NUM=345
DRY_RUN=false

# 使用方法
usage() {
    echo "用法: $0 [选项]"
    echo "选项:"
    echo "  -d, --dry-run    试运行（只显示不会实际删除）"
    echo "  -h, --help       显示帮助信息"
    exit 1
}

# 解析参数
while [[ $# -gt 0 ]]; do
    case "$1" in
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "未知参数: $1"
            usage
            ;;
    esac
done

# 删除操作函数
delete_directories() {
    local total=$((END_NUM - START_NUM + 1))
    local current=0
    
    for ((num=START_NUM; num<=END_NUM; num++)); do
        ((current++))
        dir_name=$(printf "%04d" "$num")
        hdfs_dir="${BASE_HDFS_DIR}/${dir_name}"
        
        echo -n "[${current}/${total}] 处理 ${hdfs_dir} ... "
        
        if hdfs dfs -test -d "${hdfs_dir}" 2>/dev/null; then
            if [[ "$DRY_RUN" == true ]]; then
                echo "试运行（目录存在，跳过删除）"
            else
                if hdfs dfs -rm -r "${hdfs_dir}" 2>/dev/null; then
                    echo "删除成功"
                else
                    echo "删除失败！"
                    exit 1
                fi
            fi
        else
            echo "目录不存在，跳过"
        fi
    done
}

# 用户确认
echo "即将操作的HDFS路径：${BASE_HDFS_DIR}"
echo "操作范围：${START_NUM} 到 ${END_NUM}（共 $((END_NUM - START_NUM + 1)) 个目录）"
if [[ "$DRY_RUN" == true ]]; then
    echo "模式：试运行（不执行实际删除）"
else
    echo "模式：实际删除"
fi

read -rp "确认要继续吗？(y/N) " answer
case "${answer}" in
    [yY]|[yY][eE][sS])
        delete_directories
        ;;
    *)
        echo "操作已取消"
        exit 0
        ;;
esac

echo "所有操作完成"