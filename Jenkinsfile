pipeline {
    agent any

    environment {
        IMAGE_NAME = "sameersawarkar/javacicd-app"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Build JAR') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Verify JAR') {
            steps {
                sh 'ls -l target/'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG .'
            }
        }

        stage('Tag Latest') {
            steps {
                sh 'docker tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:latest'
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Push Image') {
            steps {
                sh 'docker push $IMAGE_NAME:$IMAGE_TAG'
                sh 'docker push $IMAGE_NAME:latest'
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                docker stop javacicd || true
                docker rm javacicd || true
                docker run -d -p 8083:8081 --name javacicd $IMAGE_NAME:$IMAGE_TAG
                '''
            }
        }
    }

    post {
    success {
        emailext (
            subject: "SUCCESS: Job ${env.JOB_NAME} Build #${env.BUILD_NUMBER}",
            body: """
            🎉 Build Success!

            Job Name: ${env.JOB_NAME}
            Build Number: ${env.BUILD_NUMBER}
            URL: ${env.BUILD_URL}

            Docker Image: sameersawarkar/my-app:${env.BUILD_NUMBER}
            """,
            to: "vaishupise1@gmail.com;smrsawarkar1@gmail.com",
            attachLog: true
        )
    }

    failure {
        emailext (
            subject: "FAILED: Job ${env.JOB_NAME} Build #${env.BUILD_NUMBER}",
            body: """
            ❌ Build Failed!

            Job Name: ${env.JOB_NAME}
            Build Number: ${env.BUILD_NUMBER}
            URL: ${env.BUILD_URL}

            Please check attached logs.
            """,
            to: "vaishupise1@gmail.com;smrsawarkar1@gmail.com",
            attachLog: true
        )
    }
}
}
