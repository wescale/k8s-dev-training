# Liquibase Demo

Clone the repository on the bastion
```
git clone -b solution https://github.com/wescale/kubernetes-dev-training

cd kubernetes-dev-training/day-2/demo-liquibase
```


Show changelog files
  - Root changelog that is including all the changes from the `changes` folder
  - `001_create_table` that creates a new table
  - `002_alter_column` that adds an additional column to the table
  - `003_alter_column` that adds a lookup table called state


Show dockerfile and the scripts
  - Dockerfile base is liquibase official image. We just tweak it to pass the configuration
  - Add the changelog files and the scripts to be executed from inside the pod
  - Temporarily change user to give the right permissions
  - Change ENTRYPOINT and CMD to use the script
  - Image is already pushed to dockerhub (docker.io/rdavaze/liquibase-postgres:4.15.0)


Show the chart in the `chart` directory and explain it
  - We use the same objects as the second exercise
  - Credentials are passed via the CSI Secret Store like in exercise 2
  - We just source them before launching the migration in the `start.sh` and `rollback.sh` scripts
  - We have a job for schema migration that will be triggered at the `pre-upgrade` phase (explain the annotations & spec)
  - We have a job for schema migration that will be triggered at the `pre-rollback` phase (explain the annotations & spec)
  - Show the `Chart.yaml` and `values.yaml` files
  

Install the chart
```
helm install demo-liquibase ./chart -n wsc-training-db -f /chart/values.yaml --create-namespace
```

Check that the pod is running
```
kubectl get po -n wsc-training-db
```

Open a second terminal to watch pods being created
```
watch kubectl get po -n wsc-training-db
```

Launch an upgrade
```
# Change the applicationVersion to 1.0.3

# Perform the upgrade
helm upgrade demo-liquibase /chart -n wsc-training-db -f /chart/values.yaml
```

Watch pods being created

Show the logs of the upgrade job
```
kubectl logs job/demo-liquibase-db-upgrade -n wsc-training-db
```

Connect to the main pod and show the changes are applied successfully
```
kubectl exec -it demo-liquibase -n wsc-training-db -c demo-liquibase -- sh

# Retrieve connection information
source /var/secrets/value

# Connect to the database
psql postgresql://training:$password@$ip/postgres

# Show the two tables person and state
\dt

# Show the structure of the two tables
\d+ person
\d+ state

# Show the changelog
SELECT * FROM databasechangelog;
# Show Liquibase tags for the restore operation
SELECT filename,description,tag FROM databasechangelog;
```

Show the `schemaMigration.rollback.tag` value in the chart and how it is passed to the rollback job
Rollback the helm release
```
helm rollback demo-liquibase -n wsc-training-db
```

Show the job logs
```
kubectl logs job/demo-liquibase-db-rollback -n wsc-training-db
```

Check that the rollback went well (on the pg client pod)
```
# The lookup table disappeared
\dt

# The username column from the person table is not here anymore
\d+

# We only have one tag now
SELECT * FROM databasechangelog;
```
