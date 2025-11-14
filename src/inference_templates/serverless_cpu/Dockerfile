# Serverless CPU 추론용 Lambda 컨테이너 이미지
FROM public.ecr.aws/lambda/python:3.11

# 작업 디렉토리 설정
WORKDIR ${LAMBDA_TASK_ROOT}

# 의존성 파일 복사
COPY requirements.txt ${LAMBDA_TASK_ROOT}

# Python 패키지 설치
RUN pip install --no-cache-dir -r requirements.txt

# 애플리케이션 코드 복사
COPY lambda_app.py ${LAMBDA_TASK_ROOT}
COPY model.py ${LAMBDA_TASK_ROOT}

# Lambda 핸들러 지정
CMD [ "lambda_app.handler" ]

