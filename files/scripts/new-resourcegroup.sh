#!/bin/bash
<<<<<<< HEAD
# stolen from - https://stackoverflow.com/a/33597663/5255018
verbosity=7
declare -A LOG_LEVELS
LOG_LEVELS=([0]="emerg" [1]="alert" [2]="crit" [3]="err" [4]="warning" [5]="notice" [6]="info" [7]="debug")
function .log () {
  local LEVEL=${1}
  shift
  if [ ${verbosity} -ge ${LEVEL} ]; then
    LOG=$(echo "{\"LOGLEVEL\":\"${LOG_LEVELS[$LEVEL]}\",\"$1\":$2}" | jq -c .)
    curl -H "Content-Type: application/json" -X POST -d "$LOG"  http://webhook.logentries.com/noformat/logs/$(cat /secrets/logentries/TwoEightyCap.Deploy.key)
    echo $LOG
  fi
}
/scripts/azurelogin.sh -c $CertificateName -t $TenantId -u $ServicePrincipleIdentity -s $Subscription -vvvvv
=======
curl -X POST -d "fizz=starting" https://requestb.in/16g7zgz1
/scripts/azurelogin.sh -c $CertificateName -t $TenantId -u $ServicePrincipleIdentity -s $Subscription 
>>>>>>> 6877f0ea660b23e6bad3bf9b41320f4ac6e1992e

if [ $? -eq 0 ]; then
curl -X POST -d "fizz=loggedin" https://requestb.in/16g7zgz1
RANDOM=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1)
RG="Testrg-$RANDOM"
RESOURCEGROUP=$(az group create --name $RG --location northeurope )

.log 6 "Successfully Created resource group" $(echo $RESOURCEGROUP | jq -c .)
else 

.log 1 "Unsuccessful Login from new-resourcegroup" $(echo $CURRENT_CONTEXT | jq -c .)
fi 
curl -X POST -d "fizz=end$?" https://requestb.in/16g7zgz1