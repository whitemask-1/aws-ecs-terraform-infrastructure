

````markdown
# 🚀 Project 1: Infrastructure as Code (AWS)

> **DevOps Portfolio Project** - Demonstrating Infrastructure as Code, containerization, and cloud deployment skills

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

## 🎓 What I Learned

✅ Infrastructure as Code with Terraform
✅ AWS ECS Fargate (serverless containers)
✅ IAM Roles & Permissions
✅ Security Groups & VPC
✅ CloudWatch Logging
✅ AWS CLI Commands

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
