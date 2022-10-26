NAME_TAG = ghcr.io/saltstack/salt-ci-containers/openldap-minion:latest
SALT_PATH ?= $(shell python -c 'import os, salt; print(os.path.abspath(salt.__file__ + "../../.."))')

all: build

build:
	docker build -t '$(NAME_TAG)' -f latest.Dockerfile .

run:
	if [ -d $(SALT_PATH) ]; then \
		docker run \
			--rm \
			--privileged \
			--device /dev/mem \
			--network host \
			--name openldap-minion \
			-it \
			--mount type=bind,source=$(SALT_PATH),target=/salt \
			'$(NAME_TAG)' \
			sh; \
	fi

clean:
	docker rmi '$(NAME_TAG)'
