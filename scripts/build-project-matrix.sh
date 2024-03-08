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

#CHANGE_SET=$(git diff --name-only "$GITHUB_SHA" | grep getting | cut -d/ -f1-2 |uniq)

CHANGES_SINCE_LAST_COMMIT=$(git diff-tree --no-commit-id --name-only -r HEAD)
echo "Files changed $CHANGES_SINCE_LAST_COMMIT"

PROJECT_DIRECTORIES="$(find ./getting-started -maxdepth 1 -mindepth 1 -type d -print0 | xargs -0 -I{} echo -n '{},' | sed -e 's/,$//' | jq -R -c 'split(",")')"

echo "project_directories=${PROJECT_DIRECTORIES}"