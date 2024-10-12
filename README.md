# Terraform AWS Project

This project contains Terraform configurations for deploying infrastructure on AWS.

## Prerequisites

Before getting started, ensure you have the following tools installed on your local machine:

- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Terraform](https://www.terraform.io/downloads.html)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

Make sure your AWS CLI is configured with the necessary credentials:

```bash
aws configure
```

## Clone the Repository
Start by cloning the GitHub repository to your local machine.

```bash
git clone git@github.com:volha10/rsschool-devops-course-tasks.git
cd rsschool-devops-course-tasks
```

## Export Environment Variables
You need to set the environment variables that will be used in the terraform init command to configure the backend:

```bash
export TF_VAR_aws_s3_bucket_name="your-bucket-name"
export TF_VAR_aws_s3_bucket_region="your-region"
```
Replace your-bucket-name with the name of your S3 bucket and your-region with your AWS region (e.g., us-east-1).

## Initialize Terraform
Once inside the project directory, initialize Terraform. This will download the necessary provider plugins and set up the backend.

```bash
terraform init -backend-config="bucket=$TF_VAR_aws_s3_bucket_name" -backend-config="region=$TF_VAR_aws_s3_bucket_region"
```

## Terraform Plan
Next, create an execution plan to preview the changes Terraform will make to your infrastructure.

```bash
terraform plan
```
This command will show you a list of resources that will be created, modified, or destroyed.

## Terraform Apply
Once you're satisfied with the plan, apply the changes to deploy your infrastructure.

```bash
terraform apply
```
You will be asked to confirm the action. Type yes to proceed.





