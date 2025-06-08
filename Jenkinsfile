pipeline {
    agent {
        node {
            label 'maven'
        }
    }
    environment {
        PATH = "/opt/maven/bin:$PATH"
        DOCKER_IMAGE = 'devopssteps/myapp'
        DOCKER_TAG = 'latest'
        DOCKERHUB_CREDENTIALS = credentials('docker-hub-credential')
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION = 'us-east-1'
    }
    stages {
        stage('build') {
            steps {
                echo '-------------build started------------------'
                sh 'mvn clean deploy' //-Dmaven.test.skip=true
                echo '------------buildc completed------------------'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t devopssteps/myapp:latest .'
            }
        }
        stage('Login to dockerhub') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        stage('Push to dockerhub') {
            steps {
                sh 'docker push devopssteps/myapp:latest'
            }
        }
        stage('deploy to kubernetes') {
            steps {
                script {
                    sh '''
                        aws eks update-kubeconfig --region us-east-1 --name devopssteps-eks-01 --profile eks
                        ./k8s/deploy.sh
                    '''
                }
            }
        }
    }
    post {
        always {
            echo 'Cleaning up unused Docker images...'
            sh 'docker image prune -f'
            sh 'docker logout'
        }
    }
}
