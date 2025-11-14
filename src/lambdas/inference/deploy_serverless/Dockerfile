FROM public.ecr.aws/lambda/python:3.12

# Terraform binary + provider + lock 파일을 전부 /var/task 에 복사
COPY ./files/ ${LAMBDA_TASK_ROOT}/

# Python dependencies
COPY requirements.txt ${LAMBDA_TASK_ROOT}/
RUN pip install -r requirements.txt

# Git 등 유틸 설치 (필요 시)
RUN dnf install -y git && dnf clean all

# Lambda handler
COPY lambda.py ${LAMBDA_TASK_ROOT}/
COPY main.tf ${LAMBDA_TASK_ROOT}/   # 필요하다면 유지 / files에 이미 있으면 제거 가능

# Terraform 실행 권한 부여
RUN chmod +x /var/task/terraform

CMD ["lambda.handler"]
