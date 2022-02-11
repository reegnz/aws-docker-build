# syntax=docker/dockerfile:1.3
FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update \
    && apt-get -y install --no-install-recommends awscli \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN --mount=type=secret,id=aws,target=/root/.aws/credentials \
    aws s3 ls
