pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/jolintanql/Vulnerable-Web-Application.git'
            }
        }
        stage('Code Quality Check via SonarQube') {
            environment {
                SONAR_TOKEN = credentials('SonarQube-Token') // Reference the credentials ID for SonarQube token
            }
            steps {
                script {
                    def scannerHome = tool name: 'SonarQube', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
                    sh "echo SonarQube Scanner Path: ${scannerHome}"
                    
                    withSonarQubeEnv('SonarQube') {
                        withCredentials([string(credentialsId: 'SonarQube-Token', variable: 'SONAR_TOKEN')]) {
                            sh """
                                export PATH=\$PATH:/usr/bin  # Add the Node.js and npm path here
                                node -v
                                npm -v
                                ${scannerHome}/bin/sonar-scanner \
                                -Dsonar.projectKey=OWASP \
                                -Dsonar.sources=. \
                                -Dsonar.host.url=http://192.168.1.82:9000 \
                                -Dsonar.login=\$SONAR_TOKEN \
                                -X
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
