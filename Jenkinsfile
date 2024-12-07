pipeline {
    agent any

    environment {
        // Secure credentials for Azure Subscription
        AZURE_SUBSCRIPTION_ID = credentials('azure-subscription-id') // Replace with your Jenkins Credential ID
        RESOURCE_GROUP = "TP_terraform" // Resource Group name
        LOCATION = "northeurope" // Azure location
        DOCKER_IMAGE = "nginx:latest" // Demo Docker image to deploy
    }

    stages {
        stage('Initialize Terraform') {
            steps {
                echo "Initializing Terraform..."
                sh '''
                    pwd
                '''
            }
        }

        stage('Plan Terraform Changes') {
            steps {
                echo "Planning Terraform changes..."
                sh '''
                    terraform plan -input=false \
                        -var="subscription_id=${AZURE_SUBSCRIPTION_ID}" \
                        -var="resource_group=${RESOURCE_GROUP}" \
                        -var="location=${LOCATION}" \
                        -var="docker_image=${DOCKER_IMAGE}" \
                        -out=tfplan
                '''
            }
        }

        stage('Apply Terraform Configuration') {
            steps {
                echo "Applying Terraform configuration..."
                sh '''
                    pwd
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
                        --docker-custom-image-name ${DOCKER_IMAGE}
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
