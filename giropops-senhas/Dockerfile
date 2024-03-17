FROM cgr.dev/chainguard/python:latest-dev@sha256:c26229dc2d26473042e47e337ee93bdcb09d0ad8184f681ced37d5d246f7f556 as builder
WORKDIR /app
COPY . /app
RUN pip install -r requirements.txt --user

FROM cgr.dev/chainguard/python:latest@sha256:0492ec3eb9f43757c3a5d42198ea85fb61757700cd98436577a1924ec9d11c4e
WORKDIR /app
COPY --from=builder /home/nonroot/.local/lib/python3.12/site-packages /home/nonroot/.local/lib/python3.12/site-packages
COPY --from=builder /app /app

ENTRYPOINT ["python", "-m", "flask", "run", "--host=0.0.0.0"]