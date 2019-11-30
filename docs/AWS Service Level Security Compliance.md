# AWS Service Level Security Compliance

Last reviewed: 2019-08-01
Sources:
- https://aws.amazon.com/compliance/programs
- https://aws.amazon.com/compliance/csa
- https://aws.amazon.com/compliance/services-in-scope
- https://aws.amazon.com/compliance/fips

Compliance Report: https://aws.amazon.com/artifact/getting-started

## Certifications
- CSA
- SOC: 1,2,3
- PCI: DSS Level 1
- ISO: 9001:2015, 27001:2013, 27017:2015, 27018:2014
- FIPS: 140-2

Service                            | SOC | PCI | ISO | FIPS | Dependencies | NOTES + CONSIDERATIONS
-----------------------------------|-----|-----|-----|------|--------------|------------
API Gateway (APIG)                 | Yes | Yes | Yes | US   |              | Deployed with serverless
Certificate Manager (ACM)          | Yes | Yes | Yes | No   |              | Security Secret Management
CloudFront (CDN)                   | Yes | Yes | Yes | No   |              | Edge Service
CloudFormation                     | Yes | Yes | Yes | US   |              | DevOps, Deployed with serverless
CloudHSM                           | Yes | Yes | Yes | No   |              | Security Secret Management
CloudTrail                         | Yes | Yes | Yes | US   | S3           | Edge Service, Security Logging
CloudWatch                         | Yes | Yes | Yes | No   |              | DevOps, PCI for Logs only
Config                             | Yes | Yes | Yes | US   |              | Security Scanning
Cognito                            | Yes | Yes | Yes | US   |              | Security Authentication
DynamoDB                           | Yes | Yes | Yes | Yes  |              | 
Elastic Block Storage (EBS)        | Yes | Yes | Yes | US   | VPC          | 
Elastic Compute Cloud (EC2)        | Yes | Yes | Yes | Yes  | VPC          | 
Elastic Container Registry (ECR)   | Yes | Yes | Yes | No   |              |
Elastic Container Service (ECS)    | Yes | Yes | Yes | No   | VPC          | 
Elastic File System (EFS)          | Yes | Yes | Yes | No   | VPC          | 
Elastic Load Balancing (ELB)       | Yes | Yes | Yes | US   | VPC          | 
ElastiCache                        | Yes | Yes | Yes | US   | VPC          | redis only
Elasticsearch Service              | Yes | Yes | Yes | US   |              | 
GuardDuty                          | Yes | Yes | Yes | No   |              | Security Scanner
Identity & Access Management (IAM) | Yes | Yes | Yes | US   |              | Edge Service	
Inspector                          | Yes | Yes | Yes | US   | EC2          | Security Scanner
Key Management Service (KMS)       | Yes | Yes | Yes | US   |              | Security Secret Management
Kinesis Data Firehose              | Yes | Yes | Yes | US   |              | Security Logging
Lambda                             | Yes | Yes | Yes | US   |              | 
Lambda@Edge                        | Yes | Yes | No  | No   | CDN          | Edge Service currently used with CloudFront to enforce CSP headers on static assets
Macie                              | Yes | Yes | Yes | No   | S3           | Security Scanner
Organizations                      | Yes | No  | Yes | No   |              | Edge Service
Relational Database Service (RDS)  | Yes | Yes | Yes | Yes  | VPC          | 
Route 53 (DNS)                     | Yes | Yes | Yes | US   |              | Edge Service
Security Hub                       | Yes | Yes | Yes | No   |              | Security Scanner
Security Token Service (STS)       | --- | --- | --- | Yes  |              | Security
Shield                             | Yes | Yes | Yes | US   | APIG,CDN,ELB | Security
Simple Email Service (SES)         | Yes | No  | Yes | No   |              | Edge service
Simple Notification Service (SNS)  | Yes | Yes | Yes | US   |              | 
Simple Queue Service (SQS)         | Yes | Yes | Yes | US   |              | 
Simple Storage Service (S3)        | Yes | Yes | Yes | US   |              | Includes Glacier
Step Functions                     | Yes | Yes | Yes | No   |              | 
Systems Manager (SSM)              | Yes | Yes | Yes | No   |              | Security Secret Management
Trusted Advisor                    | No  | No  | Yes | No   |              | Edge Service, Security Scanner
Virtual Private Cloud (VPC)        | Yes | Yes | Yes | US   |              |
Web Application Firewall (WAF)     | Yes | Yes | Yes | US   | APIG,CDN,ELB | Security Scanner
X-Ray                              | Yes | Yes | Yes | No   | APIG,EC2,ECS | DevOps

## Encryption at Rest 

Service                           | Keys | Notes
----------------------------------|------|------
DynamoDB                          | AWS  | 
Elastic Block Storage (EBS)       | KMS  | 
Elastic Compute Cloud (EC2) AMI   | KMS  | Encrypted AMI can only be used in the same account.
Elastic Container Registry (ECR)  | No   | 
Elastic File System (EFS)         | KMS  | 
ElastiCache                       | AWS  | 
Elasticsearch Service             | KMS  | Only certain instances [Docs](https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/aes-supported-instance-types.html)
Lambda                            | KMS  | 
Relational Database Service (RDS) | KMS  | Only certain instances [Docs](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.Encryption.html#Overview.Encryption.Limitations)
Simple Storage Service (S3)       | KMS* | ELB logs cannot use KMS - TODO re-check

## Encryption in Transit
Service                           | TLS  | Notes
----------------------------------|------|------
Elastic File System (EFS)         | 1.2  | OCSP option
ElastiCache                       | 1.2? | 
Elasticsearch Service             | 1.2? |
Relational Database Service (RDS) | 1.2? | Requires `ssl:true` to be set in application, or use serverless.
