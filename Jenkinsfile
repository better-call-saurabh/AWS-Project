pipeline {
    agent any

    environment {
        IMAGE_NAME = "better0call/flask-app:latest"
        CONTAINER_NAME = "flask-app"
    }

    stages {

        stage('Clone Repository') {
            steps {
                // Using GitHub PAT stored as username/password in Jenkins
                withCredentials([usernamePassword(
                    credentialsId: 'github-pat',
                    usernameVariable: 'GITHUB_USER',
                    passwordVariable: 'GITHUB_TOKEN'
                )]) {
                    sh '''
                    rm -rf app
                    git clone https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/better-call-saurabh/AWS-Project.git app
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                cd app
                docker build -t $IMAGE_NAME .
                '''
            }
        }
        stage('Push Image to Docker Hub', id: 'docker') {
            steps {
                // Using DockerHub credentials stored in Jenkins
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    docker push $IMAGE_NAME
                    '''
                }
            }
        }

        stage('Delete Old Container') {
            steps {
                sh '''
                docker rm -f $CONTAINER_NAME || true
                '''
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                docker run -d --name $CONTAINER_NAME -p 5000:5000 $IMAGE_NAME
                '''
            }
        }

    }

    post {
        always {
            echo 'Pipeline finished!'
        }
    }
}
