setup-node-exporter:
	bash scripts/setup_node_exporter.sh

run-prometheus:
	sudo docker build -t prometheus:latest -f docker/Dockerfile.prometheus .
	sudo docker volume create prometheus-data
	sudo docker run -d \
		--network host \
		-v prometheus-data:/prometheus \
		prometheus

run-grafana:
