#!/usr/bin/env bash

# when a command fails, bash exits instead of continuing with the rest of the script
set -o errexit
# make the script fail, when accessing an unset variable
set -o nounset
# pipeline command is treated as failed, even if one command in the pipeline fails
set -o pipefail

export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`
echo "deb [signed-by=/usr/share/keyrings/cloud.google.asc] https://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo tee /usr/share/keyrings/cloud.google.asc
sudo apt-get update
sudo apt-get install -y gcsfuse nginx

mkdir -p /tmp/website-content
gcsfuse website-ex-06-838540 /tmp/website-content
sudo cp -rvf /tmp/website-content/* /var/www/html/
sudo sed -e "s,nginx,${hostname}," < /usr/share/nginx/html/index.html > /tmp/index.html
sudo mv /tmp/index.html /var/www/html/index.html

sudo systemctl start nginx
sudo systemctl enable nginx
