SALT_PATH ?= $(shell python -c 'import os, salt; print(os.path.abspath(salt.__file__ + "../../.."))')

all: build

build:
	docker build -t openldap-minion:latest -f latest.Dockerfile .

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
			openldap-minion:latest \
			sh; \
	fi

clean:
	docker rmi openldap-minion
