pipeline {
 agent {
        label 'your-node-label'  // Specify your Jenkins node label here
    }
    environment {
        TF_VAR_AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        TF_VAR_AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    stages {
        stage('Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/AndrewMego/Task_Terraform_Jenkins.git',
                    ]]
                ])
            }
        }
        stage('Terraform Init & Apply') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_ACCESS_KEY_AA']]) {
                        sh '''
                            terraform init
                            terraform apply -auto-approve
                        '''
                    }
                }
            }
        }
    }
    post {
        always {
            echo 'Deployment completed.'
        }
        failure {
            echo 'Deployment failed.'
        }
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

        stage('Deploy PHP Application') {
            steps {
                // Use SSH or a deployment script to deploy PHP application on the EC2 instance
                script {
                    def publicIp = sh(script: "terraform output -raw ec2_public_ip", returnStdout: true).trim()
                    sshagent(['AWS_ACCESS_KEY_AA']) {
                        sh "scp -o StrictHostKeyChecking=no -i ~/Key_Andrew.pem /php/index.php ubuntu@${publicIp}:/var/www/html/index.php"
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
