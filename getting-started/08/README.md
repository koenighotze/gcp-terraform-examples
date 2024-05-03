# Number 7

Again webservers. Change here is, that we'll drop one backend per subnet.
Each subnet will host one backend. The number of instances per MIG is configurable.

_Note_: this is not good practise on GCP. Use GCS or something else to host websites :D

## TODO list

- Introduce packer for building the instance templates
- number of subnets dynamic
- number of mig instances dynamic
- number of backends dynamic (same as subnets)
