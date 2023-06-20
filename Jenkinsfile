pipeline {
    agent any

    environment { 
    NAME = "wifi-webserver"
    VERSION = "${env.BUILD_ID}-${env.GIT_COMMIT}"
    }   
    stages {
        stage('Stop Existing') {
            steps {
                echo 'Prechecks...'
                sh 'docker stop wifi' || true
            }
        }
        stage('Remove Existing') {
            steps {
                echo 'Prechecks...'
                sh 'docker rm wifi' || true
            }
        }
        stage('Build') {
            steps {
                echo 'Building..'
                checkout poll: false, scm: scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/cjohnhelms/wifi-webserver']])
                sh 'docker build -t docker.io/cjohnhelms/${NAME} .'
                sh 'docker tag docker.io/cjohnhelms/${NAME}:latest docker.io/cjohnhelms/${NAME}:${VERSION}'
            }
        }
        stage('Test') {
            steps {
                script {
                    echo 'Testing..'
                    sh 'docker run -d --name wifi -p 8000:80 docker.io/cjohnhelms/${NAME}:latest'
                    try {
                        httpRequest ignoreSslErrors: true, responseHandle: 'NONE', url: '192.168.1.100:8000', wrapAsMultipart: false
                    } catch (err) {
                        echo 'Container not running as expected'
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
                withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
                    sh 'docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}'
                    sh 'docker push docker.io/cjohnhelms/wifi-webserver:latest'
                }
            }
        }
        stage('Cleanup') {
            steps {
                echo 'Prechecks...'
                sh 'docker stop wifi' || true
            }
        }   
    }
}
