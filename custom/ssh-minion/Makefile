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
			ssh-minion \
			sh; \
	fi
clean:
	docker rmi ssh-minion
