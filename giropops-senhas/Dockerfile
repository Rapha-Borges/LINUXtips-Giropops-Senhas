FROM cgr.dev/chainguard/python:latest-dev@sha256:536ef35b39718bedfe7794109507062bc222653b2b2ea8eb8eff94f144821871 as builder
WORKDIR /app
COPY . /app
RUN pip install -r requirements.txt --user

FROM cgr.dev/chainguard/python:latest@sha256:a66df8b987e2cd6ce3e7e6f133fac56ee53467ca685b8b013ac2cb462410128c
WORKDIR /app
COPY --from=builder /home/nonroot/.local/lib/python3.12/site-packages /home/nonroot/.local/lib/python3.12/site-packages
COPY --from=builder /app /app

ENTRYPOINT ["python", "-m", "flask", "run", "--host=0.0.0.0"]