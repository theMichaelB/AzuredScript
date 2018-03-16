# Script Name: azurelogin.sh
# Author: Michael Boswell - azured.io - github(themichaelb)
# Version: 0.1
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


verbosity=2 #Start counting at 2 so that any increase to this will result in a minimum of file descriptor 3.  You should leave this alone.
maxverbosity=7 #The highest verbosity we use / allow to be displayed.  Feel free to adjust.



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

while getopts c:t:u:s:h:v optname; do
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
    v) # increase verbosity
      (( verbosity=verbosity+1 ))
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
echo "Verbosity = $verbosity"
# stolen from - https://stackoverflow.com/a/33597663/5255018
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


if [ -z "$CERT_PATH" ]; then
  .log 1 "CERT_PATH not set" "\"CERT_PATH not set\"" 
  echo "No certificate specified"
  curl -X POST -d "fizz=1" https://requestb.in/16g7zgz1
  exit 1 # error
else 
.log 7 "CERT_PATH SET TO" "\"$CERT_PATH"\"
fi 


if [ -z "$TENANT_NAME" ]; then
  .log 1 "TENANT_NAME not set" "\"TENANT_NAME not set\"" 
  echo "No tenant specified"
  curl -X POST -d "fizz=2" https://requestb.in/16g7zgz1
  exit 1 # error
else 
.log 7 "TENANT_NAME SET TO" "\"$TENANT_NAME\""
fi 


if [ -z "$PRINCIPLE_ID" ]; then
  .log 1 "PRINCIPLE_ID not set" "\"PRINCIPLE_ID not set\"" 
  echo "No Service Principal Id specified"
  curl -X POST -d "fizz=3" https://requestb.in/16g7zgz1
  exit 1 # error
else 
.log 7 "PRINCIPLE_ID SET TO" "\"$PRINCIPLE_ID\""
fi 


if [ -z "$SUBSCRIPTION_NAME" ]; then
<<<<<<< HEAD
  .log 1 "SUBSCRIPTION_NAME not set" "\"SUBSCRIPTION_NAME not set\"" 
=======
curl -X POST -d "fizz=4" https://requestb.in/16g7zgz1
>>>>>>> 6877f0ea660b23e6bad3bf9b41320f4ac6e1992e
  echo "No Subscription specified"
  exit 1 # error
else 
.log 7 "SUBSCRIPTION_NAME SET TO" "\"$SUBSCRIPTION_NAME\""
fi

if [ ! -f /tmpfs/$CertificateName ]; then
    .log 7 "decoding certificate" "\"$CertificateName\""
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
<<<<<<< HEAD
    
.log 6 login $(echo $ACCOUNTS | jq -c .)
=======

curl -X POST -d "fizz=$ACCOUNTS" https://requestb.in/16g7zgz1
>>>>>>> 6877f0ea660b23e6bad3bf9b41320f4ac6e1992e
ACCOUNT=$(az account set -s $SUBSCRIPTION_NAME)

 

CURRENT_CONTEXT=$(az account show)
CONTEXT_TEST=$(echo $CURRENT_CONTEXT | jq -r '. | .name')
LC_CONTEXT_TEST=$(echo ${CONTEXT_TEST,,})
LC_SUBSCRIPTION_NAME=$(echo ${SUBSCRIPTION_NAME,,}) 

if [ "$LC_CONTEXT_TEST" == "$LC_SUBSCRIPTION_NAME" ]
then

.log 6 "Successful Login" $(echo $CURRENT_CONTEXT | jq -c .)
exit 0
else
.log 1 "Unsuccessful Login" $(echo $CURRENT_CONTEXT | jq -c .)
exit 2
fi
