# AWS Terraform Deployment Guide

## 1. Introduction

This document describes the deployment of AWS infrastructure using Terraform in three stages.

## 2. Prerequisites

- AWS account
- AWS CLI
- Terraform
- Docker Desktop
- Git
- Node.js
- Python

## 3. Part 1 – Single EC2

1. Open the part1-single-ec2 directory.
2. Initialize Terraform.
3. Validate the configuration.
4. Review the Terraform plan.
5. Apply the configuration.
6. Verify the EC2 instance and deployed application.

Commands:

    terraform init
    terraform fmt
    terraform validate
    terraform plan
    terraform apply

## 4. Part 2 – Separate EC2 Instances

1. Open the part2-separate-ec2 directory.
2. Initialize Terraform.
3. Create separate frontend and backend EC2 instances.
4. Configure frontend and backend communication.
5. Verify the frontend and backend endpoints.

Frontend port: 3000

Backend port: 5000

## 5. Part 3 – Docker and ECS Fargate

### Step 1: Build Docker images

The frontend and backend applications are containerized using Docker.

### Step 2: Push images to Amazon ECR

Docker images are built for Linux AMD64 architecture and pushed to their respective ECR repositories.

### Step 3: Create ECS infrastructure

Terraform provisions:

- ECS Cluster
- ECS Task Definitions
- ECS Services
- IAM Execution Role
- CloudWatch Log Groups
- Application Load Balancer
- Target Group
- Security Groups
- AWS Cloud Map Namespace and Service

### Step 4: Deploy services

Frontend and backend containers run as separate ECS Fargate services.

### Step 5: Verify deployment

The frontend is accessed through the Application Load Balancer.

Backend health endpoint:

    /api/health

Expected response:

    {"status":"healthy"}

## 6. Final Verification

The following checks were completed:

- Frontend returned HTTP 200 OK.
- Backend API returned HTTP 200 OK.
- Both ECS services reached 1/1 running tasks.
- Application Load Balancer target health was healthy.

## 7. Security and Cost Notes

- AWS credentials must not be stored in source code.
- Terraform state files must not be uploaded publicly.
- Review AWS resources before running destroy commands.
- Running EC2, ECS Fargate, ALB and public IPv4 resources may incur charges.

## 8. Author

Deepanshu Tyagi
