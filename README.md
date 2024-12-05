# Terraform AWS Project

This project contains Terraform configurations for deploying infrastructure on AWS.

## Prerequisites

Before getting started, ensure you have the following tools installed on your local machine:

- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Terraform](https://www.terraform.io/downloads.html)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/#install-with-homebrew-on-macos) (The Kubernetes command-line tool)

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
terraform init -backend-config="bucket=$TF_VAR_aws_s3_bucket_name" -backend-config="region=$TF_VAR_aws_s3_bucket_region" -migrate-state
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

## Terraform Destroy

```bash
terraform destroy
```
You will be asked to confirm the action. Type yes to proceed.

## SSH Configuration for Connecting to Private Instances via Bastion Host

A bastion host serves as a gateway, allowing secure access to instances in private subnets.

### Prerequisites
- Bastion Host: An EC2 instance in a public subnet, accessible from outside the VPC.
- Private Instance: An EC2 instance in a private subnet, accessible only via the bastion host.
- SSH Key: The private key (.pem or .ppk file) used to connect to both instances.
- Bastion Host Public IP: The public IP address of the bastion host.
- Private Instance Private IP: The private IP address of the private instance.
- SSH Agent Forwarding: SSH agent must be running locally if key forwarding is required.

### Step 1: Configure SSH
#### 1. Open SSH Config File. 
SSH configuration is stored in the file ~/.ssh/config on local machine. If this file does not exist, create it.

```
vim ~/.ssh/config
```

#### 2. Add the Bastion and Private Instance Configuration

Add the following configuration to the ~/.ssh/config file:

```
# Bastion Host configuration
Host bastion
    HostName <BASTION_PUBLIC_IP>
    User ec2-user
    IdentityFile ~/.ssh/your-key.pem
    ForwardAgent yes

# Private Instance configuration
Host private-instance
    HostName <PRIVATE_INSTANCE_PRIVATE_IP>
    User ec2-user
    IdentityFile ~/.ssh/your-key.pem
    ProxyJump bastion
```

- Replace <BASTION_PUBLIC_IP> with the public IP of your bastion host.
- Replace <PRIVATE_INSTANCE_PRIVATE_IP> with the private IP of your private instance.
- Replace ~/.ssh/your-key.pem with the path to your SSH key file.

The ProxyJump bastion command is used to route connections to the private instance through the bastion host.

### Step 2: Enable SSH Agent Forwarding

To securely forward the SSH key through the bastion host, enable SSH agent forwarding by adding ForwardAgent yes to the bastion block.

To start the SSH agent and add the private key:

```
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/your-key.pem
```

### Step 3: Set SSH Key Permissions
Ensure that only the owner can read the private key file:

```
chmod 400 ~/.ssh/your-key.pem
```

### Example
Test the connection to the bastion host:

```
ssh bastion
```

Test the connection to the private instance through the bastion host:

```
ssh private-instance
```

## Kubernetes (K8s) Cluster Setup and Deployment Using k3s
K3s is a lightweight Kubernetes distribution ideal for resource-constrained environments.

### Prerequisites

- Bastion Host Security Group:
    - Allow inbound SSH (port 22) traffic from your local machine’s IP address.
- Private Host (K3s server) Security Group:
    - Allow inbound SSH (port 22) from the bastion host.
    - Allow inbound traffic on port 6443 from the bastion host (K3s API port).

### Step 1: Install k3s on the Private Host (K3s server)

#### 1. SSH into the private host via the bastion:

```bash
ssh -J ec2-user@bastion ec2-user@private-instance
```

#### 2. Install k3s on the private server:

```
curl -sfL https://get.k3s.io | sh -
```

#### 3. Check if K3s is running:

```
sudo k3s kubectl get nodes
```

You should see the K3s node listed.


### Step 2: Set Up SSH Tunnel to Access K3s from Local Machine
On your local machine, set up an SSH tunnel to access the K3s server via the bastion:

```
ssh -L 6443:k3s-private-ip:6443 ec2-user@bastion -N
```

Replace k3s-private-ip with the actual IP address.
Leave the SSH tunnel running in the background.


### Step 3: Access K3s from Local Machine
#### 1. Configure kubectl on your local machine to connect to K3s. Copy the kubeconfig from the K3s server:

```
scp -i key.pem ec2-user@bastion-public-ip:/etc/rancher/k3s/k3s.yaml ~/k3s-config.yaml
```

#### 2. Edit the k3s-config.yaml on your local machine:

Replace the server address with https://127.0.0.1:6443.
Run kubectl commands on your local machine:

```
EXPORT KUBECONFIG=~/.kube/config
kubectl get nodes
```

This command should now show the K3s node running.

### Step 4: Deploy Prometheus
Create namespace:

```
kubectl create namespace monitoring 
```

Install Prometheus:
```
helm upgrade --install release-1 oci://registry-1.docker.io/bitnamicharts/kube-prometheus \
  --set prometheus.service.type=NodePort \
  --set prometheus.service.nodePorts.http=30090 \
  -n monitoring
```

Verify deployment:

```
kubectl get all -n monitoring
```