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
    DOCKERHUB_CREDENTIALS = credentials('docker-hub-credential')
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
        stage('Login') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
      }
    }
        stage('Push') {
            steps {
                sh 'docker push devopssteps/myapp:latest'
      }
    }
        
    }
}