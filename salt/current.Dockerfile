FROM python:3.10

RUN apt update \
  && apt install -y git rustc build-essential
# Let's do a full clone for proper versioning
RUN git clone https://github.com/saltstack/salt.git salt-git \
  && echo "setuptools<75.6.0" > /tmp/constraint.txt \
  && export PIP_CONSTRAINT=/tmp/constraint.txt \
  && export USE_STATIC_REQUIREMENTS=1 \
  && python -m pip install ./salt-git \
  && rm -rf salt-git/
