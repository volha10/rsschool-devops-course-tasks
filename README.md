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

## Rename and Initialize Variables

After you are in the project directory, follow these steps to rename the sample variables file and set up the required variables for Terraform.

1. **Rename the sample file**:

   Run this command to change the name of the file:

   ```bash
   mv terraform.tfvars.sample terraform.tfvars
    ```

2. **Open the terraform.tfvars file**:

   Open the terraform.tfvars file in a text editor and set the values for aws_region and aws_s3_bucket_name:

   ```hcl
   aws_region           = "your-aws-region"
   aws_s3_bucket_name   = "your-s3-bucket-name"
    ```
   
## Export Environment Variables
You need to set the environment variables that will be used in the terraform init command to configure the backend:

```
export AWS_S3_BACKEND_NAME="your-bucket-name"
export AWS_S3_BACKEND_REGION="your-region"
```
Replace your-bucket-name with the name of your S3 bucket and your-region with your AWS region (e.g., us-east-1).

## Initialize Terraform
Once inside the project directory, initialize Terraform. This will download the necessary provider plugins and set up the backend.

```bash
terraform init \
  -backend-config="bucket=$AWS_S3_BACKEND_NAME" \
  -backend-config="region=$AWS_S3_BACKEND_REGION"
```

## Terraform Plan
Next, create an execution plan to preview the changes Terraform will make to your infrastructure.

```bash
terraform plan -input=false
```
This command will show you a list of resources that will be created, modified, or destroyed.

## Terraform Apply
Once you're satisfied with the plan, apply the changes to deploy your infrastructure.

```bash
terraform apply -input=false
```
You will be asked to confirm the action. Type yes to proceed.

## Setting Up GitHub Secrets

Before running the workflow, you need to set up the following secrets in your GitHub repository:

1. **AWS_ROLE_TO_ASSUME_DEPLOY**: The IAM role that your GitHub Actions will assume to deploy resources.

2. **AWS_REGION**: The AWS region where your resources will be deployed (e.g., `us-east-1`).

3. **AWS_BACKEND_S3**: The name of the S3 bucket that will be used as the backend for storing the Terraform state.

4. **AWS_SAMPLE_BUCKET**: The name of your sample S3 bucket.

### Steps to Add Secrets:

1. Go to your GitHub repository.

2. Click on the **Settings** tab.

3. In the left sidebar, click on **Secrets and variables**, then click on **Actions**.

4. Click on the **New repository secret** button.

5. Add the secrets one by one:
   - For **Name**, enter `AWS_ROLE_TO_ASSUME_DEPLOY` and then enter the corresponding value.
   - Repeat this for `AWS_REGION`, `AWS_BACKEND_S3`, and `AWS_SAMPLE_BUCKET`.




