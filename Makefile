setup-node-exporter:
	bash scripts/setup_node_exporter.sh

run-prometheus:
	sudo docker build -t prometheus:latest -f docker/Dockerfile.prometheus .
	sudo docker volume create prometheus-data
	sudo docker run -d \
		-p 9090:9090 \
		-v prometheus-data:/prometheus \
		prometheus

run-grafana:
