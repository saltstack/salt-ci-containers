FROM python:3.10

RUN apt update \
  && apt install -y rustc build-essential
