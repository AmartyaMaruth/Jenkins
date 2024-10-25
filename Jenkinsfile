pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "232183/my-survey-app:latest"
        DOCKER_CREDENTIALS_ID = 'docker_id'  // Ensure this ID is correct
        GIT_REPO = 'https://github.com/AmartyaMaruth/SWE645.git'
        KUBECONFIG_CREDENTIALS_ID = 'kubeconfig_id'
        AWS_CREDENTIALS_ID = 'aws_credentials_id'
    }
    
    stages {
        stage('Clone Git Repository') {
            steps {
                script {
                    sh 'rm -rf SWE645'
                    sh 'git clone ${GIT_REPO}'
                    sh 'ls -al SWE645' // Debugging: Check contents of cloned repo
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t ${DOCKER_IMAGE} SWE645/'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                        sh "docker push ${DOCKER_IMAGE}"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withCredentials([file(credentialsId: KUBECONFIG_CREDENTIALS_ID, variable: 'KUBECONFIG'),
                                     [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: AWS_CREDENTIALS_ID]]) {
                        sh 'kubectl delete -f SWE645/my-survey-app-deployment.yaml'
                        sh 'kubectl apply -f SWE645/my-survey-app-deployment.yaml --validate=false'
                    }
                }
            }
        }
    }
}
