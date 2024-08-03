helm repo add open-webui https://helm.openwebui.com/
helm repo update
helm upgrade --install open-webui open-webui/pipelines --namespace ollama --values kubernetes-deployment/open-webui/pipelines/values-pipelines.yaml
helm upgrade --install open-webui open-webui/open-webui --namespace ollama --values kubernetes-deployment/open-webui/values.yaml
