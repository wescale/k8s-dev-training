# Exercise 3

## PodSpec focus

1. Deploy the current folder to your Minikube cluster **with kubectl** (not VSCode)
2. Investigate the deployed objects and fix errors

Questions:
1. How do you see the logs of an init container?
2. Note the "Pod name" displayed, then scale the deployment to 2 replicas and observe again the "Pod name". How do you explain the value?


### Cleaning

```sh
kubectl delete -f .
```

## Remote IDE

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://shell.cloud.google.com/cloudshell/open?cloudshell_git_repo=https://github.com/wescale/k8s-dev-training.git&cloudshell_tutorial=tutorial.md&show=ide%2Cterminal&cloudshell_git_branch=main&cloudshell_workspace=day-1/ex-3/)