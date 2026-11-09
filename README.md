# AWS DevOps Assignment – Terraform

## Project Overview
This project demonstrates AWS infrastructure automation using Terraform. It includes three deployment approaches, starting with a single EC2 instance and progressing to a containerized application using ECS Fargate.

## Technologies Used
- AWS EC2
- AWS VPC
- AWS IAM
- Terraform
- Docker
- Amazon ECR
- Amazon ECS Fargate
- Application Load Balancer
- AWS Cloud Map
- Amazon CloudWatch
- Node.js and Express
- Python and Flask
- Git and GitHub

## Project Structure
- app/frontend – Express frontend application
- app/backend – Flask backend application
- part1-single-ec2 – Single EC2 deployment
- part2-separate-ec2 – Separate frontend and backend EC2 deployment
- part3-ecs-ecr-alb – Docker, ECR, ECS Fargate and ALB deployment
- documentation – Project documentation
- screenshots – Deployment screenshots

## Part 1 – Single EC2 Deployment
- Provisioned AWS infrastructure using Terraform.
- Deployed the application on a single EC2 instance.
- Used Terraform variables, outputs and user data.

## Part 2 – Separate EC2 Deployment
- Created separate EC2 instances for frontend and backend.
- Deployed Express frontend on port 3000.
- Deployed Flask backend on port 5000.
- Configured communication between frontend and backend.
- Tested backend health endpoint.

## Part 3 – ECS Fargate Deployment
- Created Docker images for frontend and backend.
- Built Linux AMD64 images and pushed them to Amazon ECR.
- Created an ECS Fargate cluster.
- Deployed separate frontend and backend services.
- Configured Application Load Balancer.
- Configured AWS Cloud Map service discovery.
- Configured security groups and CloudWatch log groups.

## Part 3 Architecture
Internet → Application Load Balancer → Frontend ECS Service → Backend ECS Service.

The frontend communicates with the backend using AWS Cloud Map.

## Testing Results

| Test | Result |
|---|---|
| Frontend | HTTP 200 OK |
| Backend API | HTTP 200 OK |
| Backend response | {"status":"healthy"} |
| Frontend ECS | 1/1 Running |
| Backend ECS | 1/1 Running |
| ALB Target Health | healthy |

## Application URL
http://terraform-separate-alb-2108105710.ap-south-1.elb.amazonaws.com

Note: The URL works while the AWS infrastructure remains deployed.

## Terraform Commands
Run commands from the relevant part directory.

    terraform init
    terraform fmt
    terraform validate
    terraform plan
    terraform apply

## Important Notes
- AWS credentials and secrets must never be committed.
- Terraform state files are excluded through .gitignore.
- Terraform lock files are retained.
- AWS resources may incur charges while running.

## Author
Deepanshu Tyagi

AWS Infrastructure Automation and DevOps Assignment
