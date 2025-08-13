FROM python:3.22-alpine AS builder

# set labels
ARG IMAGE_BUILD_DATE
LABEL org.opencontainers.image.authors="Tibor (https://github.com/tibor309)"
LABEL org.opencontainers.image.created="${IMAGE_BUILD_DATE}"
LABEL org.opencontainers.image.title="Orbit"
LABEL org.opencontainers.image.description="A simple discord bot made with discord.py"
LABEL org.opencontainers.image.source="https://github.com/tibor309/orbit"
LABEL org.opencontainers.image.url="https://github.com/tibor309/orbit/packages"
LABEL org.opencontainers.image.licenses="GPL-3.0"
LABEL org.opencontainers.image.base.name="python:3.22-alpine"
LABEL org.opencontainers.image.base.documentation="https://hub.docker.com/_/python"

# set environment for builder
WORKDIR /app
ENV PATH="/app/venv/bin:$PATH"

# set venv and copy requirements
RUN python -m venv /app/venv
COPY requirements.txt .

# install packages
RUN \
    apk add --no-cache --no-interactive build-base && \
    pip install --no-cache-dir -r requirements.txt


FROM python:3.22-alpine

# set environment
WORKDIR /app
ENV PATH="/app/venv/bin:$PATH"

# copy files from builder
COPY . .
COPY --from=builder /app/venv /app/venv

# run the bot
CMD ["python3", "main.py"]