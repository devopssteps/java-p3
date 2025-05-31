pipeline {
    agent {
        node {
            label 'maven'
        }
    }
environment {
    PATH = "/opt/apache-maven-3.9.9/bin:$PATH"
    DOCKER_IMAGE = "devopssteps/myapp"
    DOCKER_TAG = "latest"
}
    stages {
        stage('build') {
            steps {
                echo "-------------build started------------------"
                sh 'mvn clean deploy' //-Dmaven.test.skip=true
                echo "------------buildc completed------------------"
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t devopssteps/myapp:latest .'
            }
        }
        stage('Login to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials') {
                    echo "Logged into Docker Hub"
                    }
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials') {
                    docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push()
                    }
                }
            }
        }
        
    }
}