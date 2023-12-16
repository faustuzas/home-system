setup-node-exporter:
	bash scripts/setup_node_exporter.sh

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
	sudo docker run --rm -d \
		--network host \
		-v grafana-data:/var/lib/grafana \
		grafana-custom

run-nginx:
	sudo docker build -t nginx-custom:latest -f docker/Dockerfile.nginx .
	sudo docker run -it --rm --network host nginx-custom

after-boot: run-prometheus run-grafana run-nginx

# Goal:
	# move node_exporter to docker as well
	# configure grafana to use /grafana prefix