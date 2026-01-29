pipeline {
    agent any

    environment {
        IMAGE_NAME = "better0call/flask-app"
        CONTAINER_NAME = "flask-app-container"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub_credentials') // Docker Hub creds in Jenkins
    }

    stages {

        stage('Checkout') {
            steps {
                git url: 'https://github.com/your-repo/flask-app.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $IMAGE_NAME:latest ."
            }
        }

        stage('Push Docker Image') {
            steps {
                sh """
                echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                docker push $IMAGE_NAME:latest
                """
            }
        }

        stage('Delete old Container') {
            steps {
                sh """
                # Stop and remove existing container if it exists
                docker rm -f $CONTAINER_NAME || true
                """
            }
        }

        stage('Deploy Container') {
            steps {
                sh """
                # Run the new container
                docker run -d --name $CONTAINER_NAME -p 5000:5000 $IMAGE_NAME:latest
                """
            }
        }

    }

    post {
        always {
            echo 'CI/CD pipeline completed!'
        }
    }
}
