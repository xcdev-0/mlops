FROM pytorch/pytorch:2.3.0-cuda12.1-cudnn8-runtime

WORKDIR /app

# Install python packages
COPY requirements.txt /app/requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

# OS tools (wget + unzip)
RUN apt-get update && \
    apt-get install -y wget unzip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy your FastAPI app
COPY app.py /app/app.py

EXPOSE 8080

CMD ["python3", "/app/app.py"]
