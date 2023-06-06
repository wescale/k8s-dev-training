# Exercise 1

Following steps must be executed on your local computer.

## Installation of Podman

1. Go to https://podman.io/getting-started/installation#installing-on-linux and follow installation steps
2. Find the command to launch a Pod using pod.yaml description file
```
# Podman version 3.4.4
podman play kube pod.yaml
```

Questions:

1. Where is launched the _productpage_ container?
2. How do you display corresponding logs?
```
podman pod ps
podman pod logs bookinfo
```

### Cleaning

```
podman pod stop bookinfo
podman pod rm bookinfo
```

## Installation of Minikube

1. Go to https://minikube.sigs.k8s.io/docs/start/ and follow from step 1 to 3
2. Type `docker ps` and explain what is running
3. Type `kubectl get nodes` to check how is distributed your cluster
4. Launch a Pod with the image hello-world once (without restart) using one command line
```
kubectl run hello-world --image=hello-world --restart=Never
```
5. Deploy the preceding pod.yaml file
```
kubectl apply -f pod.yaml
```

Questions:

1. Where is launched the corresponding container?
```
docker exec minikube docker ps -a
```
2. How do you display corresponding logs?
```
kubectl logs bookinfo
```
