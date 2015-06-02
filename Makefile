all: build push

build:
	docker build -t ${DOCKER_USER}/suricata:2.0.8 .

push: build
	docker push ${DOCKER_USER}/suricata:2.0.8

test: build
	docker run -i ${DOCKER_USER}/suricata:2.0.8 build-info
