#!/bin/bash
set -e

echo "🔥 Creating Linux/x86_64 Terraform environment..."

# 작업 디렉토리
TARGET_DIR="terraform_init"
rm -rf $TARGET_DIR
mkdir -p $TARGET_DIR
chmod -R 777 terraform_init

# main.tf 생성
cat <<EOF > $TARGET_DIR/main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}
EOF

echo "📌 main.tf created."

echo "🐳 Running Terraform init in Docker (Linux/x86_64)..."
docker run --platform=linux/amd64 --rm -it \
  -v $(pwd)/$TARGET_DIR:/tf \
  -w /tf \
  hashicorp/terraform \
  init -input=false


echo "📝 Copying Terraform binary from Docker image..."
docker run --platform=linux/amd64 --rm \
  -v $(pwd)/$TARGET_DIR:/out \
  hashicorp/terraform \
  cp /bin/terraform /out/terraform

chmod +x $TARGET_DIR/terraform

echo "✅ DONE!"
echo "--------------------------------------------"
echo "Terraform Linux version ready at:"
echo "  $TARGET_DIR/.terraform/"
echo "  $TARGET_DIR/.terraform.lock.hcl"
echo "  $TARGET_DIR/terraform"
echo "--------------------------------------------"
