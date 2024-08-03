helm repo add ollama-helm https://otwld.github.io/ollama-helm/
helm repo update
helm upgrade ollama ollama-helm/ollama --namespace ollama --values kubernetes-deployment/ollama-deployment/values.yaml
