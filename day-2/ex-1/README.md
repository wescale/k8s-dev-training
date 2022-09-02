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

{
  "kind": "APIResourceList",
  "groupVersion": "v1",
  "resources": [
    {
      "name": "bindings",
      "singularName": "",
      "namespaced": true,
      "kind": "Binding",
      "verbs": [
        "create"
      ]
    },
   (...)
}
```

- Within your pod, try to you use this token to list all the Pods: https://kubernetes.default.svc/api/v1/default/pods
and https://kubernetes.default.svc/api/v1/sa-demo/pods
 
 ```sh
# curl -H "Authorization: Bearer $TOKEN" https://kubernetes.default.svc/api/v1/default/pods --insecure

 "message": "sa-demo \"pods\" is forbidden: User \"system:serviceaccount:default:default\" cannot get resource \"sa-demo\" in API group \"\" at the cluster scope",
 
 # curl -H "Authorization: Bearer $TOKEN" https://kubernetes.default.svc/api/v1/sa-demo/pods --insecure

  "message": "sa-demo \"pods\" is forbidden: User \"system:serviceaccount:default:default\" cannot get resource \"sa-demo\" in API group \"\" at the cluster scope",

 ```

 What do you notice ? > The default service account does not have enough rights to perform this query. 
 => We will create our own ServiceAccount and provide it with the additional rights it needs for this action.

# Customize a Service Account with a Role

A ServiceAccount is not that useful unless certain rights are bound to it. 
What kind of Role do you need ? Role or ClusterRole ?

- Defines a Role allowing to list all the Pods in the your namespace using `role.yaml` file.


- Within your namespace, inside the new Pod, try to you use the token for your new sa to list all the Pods:  
  - https://kubernetes.default.svc/api/v1/namespaces/sa-demo/pods and 
  - https://kubernetes.default.svc/api/v1/namespaces/default/pods
 
 ```sh
 $ kubectl exec -n sa-demo -it ratings -- sh
# apk add --update curl
# TOKEN=$(cat /run/secrets/kubernetes.io/serviceaccount/token)
# curl -H "Authorization: Bearer $TOKEN" https://kubernetes.default.svc/api/v1/ --insecure
# curl -H "Authorization: Bearer $TOKEN" https://kubernetes.default.svc/api/v1/namespaces/sa-demo/pods --insecure
# curl -H "Authorization: Bearer $TOKEN"  https://kubernetes.default.svc/api/v1/namespaces/default/pods --insecure
  ```
What do you notice when you call the api namespaces/default/pods ?
=> Yes got a reason Forbidden when call the api namespaces/default/pods 

What is the solution to solve this ?

- Delete the namespace `kubectl delete ns sa-demo`

