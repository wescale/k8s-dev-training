# Exercise 4

> **TIPS**
> - `helm lint` command will help you to validate your chart.
> - `helm template` command will help you to see the generated kubernetes resources.

## 1. Install Helm 3 and try it

> Objective: Install Helm 3 and use it to install a simple application.

1. Install Helm by following official instructions: https://helm.sh/docs/intro/install/
2. Inspect the provided Helm chart in simpleapp directory.
   - What is the purpose of the `_helpers.tpl` file ?
2. Install the provided Helm chart in simpleapp directory using the appropriate `helm` command.
```sh
helm install my-app ./simpleapp
helm upgrade --install my-app ./simpleapp
```
3. Inspect the installed resources using `kubectl` commands.
   - What is the default image in the helm chart ?
```sh
kubectl get svc,pods,deploy
```
4. Access the service in your browser using the appropriate `minikube service` command.
```sh
minikube service my-app-simpleapp
```
5. Use `helm` commands to lookup installed helm releases.
   - What is the installed chart version ?
   - What is the installed chart app version ?
```sh
helm list
helm status my-app
helm history my-app
```
## 2. Install a customized Helm realease

> Objective: Install a customized version of the helm chart using a values file.

1. Create a values file to override the default image in the Helm chart.
   - Name the file `values-dev.yaml`
   - Set the image to `nginx:1.25`
2. Upgrade the previously installed Helm release using the `dev` values file.
```sh
helm upgrade --install my-app ./simpleapp -f values-dev.yaml
```

## 3. Customize the replicaCount of your deployment

> Objective: Update a helm chart to allow the user to customize the number of replicas.

1. Inspect the `simpleapp` default values file and find the property that controls the number of replicas.
2. Using the previous `values-dev.yaml` file, add a property to set the number of replicas to 2.
3. Upgrade the Helm release using the `values-dev.yaml` values file.
   - Inspect the deployment to verify that the number of replicas has been updated.
4. Find and fix the issue
```yaml
# in day-1/ex-4/simpleapp/templates/deployment.yaml
spec:
  replicas: {{ .Values.replicaCount }}
```
```sh
helm upgrade --install my-app ./simpleapp -f values-dev.yaml
```
## 4. Tests

> Objective: Understand helm tests

1. Inspect the `simpleapp/tests/test-connection.yaml` file
    - What is the purpose of this file ?
    - What command is executed ?
2. Using `helm` commands, run the tests for the deployed release.
```sh
helm test my-app
```
3. Fix the issue in the chart and run the tests again.
```yaml
# in day-1/ex-4/simpleapp/templates/tests/test-connection.yaml
spec:
   containers:
      - name: wget
        image: busybox
        command: ['wget']
        args: ['{{ include "simpleapp.fullname" . }}:{{ .Values.service.port }}']
```
```sh
helm upgrade --install my-app ./simpleapp -f values-dev.yaml
helm test my-app
```
## 5. Fail a deployment

> Objective: Understand how to rollback a failed deployment

1. Create a new values file `values-fail.yaml` to set the image to `nginx:fail`
2. Launch a new release using the `values-fail.yaml` file.
```sh
helm upgrade --install my-app ./simpleapp -f values-fail.yaml
```
3. Access the service in your browser using the appropriate `minikube service` command.
4. Use `helm` commands to lookup installed helm releases.
```sh
helm status my-app
```
5. Use `kubectl` commands to inspect the resources (pods, deployments, replicasets)
```sh
kubectl get pods,deploy,rs
```
7. Use `helm` commands to rollback the failed release to the previous revision.
```sh
helm history my-app
helm rollback my-app <desired revision>
```

## 6. Cleaning

```sh
helm uninstall <REPLACE BY MY APP NAME>
```


## Bonus: play with functions and named templates

> Objectives: Create a template to add environment variables to you chart.
> 
> Doc:  https://helm.sh/docs/chart_template_guide/named_templates/

1. Create a named template to add environment variables to the deployment in the `_helpers.tpl` file.
   - Add the following environment, variables: `KEY_1=VALUE_1`, `KEY_2=VALUE_2`
2. Update the deployment template to use the function to add the environment variables.
```yaml
# in day-1/ex-4/simpleapp/templates/deployment.yaml
spec:
   containers:
      - name: {{ .Chart.Name }}
        env: {{ include "simpleapp.environmentVariables" . | nindent 12 }}

# in day-1/ex-4/simpleapp/templates/_helpers.tpl
{{- define "simpleapp.environmentVariables" -}}
- name: "KEY_1"
  value: "VALUE_1"
- name: "KEY_2"
  value: "VALUE_2"
{{- end}}
```
3. Install the updated chart.
```sh
helm upgrade --install my-app ./simpleapp -f values-dev.yaml
```
4. Inspect the deployment to verify that the environment variables have been added.
```sh
kubectl exec -it pod/<POD_NAME> -- env | grep KEY_
```
