from transformers import AutoModelForCausalLM
import torch

model = AutoModelForCausalLM.from_pretrained("distilgpt2")
torch.save(model.state_dict(), "torch.pt")
