#!/bin/bash

sudo su
sudo apt-get update -y
sudo apt-get update -y
sudo apt-get python3 -y
sudo apt-get install curl git zip -y
sudo apt-get install docker.io -y
sudo systemctl enable --now docker
sudo systemctl start docker
sudo chkconfig docker on
sudo docker pull thecalifornia16/desafio_gb:latest
sudo docker run --name desafio_gb -d -it -p 80:8000 thecalifornia16/desafio_gb
sleep 40s
sudo docker container exec desafio_gb sh /app/comentarios.sh