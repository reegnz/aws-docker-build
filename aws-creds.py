#!/usr/bin/env python3
# shim to get AWS creds from the default credential chain so we can inject
# AWS credentials into processes that don't allow using it (eg. docker build)

import boto3

# Utilize the default credential chain to get a Session
session = boto3.Session()

creds = session.get_credentials()
creds = creds.get_frozen_credentials()

# Expose the session as shell variables
print (f"[default]")
print(f"aws_access_key_id={creds.access_key}")
print(f"aws_secret_access_key={creds.secret_key}")
print(f"aws_session_token={creds.token}")
