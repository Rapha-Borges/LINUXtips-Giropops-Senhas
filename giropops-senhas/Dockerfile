FROM cgr.dev/chainguard/python:latest-dev@sha256:644de8cd529d28af198e476ce9949f365d5002301f4ccb02a895bfe8fa49439f as builder
WORKDIR /app
COPY . /app
RUN pip install -r requirements.txt --user

FROM cgr.dev/chainguard/python:latest@sha256:d18bb6ba80da7dc894bbb40c438caf37187a2efbbba8560e691e577d8711e778
WORKDIR /app
COPY --from=builder /home/nonroot/.local/lib/python3.12/site-packages /home/nonroot/.local/lib/python3.12/site-packages
COPY --from=builder /app /app

ENTRYPOINT ["python", "-m", "flask", "run", "--host=0.0.0.0"]