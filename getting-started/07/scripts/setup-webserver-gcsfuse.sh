#!/usr/bin/env bash

# when a command fails, bash exits instead of continuing with the rest of the script
set -o errexit
# make the script fail, when accessing an unset variable
set -o nounset
# pipeline command is treated as failed, even if one command in the pipeline fails
set -o pipefail

TMP_DIR=/tmp/website-content
NGINX_DOC_DIR=/var/www/html

GCSFUSE_REPO=gcsfuse-$(lsb_release -c -s)
export GCSFUSE_REPO
echo "deb [signed-by=/usr/share/keyrings/cloud.google.asc] https://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo tee /usr/share/keyrings/cloud.google.asc
sudo apt-get update
sudo apt-get install -y gcsfuse nginx

mkdir -p "$TMP_DIR"
# shellcheck disable=SC2154
gcsfuse "${bucket_name}" "$NGINX_DOC_DIR"
# sudo cp -rvf "$TMP_DIR"/* "$NGINX_DOC_DIR"/
# shellcheck disable=SC2154
# echo "s,nginx,${hostname}," | sudo sed -e /usr/share/nginx/html/index.html | sudo tee /tmp/index.html > /dev/null
# sudo mv /tmp/index.html "$NGINX_DOC_DIR"/index.html

sudo systemctl start nginx
sudo systemctl enable nginx
