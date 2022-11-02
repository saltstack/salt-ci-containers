SALT_PATH ?= $(shell python -c 'import os, salt; print(os.path.abspath(salt.__file__ + "../../.."))')

all: build

build:
	docker build -t ssh-minion .

run:
	if [ -d $(SALT_PATH) ]; then \
		docker run \
			--rm \
			--privileged \
			--device /dev/mem \
			--network host \
			--name ssh-minion \
			-it \
			--mount type=bind,source=$(SALT_PATH),target=/salt \
			virt-minion \
			sh; \
	fi
clean:
	docker rmi virt-minion
