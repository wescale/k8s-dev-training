#!/bin/bash

# Update the package list and install the Cloud SDK
apt-get update && apt-get install -y nano unzip git xsel jq apt-transport-https ca-certificates gnupg

# Add the Cloud SDK distribution URI as a package source
echo "deb [signed-by=/etc/apt/trusted.gpg.d/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

# Import the Google Cloud Platform public key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg -O
gpg --dearmor -o cloud.google.gpg apt-key.gpg
rm apt-key.gpg
mv cloud.google.gpg /etc/apt/trusted.gpg.d/cloud.google.gpg

# Update the package list and install the Cloud SDK
apt-get update && apt-get install -y kubectl google-cloud-sdk-gke-gcloud-auth-plugin

gcloud config set compute/zone europe-west1-b

cat <<EOF > /tmp/get-credential-cluster-$1.sh
#!/bin/bash

until gcloud container clusters list | grep RUNNING
do
    echo "Wait for cluster provisionning"
    sleep 1
done

USE_GKE_GCLOUD_AUTH_PLUGIN=True gcloud container clusters get-credentials "training-cluster-$1" --zone europe-west1-b

#kubectl proxy --address="0.0.0.0" --accept-hosts='.*' &

EOF

chmod +x /tmp/get-credential-cluster-$1.sh





