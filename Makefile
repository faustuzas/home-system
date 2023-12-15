setup-node-exporter:
	bash scripts/setup_node_exporter.sh

run-prometheus:
	sudo docker build -t prometheus:latest -f docker/Dockerfile.prometheus .
	sudo docker run \
		-p 9090:9090 \
		-v ~/data/prometheus:/prometheus \
		prometheus

run-grafana:
