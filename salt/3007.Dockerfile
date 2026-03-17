FROM python:3.10

RUN apt update \
  && apt install -y rustc build-essential
RUN echo "setuptools<75.6.0" > /tmp/constraint.txt \
  && export PIP_CONSTRAINT=/tmp/constraint.txt \
  && export USE_STATIC_REQUIREMENTS=1 \
  && python -m pip install salt~=3007.0
