setup-prometheus:
	sudo docker build -t prometheus-custom:latest -f docker/Dockerfile.prometheus .
	sudo docker volume create prometheus-data

run-prometheus:
	sudo docker run --rm \
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

run-node_exporter:
	sudo docker run \
           --network host \
           --pid="host" \
           -v "/:/host:ro,rslave" \
           quay.io/prometheus/node-exporter:latest \
           --path.rootfs=/host

SERVICES_TO_BOOT = \
	nginx \
	prometheus \
	grafana \
	node_exporter

SYSTEMD_TEMPLATE = configs/systemd_template.txt

define SYSTEMD_CONFIG
.PHONY: systemd-config-$(SERVICE)
systemd-config-$(SERVICE):
	@echo Configuring $(SERVICE) file
	@sed 's|%SERVICE_NAME%|$(SERVICE)|g' $(SYSTEMD_TEMPLATE) \
		| sudo tee /etc/systemd/system/$(SERVICE).service > /dev/null

	@echo Configuring systemd
	sudo systemctl daemon-reload
	sudo systemctl enable $(SERVICE)
	sudo systemctl start $(SERVICE)
endef

$(foreach SERVICE,$(SERVICES_TO_BOOT),$(eval $(SYSTEMD_CONFIG)))
