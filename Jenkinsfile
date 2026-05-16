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
                subject: "🚀 CI/CD SUCCESS: ${env.JOB_NAME} | Build #${env.BUILD_NUMBER}",
                body: """
                <!DOCTYPE html>
                <html>
                <body style="font-family: Verdana; background:#f4f6f8; padding:20px;">
                  <div style="max-width:700px;margin:auto;background:#fff;border-radius:10px;box-shadow:0 4px 12px rgba(0,0,0,0.1);overflow:hidden;">
                    
                    <div style="background:#1f2937;color:#fff;padding:20px;text-align:center;font-size:20px;">
                      CI/CD Pipeline Notification
                    </div>

                    <div style="padding:15px;text-align:center;font-size:18px;font-weight:bold;color:#16a34a;">
                      ✅ Build Successful
                    </div>

                    <div style="padding:20px;">
                      <h3>Project Details</h3>
                      <p><b>Job:</b> ${env.JOB_NAME}</p>
                      <p><b>Build:</b> #${env.BUILD_NUMBER}</p>

                      <h3>Deployment</h3>
                      <p><b>Docker Image:</b> ${IMAGE_NAME}:${IMAGE_TAG}</p>
                      <p><b>Status:</b> Successfully Deployed</p>

                      <a href="${env.BUILD_URL}" 
                         style="display:block;width:200px;margin:20px auto;padding:12px;background:#2563eb;color:#fff;text-align:center;border-radius:6px;text-decoration:none;">
                         View Build
                      </a>
                    </div>

                    <div style="background:#f3f4f6;text-align:center;padding:10px;font-size:12px;">
                      Automated by Jenkins CI/CD
                    </div>

                  </div>
                </body>
                </html>
                """,
                mimeType: 'text/html',
		to: "smrsawarkar1@gmail.com;sameersawarkar17@gmail.com;vaishupise1@gmail.com",
                attachLog: true,
                compressLog: true
            )
        }

        failure {
            emailext (
                subject: "❌ CI/CD FAILED: ${env.JOB_NAME} | Build #${env.BUILD_NUMBER}",
                body: """
                <!DOCTYPE html>
                <html>
                <body style="font-family: Verdana; background:#f4f6f8; padding:20px;">
                  <div style="max-width:700px;margin:auto;background:#fff;border-radius:10px;box-shadow:0 4px 12px rgba(0,0,0,0.1);overflow:hidden;">
                    
                    <div style="background:#1f2937;color:#fff;padding:20px;text-align:center;font-size:20px;">
                      CI/CD Pipeline Notification
                    </div>

                    <div style="padding:15px;text-align:center;font-size:18px;font-weight:bold;color:#dc2626;">
                      ❌ Build Failed
                    </div>

                    <div style="padding:20px;">
                      <h3>Project Details</h3>
                      <p><b>Job:</b> ${env.JOB_NAME}</p>
                      <p><b>Build:</b> #${env.BUILD_NUMBER}</p>

                      <h3>Issue</h3>
                      <p>The pipeline execution failed. Please check attached logs.</p>

                      <a href="${env.BUILD_URL}" 
                         style="display:block;width:200px;margin:20px auto;padding:12px;background:#2563eb;color:#fff;text-align:center;border-radius:6px;text-decoration:none;">
                         View Logs
                      </a>
                    </div>

                    <div style="background:#f3f4f6;text-align:center;padding:10px;font-size:12px;">
                      Automated by Jenkins CI/CD
                    </div>

                  </div>
                </body>
                </html>
                """,
                mimeType: 'text/html',
                to: "smrsawarkar1@gmail.com;sameersawarkar17@gmail.com;vaishupise1@gmail.com",
                attachLog: true,
                compressLog: true
            )
        }
    }
}
