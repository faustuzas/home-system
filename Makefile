setup-node-exporter:
	bash scripts/setup_node_exporter.sh

run-prometheus:
	docker build -t prometheus -f docker/Dockerfile.prometheus
	docker run \
		-p 9090:9090 \
		-v ~/data/prometheus:/prometheus \
		prometheus

run-grafana:
