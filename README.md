# Project Title 
# Static Website Deployment Using AWS CI/CD (Blue/Green Deployment)
This project demonstrates automated deployment of a static website to EC2 using a blue/green strategy via AWS CodePipeline, CodeDeploy, CodeBuild, and S3.

## Tools & Services Used
GitHub – Source version control
Amazon EC2 – Web server instances
Amazon S3 – Stores app revision artifacts
Amazon ECR – Docker image registry
AWS CodePipeline – Orchestrates the CI/CD flow
AWS CodeBuild – Builds Docker images
AWS CodeDeploy – Manages blue/green deployments
Elastic Load Balancer (ELB) – Routes traffic to healthy targets

## Architecture Overview
GitHub → CodePipeline → CodeBuild (Docker) → ECR
                        ↓
                  S3 (artifact storage)
                        ↓
                  CodeDeploy (Blue/Green)
                        ↓
               EC2 Auto Scaling + Load Balancer

 ## Features
 1.Zero Downtime Deployment
 2.Dockerized Application
 3.Load Balancer with Health Checks
 4.Auto-rollback on failure
 5.Custom Lifecycle Hooks via appspec.yml

 # Project Structure
 .
├── Dockerfile
├── appspec.yml
├── scripts/
│   └── start_server.sh
├── buildspec.yml
├── index.html
└── README.md

# Setup Instructions
1.  Pre-Requisites
-> Go to AWS Account
-> IAM Role with appropriate permissions for CodeBuild, CodeDeploy, and ECR
-> GitHub repo with your project files
-> Docker installed locally (for local testing)

2.  Code Files
-> Dockerfile: Builds your static website image.
-> appspec.yml: Instructions for CodeDeploy lifecycle hooks.
-> start_server.sh: Script that stops old containers, builds and runs new one.
-> buildspec.yml: CodeBuild steps for building and pushing Docker image to ECR.

3.  AWS Infrastructure Steps
a. Elastic Load Balancer
-> Create an Application Load Balancer.
-> Create a target group (e.g., blue-group) and register EC2 instances.

b. EC2 Setup
-> Install CodeDeploy agent.
# Update the package repository
sudo yum update -y

# Install Ruby (required for CodeDeploy agent)
sudo yum install ruby -y

# Install wget to download the agent package
sudo yum install wget -y

# Download the CodeDeploy agent installation script
cd /home/ec2-user
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install

# Make the install script executable
chmod +x ./install

# Install the CodeDeploy agent
sudo ./install auto

# Enable and start the agent service
sudo systemctl enable codedeploy-agent
sudo systemctl start codedeploy-agent

# Check status (make sure it's active/running)
sudo systemctl status codedeploy-agent

Note => Ensure EC2 is part of an Auto Scaling Group (for blue/green).
-> Give proper IAM role to EC2 with AmazonEC2RoleforAWSCodeDeploy.

c. CodeDeploy App + Deployment Group
-> Application Type: EC2/On-premises.
-> Use Blue/Green Deployment.
-> Attach target group and load balancer.

d. Create ECR Repository
-> Push your Docker image from CodeBuild to ECR.

e. CodePipeline
Source: GitHub
-> Build: CodeBuild using buildspec.yml
-> Deploy: CodeDeploy with appspec.yml

# IAM Inline Policy for CodeBuild (Docker + ECR)
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload"
      ],
      "Resource": "*"
    }
  ]
}
# Test It
Commit and push a new change to GitHub.
CodePipeline automatically triggers.
CodeBuild builds and pushes new Docker image.
CodeDeploy replaces old environment with new one via blue/green strategy.








# aws_cicd
