setup-prometheus:
	sudo docker build -t prometheus-custom:latest -f docker/Dockerfile.prometheus .
	sudo docker volume create prometheus-data

run-prometheus:
	sudo docker run --rm -d \
		--network host \
		-v prometheus-data:/prometheus \
		prometheus-custom

setup-grafana:
	sudo docker build -t grafana-custom:latest -f docker/Dockerfile.grafana .
	sudo docker volume create grafana-data

run-grafana:
	sudo docker run --rm \
		--network host \
		-v grafana-data:/var/lib/grafana \
		grafana-custom

run-nginx:
	sudo docker build -t nginx-custom:latest -f docker/Dockerfile.nginx .
	sudo docker run --rm --network host nginx-custom

run-node-exporter:
	sudo docker run \
           --network host \
           --pid="host" \
           -v "/:/host:ro,rslave" \
           quay.io/prometheus/node-exporter:latest \
           --path.rootfs=/host

after-boot: run-prometheus run-grafana run-nginx run-node-exporter