pipeline {
    agent any

    environment {
        RESOURCE_GROUP = "TP_terraform"
        LOCATION = "northeurope"
        DOCKER_IMAGE = "akramlh/tp3-k8s:latest"
    }

    stages {
        stage('Pull Terraform Configuration from GitHub') {
            steps {
                echo "Cloning repository to pull Terraform configuration..."
                git url: 'https://github.com/akramLh005/TP_terraform.git',
                    branch: 'main',
                    credentialsId: 'github-credentials'
            }
        }

        stage('Initialize Terraform') {
            steps {
                echo "Initializing Terraform..."
                sh '''
                    terraform init -input=false
                '''
            }
        }

        stage('Plan Terraform Changes') {
            steps {
                echo "Planning Terraform changes..."
                sh '''
                    terraform plan \
                    -var "subscription_id=$AZURE_SUBSCRIPTION_ID" \
                    -var "docker_image=${DOCKER_IMAGE}"
                '''
            }
        }

        stage('Apply Terraform Configuration') {
            steps {
                echo "Applying Terraform configuration..."
                sh '''
                    terraform apply -auto-approve \
                    -var "subscription_id=$azure-subscription-id" \
                    -var "docker_image=${DOCKER_IMAGE}"
                '''
            }
        }
    }

    post {
        always {
            echo "
