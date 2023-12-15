#!/usr/bin/bash

set -e

MY_BIN=~/bin

if [ ! -e $MY_BIN/grafana ]; then
  echo -- Downloading grafana because it was not found in $MY_BIN/grafana

  mkdir -p $MY_BIN

  DOWNLOAD_URL=https://dl.grafana.com/oss/release/grafana-10.2.2.linux-arm64.tar.gz

  DOWNLOAD_DIR=/tmp/downloads/grafana
  DOWNLOAD_PATH=$DOWNLOAD_DIR/grafana.tar.gz

  mkdir -p $DOWNLOAD_DIR

  echo -- Downloading binary
  wget -O $DOWNLOAD_PATH $DOWNLOAD_URL

  echo -- Decompressing downloaded bundle
  tar -xvf $DOWNLOAD_PATH -C $DOWNLOAD_DIR

  echo -- Moving binary into $MY_BIN/grafana
  mv $DOWNLOAD_DIR/grafana-v10.2.2/bin/grafana-server $MY_BIN/grafana

  rm -rf $DOWNLOAD_DIR
else
  echo -- grafana binary found. Skipping download step...
fi
#
#if [ ! -e /etc/systemd/system/grafana.service ]; then
#  echo -- Configuring grafana because configuration file was not found
#  echo "
#[Unit]
#Description=grafana
#After=network.target
#
#[Service]
#ExecStart=$MY_BIN/grafana \
#  --config.file=/etc/prometheus/prometheus.yml \
#  --storage.tsdb.path=/home/faustasbutkus/_data/prometheus/ \
#  --storage.tsdb.retention.time=4d
#User=faustasbutkus
#Group=faustasbutkus
#Restart=always
#
#[Install]
#WantedBy=default.target
#  " | sudo tee /etc/systemd/system/prometheus.service > /dev/null
#
#  sudo systemctl daemon-reload
#
#  sudo systemctl enable prometheus
#  sudo systemctl start prometheus
#fi
#
#sudo mkdir -p /_data/prometheus
#
#echo -- Moving latest config to /etc/prometheus/prometheus.yml
#sudo mkdir -p /etc/prometheus
#sudo cp configs/prometheus.yml /etc/prometheus/prometheus.yml