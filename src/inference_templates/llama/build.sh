#!/bin/bash
set -e

# ====== CONFIG ======
ACCOUNT_ID="972775291226"
REGION="ap-northeast-2"
REPO="llama2-inference"

IMAGE_TAG="v1"
IMAGE_URI="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${REPO}:${IMAGE_TAG}"

echo "=============================="
echo " 🚀 Building LLaMA2 GPU Image"
echo "=============================="

# ====== ECR 로그인 ======
echo "🔐 Logging into AWS ECR..."
aws ecr get-login-password --region ${REGION} \
  | docker login --username AWS \
    --password-stdin "${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com"

# ====== ECR 리포지토리 자동 생성 (없으면) ======
echo "📦 Checking ECR Repository..."
aws ecr describe-repositories --repository-names "${REPO}" \
  --region $REGION > /dev/null 2>&1 || \
aws ecr create-repository --repository-name "${REPO}" \
  --region $REGION > /dev/null

docker buildx build \
  --platform linux/amd64 \
  -t ${IMAGE_URI} \
  --push .


echo "===================================="
echo "✅ DONE! Image pushed to ECR:"
echo "👉 ${IMAGE_URI}"
echo "===================================="
