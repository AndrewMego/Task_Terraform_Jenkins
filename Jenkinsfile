pipeline {
 agent {
        label 'your-node-label'  // Specify your Jenkins node label here
    }
    environment {   
     AWS_ACCESS_KEY_ID = credentials('aws-credentials').accessKey
     AWS_SECRET_ACCESS_KEY = credentials('aws-credentials').secretKey 
     AWS_DEFAULT_REGION = 'us-east-1' // Optional
 
    stages {
        stage('Checkout') {
            steps {
                // Checkout the repository containing Terraform code
                git branch: 'main', url: 'https://github.com/AndrewMego/Task_Terraform_Jenkins.git' // Update with your repo URL
            }
        }

        stage('Terraform Init') {
            steps {
                // Initialize Terraform
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                // Plan Terraform deployment
                sh 'terraform plan -out=plan.tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                // Apply Terraform configuration
                sh 'terraform apply -auto-approve plan.tfplan'
            }
        }
    }

    post {
        always {
            // Cleanup Terraform plan file
            sh 'rm -f plan.tfplan'
        }
        success {
            echo 'Infrastructure deployed and PHP application served successfully.'
        }
        failure {
            echo 'Deployment failed.'
        }
    }
}
