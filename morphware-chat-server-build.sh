#!/usr/bin/env bash

###############################################################################
###############################################################################
###############################################################################
####                                                                       ####
####                                                                       ####
####                                                                       ####
####                                                                       ####
####                                                                       ####
####                          M O R P H W A R E                            ####
####                                                                       ####
####                                                                       ####
####                                                                       ####
####                                                                       ####
####                                                                       ####
####                                                                       ####
###############################################################################
###############################################################################
###############################################################################


# Nvidia Container Toolkit
#
## 1. Update the Package List
sudo apt-get update
#
## 2. Install Required Dependencies
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
#
#
## 3. Add the NVIDIA Package Repository
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
    && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
    && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
#
## 4. Install the NVIDIA Container Toolkit
sudo apt-get update
sudo apt-get install -y nvidia-docker2
#
## 5. Restart the Docker Daemon
sudo systemctl restart docker
#
## 6. Restart
sudo reboot


# Installing Open WebUI with Bundled Ollama Support
docker run -d -p 3000:8080 --gpus=all -v ollama:/root/.ollama -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:ollama


# Ngrok
#
## 1. Install Ngrok via Apt
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc \
	| sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null \
	&& echo "deb https://ngrok-agent.s3.amazonaws.com buster main" \
	| sudo tee /etc/apt/sources.list.d/ngrok.list \
	&& sudo apt update \
	&& sudo apt install ngrok
#
## 2. Authenticate Your Ngrok Agent
ngrok config add-authtoken $YOUR_AUTHTOKEN
#
## 3. Connect internal port to external port
ngrok http http://localhost:8080
