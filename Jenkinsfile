pipeline {
    agent {
        docker {
            image 'my-jenkins-with-node:latest'
            args '-u root:root'  // Use root user to ensure Node.js is accessible
        }
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/jolintanql/Vulnerable-Web-Application.git'
            }
        }
        stage('Code Quality Check via SonarQube') {
            environment {
                // Reference the credentials ID for SonarQube token
                SONAR_TOKEN = credentials('SonarQube-Token')
            }
            steps {
                script {
                    def scannerHome = tool name: 'SonarQube', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
                    // Print the path of SonarQube scanner
                    sh "echo SonarQube Scanner Path: ${scannerHome}"
                    
                    withSonarQubeEnv('SonarQube') {
                        withCredentials([string(credentialsId: 'SonarQube-Token', variable: 'SONAR_TOKEN')]) {
                            sh """
                                node -v
                                npm -v
                                ${scannerHome}/bin/sonar-scanner \
                                -Dsonar.projectKey=OWASP \
                                -Dsonar.sources=. \
                                -Dsonar.host.url=http://192.168.1.82:9000 \
                                -Dsonar.token=${SONAR_TOKEN}
                            """
                        }
                    }
                }
            }
        }
    }
    post {
        always {
            recordIssues enabledForFailure: true, tools: [sonarQube()]
        }
    }
}
