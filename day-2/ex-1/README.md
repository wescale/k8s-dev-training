# Exercise 1

This exercise aims to configure a ServiceAccount for Pods and accessing the API Server From a Pod

A lot of applications that run in the cluster (read: running in Pods), need to communicate with the API server.
For example, some applications might need to know:

- The status of the cluster’s nodes.
- The namespaces available.
- The Pods running in the cluster, or in a specific namespace.
...

# Deploy a Pod running with a dedicated Service Account

- Create a namespace with `kubectl create namespace sa-demo` 
- Deploy the provided `pod.yaml` in this namespace (you may have to fix it) 
- Look into the container to see how the information of the ServiceAccount is mounted, through the usage of volume, in `/var/run/secrets/kubernetes.io/serviceaccount`
- Try from the container to get information from the API server without authentication.
  `curl -k https://kubernetes.default.svc/api/v1`
  What do you notice ?
- Try from the container to do the same call using the ServiceAccount token
```sh
TOKEN=$(cat /run/secrets/kubernetes.io/serviceaccount/token)
curl -k -H "Authorization: Bearer $TOKEN" https://kubernetes.default.svc/api/v1
```
- Try to you use this token to list all the Pods 
  - inside the default namespace: https://kubernetes.default.svc/api/v1/namespaces/default/pods
  - inside the current namespace: https://kubernetes.default.svc/api/v1/namespaces/sa-demo/pods

What do you notice ?

# Customize a Service Account with a Role

A ServiceAccount is not that useful unless certain rights are bound to it. 
What kind of Role do you need ? Role or ClusterRole ?

- Defines a Role allowing to list all the Pods in the your namespace using `role.yaml` file.


- Within your namespace, inside the new Pod, try to you use the token for your new sa to list all the Pods:  
  - https://kubernetes.default.svc/api/v1/namespaces/sa-demo/pods and 
  - https://kubernetes.default.svc/api/v1/namespaces/default/pods
 
What do you notice when you call the api namespaces/default/pods ?
What is the solution to solve this ?

- Delete the namespace `kubectl delete ns sa-demo`

