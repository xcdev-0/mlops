FROM public.ecr.aws/lambda/python:3.12

RUN dnf install -y unzip wget && dnf clean all

# PyTorch CPU 버전을 먼저 설치 (Lambda는 CPU만 사용)
RUN pip install --no-cache-dir --index-url https://download.pytorch.org/whl/cpu torch==2.2.0

# 나머지 패키지 설치 (torch 제외)
COPY requirements.txt ${LAMBDA_TASK_ROOT}/requirements.txt
RUN pip install --no-cache-dir -r ${LAMBDA_TASK_ROOT}/requirements.txt || true

COPY handler.py ${LAMBDA_TASK_ROOT}/handler.py

CMD ["handler.handler"]
