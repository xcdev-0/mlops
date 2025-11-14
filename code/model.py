import torch
import torch.nn as nn
from transformers import GPT2Config, GPT2LMHeadModel

class ModelClass(nn.Module):
    def __init__(self):
        super().__init__()
        config = GPT2Config.from_pretrained("distilgpt2")
        self.model = GPT2LMHeadModel(config)

    def forward(self, input_ids):
        return self.model(input_ids).logits

    def generate(self, **kwargs):
        return self.model.generate(**kwargs)
