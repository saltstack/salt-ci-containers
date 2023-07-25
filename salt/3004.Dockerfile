FROM python:3.6

RUN env python -m pip install --no-build-isolation 'cython<3.0' pyyaml==5.4.1 \
  && USE_STATIC_REQUIREMENTS=1 python -m pip install salt~=3004.0
