# Exercise 3

## PodSpec focus

1. Deploy the current folder to your Minikube cluster **with kubectl** (not VSCode)
2. Investigate the deployed objects and fix errors
    1. Mode privileged not authorized by 
    2. sleep 3600 block the main container start
    3. imagePullPolicy: Never cannot download the image
    4. readiness /health does not exist
  

Questions:
1. How do you see the logs of an init container?
2. Note the "Pod name" displayed, then scale the deployment to 2 replicas and observe again the "Pod name". How do you explain the value?


### Cleaning

```sh
kubectl delete -f .
```
