# Morphware Chat Daemon

This repository contains the necessary scripts and instructions to set up the Morphware Chat Daemon, which includes installing the NVIDIA Container Toolkit, setting up Open WebUI with bundled Ollama support, and configuring Ngrok for secure tunneling.

The project plans to sponsor Open WebUI, soon, and will eventually maintain a forked version of it in a separate repository. This repository should be the one that pulls everything together. The entire stack is as follows:

![image](https://github.com/morphware/chat-daemon/assets/8116437/bd8275ab-5dbe-429e-9e5f-4194fb1b950b)

## Table of Contents
- [Installation](#installation)
  - [NVIDIA Container Toolkit](#nvidia-container-toolkit)
  - [Open WebUI with Ollama Support](#open-webui-with-ollama-support)
  - [Ngrok](#ngrok)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Installation

### NVIDIA Container Toolkit

To use GPU acceleration with Docker containers, install the NVIDIA Container Toolkit by following these steps:

1. **Update the Package List**
    ```bash
    sudo apt-get update
    ```

2. **Install Required Dependencies**
    ```bash
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    ```

3. **Add the NVIDIA Package Repository**
    ```bash
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
    && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
    && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
    ```

4. **Install the NVIDIA Container Toolkit**
    ```bash
    sudo apt-get update
    sudo apt-get install -y nvidia-docker2
    ```

5. **Restart the Docker Daemon**
    ```bash
    sudo systemctl restart docker
    ```

6. **Reboot the System**
    ```bash
    sudo reboot
    ```

### Open WebUI with Ollama Support

To install Open WebUI with bundled Ollama support, use the following Docker command:

```bash
docker run -d -p 3000:8080 --gpus=all -v ollama:/root/.ollama -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:ollama
```

### Ngrok

To set up Ngrok for secure tunneling, follow these steps:

1. **Install Ngrok via Apt**
    ```bash
    curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null \
    && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list \
    && sudo apt update \
    && sudo apt install ngrok
    ```

2. **Authenticate Your Ngrok Agent**
    ```bash
    ngrok config add-authtoken $YOUR_AUTHTOKEN
    ```

3. **Connect Internal Port to External Port**
    ```bash
    ngrok http http://localhost:8080
    ```

## Usage

Once the installation is complete, you can start the services and access the Open WebUI interface via the Ngrok URL provided.

### Download a Model

_Note: The following is only for users with GPU-enabled nodes who want to download LLMs. These users have administrative privileges on their nodes, which you can see in the image below ("Admin Panel")._

To download and start using a model, enter the model name into the form-field highlight in red, below. Then, press enter or click the download button to the right of the form-field.

![image](https://github.com/morphware/chat-daemon/assets/8116437/df6052c8-abab-4c08-b663-e36b120a421d)


## Contributing

Contributions are welcome! Please fork this repository, create a new branch, and submit a pull request for review.
