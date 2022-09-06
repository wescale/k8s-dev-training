# Exercise 2

The goal of this exercise is to discover how you can access secrets from an external source directly from a Kubernetes cluster.

To do that, a Cloud SQL postgres database has been provisioned on your GCP project. The credentials to access this database are stored in a Secret Manager secret called `training-database-credentials`.

We will see how we can retrieve these credentials and use them to connect to the Cloud SQL database from a pod inside the cluster.

*NB: Be careful of the content of the files. There might be some things to change in order to make it work.*


# Install the secrets-store-csi-driver

- Install helm
```
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

- Install the secrets-store-csi driver using Helm
```
helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts
helm install csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver --namespace kube-system
```

- Install the csi plugin for GCP
```
kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/secrets-store-csi-driver-provider-gcp/main/deploy/provider-gcp-plugin.yaml
```

- Check that pods are correctly running in the **kube-system** namespace
- How many pods do you see ?
> 3 of each
- Why do we have that amount ?
> Pods are deployed with Daemonsets
- What is it used for ?
> Kubernetes needs to mount the secret into files stored on the pod node


- Deploy the secretProviderClass object from the `secretProviderClass.yaml` file
- What is defined in this object ?
> Secrets and paths that will be usable by pods on the `wsc-training-db` namespace



# Deploy a test pod and retrieve the database credentials

- Create a new namespace called `wsc-training-db`

- Check the `pod-sa.yaml` file. Do you notice something ? What do you think this is used for ?
> There is an annotation to specify the GCP service account to be used to give permissions to the pod

- Deploy the service account

- Check the **volumes** and **volumeMounts** sections of the `pod.yaml` file and try to understand what they do.
> Use the secrets-store-csi-driver to retrieve the secrets and mount it as a volume. We also have the secretProvider class specified in the `volumeAttributes` section

- Deploy the pod

- Connect to the pod and look what is inside the mounted file
    ```
    kubectl exec -n wsc-training-db -it wsc-db-client -- sh
    ```

- Use these credentials to connect to the Cloud SQL postgres instance
    ```
    psql postgresql://training:<PASSWORD>@<IP>/postgres -c 'select 1'
    ```

- Delete the `wsc-training-db` namespace
