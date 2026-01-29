#!/bin/bash
# 加载在 after_install.sh 中生成的环境变量（包含 FULL_IMAGE 变量）
source /opt/app/java_env.file

echo "Stopping old container..."
docker stop cool-java || true
docker rm cool-java || true

echo "Starting new container on port 8001..."
# [重要] 端口映射必须是 8001:8001
docker run -d \
  --name cool-java \
  --restart unless-stopped \
  -p 8001:8001 \
  -e TZ=Asia/Shanghai \
  $FULL_IMAGE

echo "Deployment finished!"