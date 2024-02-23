#!/usr/bin/env bash
# shellcheck disable=SC1091
# when a command fails, bash exits instead of continuing with the rest of the script
set -o errexit
# make the script fail, when accessing an unset variable
set -o nounset
# pipeline command is treated as failed, even if one command in the pipeline fails
set -o pipefail
# enable debug mode, by running your script as TRACE=1
if [[ "${TRACE-0}" == "1" ]]; then set -o xtrace; fi

source "$(dirname "$0")/common.sh"


PROJECT_ROOTS=(
    getting-started/03
)

checkov --quiet -d .
terraform fmt -check -recursive

CURRENT=$PWD
for i in "${PROJECT_ROOTS[@]}"
do
    cd $CURRENT
    cd $i
    tflint --init 
    tflint -f compact --disable-rule=terraform_module_pinned_source --disable-rule=terraform_required_providers --recursive
    terraform validate -no-color 
done

