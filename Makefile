build:
	docker build -t virt-minion .

run:
	docker run --privileged --device /dev/mem -it virt-salt-minion sh
