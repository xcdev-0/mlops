#!/bin/bash
set -e

ACCOUNT_ID="972775291226"
REGION="ap-northeast-2"
REPO="gennie-serverless-inference"

IMAGE_URI="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${REPO}:v2"

echo "🔐 Logging in to ECR..."
aws ecr get-login-password --region $REGION \
  | docker login --username AWS --password-stdin "${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com"

aws ecr get-login-password --region ap-northeast-2 \
  | docker login --username AWS \
    --password-stdin 763104351884.dkr.ecr.ap-northeast-2.amazonaws.com

echo "🐳 Building image: $IMAGE_URI"
docker buildx build --platform linux/amd64 -t $IMAGE_URI --push .


echo "✅ Done: $IMAGE_URI"
