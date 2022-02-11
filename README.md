# Using AWS CLI in Dockerfiles

You run it with:

```sh
AWS_PROFILE=my_profile ./build.sh (edited) 
```

## Reasoning

It is quite challenging to build docker images where the docker build relies
on tools utilizing the AWS SDK.

Usually they use the default credential chain, but a lot of credential
providers don't work as expected during a docker build.

* Shared credentials file cannot be used because you cannot mount a volume
  during a docker build.
* Because you cannot mount a volume during a docker build
  * your aws config file won't work 
  * credential_process won't work
  * shared credentials file don't work
  * web identity token file don't work

Because of that, your only options are:

* If you have IAM User credentials, you set AWS_ACCESS_KEY_ID and 
  AWS_SECRET_ACCESS_KEY environment variables (not great, as you shouldn'the
  use those directly, but create a session instead and use session creds)
* You run a mock instance metadata server and alias 169.254.169.254 to your
  localhost and have the SDK pick it up from there
* You render a shared credentials file and mount it with buildkit

No. 1 has the issues that build args show up in the docker image history,
therefore you're leaking keys.
No. 2 is quite difficult to achieve, but has the advantage of working with old
docker builds without buildkit.

I went with No. 3, the buildkit approach.

The `aws-creds.py` is using your default credential chain to fetch the session
credentials. These credentials are then injected into the docker build using
a secret mount.
