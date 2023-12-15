setup-node-exporter:
	bash scripts/setup_node_exporter.sh

setup-prometheus:
	sudo docker build -t prometheus:latest -f docker/Dockerfile.prometheus .
	sudo docker volume create prometheus-data

run-prometheus:
	sudo docker run --rm \
		--network host \
		-v prometheus-data:/prometheus \
		prometheus

setup-grafana:
	sudo docker volume create grafana-data

run-grafana:
	sudo docker run --rm \
		--network host \
		-v grafana-data:/var/lib/grafana \
		grafana/grafana-enterprise

run-nginx:
	sudo docker build -t nginx-custom:latest -f docker/Dockerfile.nginx .
	sudo docker run -it --rm -d --network host nginx-custom

after-boot: run-prometheus run-grafana