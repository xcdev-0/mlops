# Capstone 2024-12 Project

ML/AI 인프라 프로젝트

## 프로젝트 구조

```
capstone-2024-12/
├── infra/                                  # 모든 IaC(Terraform) 관련
│   ├── modules/                            # 공통 재사용 모듈
│   │   ├── eks_cluster/                    # EKS 생성 모듈
│   │   ├── lambda_template/                # Lambda 생성 템플릿 (serverless_api_template 대체)
│   │   ├── s3_web/                         # S3 + CloudFront 배포용 모듈
│   │   └── db_api/                         # DynamoDB + Lambda + API Gateway 모듈
│   │
│   ├── services/                           # 각 기능별 IaC
│   │   ├── inference/                      # 추론 관련
│   │   │   ├── llama_inference.tf
│   │   │   ├── diffusion_inference.tf
│   │   │   ├── kubernetes_inference.tf
│   │   │   └── serverless_inference.tf
│   │   ├── training/                       # 학습 관련
│   │   │   ├── llama_train.tf
│   │   │   ├── diffusion_train.tf
│   │   │   └── ray_cluster.tf
│   │   ├── monitoring/                     # 모델 프로파일링, 추천 등
│   │   │   ├── model_profiler.tf
│   │   │   └── recommend_family.tf
│   │   ├── frontend/                       # 웹, streamlit
│   │   │   ├── s3_web.tf
│   │   │   ├── streamlit.tf
│   │   └── nodepool/                       # Karpenter node pool 관리
│   │       └── karpenter_nodepool.tf
│   │
│   ├── main.tf                             # 전체 orchestration
│   ├── provider.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── backend.tf                          # terraform state bucket 정의
│
├── src/                                    # 코드 실행 로직 (Lambda, EKS 등)
│   ├── lambdas/                            # Lambda용 실행 코드
│   │   ├── inference/                      # 추론 배포용 Lambda 코드
│   │   │   ├── handler_llama.py
│   │   │   ├── handler_diffusion.py
│   │   │   ├── handler_kubernetes.py
│   │   │   └── handler_serverless.py
│   │   ├── train/                          # 학습 배포용 Lambda 코드
│   │   │   ├── handler_llama_train.py
│   │   │   ├── handler_diffusion_train.py
│   │   │   └── handler_ray.py
│   │   ├── db_api/handler_db.py
│   │   ├── nodepool/handler_nodepool.py
│   │   └── streamlit/handler_streamlit.py
│   │
│   ├── inference_templates/                # 실제 EKS에서 실행되는 모델 서버 코드
│   │   ├── llama/
│   │   │   ├── Dockerfile
│   │   │   ├── app.py
│   │   │   ├── requirements.txt
│   │   │   └── ...
│   │   ├── diffusion/
│   │   ├── generic_gpu/
│   │   └── serverless_cpu/
│   │
│   ├── training_templates/                 # 학습 관련 코드
│   │   ├── llama/
│   │   ├── diffusion/
│   │   └── ray/
│   │
│   ├── recommend/                          # 추천 알고리즘 관련
│   └── monitor/                            # 모델 성능, 자원 모니터링 코드
│
├── scripts/                                # 자동화 스크립트
│   ├── build_images.sh                     # 모든 이미지 빌드 및 푸시
│   ├── delete_images.sh
│   ├── init_env.sh                         # setup.env 초기화용
│   └── sskai_execute.py                    # 배포 Entry Script (CLI)
│
├── frontend/                               # 웹 클라이언트
│   ├── streamlit/
│   └── s3_web/
│
├── README.md
└── .gitignore
```

## 시작하기

```bash
# 환경 설정
./scripts/init_env.sh

# 배포 실행
python scripts/sskai_execute.py
```

# mlops
