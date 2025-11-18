#!/bin/bash
set -e

ACCOUNT_ID="972775291226"
REGION="ap-northeast-2"
REPO="llama2-inference"
TAG="v1"

IMAGE_URI="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${REPO}:${TAG}"

echo "=== Building Image on AWS GPU Node (native x86_64) ==="

aws ecr get-login-password --region ${REGION} \
| docker login --username AWS --password-stdin "${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com"

docker build -t ${IMAGE_URI} .
docker push ${IMAGE_URI}

echo "=== DONE ==="
echo "Image pushed: ${IMAGE_URI}"
