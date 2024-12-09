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
                    terraform plan
                '''
            }
        }

        stage('Apply Terraform Configuration') {
            steps {
                echo "Applying Terraform configuration..."
                sh '''
                    terraform apply -auto-approve
                '''
            }
        }

        stage('Authenticate Azure CLI with Managed Identity') {
            steps {
                echo "Authenticating Azure CLI with Managed Identity..."
                sh '''
                    az login --identity
                '''
            }
        }

        stage('Deploy Docker Container') {
            steps {
                echo "Deploying Docker container to Azure Web App..."
                sh '''
                    # Get the web app name from Terraform output
                    WEB_APP_NAME=$(terraform output -raw web_app_name)
                    # Update the web app to use the Docker image
                    az webapp config container set \
                        --resource-group ${RESOURCE_GROUP} \
                        --name ${WEB_APP_NAME} \
                        --container-image-name ${DOCKER_IMAGE}
                '''
            }
        }
    }

    post {
        always {
            echo "Cleaning up workspace..."
            cleanWs()
        }
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed. Please check the logs for details."
        }
    }
}
