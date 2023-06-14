# Salt CI Containers

These are containers used in the Salt Test Suite, either custom, or mirrors from other container registries.

## Contributing

### Initial Setup

Install `pre-commit`

```shell
python -m pip install pre-commit
pre-commit install --install-hooks
```

### Mirror Container

Edit the `containers.yml` file found in the root of the repository, and, under the `mirrors`
key add your new mirror:

```yaml
mirrors:
  <container label - display name>:
    container: <container image>
    versions:
      - "1.0"
      - "2.2"
```

### Custom Container

When adding a custom container, edit the `containers.yml` file found in the root of the
repository, and, under the `custom` key, add the new container:

```yaml
custom:
  <container label - display name>:
    name: <the name the container will have>
    # The name is also the path, on the root of the repo of where the Dockerfile(s)
    # can be found, for example, a custom container named foo will have it's files
    # in <repo-root>/custom/foo
    versions:
      - "1.0"
      - "2.2"
      # These versions will map to existing Dockerfile(s).
      # Following the example from above, the versions declared here would map
      # to the following files:
      #  - <repo-root>/custom/foo/1.0.Dockerfile
      #  - <repo-root>/custom/foo/2.2.Dockerfile
```

### Commit Changes

When you commit changes, pre-commit will generate the necessary workflows, and
Dockerfile(s) if needed, and also update this `README.md` file.

So, the first time you `git commit -a`, it will fail, because it updated files.
The next time, if there are no errors reported by `pre-commit`, the changes
will be commited.

# Containers Listing

<!-- included-containers -->

## Salt Releases


### [![Salt Releases](https://github.com/saltstack/salt-ci-containers/actions/workflows/salt-containers.yml/badge.svg)](https://github.com/saltstack/salt-ci-containers/actions/workflows/salt-containers.yml)

- salt:3002 - `ghcr.io/saltstack/salt-ci-containers/salt:3002`
- salt:3003 - `ghcr.io/saltstack/salt-ci-containers/salt:3003`
- salt:3004 - `ghcr.io/saltstack/salt-ci-containers/salt:3004`
- salt:3005 - `ghcr.io/saltstack/salt-ci-containers/salt:3005`
- salt:current - `ghcr.io/saltstack/salt-ci-containers/salt:current`

## Custom


### [![OpenLDAP Minion](https://github.com/saltstack/salt-ci-containers/actions/workflows/openldap-minion-containers.yml/badge.svg)](https://github.com/saltstack/salt-ci-containers/actions/workflows/openldap-minion-containers.yml)

- openldap-minion:latest - `ghcr.io/saltstack/salt-ci-containers/openldap-minion:latest`


### [![SSH Minion](https://github.com/saltstack/salt-ci-containers/actions/workflows/ssh-minion-containers.yml/badge.svg)](https://github.com/saltstack/salt-ci-containers/actions/workflows/ssh-minion-containers.yml)

- ssh-minion:latest - `ghcr.io/saltstack/salt-ci-containers/ssh-minion:latest`


### [![Salt GitFS HTTP Server](https://github.com/saltstack/salt-ci-containers/actions/workflows/salt-gitfs-http-containers.yml/badge.svg)](https://github.com/saltstack/salt-ci-containers/actions/workflows/salt-gitfs-http-containers.yml)

- salt-gitfs-http:latest - `ghcr.io/saltstack/salt-ci-containers/salt-gitfs-http:latest`


### [![Salt Packaging](https://github.com/saltstack/salt-ci-containers/actions/workflows/packaging-containers.yml/badge.svg)](https://github.com/saltstack/salt-ci-containers/actions/workflows/packaging-containers.yml)

- packaging:centosstream-9 - `ghcr.io/saltstack/salt-ci-containers/packaging:centosstream-9`
- packaging:debian-11 - `ghcr.io/saltstack/salt-ci-containers/packaging:debian-11`


### [![Virt Minion](https://github.com/saltstack/salt-ci-containers/actions/workflows/virt-minion-containers.yml/badge.svg)](https://github.com/saltstack/salt-ci-containers/actions/workflows/virt-minion-containers.yml)

- virt-minion:latest - `ghcr.io/saltstack/salt-ci-containers/virt-minion:latest`


## Mirrors


### [![Amazon Linux](https://github.com/saltstack/salt-ci-containers/actions/workflows/amazon-linux-containers.yml/badge.svg)](https://github.com/saltstack/salt-ci-containers/actions/workflows/amazon-linux-containers.yml)

- [dockerhub/amazonlinux:2](https://hub.docker.com/r/_/amazonlinux/tags?name=2) - `ghcr.io/saltstack/salt-ci-containers/amazon-linux:2`


### [![Apache ZooKeeper](https://github.com/saltstack/salt-ci-containers/actions/workflows/zookeeper-containers.yml/badge.svg)](https://github.com/saltstack/salt-ci-containers/actions/workflows/zookeeper-containers.yml)

- [dockerhub/zookeeper:3.5.9](https://hub.docker.com/r/_/zookeeper/tags?name=3.5.9) - `ghcr.io/saltstack/salt-ci-containers/zookeeper:3.5.9`


### [![BusyBox](https://github.com/saltstack/salt-ci-containers/actions/workflows/busybox-containers.yml/badge.svg)](https://github.com/saltstack/salt-ci-containers/actions/workflows/busybox-containers.yml)

- [dockerhub/busybox:musl](https://hub.docker.com/r/_/busybox/tags?name=musl) - `ghcr.io/saltstack/salt-ci-containers/busybox:musl`


### [![CentOS](https://github.com/saltstack/salt-ci-containers/actions/workflows/centos-containers.yml/badge.svg)](https://github.com/saltstack/salt-ci-containers/actions/workflows/centos-containers.yml)

- [dockerhub/centos:7](https://hub.docker.com/r/_/centos/tags?name=7) - `ghcr.io/saltstack/salt-ci-containers/centos:7`


### [![CentOS Stream](https://github.com/saltstack/salt-ci-containers/actions/workflows/centos-stream-containers.yml/badge.svg)](https://github.com/saltstack/salt-ci-containers/actions/workflows/centos-stream-containers.yml)

- [quay.io/centos/centos:stream8](https://quay.io/centos/centos?tab=tags&tag=stream8) - `ghcr.io/saltstack/salt-ci-containers/centos-stream:8`
- [quay.io/centos/centos:stream9](https://quay.io/centos/centos?tab=tags&tag=stream9) - `ghcr.io/saltstack/salt-ci-containers/centos-stream:9`


### [![Consul](https://github.com/saltstack/salt-ci-containers/actions/workflows/consul-containers.yml/badge.svg)](https://github.com/saltstack/salt-ci-containers/actions/workflows/consul-containers.yml)

- [dockerhub/consul:latest](https://hub.docker.com/r/_/consul/tags?name=latest) - `ghcr.io/saltstack/salt-ci-containers/consul:latest`


### [![Debian](https://github.com/saltstack/salt-ci-containers/actions/workflows/debian-containers.yml/badge.svg)](https://github.com/saltstack/salt-ci-containers/actions/workflows/debian-containers.yml)

- [dockerhub/debian:10](https://hub.docker.com/r/_/debian/tags?name=10) - `ghcr.io/saltstack/salt-ci-containers/debian:10`
- [dockerhub/debian:11](https://hub.docker.com/r/_/debian/tags?name=11) - `ghcr.io/saltstack/salt-ci-containers/debian:11`


### [![Etcd v2](https://github.com/saltstack/salt-ci-containers/actions/workflows/etcd-v2-containers.yml/badge.svg)](https://github.com/saltstack/salt-ci-containers/actions/workflows/etcd-v2-containers.yml)

- [elcolio/etcd:latest](https://hub.docker.com/r/elcolio/etcd/tags?name=latest) - `ghcr.io/saltstack/salt-ci-containers/etcd:2`


### [![Etcd v3](https://github.com/saltstack/salt-ci-containers/actions/workflows/etcd-v3-containers.yml/badge.svg)](https://github.com/saltstack/salt-ci-containers/actions/workflows/etcd-v3-containers.yml)

- [bitnami/etcd:3](https://hub.docker.com/r/bitnami/etcd/tags?name=3) - `ghcr.io/saltstack/salt-ci-containers/etcd:3`


### [![Fedora](https://github.com/saltstack/salt-ci-containers/actions/workflows/fedora-containers.yml/badge.svg)](https://github.com/saltstack/salt-ci-containers/actions/workflows/fedora-containers.yml)

- [dockerhub/fedora:36](https://hub.docker.com/r/_/fedora/tags?name=36) - `ghcr.io/saltstack/salt-ci-containers/fedora:36`
- [dockerhub/fedora:37](https://hub.docker.com/r/_/fedora/tags?name=37) - `ghcr.io/saltstack/salt-ci-containers/fedora:37`
- [dockerhub/fedora:38](https://hub.docker.com/r/_/fedora/tags?name=38) - `ghcr.io/saltstack/salt-ci-containers/fedora:38`


### [![MariaDB](https://github.com/saltstack/salt-ci-containers/actions/workflows/mariadb-containers.yml/badge.svg)](https://github.com/saltstack/salt-ci-containers/actions/workflows/mariadb-containers.yml)

- [dockerhub/mariadb:10.1](https://hub.docker.com/r/_/mariadb/tags?name=10.1) - `ghcr.io/saltstack/salt-ci-containers/mariadb:10.1`
- [dockerhub/mariadb:10.2](https://hub.docker.com/r/_/mariadb/tags?name=10.2) - `ghcr.io/saltstack/salt-ci-containers/mariadb:10.2`
- [dockerhub/mariadb:10.3](https://hub.docker.com/r/_/mariadb/tags?name=10.3) - `ghcr.io/saltstack/salt-ci-containers/mariadb:10.3`
- [dockerhub/mariadb:10.4](https://hub.docker.com/r/_/mariadb/tags?name=10.4) - `ghcr.io/saltstack/salt-ci-containers/mariadb:10.4`
- [dockerhub/mariadb:10.5](https://hub.docker.com/r/_/mariadb/tags?name=10.5) - `ghcr.io/saltstack/salt-ci-containers/mariadb:10.5`


### [![MySQL Server](https://github.com/saltstack/salt-ci-containers/actions/workflows/mysql-server-containers.yml/badge.svg)](https://github.com/saltstack/salt-ci-containers/actions/workflows/mysql-server-containers.yml)

- [mysql/mysql-server:5.5](https://hub.docker.com/r/mysql/mysql-server/tags?name=5.5) - `ghcr.io/saltstack/salt-ci-containers/mysql-server:5.5`
- [mysql/mysql-server:5.6](https://hub.docker.com/r/mysql/mysql-server/tags?name=5.6) - `ghcr.io/saltstack/salt-ci-containers/mysql-server:5.6`
- [mysql/mysql-server:5.7](https://hub.docker.com/r/mysql/mysql-server/tags?name=5.7) - `ghcr.io/saltstack/salt-ci-containers/mysql-server:5.7`
- [mysql/mysql-server:8.0](https://hub.docker.com/r/mysql/mysql-server/tags?name=8.0) - `ghcr.io/saltstack/salt-ci-containers/mysql-server:8.0`


### [![Percona](https://github.com/saltstack/salt-ci-containers/actions/workflows/percona-containers.yml/badge.svg)](https://github.com/saltstack/salt-ci-containers/actions/workflows/percona-containers.yml)

- [dockerhub/percona:5.5](https://hub.docker.com/r/_/percona/tags?name=5.5) - `ghcr.io/saltstack/salt-ci-containers/percona:5.5`
- [dockerhub/percona:5.6](https://hub.docker.com/r/_/percona/tags?name=5.6) - `ghcr.io/saltstack/salt-ci-containers/percona:5.6`
- [dockerhub/percona:5.7](https://hub.docker.com/r/_/percona/tags?name=5.7) - `ghcr.io/saltstack/salt-ci-containers/percona:5.7`
- [dockerhub/percona:8.0](https://hub.docker.com/r/_/percona/tags?name=8.0) - `ghcr.io/saltstack/salt-ci-containers/percona:8.0`


### [![Photon](https://github.com/saltstack/salt-ci-containers/actions/workflows/photon-containers.yml/badge.svg)](https://github.com/saltstack/salt-ci-containers/actions/workflows/photon-containers.yml)

- [dockerhub/photon:3.0](https://hub.docker.com/r/_/photon/tags?name=3.0) - `ghcr.io/saltstack/salt-ci-containers/photon:3`
- [dockerhub/photon:4.0](https://hub.docker.com/r/_/photon/tags?name=4.0) - `ghcr.io/saltstack/salt-ci-containers/photon:4`


### [![Python](https://github.com/saltstack/salt-ci-containers/actions/workflows/python-containers.yml/badge.svg)](https://github.com/saltstack/salt-ci-containers/actions/workflows/python-containers.yml)

- [dockerhub/python:3](https://hub.docker.com/r/_/python/tags?name=3) - `ghcr.io/saltstack/salt-ci-containers/python:3`
- [dockerhub/python:3.10](https://hub.docker.com/r/_/python/tags?name=3.10) - `ghcr.io/saltstack/salt-ci-containers/python:3.10`
- [dockerhub/python:3.11](https://hub.docker.com/r/_/python/tags?name=3.11) - `ghcr.io/saltstack/salt-ci-containers/python:3.11`
- [dockerhub/python:3.6](https://hub.docker.com/r/_/python/tags?name=3.6) - `ghcr.io/saltstack/salt-ci-containers/python:3.6`
- [dockerhub/python:3.7](https://hub.docker.com/r/_/python/tags?name=3.7) - `ghcr.io/saltstack/salt-ci-containers/python:3.7`
- [dockerhub/python:3.8](https://hub.docker.com/r/_/python/tags?name=3.8) - `ghcr.io/saltstack/salt-ci-containers/python:3.8`
- [dockerhub/python:3.9](https://hub.docker.com/r/_/python/tags?name=3.9) - `ghcr.io/saltstack/salt-ci-containers/python:3.9`


### [![RabbitMQ](https://github.com/saltstack/salt-ci-containers/actions/workflows/rabbitmq-containers.yml/badge.svg)](https://github.com/saltstack/salt-ci-containers/actions/workflows/rabbitmq-containers.yml)

- [dockerhub/rabbitmq:3.10](https://hub.docker.com/r/_/rabbitmq/tags?name=3.10) - `ghcr.io/saltstack/salt-ci-containers/rabbitmq:3.10`
- [dockerhub/rabbitmq:3.11](https://hub.docker.com/r/_/rabbitmq/tags?name=3.11) - `ghcr.io/saltstack/salt-ci-containers/rabbitmq:3.11`
- [dockerhub/rabbitmq:3.9](https://hub.docker.com/r/_/rabbitmq/tags?name=3.9) - `ghcr.io/saltstack/salt-ci-containers/rabbitmq:3.9`


### [![Redis](https://github.com/saltstack/salt-ci-containers/actions/workflows/redis-containers.yml/badge.svg)](https://github.com/saltstack/salt-ci-containers/actions/workflows/redis-containers.yml)

- [dockerhub/redis:alpine](https://hub.docker.com/r/_/redis/tags?name=alpine) - `ghcr.io/saltstack/salt-ci-containers/redis:alpine`


### [![Tinyproxy](https://github.com/saltstack/salt-ci-containers/actions/workflows/tinyproxy-containers.yml/badge.svg)](https://github.com/saltstack/salt-ci-containers/actions/workflows/tinyproxy-containers.yml)

- [vimagick/tinyproxy:latest](https://hub.docker.com/r/vimagick/tinyproxy/tags?name=latest) - `ghcr.io/saltstack/salt-ci-containers/tinyproxy:latest`


### [![Ubuntu](https://github.com/saltstack/salt-ci-containers/actions/workflows/ubuntu-containers.yml/badge.svg)](https://github.com/saltstack/salt-ci-containers/actions/workflows/ubuntu-containers.yml)

- [dockerhub/ubuntu:20.04](https://hub.docker.com/r/_/ubuntu/tags?name=20.04) - `ghcr.io/saltstack/salt-ci-containers/ubuntu:20.04`
- [dockerhub/ubuntu:22.04](https://hub.docker.com/r/_/ubuntu/tags?name=22.04) - `ghcr.io/saltstack/salt-ci-containers/ubuntu:22.04`


### [![Vault](https://github.com/saltstack/salt-ci-containers/actions/workflows/vault-containers.yml/badge.svg)](https://github.com/saltstack/salt-ci-containers/actions/workflows/vault-containers.yml)

- [dockerhub/vault:0.9.6](https://hub.docker.com/r/_/vault/tags?name=0.9.6) - `ghcr.io/saltstack/salt-ci-containers/vault:0.9.6`
- [dockerhub/vault:1.3.1](https://hub.docker.com/r/_/vault/tags?name=1.3.1) - `ghcr.io/saltstack/salt-ci-containers/vault:1.3.1`
- [dockerhub/vault:latest](https://hub.docker.com/r/_/vault/tags?name=latest) - `ghcr.io/saltstack/salt-ci-containers/vault:latest`
