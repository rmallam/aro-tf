# aro-tf
terraform plans for ARO

#Create a service principal

az ad sp create-for-rbac --role="Owner" --name myServicePrincipal

#this will output the appid/clientid and the client secret that are required for authentication

#Retrieve the objectid of the service principal using the appid(Appid is in the output of the above command)

az ad sp list --display-name `appid` --query '[].{objectid:objectId}'

#get the resource provider object id for Red Hat OpenShift using the command below.

az ad sp list --display-name "Azure Red Hat OpenShift RP" --query '[].{objectid:objectId}' --output table

#Update the variables.tf file or pass these values at the time of execution.

terraform init
terraform plan
terraform apply --auto-approve



