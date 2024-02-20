# Scenario Simple Web Server

A simple webserver running NGINX. The webserver is exposed to the public internet, only via port 80. Outbound is unrestricted.

## Components

-  VPC, Subnet
-  Compute Engine with NGINX running

gcloud compute networks create manual-vpc --project=terraform-examples-398addce --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional && gcloud compute networks subnets create manual-subnet --project=terraform-examples-398addce --range=10.0.0.0/24 --stack-type=IPV4_ONLY --network=manual-vpc --region=europe-west3


