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

function service_account_exists() {
  local project_id="$1"
  local existing_sa
  existing_sa=$(gcloud iam service-accounts list --project="$project_id" --format="value(name)")

  if [ -z "$existing_sa" ] 
  then
    return 1
  else
    return 0
  fi
}

function project_exists() {
  local project_id="$1"
  local existing_project
  existing_project=$(gcloud projects list --filter=PROJECT_ID="$project_id" --format="value(PROJECT_ID)")

  if [ -z "$existing_project" ] 
  then
    return 1
  else
    return 0
  fi
}

function bucket_exists() {
  local bucket_name="$1"
  local existing_bucket
  existing_bucket=$(gcloud storage buckets list --filter=name="$bucket_name" --format="value(name)")

  if [ -z "$existing_bucket" ] 
  then
    return 1
  else
    return 0
  fi
}

function create_project() {
  local projectId="$1"

  echo "Creating project $projectId"

  if project_exists "$projectId"
  then
      echo "Project $projectId already exists, will not create"
  else
      gcloud projects create "${projectId}" --name="Koenighotze $projectId"
  fi
}

function confirm() {
    local message="${1:-Are you sure?}"

    # call with a prompt string or use a default
    read -r -p "${1:-$message} [y/N]?" response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}