FROM debian:12-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        slapd \
        ldap-utils \
        python3-distro \
        python3-jinja2 \
        python3-ldap \
        python3-msgpack \
        python3-pycryptodome \
        python3-yaml \
        python3-zmq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
