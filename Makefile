#!/bin/bash
pack:
	(docker run -v "$$(pwd)":/go/src/github.com/adamwalach/openvpn-web-ui --rm -w /usr/src/myapp awalach/beego:1.8.1 sh -c "cd /go/src/github.com/adamwalach/openvpn-web-ui/ && bee version && bee pack -exr='^vendor|^data.db|^build|^README.md|^docs'")

docker-build:
	set -e
	docker build -t awalach/openvpn-web-ui .

run:
	(docker run -p 8088:8088 -p 8080:8080 -v "$$(pwd)/":/go/src/github.com/adamwalach/openvpn-web-ui --rm -w /usr/src/myapp awalach/beego:1.8.1 sh -c "cd /go/src/github.com/adamwalach/openvpn-web-ui/ && bee run -gendoc=true")

compose-up:
	(cd docs && docker-compose up -d)

compose-down:
	(cd docs && docker-compose down)

prod-run:
	make compose-down
	make pack
	make docker-build
	make compose-up

clean:
	(docker rm -f $(docker ps -a -q))