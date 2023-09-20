FROM python:3.7

RUN apt update \
  && apt install -y rustc build-essential
RUN echo "cython<3" > /tmp/constraint.txt \
  && echo "pyyaml==5.4.1" >> /tmp/constraint.txt \
  && export PIP_CONSTRAINT=/tmp/constraint.txt \
  && export USE_STATIC_REQUIREMENTS=1 \
  && python -m pip install salt~=3005.0
