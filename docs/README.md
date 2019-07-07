# Infrastructure

## Accounts

Name        | Account ID   | Colour | Root Email         |
------------|--------------|--------|--------------------|
master      |              | ---    |                    |
operations  |              | Blue   |                    |
production  |              | Red    |                    |
staging     |              | Orange |                    |
testing     |              | Yellow |                    |
development |              | Green  |                    |
forensics   |              | Purple |                    |

## Project Structure

```bash
${project}-infrastructure
|-- package.json	# Script shortcuts (lint, install, deploy, test) & versioning?
|-- amis            # Collection of AMIs, built by Packer
|   |-- {name}      # AMI files
|-- master			# Setup for root level account
|   |-- state		# Sets up state management for terraform
|   |-- account     # Account setup (Groups, Monitoring)
|   |-- users		# IAM Users
|-- operations		# Setup for operation pieces
|   |-- account     # Account setup (Roles, Monitoring)
|   |-- cicd		# Jenkins
|   |-- dns			# Route53
|   |-- logging		# ELK & CloudWatch
|   |-- secrets		# HashiCorp Vault
|-- environments
|   |-- account     # Account setup (Roles, Monitoring)
|   |-- app			# Public static assets
|   |-- api			# Public/Private API endpoints and support infrastructure (cache, events, lambda)
|   |-- db			# Databases
|   |-- ops     	# Ops dashboards
|   |-- vpc			# VPC & Networking
|-- modules			# Collection of project specific modules
```

## Getting Started

### Installing CLIs
```bash
$ brew install terraform

# Optional, for building AMIs
$ brew install packer
```

- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-macos.html)
- [AWS SSM Plugin](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html)
- [AWS ECS CLI](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_CLI_installation.html)

### Setup Terraform Workspaces
To create the workspaces, go to the respective subfolder (`/environments/*/`), and run:

```bash
$ terraform init
$ terraform workspace new production
$ terraform workspace new staging
$ terraform workspace new testing
$ terraform workspace new development
```

Ensure you have the right workspace selected before you `apply`.

```bash
$ terraform workspace select development
$ terraform workspace list
```

### Setup Multi-Accounts
See [docs](./docs/Multi Account Setup.md) for detailed steps.

### Build AMIs
To create the AMIs, go to the respective subfolder (`/amis/*/`), edit the `variables.json`, and run:
```bash
$ packer build -var-file=variables.json ami.json
```

See [docs](./docs/AMIs.md) for configuration and full documentation.

### Install node dependencies
```bash
$ npm run install:npm
```


## Switch Roles
- `admin`
- `developer`

TODO complete policy for developer
TODO add in `audit` role?

## Terraform Apply Order
1. master/state
1. master/account
    - [ ] Sub-Accounts / Organization (Manual)
    - [x] Groups for sub account access
    - [x] Roles for sub accounts (bastion)
    - [ ] Users (Manual/Optional)
    - [x] CloudTrail
    - [ ] Security Hub
1. environment/account
    - [ ] roles (admin, developer, operator, audit, etc)
    - [x] API Gateway Logs
    - [x] CloudTrail
    - [ ] GuardDuty
    - [ ] Inspector Agent
    - [ ] Macie
1. environment/vpc
    - [x] VPC
    - [x] VPC Endpoints (S3, DynamoDB)
    - [x] Bastion
1. environment/db
    - [x] RDS (postgres,mysql)
    - [x] ElasticCache (redis)
    - [x] ElasticSearch
1. environment/api
    - [-] DynamoDB
    - [-] ALB + ECS
    - [x] ECS
    - [ ] API Gateway
    - [ ] Events, SQS, SNS, Lambda, S3,
1. environment/app
    - [x] CloudFront
    - [x] S3
1. environment/ops
    - [ ] CloudWatch Dashboards


## Built With
- [Terraform](https://www.terraform.io/)
- [Packer](https://www.packer.io/)
- [NodeJS](https://nodejs.org/en/)

## Contributing
See Developer Guide (TODO add link)

## Versioning
We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/willfarrell/terraform-aws-template/tags).

## Authors
- [will Farrell](https://github.com/willfarrell)

See also the list of [contributors](https://github.com/willfarrell/terraform-aws-template/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments


## TODO / Roadmap
- [ ] Setup Vault - http://www.singulariti.co/2018/03/30/tech-blog-hashicorp-stack-for-secrets-management/




