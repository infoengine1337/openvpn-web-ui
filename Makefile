#!/bin/bash
pack:
	(docker run -v "$$(pwd)":/go/src/github.com/adamwalach/openvpn-web-ui --rm -w /usr/src/myapp awalach/beego:1.8.1 sh -c "cd /go/src/github.com/adamwalach/openvpn-web-ui/ && bee version && bee pack -exr='^vendor|^data.db|^build|^README.md|^docs'")

docker-build:
	set -e
	docker build -t awalach/openvpn-web-ui .

run:
	(docker run -p 8088:8088 -p 8080:8080 -e OPENVPN_ADMIN_USERNAME=admin -e OPENVPN_ADMIN_PASSWORD=b3secure -v "$$(pwd)"/docs/openvpn-data/db:/opt/openvpn-gui/db -v "$$(pwd)"/docs/openvpn-data/conf:/etc/openvpn -v "$$(pwd)/":/go/src/github.com/adamwalach/openvpn-web-ui --rm -w /usr/src/myapp awalach/beego:1.8.1 sh -c "cd /go/src/github.com/adamwalach/openvpn-web-ui/ && bee run")

compose-up:
	(cd docs && docker-compose up -d)

compose-down:
	(cd docs && docker-compose down)

compose-logs:
	(cd docs && docker-compose logs -f)

prod-run:
	make compose-down
	make pack
	make docker-build
	make compose-up

clean:
	(docker rm -f $(docker ps -a -q))

update-iptables:
	(docker exec -t openvpn bash -c "iptables -t nat -A POSTROUTING -s 10.0.0.0/8 -j MASQUERADE";docker exec -t openvpn bash -c "iptables -t nat -A POSTROUTING -s 172.16.0.0/12 -j MASQUERADE";docker exec -t openvpn bash -c "iptables -t nat -A POSTROUTING -s 192.168.0.0/16 -j MASQUERADE";)