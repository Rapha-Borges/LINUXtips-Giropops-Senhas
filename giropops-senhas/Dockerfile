FROM cgr.dev/chainguard/python:latest-dev@sha256:5b4203b3f6bd2fb9bf781c25f4ebaba7e61be425c2d953c4bb729a47d63e794e as builder
WORKDIR /app
COPY . /app
RUN pip install -r requirements.txt --user

FROM cgr.dev/chainguard/python:latest@sha256:a8cc6a296daaa162d60d09b3ebf33a5766e31c17c815a05eb1837094a738b8ee
WORKDIR /app
COPY --from=builder /home/nonroot/.local/lib/python3.12/site-packages /home/nonroot/.local/lib/python3.12/site-packages
COPY --from=builder /app /app

ENTRYPOINT ["python", "-m", "flask", "run", "--host=0.0.0.0"]