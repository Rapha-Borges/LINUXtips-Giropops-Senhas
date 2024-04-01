FROM cgr.dev/chainguard/python:latest-dev@sha256:5e011b48d919b43dba2d821e7646f643eec568ab545ed5a2662d662e66e97e80 as builder
WORKDIR /app
COPY . /app
RUN pip install -r requirements.txt --user

FROM cgr.dev/chainguard/python:latest@sha256:c8c58449cd64727cfca03206b798ee9f3d64f8930273855db573538e023150a0
WORKDIR /app
COPY --from=builder /home/nonroot/.local/lib/python3.12/site-packages /home/nonroot/.local/lib/python3.12/site-packages
COPY --from=builder /app /app

ENTRYPOINT ["python", "-m", "flask", "run", "--host=0.0.0.0"]