import requests
import pickle
import base64
import json
import torch

LAMBDA_URL = "https://nrgrmntdr3wgjerf4z6sgvr2hi0qzzpw.lambda-url.ap-northeast-2.on.aws/"

tensor_input = torch.randn(1, 512)

pickled = pickle.dumps(tensor_input)
encoded = base64.b64encode(pickled).decode("utf-8")

payload = {"body": encoded}

resp = requests.post(
    LAMBDA_URL,
    data=json.dumps(payload),
    headers={"Content-Type": "application/json"}   # ⭐ MUST HAVE ⭐
)

print("status:", resp.status_code)
print("response:", resp.text)

try:
    body = resp.json()["body"]
    decoded = base64.b64decode(body)
    output = pickle.loads(decoded)
    print("Model Output:", output)
except Exception as e:
    print("Decode error:", e)
