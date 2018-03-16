#!/bin/bash

/scripts/azurelogin.sh -c $CertificateName -t $TenantId -u $ServicePrincipleIdentity -s $Subscription 

if [ $? -eq 0 ]; then
RANDOM=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1)
RG="Testrg-$RANDOM"
az group create --name $RG --location northeurope 
fi 
