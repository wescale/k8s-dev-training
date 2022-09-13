# Liquibase Demo

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


Show `manifests.yaml` file and explain it
  - We use the same objects as the second exercise
  - The difference is that we have an init container that does the DB migration
  - Credentials are passed via the CSI Secret Store like in exercise 2
  - We just source them before launching the migration in the `start.sh` script


Apply the manifests file
```
kubectl apply -f manifests.yaml
```

Check that the pod is running and that it is in init state
```
kubectl get po -n wsc-training-db
```

Show the logs of the init container
```
kubectl logs demo-liquibase -n wsc-training-db -c db-migration -f
```

Connect to the main pod and show the changes are applied successfully
```
kubectl exec -it demo-liquibase -n wsc-training-db -c mypod -- sh

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

Show the job spec in `job-rollback.yaml` file to apply the rollback

Open a new terminal and deploy the job
```
kubectl apply -f job-rollback.yaml
```

Show the job logs
```
kubectl logs job/db-rollback -n wsc-training-db -f
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
