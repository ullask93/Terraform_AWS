# Terraform_AWS

## Remote state storage and state locking
- Create an S3 bucket with name "tf-state-assign". Enable versioning for the bucket
- Create a Dynomodb table - "tf-state-table" with partition key - "LockID"
- Generate ssh key in the local machine

## Commands
- ```terraform init```
- ```terraform plan```
- ```terraform apply```
