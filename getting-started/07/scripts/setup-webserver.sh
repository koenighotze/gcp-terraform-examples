#!/usr/bin/env bash

# when a command fails, bash exits instead of continuing with the rest of the script
set -o errexit
# make the script fail, when accessing an unset variable
set -o nounset
# pipeline command is treated as failed, even if one command in the pipeline fails
set -o pipefail

sudo apt-get update
sudo apt-get install -y nginx

TMP_DIR=/tmp/website-content
NGINX_DOC_DIR=/var/www/html

mkdir -p "$TMP_DIR"/
# shellcheck disable=SC2154
gsutil cp "${bucket_url}"/* "$TMP_DIR"/
sudo cp -rvf "$TMP_DIR"/* "$NGINX_DOC_DIR"/

find "$TMP_DIR" -name "*.html" -print0 | while IFS= read -r -d '' file
do
  sudo sed -e "s,instance_name,$HOSTNAME," "$file" | sudo tee "$NGINX_DOC_DIR/$(basename "$file")" > /dev/null
done

sudo systemctl start nginx
sudo systemctl enable nginx
