# Exercise 5

In this exercise you will see how to watch pod logs and how to centralize them with tools like Loki and Grafana

Check the resources created

# Pod logs


With the **kubectl** command, print the logs of the grafana pod in real time

Log into Grafana and navigate through the dashboards : http://grafana.wsc-cnd-dev-k8s-X.wescaletraining.fr/

Check the logs again. What do you see ?
> We see access logs being printed

Delete the grafana pod and check the logs of the new one that spawns.

What happened to your previous access logs ?
> They disappeared
What is the solution to avoid that ?
> Centralized the logs on an external platform

# Loki

## Install


Create a `logging` namespace
```
kubectl create ns logging
```

Install the [loki-stack](https://github.com/grafana/helm-charts/tree/main/charts/loki-stack) helm chart in the logging namespace
```
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install loki grafana/loki-stack -n logging
```

Check the resources created

What kind of pods do you see ? What might be their respective role ?
> Promtail (collect logs) & Loki (Store logs and expose a query API)


## Watch logs on Grafana


On Grafana go to `Settings => Data Sources` and add Loki as the datasource (*tip: use the internal dns name for the address*)
> Set the address to http://loki.logging.svc.cluster.local:3100

Go to the explore tab and select Loki as the datasource

Make a query to display Grafana logs
> Select pod=kube-prometheus-stack-grafana-xxx and execute the query

Click on a log line and inspect what appears. Can you explain the data that shows up ?
> We have labels that are set dynamically by promtail when collecting the logs and fields that are automatically detected by Loki by parsing the log

Make a new query to only display the logs of the grafana container of the grafana pod containing the word `dashboard` in the last 30 minutes.
> Select pod=kube-prometheus-stack-grafana-xxx, container=grafana, line contains "dashboard" and select last 30 minutes on the top right

## Cleanup

Delete the `logging` namespace
