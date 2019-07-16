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

Service                            | SOC | PCI | ISO | FIPS | NOTES + CONSIDERATIONS
-----------------------------------|-----|-----|-----|------|-------------------
API Gateway                        | Yes | Yes | Yes | US   | Deployed with serverless
Certificate Manager (ACM)          | Yes | Yes | Yes | No   | Security Secret Management
CloudFront                         | Yes | Yes | Yes | No   | Edge Service
CloudFormation                     | Yes | Yes | Yes | US   | DevOps, Deployed with serverless
CloudHSM                           | Yes | Yes | Yes | No   | Security Secret Management
CloudTrail                         | Yes | Yes | Yes | US   | Edge Service, Security Logging
CloudWatch                         | Yes | Yes | Yes | No   | DevOps, PCI for Logs only
Config                             | Yes | Yes | Yes | US   | Security Scanning
Cognito                            | Yes | Yes | Yes | US   | Security Authentication
DynamoDB                           | Yes | Yes | Yes | Yes  | 
Elastic Block Storage (EBS)        | Yes | Yes | Yes | US   | Requires VPC
Elastic Compute Cloud (EC2)        | Yes | Yes | Yes | Yes  | Requires VPC
Elastic Container Registry (ECR)   | Yes | Yes | Yes | No   |
Elastic Container Service (ECS)    | Yes | Yes | Yes | No   | Requires VPC
Elastic File System (EFS)          | Yes | Yes | Yes | No   | Requires VPC
Elastic Load Balancing (ELB)       | Yes | Yes | Yes | US   | Requires VPC
ElastiCache                        | Yes | Yes | Yes | US   | Requires VPC, redis only
Elasticsearch Service              | Yes | Yes | Yes | US   |  
GuardDuty                          | Yes | Yes | Yes | No   | Security Scanner
Identity & Access Management (IAM) | Yes | Yes | Yes | US   | Edge Service	Key Management Service                 | Yes | Yes | Yes | No   | Security Secret Management
Inspector                          | Yes | Yes | Yes | US   | Security Scanner
Key Management Service (KMS)       | Yes | Yes | Yes | US   | Security Secret Management
Kinesis Data Firehose              | Yes | Yes | Yes | US   | Security Logging
Lambda                             | Yes | Yes | Yes | US   |
Lambda@Edge                        | Yes | Yes | No* | No   | Edge Service currently used with CloudFront to enforce CSP headers on static assets
Macie                              | Yes | Yes | Yes | No   | Security Scanner
Organizations                      | Yes | No  | Yes | No   | Edge Service
Relational Database Service (RDS)  | Yes | Yes | Yes | Yes  | Requires VPC
Route 53                           | Yes | Yes | Yes | US   | Edge Service
Security Hub                       | Yes | Yes | Yes | No   | Security Scanner
Security Token Service (STS)       | --- | --- | --- | Yes  | Security
Shield                             | Yes | Yes | Yes | US   | Security
Simple Email Service (SES)         | Yes | No  | Yes | No   | Edge service
Simple Notification Service (SNS)  | Yes | Yes | Yes | US   |  
Simple Queue Service (SQS)         | Yes | Yes | Yes | US   |
Simple Storage Service (S3)        | Yes | Yes | Yes | US   | Includes Glacier
Step Functions                     | Yes | Yes | Yes | No   | 
Systems Manager (SSM)              | Yes | Yes | Yes | No   | Security Secret Management
Trusted Advisor                    | No  | No  | Yes | No   | Edge Service, Security Scanner
Virtual Private Cloud (VPC)        | Yes | Yes | Yes | US   | 
Web Application Firewall (WAF)     | Yes | Yes | Yes | US   | Security Scanner
X-Ray                              | Yes | Yes | Yes | No   | DevOps