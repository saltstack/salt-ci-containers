FROM python:3.10

RUN apt update \
  && apt install -y rustc build-essential
RUN export USE_STATIC_REQUIREMENTS=1 \
  && python -m pip install salt~=3007.0
