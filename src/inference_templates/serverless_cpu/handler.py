import os
import sys
import pickle
import torch
import base64
import shutil
import json
import subprocess

# ------------------------------------------------------
# 1) 환경 변수 설정
# ------------------------------------------------------
MODEL_S3_URL = os.getenv('MODEL_S3_URL')

# ZIP 파일명 (/tmp 안에 저장될 파일)
zip_filename = MODEL_S3_URL.split('/')[-1]
zip_path = f"/tmp/{zip_filename}"

# 모델이 풀릴 디렉토리
model_dir = "/tmp/model"

# PyTorch 가중치 파일 경로 (state_dict)
weights_path = f"{model_dir}/torch.pt"

# 런타임에 메모리로 유지할 모델 객체
model = None
initialized = False


# ------------------------------------------------------
# 2) 모델 초기화 함수 (cold start 때 1번만 실행)
# ------------------------------------------------------
def init_model():
    global initialized, model

    if initialized:
        return

    os.makedirs("/tmp", exist_ok=True)

    # --------------------------------------------------
    # (A) ZIP 파일이 없으면 S3에서 다운로드
    # --------------------------------------------------
    if not os.path.exists(zip_path):
        try:
            print(f"[Lambda] Downloading model zip from {MODEL_S3_URL}")
            subprocess.run(
                ["wget", "-q", MODEL_S3_URL, "-O", zip_path],
                check=True
            )
        except Exception as e:
            print(f"[Error] Failed to download model zip: {e}")
            raise

    # --------------------------------------------------
    # (B) /tmp/model 폴더 초기화 (항상 clean 상태 보장)
    # --------------------------------------------------
    if os.path.exists(model_dir):
        shutil.rmtree(model_dir)
    os.makedirs(model_dir)

    # --------------------------------------------------
    # (C) ZIP 압축 해제 → model.py / torch.pt 복원
    # --------------------------------------------------
    try:
        subprocess.run(["unzip", "-o", zip_path, "-d", model_dir], check=True)
    except Exception as e:
        print(f"[Error] Failed to unzip model zip: {e}")
        raise

    # --------------------------------------------------
    # (D) model.py 동적 import
    # --------------------------------------------------
    sys.path.append(model_dir)
    from model import ModelClass

    # --------------------------------------------------
    # (E) 가중치(state_dict) 로드
    # --------------------------------------------------
    try:
        model = ModelClass()
        state_dict = torch.load(weights_path, map_location="cpu")

        # DataParallel로 학습된 경우 key 변경
        first_key = list(state_dict.keys())[0]
        if first_key.startswith("module."):
            from collections import OrderedDict
            new_state_dict = OrderedDict(
                (k.replace("module.", ""), v) for k, v in state_dict.items()
            )
            state_dict = new_state_dict

        model.load_state_dict(state_dict)
        model.eval()

    except Exception as e:
        print(f"[Error] Failed to load model weights: {e}")
        raise

    initialized = True
    print("[Lambda] Model initialized successfully.")


# ------------------------------------------------------
# 3) Lambda Handler
# ------------------------------------------------------
def handler(event, context):
    
    # ---- body 읽기 ----
    body = event.get("body")

    if body is None:
        return {
            "statusCode": 400,
            "body": json.dumps({"error": "Missing body"})
        }

    # body가 dict인지 문자열인지 자동 처리
    if isinstance(body, dict):
        # 이미 파싱된 상태
        encoded_data = body
    else:
        try:
            encoded_data = json.loads(body)
        except Exception as e:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Decode failed", "message": str(e)})
            }

    # ---- base64 decode ----
    try:
        decoded_data = base64.b64decode(encoded_data["body"])
        input_data = pickle.loads(decoded_data)
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": "Deserialization failed", "message": str(e)})
        }

    # ---- inference ----
    with torch.no_grad():
        output = model(input_data)

    # ---- encode back ----
    encoded_out = base64.b64encode(pickle.dumps(output)).decode()

    return {
        "statusCode": 200,
        "body": json.dumps({"body": encoded_out})
    }
