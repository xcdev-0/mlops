# 모델 구조 정의
import torch
import torch.nn as nn
from transformers import GPT2Config, GPT2LMHeadModel


class ModelClass(nn.Module):
    """
    CPU 추론용 모델 클래스
    GPT2 기반 언어 모델을 래핑합니다.
    """
    
    def __init__(self):
        super().__init__()
        config = GPT2Config.from_pretrained("distilgpt2")
        self.model = GPT2LMHeadModel(config)
    
    def forward(self, input_ids):
        """
        Forward pass
        
        Args:
            input_ids: 입력 토큰 ID 텐서
        
        Returns:
            모델의 로짓 출력
        """
        return self.model(input_ids).logits
    
    def generate(self, **kwargs):
        """
        텍스트 생성
        
        Args:
            **kwargs: generate 메서드에 전달할 인자들
                - input_ids: 입력 토큰 ID
                - max_length: 최대 생성 길이
                - temperature: 생성 온도
                - 등등
        
        Returns:
            생성된 토큰 ID 텐서
        """
        return self.model.generate(**kwargs)

