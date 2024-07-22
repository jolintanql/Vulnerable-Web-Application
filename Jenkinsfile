pipeline {
    agent any
    
    environment {
        SONAR_PROJECT_KEY = 'OWASP'
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/jolintanql/Vulnerable-Web-Application.git'
            }
        }
        
        stage('Code Quality Check via SonarQube') {
            steps {
                script {
                    def scannerHome = tool 'SonarQube'
                    withSonarQubeEnv('SonarQube') {
                        sh """
                            ${scannerHome}/bin/sonar-scanner \
                            -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                            -Dsonar.sources=. \
                            -Dsonar.host.url=${SONAR_HOST_URL} \
                            -Dsonar.login=${SONAR_AUTH_TOKEN}
                        """
                    }
                }
            }
        }
    }
    
    post {
        always {
            script {
                def reportPath = '**/target/sonar/report-task.txt'
                if (fileExists(reportPath)) {
                    recordIssues(enabledForFailure: true, tools: [sonarQube(reportPath: reportPath)])
                } else {
                    error "SonarQube report not found. SonarQube analysis may have failed."
                }
            }
        }
    }
}