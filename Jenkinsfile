pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "232183/my-survey-app:latest"
        DOCKER_CREDENTIALS_ID = 'docker-id'  // Updated to the correct credential ID
        GIT_REPO = 'https://github.com/AmartyaMaruth/Jenkins.git'  // GitHub repo URL
        KUBECONFIG_CREDENTIALS_ID = 'kubeconfig_id' // Kubernetes config credential ID
        AWS_CREDENTIALS_ID = 'aws_credentials_id' // AWS credentials ID (for AWS credentials type)
    }
    
    stages {
        stage('Clone Git Repository') {
            steps {
                script {
                    // Remove any existing repo and clone the GitHub repository to fetch the Dockerfile and other resources
                    sh 'rm -rf Jenkins && git clone ${GIT_REPO}'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image using the Dockerfile from the cloned repo
                    sh 'docker build -t ${DOCKER_IMAGE} Jenkins/'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Authenticate with Docker Hub using the credentials stored in Jenkins (docker-id)
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        // Login to Docker Hub
                        sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                        
                        // Push the Docker image to Docker Hub
                        sh "docker push ${DOCKER_IMAGE}"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Use kubeconfig for Kubernetes authentication and AWS credentials
                    withCredentials([file(credentialsId: KUBECONFIG_CREDENTIALS_ID, variable: 'KUBECONFIG'),
                                     [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: AWS_CREDENTIALS_ID]]) {
                        
                        // Check the current context or nodes in the cluster for debugging (optional)
                        sh 'kubectl config current-context' // Optional: Check current context
                        // sh 'kubectl get nodes' // Optional: List nodes for verification
                        
                        // Deploy the Kubernetes deployment and service YAML files
                        sh 'kubectl delete -f my-survey-app-deployment.yaml || true' // Ignore if it doesn't exist
                        // sh 'kubectl delete -f my-survey-app-service.yaml || true' // Uncomment if you want to delete the service as well
                        sh 'kubectl apply -f my-survey-app-deployment.yaml'
                        // sh 'kubectl apply -f my-survey-app-service.yaml' // Uncomment if you want to apply the service as well
                    }
                }
            }
        }
    }
}
