pipeline {
    agent any
    stages {
        stage ('Checkout') {
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
                    def scannerHome = tool name: 'SonarQube', type: 'hudson.plugins.sonar.SonarRunnerInstallation';
                    // Print the path of SonarQube scanner
                    sh "echo SonarQube Scanner Path: ${scannerHome}"

                    withSonarQubeEnv('SonarQube') {
                        sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=OWASP -Dsonar.sources=. -Dsonar.host.url=http://192.168.1.82:9000 -Dsonar.login=${SONAR_TOKEN}"
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