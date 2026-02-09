#!/bin/bash
set -e

# 从 CodeDeploy 传入的描述中解析 IMAGE_TAG
DESCRIPTION=$(aws deploy get-deployment --deployment-id $DEPLOYMENT_ID --query 'deploymentInfo.description' --output text)
IMAGE_TAG=$(echo $DESCRIPTION | cut -d'=' -f2)

# 获取 AWS 账户信息和区域
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
REGION="us-east-2" # 如果你的区不是 us-east-2，请修改此处
ECR_URL="$AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com"
# [注意] 这里的仓库名必须和你 ECR 创建的名字完全一致
REPO_NAME="cool-admin-java" 

echo "Logging in to ECR..."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_URL

echo "Pulling image: $ECR_URL/$REPO_NAME:$IMAGE_TAG"
docker pull $ECR_URL/$REPO_NAME:$IMAGE_TAG

# 写入配置文件供 start.sh 使用
echo "FULL_IMAGE=$ECR_URL/$REPO_NAME:$IMAGE_TAG" > /opt/app/java_env.file

# [针对免费套餐的建议] 删除旧的无用镜像，释放 t2.micro 的磁盘空间
docker image prune -af  