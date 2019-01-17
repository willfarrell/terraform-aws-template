# Bastion Docs
Connecting to services in your AWS VPC.

## IAM
### Generate Key
Run [script](https://gist.github.com/willfarrell/e9b7553367f5edca0ac7e0b8e9647a040) or see below
```bash
# Amazon only accepts RSA Keys
$ ssh-keygen -q -t rsa -b 4096 -o -N '' -C "Your Device Name Here" -f ~/.ssh/id_rsa
$ ssh-add ~/.ssh/id_rsa
```

### Upload to AWS
Copy your key contents:
```bash
$ cat ~/.ssh/id_rsa.pub
```

Go to `https://console.aws.amazon.com/iam/home?#/users/username?section=security_credentials`. 

Press `Upload SSH public key`.

Paste contents in and press `Upload SSH public key`.

### AWS Config
You should have the proper access keys in your `~/.aws/credentials` file. They should follow the below pattern.
```bash
# ~/.aws/credentials
[${name}]
aws_access_key_id = 
aws_secret_access_key = 

[${name}-${workspace}]
source_profile = ${name}
role_arn = arn:aws:iam::${SUB_ACCOUNT_ID}:role/admin
session_name = ${name}-${workspace}
```

## SSH
Keep your ssh configs clean, used `config.d`.
**~/.ssh/config**
```bash
Include config.d/*
```

**~/.ssh/config.d/example**
```bash
### Company Name (cn) ###

# ssh -N cn-proxy-${environment}
Host cn-proxy-${environment}
  HostName ${BASTION_IP}
  IdentityFile ~/.ssh/id_rsa
  User ${USERNAME}
  ControlPath /tmp/ssh_cn-proxy-${environment}
  LocalForward 3307 mysql-test.*****.us-east-1.rds.amazonaws.com:3306
  LocalForward 5432 postgres-test.*****.us-east-1.rds.amazonaws.com:5432
  LocalForward 6378 redis-test.*****.0001.use1.cache.amazonaws.com:6379
  # TODO elasticsearch example
  # TODO Private ALB example

Host cn-bastion-${environment}
  HostName ${BASTION_IP}
  IdentityFile ~/.ssh/id_rsda
  User ${USERNAME}
  ControlPath /tmp/ssh_cn-bastion-${environment}

Host cn-${environment}-*
  ProxyCommand ssh -W %h:%p cn-bastion-${environment}
  IdentityFile ~/.ssh/id_rsa
  User ${USERNAME}
  
Host cn-${environment}-nat
  HostName ${PRIVATE_IP}
```

## SSM
Install the Session Manager Plugin for the AWS CLI - https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html

To start new shell session from aws cli
```bash
$ aws ssm start-session --target i-00000000000000000 --region ca-central-1 --profile ${name}
```
