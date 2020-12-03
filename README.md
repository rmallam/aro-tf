# aro-tf
terraform plans for ARO

#Create a service principal

az ad sp create-for-rbac --role="Owner" --name myServicePrincipal

#this will output the appid/client id and the client secret that are required for authentication

#Get the object id of the service principal using the appid

az ad sp show --id $appid | grep objectId

#Update the variables.tf file or pass these values at the time of execution.

terraform init
terraform plan
terraform apply --auto-approve



