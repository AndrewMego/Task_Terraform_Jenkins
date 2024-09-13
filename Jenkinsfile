pipeline {
    agent any

    environment {
        // Set AWS credentials
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_REGION = 'us-east-1' // Update to your AWS region
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the repository containing Terraform code
                git branch: 'main', url: 'https://github.com/your-repo/terraform-aws' // Update with your repo URL
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

        stage('Deploy PHP Application') {
            steps {
                // Use SSH or a deployment script to deploy PHP application on the EC2 instance
                script {
                    def publicIp = sh(script: "terraform output -raw ec2_public_ip", returnStdout: true).trim()
                    sshagent(['YOUR_SSH_CREDENTIALS_ID']) {
                        sh "scp -o StrictHostKeyChecking=no -i /path/to/your-key.pem path/to/your/php/index.php ubuntu@${publicIp}:/var/www/html/index.php"
                    }
                }
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
