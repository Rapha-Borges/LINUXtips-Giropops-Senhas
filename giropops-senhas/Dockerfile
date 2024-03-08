FROM cgr.dev/chainguard/python:latest-dev@sha256:352705eb5ceda0b78a857c76f533a0b285c8273600c44862929d46fb0222c042 as builder
WORKDIR /app
COPY . /app
RUN pip install -r requirements.txt --user

FROM cgr.dev/chainguard/python:latest@sha256:05c8eec91c19d8f1ba0c552b2844bb0413b3a467acf7adc93d2adc2e7a902d0f
WORKDIR /app
COPY --from=builder /home/nonroot/.local/lib/python3.12/site-packages /home/nonroot/.local/lib/python3.12/site-packages
COPY --from=builder /app /app

ENTRYPOINT ["python", "-m", "flask", "run", "--host=0.0.0.0"]