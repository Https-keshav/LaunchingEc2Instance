# Terraform AWS EC2 Instance

Provisions an Ubuntu 22.04 EC2 instance on AWS using Terraform, with a managed SSH key pair and a locked-down security group. All settings are configurable through variables.

## What it creates

- **EC2 instance** (`t2.micro` by default) using the latest Ubuntu 22.04 AMI, fetched dynamically with a data source
- **SSH key pair** built from your own public key
- **Security group**
  - SSH (port 22) allowed only from your IP
  - HTTP (port 80) open to the internet
  - All outbound traffic allowed (IPv4 and IPv6)

## Project structure

| File | Purpose |
|------|---------|
| `provider.tf` | AWS provider and region |
| `variables.tf` | All input variables with defaults and validation |
| `Keypair.tf` | SSH key pair (reads the public key from a file) |
| `SecGrp.tf` | Security group and its ingress/egress rules |
| `InstaID.tf` | AMI lookup data source and outputs |
| `Instance.tf` | EC2 instance |
| `.gitignore` | Keeps state files, keys and your tfvars out of Git |

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) installed
- [AWS CLI](https://aws.amazon.com/cli/) installed and configured (`aws configure`)
- An AWS account with permissions to create EC2 resources

## Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/Https-keshav/terraform-aws-ec2.git
   cd terraform-aws-ec2
   ```

2. **Generate an SSH key pair** (the private key stays on your machine and is git-ignored)
   ```bash
   ssh-keygen -t ed25519 -f trialKey
   ```

3. **Set your IP** (the only required variable, defined in `variables.tf`)

   Create a `terraform.tfvars` file (git-ignored) with your public IP in CIDR form. Find it with `curl ifconfig.me`:
   ```hcl
   my_ip = "203.0.113.10/32"
   ```
   Or skip the file and pass it at apply time:
   ```bash
   terraform apply -var="my_ip=203.0.113.10/32"
   ```

## Usage

```bash
terraform init       # download the AWS provider
terraform validate   # check the configuration
terraform plan       # preview what will be created
terraform apply      # create the resources
```

Connect to the instance once it's running:

```bash
ssh -i trialKey ubuntu@<instance_public_ip>
```

Clean up to avoid AWS charges:

```bash
terraform destroy
```

## Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `aws_region` | AWS region | `us-east-1` |
| `availability_zone` | Availability zone | `us-east-1a` |
| `instance_type` | EC2 instance type | `t3.micro` |
| `instance_name` | Name tag for the instance | `trial-instance` |
| `key_name` | AWS key pair name | `trialKey` |
| `public_key_path` | Path to your public key | `trialKey.pub` |
| `sg_name` | Security group name | `trial-sg` |
| `my_ip` | Your IP (CIDR) allowed to SSH | *required* |
| `http_cidr` | CIDR allowed on port 80 | `0.0.0.0/0` |
| `ami_name_filter` | AMI name pattern | Ubuntu 22.04 |
| `ami_owner` | AMI owner account ID | `099720109477` (Canonical) |

All variables and their defaults are defined in `variables.tf`. Override any value in `terraform.tfvars` or on the command line:

```bash
terraform apply -var="instance_type=t3.small"
```

## Security notes

- Never commit `trialKey` (private key), `*.tfstate` or `terraform.tfvars`. The `.gitignore` already excludes them.
- SSH is restricted to a single IP. Update `my_ip` if your IP changes.
- Port 80 is open to the world by default. Narrow `http_cidr` if you don't need public access.

## What I learned

- Fetching the latest AMI dynamically with a data source
- Managing inputs with variables, validation and `.tfvars` files
- Writing least-privilege security group rules
- Why state files and private keys must stay out of version control

## Next steps

- Add an `instance_public_ip` output
- Bootstrap Nginx with `user_data`
- Move state to a remote S3 backend
- Refactor into reusable modules
