#!/bin/bash
curl -X POST -d "fizz=starting" https://requestb.in/16g7zgz1
/scripts/azurelogin.sh -c $CertificateName -t $TenantId -u $ServicePrincipleIdentity -s $Subscription 

if [ $? -eq 0 ]; then
curl -X POST -d "fizz=loggedin" https://requestb.in/16g7zgz1
RANDOM=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1)
RG="Testrg-$RANDOM"
az group create --name $RG --location northeurope 
fi 
curl -X POST -d "fizz=end$?" https://requestb.in/16g7zgz1