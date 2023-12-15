#!/usr/bin/bash

set -e

MY_BIN=~/bin

if [ ! -e $MY_BIN/prometheus ]; then
  echo -- Downloading prometheus because it was not found in $MY_BIN/prometheus

  mkdir -p $MY_BIN

  PROMETHEUS_DIR=prometheus-2.48.1.linux-armv7
  DOWNLOAD_URL=https://github.com/prometheus/prometheus/releases/download/v2.48.1/$PROMETHEUS_DIR.tar.gz

  DOWNLOAD_DIR=/tmp/downloads/prometheus
  DOWNLOAD_PATH=$DOWNLOAD_DIR/prometheus.tar.gz

  mkdir -p $DOWNLOAD_DIR

  echo -- Downloading binary
  wget -O $DOWNLOAD_PATH $DOWNLOAD_URL

  echo -- Decompressing downloaded bundle
  tar -xvf $DOWNLOAD_PATH -C $DOWNLOAD_DIR

  echo -- Moving binary into $MY_BIN/prometheus
  mv $DOWNLOAD_DIR/$PROMETHEUS_DIR/prometheus $MY_BIN/prometheus

  rm -rf $DOWNLOAD_DIR
else
  echo -- prometheus binary found. Skipping download step...
fi

if [ ! -e /etc/systemd/system/prometheus.service ]; then
  echo -- Configuring prometheus because configuration file was not found
  echo "
[Unit]
Description=prometheus
After=network.target

[Service]
ExecStart=$MY_BIN/prometheus
User=faustasbutkus
Group=faustasbutkus
Restart=always

[Install]
WantedBy=default.target
  " | sudo tee /etc/systemd/system/prometheus.service > /dev/null

  sudo systemctl daemon-reload

  sudo systemctl enable prometheus
  sudo systemctl start prometheus
fi

echo -- Moving latest config to /etc/prometheus/prometheus.yml
mkdir -r /etc/prometheus
cp configs/prometheus.yml /etc/prometheus/prometheus.yml