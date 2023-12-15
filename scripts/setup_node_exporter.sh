#!/usr/bin/bash

set -e

MY_BIN=~/bin

if [ ! -e $MY_BIN/node_exporter ]; then
  echo -- Downloading node_exporter because it was not found in $MY_BIN/node_exporter

  mkdir -p $MY_BIN

  EXPORTER_DIR=node_exporter-1.7.0.linux-armv7
  DOWNLOAD_URL=https://github.com/prometheus/node_exporter/releases/download/v1.7.0/$EXPORTER_DIR.tar.gz

  DOWNLOAD_DIR=/tmp/downloads/node_exporter
  DOWNLOAD_PATH=$DOWNLOAD_DIR/node_exporter.tar.gz

  mkdir -p $DOWNLOAD_DIR

  echo -- Downloading binary
  wget -O $DOWNLOAD_PATH $DOWNLOAD_URL

  echo -- Decompressing downloaded bundle
  tar -xvf $DOWNLOAD_PATH -C $DOWNLOAD_DIR

  echo -- Moving binary into $MY_BIN/node_exporter
  mv $DOWNLOAD_DIR/$EXPORTER_DIR/node_exporter $MY_BIN/node_exporter

  rm -rf $DOWNLOAD_DIR
else
  echo -- node_exporter binary found. Skipping download step...
fi

if [ ! -e /etc/systemd/system/node_exporter.service ]; then
  echo -- Configuring systemd because configuration file was not found
  echo "
[Unit]
Description=node_exporter exposing metrics on 9100
After=network.target

[Service]
ExecStart=$MY_BIN/node_exporter
User=faustasbutkus
Group=faustasbutkus
Restart=always

[Install]
WantedBy=default.target
  " | sudo tee /etc/systemd/system/node_exporter.service > /dev/null

  sudo systemctl daemon-reload

  sudo systemctl enable node_exporter
  sudo systemctl start node_exporter
fi