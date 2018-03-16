#!/bin/bash
/scripts/azurelogin.sh -c $CertificatePath -t $TenantId -u $ServicePrincipleIdentity -s $Subscription

RETURN_CODE=$?

echo $RETURN_CODE
