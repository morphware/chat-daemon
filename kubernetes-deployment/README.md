# Morphware K8S Deployment

This repository contains the necessary scripts and instructions to set up the Morphware Chat Daemon on a Kubernetes Cluster.

Recommended Hardware:

CPU node for master K8S and services

GPU node with 6gb+ VRAM to run OLLAMA service 
## Table of Contents
- [Introduction](#introduction)
- [Installation](#installation)
  - [NVIDIA Container Toolkit](#nvidia-container-toolkit)
  - [K8S Device Plugin](#k8s-device-plugin)
  - [NFS Persistant Volumes (optional)](#nfs)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)



```sudo nvidia-ctk runtime configure --runtime=containerd```


```sudo nano /etc/containerd/config.toml```

Add lines:

```
version = 2

[plugins]

  [plugins."io.containerd.grpc.v1.cri"]

    [plugins."io.containerd.grpc.v1.cri".containerd]
      default_runtime_name="nvidia"
      [plugins."io.containerd.grpc.v1.cri".containerd.runtimes]

        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.nvidia]
          privileged_without_host_devices = false
          runtime_engine = ""
          runtime_root = ""
          runtime_type = "io.containerd.runc.v2"

          [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.nvidia.options]
            BinaryName = "/usr/bin/nvidia-container-runtime"
```
 

 ### CPU Node Setup

 1. Install Ubuntu Server
 2. Configure Static IP
  ```cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf net ipv4.ip_forward = 1 EOF```
  ```sudo sysctl --system```
 3. ```sudo swapoff -a```
 4. ```sudo apt install apt-transport-https ca-certificates curl software-properties-common```
 5. Docker Installation (Optional)
  
    ```curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg```
  
    ```echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null ```

    ```sudo apt update```

    ```sudo apt-cache policy docker-ce ```

    ```sudo apt install docker-ce```

    ```sudo systemctl status docker```

    ```sudo usermod -aG docker ${USER}```

    ```su - ${USER} ```

    ```sudo nano /etc/modules-load.d/containerd.conf``` 
    
    Add lines:
    ```
    overlay
    br_netfilter
    ```

    ```sudo modprobe overlay```

    ```sudo modprobe br_netfilter```

    ``` sudo nano /etc/containerd/config.toml```

    Add lines:
   
    ```
    enabled_plugins = ["cri"]
    [plugins."io.containerd.grpc.v1.cri".containerd]
      endpoint = "unix:///var/run/containerd/containerd.sock"
      ```

    ```sudo systemctl restart containerd```

 6. Kubectl, kubeadm, kubelet installation

    ```curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg```

    ```sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring```

    ```echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list```

    ```sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly```

    ```sudo apt-get update```

    ``` sudo apt-get install -y kubelet kubeadm kubectl```

    ```sudo apt-mark hold kubeadm kubelet kubectl```

    ```sudo apt-get install -y kubernetes-cni```

    ```sudo nano /etc/default/kubelet```
    
    Add Lines:
    ```
    KUBELET_EXTRA_ARGS="--cgroup-driver=cgroupfs"
    ```

