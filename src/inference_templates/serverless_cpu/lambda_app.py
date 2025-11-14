# Serverless CPU 추론용 Lambda 핸들러
import json
import os
import boto3
import logging
from typing import Dict, Any
import torch
from model import ModelClass

# 로깅 설정
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# S3 클라이언트 초기화
s3_client = boto3.client('s3')

# 전역 변수로 모델 캐싱 (Cold start 최적화)
model = None
device = torch.device('cpu')


def load_model_from_s3(s3_url: str) -> ModelClass:
    """
    S3에서 모델 파일을 다운로드하고 로드합니다.
    
    Args:
        s3_url: S3 URL (예: s3://bucket-name/path/to/model.pt)
    
    Returns:
        로드된 모델 인스턴스
    """
    try:
        # S3 URL 파싱
        if not s3_url.startswith('s3://'):
            raise ValueError(f"Invalid S3 URL: {s3_url}")
        
        s3_path = s3_url[5:]  # 's3://' 제거
        bucket_name, key = s3_path.split('/', 1)
        
        # 로컬 임시 파일 경로
        local_model_path = '/tmp/model.pt'
        
        # S3에서 모델 다운로드
        logger.info(f"Downloading model from s3://{bucket_name}/{key}")
        s3_client.download_file(bucket_name, key, local_model_path)
        
        # 모델 로드
        logger.info("Loading model...")
        model = ModelClass()
        model.load_state_dict(torch.load(local_model_path, map_location=device))
        model.to(device)
        model.eval()
        
        logger.info("Model loaded successfully")
        return model
        
    except Exception as e:
        logger.error(f"Error loading model from S3: {str(e)}")
        raise


def initialize_model():
    """모델을 초기화합니다 (Cold start 시 한 번만 실행)"""
    global model
    
    if model is None:
        model_s3_url = os.environ.get('MODEL_S3_URL')
        if not model_s3_url:
            raise ValueError("MODEL_S3_URL environment variable is not set")
        
        model = load_model_from_s3(model_s3_url)
    
    return model


def handler(event: Dict[str, Any], context: Any) -> Dict[str, Any]:
    """
    Lambda 핸들러 함수
    
    Args:
        event: Lambda 이벤트 데이터
        context: Lambda 컨텍스트
    
    Returns:
        추론 결과를 포함한 응답
    """
    try:
        # 모델 초기화 (첫 호출 시에만 로드)
        model = initialize_model()
        
        # 요청 데이터 파싱
        if isinstance(event.get('body'), str):
            body = json.loads(event['body'])
        else:
            body = event.get('body', event)
        
        # 입력 데이터 추출
        input_text = body.get('input', body.get('prompt', ''))
        max_length = body.get('max_length', 50)
        temperature = body.get('temperature', 1.0)
        
        if not input_text:
            return {
                'statusCode': 400,
                'body': json.dumps({
                    'error': 'Input text is required. Provide "input" or "prompt" in request body.'
                })
            }
        
        # 추론 수행
        logger.info(f"Processing inference request: input_length={len(input_text)}")
        
        with torch.no_grad():
            # 여기서는 간단한 예시로, 실제로는 tokenizer가 필요할 수 있습니다
            # 실제 사용 시에는 tokenizer도 함께 로드해야 합니다
            result = {
                'input': input_text,
                'output': 'Model inference completed',  # 실제 추론 로직으로 대체 필요
                'max_length': max_length,
                'temperature': temperature
            }
        
        # 응답 반환
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'success': True,
                'result': result
            })
        }
        
    except Exception as e:
        logger.error(f"Error in handler: {str(e)}", exc_info=True)
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'success': False,
                'error': str(e)
            })
        }

