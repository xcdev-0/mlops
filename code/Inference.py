from transformers import AutoModelForCausalLM, AutoTokenizer
import torch

tokenizer = AutoTokenizer.from_pretrained("sshleifer/tiny-gpt2")
model = AutoModelForCausalLM.from_pretrained("sshleifer/tiny-gpt2", torch_dtype=torch.float16)

prompt = "User: How are you?\nAssistant:"
inputs = tokenizer(prompt, return_tensors="pt")

outputs = model.generate(**inputs, max_length=30, use_cache=False)
print(tokenizer.decode(outputs[0], skip_special_tokens=True))
