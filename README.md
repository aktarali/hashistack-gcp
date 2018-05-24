# google-hashistack
Google cloud hashistack

Full hashistack working deployment for Google Cloud.

1: Add credentials file: gce-credentials.json inside providers/google/ dir

2: Add google project name and subnet CIDR info into variable.tf

3: Change the vault_cluster_name to something that is unique to you. IMPORTANT - This value will also be used for google Bucket name. This must be unique.

4: Change line 4 in providers/google/examples/nomad-consul-image/nomad-consul.json to match the vault_cluster_name you have set above.

cd providers/google/examples/nomad-consul-image and run
   #packer build nomad-consul.json
   
3: Once image has been built, take image name and add the image name to variable.tf.

4: terraform init

5: terraform plan -out `date +"$YourProject_Name.%m-%d-%Y.%H-%M.tfstate"`

6: terraform apply the above state file.

DONE.
