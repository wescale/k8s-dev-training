
# Install Litmus


Install Litmus using Helm
```
helm repo add litmuschaos https://litmuschaos.github.io/litmus-helm/

helm install chaos litmuschaos/litmus --namespace=litmus --create-namespace
```

Look at what is deployed in the `litmus` namespace


# Access the UI

Enable the port-forward on the frontend pod from the bastion instance
```
IP=$(ip a show ens4 | awk -F ' *|:' '/inet /{print $3}' | cut -d / -f1)
kubectl port-forward svc/chaos-litmus-frontend-service -n litmus 9091:9091 --address $IP
```

On an another terminal, open an SSH tunnel from your laptop
```
ssh -L 9091:bastion.cnd-X.wescaletraining.fr:9091 -i kubernetes-formation training@bastion.cnd-X.wescaletraining.fr
```

Access the UI with your browser (credentials are `admin / litmus`)


Look again at what is deployed in the `litmus` namespace as well as the new CRDs installed with the chart


# Your first scenario

Explore the different tabs.
What is the Chaos Delegates ? What's its role ?
How would you define a ChaosHub ? Browse through the experiments and see what is available.

Go to the `Chaos Scenarios` tab and launch your first scenario
 - Pre-defined scenario templates -> `Podtato-head`
 - Schedule now
 - View the YAML defining your scenario
 - Launch the scenario
 - Watch what is going on through the UI and on the cluster itself with the `watch kubectl get pods -n litmus` command
 - Do you see what kind experiment is launched ? Can you explain what is happening ?


# Create your custom scenario

As a bonus, you can try to build your own scenario using the existing experiments from the ChaosHub

What experiments did you choose ? What did you expect to happen ? Did it happen ?
