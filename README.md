

````markdown
# 🚀 Project 1: Infrastructure as Code (AWS)

> **DevOps Portfolio Project** - Demonstrating Infrastructure as Code, containerization, and cloud deployment skills

Create your first AWS infrastructure using **Terraform** and **ECS Fargate**.

## 🎯 Portfolio Highlights

✅ **Infrastructure as Code** - Terraform configuration for reproducible deployments  
✅ **Cloud Native** - AWS ECS Fargate serverless containers  
✅ **Security Best Practices** - IAM roles, security groups, VPC configuration  
✅ **Monitoring & Logging** - CloudWatch integration  
✅ **Cost Management** - Easy cleanup with `terraform destroy`  

---

## 🌐 What This Creates

- ECS Fargate cluster (serverless containers)
- ECS service running Nginx web server
- CloudWatch log group for monitoring
- Security group for network access
- IAM roles for proper permissions

---

## 🧰 Prerequisites

- [AWS CLI](https://aws.amazon.com/cli/) installed and configured
- [Terraform](https://www.terraform.io/downloads.html) installed
- AWS account (Free Tier is fine)

---

## 🛠 Step-by-Step Deployment

### ✅ Step 1: Set Up AWS CLI

```bash
# macOS
brew install awscli

# Linux
sudo apt install awscli

# Windows
# Download from AWS website

# Configure AWS credentials
aws configure
# Provide Access Key, Secret Key, region (e.g. us-east-1), output (e.g. json)

# Verify login
aws sts get-caller-identity
````

---

### ✅ Step 2: Customize Your Settings

```bash
# Edit terraform.tfvars
# Change "yourname" to personalize

cluster_name = "john-devops-cluster"
```

---

### ✅ Step 3: Deploy Infrastructure

```bash
# Initialize Terraform
terraform init

# Review planned changes
terraform plan

# Apply the configuration
terraform apply
# Confirm with 'yes' when prompted
```

---

### ✅ Step 4: Get the Public IP

```bash
# Store outputs into variables
CLUSTER_NAME=$(terraform output -raw cluster_name)
SERVICE_NAME=$(terraform output -raw service_name)

# List running tasks
aws ecs list-tasks --cluster $CLUSTER_NAME --service-name $SERVICE_NAME

# Replace [TASK_ARN] with actual output
aws ecs describe-tasks --cluster $CLUSTER_NAME --tasks [TASK_ARN]

# OR use this one-liner:
aws ecs describe-tasks \
  --cluster $CLUSTER_NAME \
  --tasks $(aws ecs list-tasks --cluster $CLUSTER_NAME --service-name $SERVICE_NAME --query 'taskArns[0]' --output text) \
  --query 'tasks[0].attachments[0].details[?name==`networkInterfaceId`].value' \
  --output text | \
  xargs -I {} aws ec2 describe-network-interfaces \
  --network-interface-ids {} \
  --query 'NetworkInterfaces[0].Association.PublicIp' \
  --output text
```

---

### ✅ Step 5: Test Your Application

* Copy the public IP from step 4
* Open in browser:
  `http://[PUBLIC_IP]`
* You should see the **Nginx Welcome Page**

---

### ✅ Step 6: View Logs in CloudWatch

```bash
LOG_GROUP=$(terraform output -raw log_group_name)
aws logs describe-log-streams --log-group-name $LOG_GROUP
```

---

## 🐞 Troubleshooting

### ❌ Error: `NoCredentialsError`

* Run `aws configure`
* Confirm with `aws sts get-caller-identity`

---

### ❌ Error: `UnauthorizedOperation`

* Attach `AdministratorAccess` policy to your IAM user
* Ensure ECS, EC2, IAM, and CloudWatch permissions are present

---

### ❌ Task Keeps Stopping

* Check logs in CloudWatch
* Verify container image is valid and accessible
* Ensure sufficient CPU/memory values

---

### ❌ Website Not Loading

* Wait 2–3 minutes for app to start
* Confirm public IP assignment
* Ensure port 80 is open in security group

---

### ❌ Error: `ResourceAlreadyExistsException`

* Edit `terraform.tfvars` to use a unique cluster name
* Or destroy existing infra: `terraform destroy`

---

## 🧹 Clean Up (Important!)

```bash
terraform destroy
# Confirm with 'yes'
```

Then verify in AWS Console that no resources remain to avoid unexpected charges.

---

## 🎓 What You Learned

✅ Infrastructure as Code with Terraform
✅ AWS ECS Fargate (serverless containers)
✅ IAM Roles & Permissions
✅ Security Groups & VPC
✅ CloudWatch Logging
✅ AWS CLI Commands

---

## 🔄 Next Steps

* Try deploying a different Docker image
* Modify the security group to allow other ports
* Move on to **Project 2: Automated Deployment Pipeline**

---

## 📸 Portfolio Evidence

This project demonstrates practical DevOps skills:

- **Infrastructure as Code**: All infrastructure defined in version-controlled Terraform files
- **Cloud Architecture**: Multi-AZ deployment using AWS best practices
- **Container Orchestration**: ECS Fargate for serverless container management
- **Security**: Proper IAM roles and security group configurations
- **Monitoring**: CloudWatch logging and monitoring setup
- **Cost Optimization**: Clean resource management and easy teardown

### Key DevOps Concepts Demonstrated:
- Declarative infrastructure management
- Cloud-native application deployment
- Security-first configuration
- Automated resource provisioning
- Infrastructure monitoring and logging
