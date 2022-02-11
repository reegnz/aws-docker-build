#!/usr/bin/env sh

./aws-creds.py > "$HOME/.aws/credentials-$AWS_PROFILE"

export DOCKER_BUILDKIT=1
docker build \
  --progress=plain \
  --secret id=aws,src="$HOME/.aws/credentials-$AWS_PROFILE" \
  -t reegnz/awscredstest:latest .
