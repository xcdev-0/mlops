import torch
from fastapi import FastAPI, Request
import uvicorn
from transformers import AutoModelForCausalLM, AutoTokenizer, BitsAndBytesConfig

app = FastAPI()

# 4bit 양자화 config
quant_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_quant_type="nf4",
    bnb_4bit_compute_dtype=torch.float16,
)

# 모델 이름
model_name = "NousResearch/Llama-2-7b-chat-hf"

# 모델/토크나이저 로드
tokenizer = AutoTokenizer.from_pretrained(model_name, trust_remote_code=True)
model = AutoModelForCausalLM.from_pretrained(
    model_name,
    quantization_config=quant_config,
    device_map="auto"
)
model.eval()

@app.get("/")
async def healthcheck():
    return {"status": "healthy"}

@app.post("/inference")
async def inference(request: Request):
    data = await request.json()
    prompt = data.get("prompt", "")
    max_gen_len = data.get("max_gen_len", 256)

    inputs = tokenizer(prompt, return_tensors="pt").to("cuda")

    with torch.no_grad():
        outputs = model.generate(
            **inputs,
            max_length=max_gen_len,
            temperature=0.7,
            top_p=0.9,
        )

    text = tokenizer.decode(outputs[0], skip_special_tokens=True)
    return {"output": text}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8080)
