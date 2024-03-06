#!/usr/bin/env bash

# when a command fails, bash exits instead of continuing with the rest of the script
set -o errexit
# make the script fail, when accessing an unset variable
set -o nounset
# pipeline command is treated as failed, even if one command in the pipeline fails
set -o pipefail
# enable debug mode, by running your script as TRACE=1
if [[ "${TRACE-0}" == "1" ]]; then set -o xtrace; fi

source "$(dirname "$0")/common.sh"

# we assume gcloud to be downloaded and initialized
# gcloud init
#gcloud auth application-default login

gcloud auth application-default set-quota-project "$QUOTA_PROJECT"
gcloud config set project "$PROJECT"
if bucket_exists "$STATE_BUCKET"; then
    terraform init -backend-config="bucket=$STATE_BUCKET" $* 
else
    echo "Missing bucket '$STATE_BUCKET'; cannot initialize backend"
    exit 1 
fi
