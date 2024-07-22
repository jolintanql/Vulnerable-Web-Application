pipeline {
    agent any
    environment {
        SONARQUBE_URL = 'http://localhost:9000'
        SONARQUBE_TOKEN = 'sqp_b7c921302a31e624a9de8089bbd03fdd9f95f798'
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/jolintanql/Vulnerable-Web-Application.git'
            }
        }
        stage('Build') {
            steps {
                sh '''
                    /var/jenkins_home/apache-maven-3.6.3/bin/mvn --batch-mode -V -U -e clean verify -Dsurefire.useFile=false -Dmaven.test.failure.ignore
                '''
            }
        }
        stage('Static Code Analysis') {
            steps {
                sh '''
                    /var/jenkins_home/apache-maven-3.6.3/bin/mvn checkstyle:checkstyle pmd:pmd pmd:cpd spotbugs:spotbugs
                '''
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                        /var/jenkins_home/apache-maven-3.6.3/bin/mvn sonar:sonar \
                        -Dsonar.projectKey=Vulnerable-Web-Application \
                        -Dsonar.host.url=${SONARQUBE_URL} \
                        -Dsonar.login=${SONARQUBE_TOKEN}
                    '''
                }
            }
        }
    }
    post {
        always {
            junit testResults: '**/target/surefire-reports/TEST-*.xml'
            recordIssues enabledForFailure: true, tools: [mavenConsole(), java(), javaDoc()]
            recordIssues enabledForFailure: true, tool: checkStyle()
            recordIssues enabledForFailure: true, tool: spotBugs(pattern: '**/target/spotbugsXml.xml')
            recordIssues enabledForFailure: true, tool: cpd(pattern: '**/target/cpd.xml')
            recordIssues enabledForFailure: true, tool: pmdParser(pattern: '**/target/pmd.xml')
            publishHTML([
                reportName: 'Checkstyle Report', 
                reportDir: 'target/site', 
                reportFiles: 'checkstyle.html',
                keepAll: true, 
                alwaysLinkToLastBuild: true, 
                allowMissing: false
            ])
            publishHTML([
                reportName: 'PMD Report', 
                reportDir: 'target/site', 
                reportFiles: 'pmd.html',
                keepAll: true, 
                alwaysLinkToLastBuild: true, 
                allowMissing: false
            ])
            publishHTML([
                reportName: 'CPD Report', 
                reportDir: 'target/site', 
                reportFiles: 'cpd.html',
                keepAll: true, 
                alwaysLinkToLastBuild: true, 
                allowMissing: false
            ])
            publishHTML([
                reportName: 'SpotBugs Report', 
                reportDir: 'target/site', 
                reportFiles: 'spotbugs.html',
                keepAll: true, 
                alwaysLinkToLastBuild: true, 
                allowMissing: false
            ])
        }
    }
}
