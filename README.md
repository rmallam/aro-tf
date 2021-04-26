- [Terraform Module to create an ARO Cluster](#terraform-module-to-create-an-aro-cluster)
- [Create a service principal](#create-a-service-principal)
- [Retrieve ObjectId](#retrieve-objectid)
- [Retrieve resource provider ID for Red Hat Openshift](#retrieve-resource-provider-id-for-red-hat-openshift)
- [create ARO cluster](#create-aro-cluster)

# Terraform Module to create an ARO Cluster

# Create a service principal

```
az ad sp create-for-rbac --role="Contributor" --name myServicePrincipal
```

These values from the output should be passed to the below variables in Variables.tf file

- value from appID to aro_client_id
- value from password to aro_client_secret

**Output**

```
{
  "appId": "xxxxx-xxxxx-xxxx-xxxx-xxxxxx", 
  "displayName": "myServicePrincipal",     
  "name": "http://myServicePrincipal",
  "password": "xxxxxxxx-xxxxxxx",          
  "tenant": "xxxxx-xxxxx-xxxxxx-xxxxxx-xxxxxxx" 
}
```

This will output the appid/clientid and the client secret that are required for authentication

# Retrieve ObjectId

ObjecctId of the service principal can be retrieved by using the command

```
az ad sp list --display-name `NameprovidedtocreateSP` --query '[].{objectid:objectId}'
```

**Example**

This value should be passed to variable aro_client_object_id in Variables.tf file

```
az ad sp list --display-name myServicePrincipal --query '[].{objectid:objectId}' 
[
  {
    "objectid": "xxxxx-xxxxx-xxxxx-xxxxx-xxxxxxxx"  
  }
]
```

# Retrieve resource provider ID for Red Hat Openshift
Get the resource provider object id for Red Hat OpenShift using the command below.

```
az ad sp list --display-name "Azure Red Hat OpenShift RP" --query '[].{objectid:objectId}' --output table
```

**Example**

This value should be passed to variable aro_rp_object_id in Variables.tf file

```
az ad sp list --display-name "Azure Red Hat OpenShift RP" --query '[].{objectid:objectId}' --output table



Objectid
------------------------------------
xxxxxx-xxxxxx-xxxxxx-xxxxxx-xxxxxx  
```

# create ARO cluster

Update the variables.tf file with the values retrieved above and run

- terraform init
- terraform plan
- terraform apply --auto-approve



