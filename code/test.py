import torch
from transformers import AutoModelForCausalLM, AutoTokenizer
from model import ModelClass

# 1️⃣ DistilGPT2 weight 저장 (이미 있다면 생략)
model_ref = AutoModelForCausalLM.from_pretrained("distilgpt2")
torch.save(model_ref.state_dict(), "torch.pt")

# 2️⃣ 모델 구조 로드
model = ModelClass()
state = torch.load("torch.pt", map_location="cpu")
model.load_state_dict(state, strict=False)  # strict=False → key mismatch 무시

# 3️⃣ 입력 토크나이즈
tokenizer = AutoTokenizer.from_pretrained("distilgpt2")
inputs = tokenizer("hello", return_tensors="pt")

# 4️⃣ 추론
out = model(inputs["input_ids"])
print(out)
print("======")

outputs = model.generate(
    **inputs,
    max_length=50,     # 생성할 문장 길이
    temperature=0.8,   # 창의성
    top_p=0.9,         # top-p 샘플링
    do_sample=True     # 랜덤 생성 활성화
)

response = tokenizer.decode(outputs[0], skip_special_tokens=True)
print(response)