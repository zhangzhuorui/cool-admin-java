#!/bin/bash

# 定义容器名称（必须与 start.sh 中的 --name 保持一致）
CONTAINER_NAME="cool-java"

echo "=========================================="
echo "Stopping ApplicationStop hook..."
echo "=========================================="

# 检查容器是否存在并运行
if [ "$(docker ps -aq -f name=${CONTAINER_NAME})" ]; then
    echo "Found container: ${CONTAINER_NAME}. Stopping and removing..."
    
    # 停止容器（等待10秒优雅关闭）
    docker stop ${CONTAINER_NAME} || true
    
    # 删除容器
    docker rm ${CONTAINER_NAME} || true
    
    echo "Container ${CONTAINER_NAME} has been cleaned up."
else
    echo "No running container found with name: ${CONTAINER_NAME}. Skipping."
fi

# [针对免费套餐的额外清理]
# 顺便清理掉那些状态为 'exited' (已退出) 的孤儿容器，释放一点点内存和磁盘
docker container prune -f || true

echo "Stop script completed successfully."