
pipeline {
    agent any

    options {
        skipDefaultCheckout(true)
    }

    environment {
        AWS_REGION = 'ap-south-1'
        AWS_ACCOUNT_ID = '743508003388'
        ECS_CLUSTER = 'terraform-separate-cluster'

        BACKEND_REPO = 'terraform-separate-backend'
        FRONTEND_REPO = 'terraform-separate-frontend'

        BACKEND_SERVICE = 'terraform-separate-backend-service'
        FRONTEND_SERVICE = 'terraform-separate-frontend-service'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Verify AWS Access') {
            steps {
                sh '''
                    set -e
                    aws sts get-caller-identity
                    docker --version
                    jq --version
                '''
            }
        }

        stage('Build and Push Docker Images') {
            steps {
                sh '''
                    set -e

                    ECR_BASE="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
                    BACKEND_URI="${ECR_BASE}/${BACKEND_REPO}"
                    FRONTEND_URI="${ECR_BASE}/${FRONTEND_REPO}"

                    aws ecr get-login-password --region "$AWS_REGION" \
                    | docker login --username AWS --password-stdin "$ECR_BASE"

                    docker build \
                        -f app/backend/Dockerfile \
                        -t "${BACKEND_URI}:${BUILD_NUMBER}" \
                        -t "${BACKEND_URI}:latest" \
                        app/backend

                    docker build \
                        -f app/frontend/Dockerfile \
                        -t "${FRONTEND_URI}:${BUILD_NUMBER}" \
                        -t "${FRONTEND_URI}:latest" \
                        app/frontend

                    docker push "${BACKEND_URI}:${BUILD_NUMBER}"
                    docker push "${BACKEND_URI}:latest"

                    docker push "${FRONTEND_URI}:${BUILD_NUMBER}"
                    docker push "${FRONTEND_URI}:latest"
                '''
            }
        }

        stage('Deploy Backend to ECS') {
            steps {
                sh '''
                    set -e

                    BACKEND_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${BACKEND_REPO}"

                    aws ecs describe-task-definition \
                        --task-definition terraform-separate-backend \
                        --region "$AWS_REGION" \
                        --query taskDefinition \
                        --output json \
                    | jq --arg image "${BACKEND_URI}:${BUILD_NUMBER}" '
                        del(
                            .taskDefinitionArn,
                            .revision,
                            .status,
                            .requiresAttributes,
                            .compatibilities,
                            .registeredAt,
                            .registeredBy
                        )
                        | .containerDefinitions |= map(
                            if .name == "backend"
                            then .image = $image
                            else .
                            end
                        )
                    ' > backend-task-def.json

                    NEW_BACKEND_TASK=$(aws ecs register-task-definition \
                        --cli-input-json file://backend-task-def.json \
                        --region "$AWS_REGION" \
                        --query 'taskDefinition.taskDefinitionArn' \
                        --output text)

                    aws ecs update-service \
                        --cluster "$ECS_CLUSTER" \
                        --service "$BACKEND_SERVICE" \
                        --task-definition "$NEW_BACKEND_TASK" \
                        --region "$AWS_REGION"
                '''
            }
        }

        stage('Deploy Frontend to ECS') {
            steps {
                sh '''
                    set -e

                    FRONTEND_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${FRONTEND_REPO}"

                    aws ecs describe-task-definition \
                        --task-definition terraform-separate-frontend \
                        --region "$AWS_REGION" \
                        --query taskDefinition \
                        --output json \
                    | jq --arg image "${FRONTEND_URI}:${BUILD_NUMBER}" '
                        del(
                            .taskDefinitionArn,
                            .revision,
                            .status,
                            .requiresAttributes,
                            .compatibilities,
                            .registeredAt,
                            .registeredBy
                        )
                        | .containerDefinitions |= map(
                            if .name == "frontend"
                            then .image = $image
                            else .
                            end
                        )
                    ' > frontend-task-def.json

                    NEW_FRONTEND_TASK=$(aws ecs register-task-definition \
                        --cli-input-json file://frontend-task-def.json \
                        --region "$AWS_REGION" \
                        --query 'taskDefinition.taskDefinitionArn' \
                        --output text)

                    aws ecs update-service \
                        --cluster "$ECS_CLUSTER" \
                        --service "$FRONTEND_SERVICE" \
                        --task-definition "$NEW_FRONTEND_TASK" \
                        --region "$AWS_REGION"
                '''
            }
        }

        stage('Wait for ECS Deployment') {
            steps {
                sh '''
                    set -e

                    aws ecs wait services-stable \
                        --cluster "$ECS_CLUSTER" \
                        --services "$BACKEND_SERVICE" "$FRONTEND_SERVICE" \
                        --region "$AWS_REGION"

                    echo "Both ECS services are stable."
                '''
            }
        }
    }

    post {
        success {
            echo 'CI/CD Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check the Jenkins console output.'
        }
    }
}
