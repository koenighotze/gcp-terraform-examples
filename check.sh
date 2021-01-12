#!/usr/bin/env bash
docker run -t -v $(PWD):/tf bridgecrew/checkov --framework terraform -d /tf
