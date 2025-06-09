pipeline {
    agent {
        node {
            label 'maven'
        }
    }
    environment {
        PATH = "/opt/maven/bin:$PATH"
        //DOCKER_IMAGE = 'devopssteps/myapp'
        //DOCKER_TAG = 'latest'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        DOCKER_IMAGE = "devopssteps/myapp:${IMAGE_TAG}"
        DOCKERHUB_CREDENTIALS = credentials('docker-hub-credential')
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION = 'us-east-1'
        GIT_CREDENTIALS_ID = 'devopssteps-github-access'  // or GitHub PAT credential ID
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
                sh 'docker build -t $DOCKER_IMAGE .' //sh 'docker build -t devopssteps/myapp:latest .'
            }
        }
        stage('Login to dockerhub') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        stage('Push to dockerhub') {
            steps {
                sh 'docker push $DOCKER_IMAGE' // sh 'docker push devopssteps/myapp:latest'
            }
        }
        //depoly to k8s by script file
        // stage('deploy to kubernetes') {
        //     steps {
        //         script {
        //             sh "sed -i 's|image: devopssteps/myapp:.*|image: $DOCKER_IMAGE|' k8s/deployment.yaml"
        //             sh './k8s/deploy.sh'
        //         }
        //     }
        // }
        
        //depoly to k8s by helm
        // stage('Deploy to k8s by helm chart') {
        //     steps {
        //         script {
        //             sh 'helm install myapp-v1 myapp-0.1.0.tgz'
        //         }
        //     }
        // }

        //deploy by helm automatical create package and push to github
        stage('Package Helm Chart') {
            steps {
                dir('helm') {
                    sh 'helm lint .'
                    sh 'helm package .'
                }
            }
        }

        stage('Push Helm Package to GitHub') {
            steps {
                sshagent (credentials: [env.GIT_CREDENTIALS_ID]) {
                    sh '''
                    git config user.email "devopssteps@gmail.com"
                    git config user.name "devopssteps"
                    mv helm/*.tgz .
                    git add *.tgz
                    git commit -m "Add Helm package for new build"
                    git push origin main
                    '''
                }
            }
        }

        //depoly to k8s by helm
        stage('Deploy to k8s by helm chart') {
            steps {
                script {
                    sh 'helm install myapp-v2 myapp-0.1.0.tgz'
                }
            }
        }

        // Force k8s container recreate with new docker image
        // stage('deploy new container with new image to kubernetes') {
        //     steps {
        //         script {
        //             sh 'kubectl rollout restart deployment.apps/myapp-deployment'
        //         }
        //     }
        // }
    }
    post {
        always {
            echo 'Cleaning up unused Docker images...'
            sh 'docker image prune -f'
            sh 'docker logout'
        }
    }
}
