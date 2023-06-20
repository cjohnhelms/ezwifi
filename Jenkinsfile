pipeline {
    agent any

    environment { 
    NAME = "wifi-webserver"
    VERSION = "${env.BUILD_ID}-${env.GIT_COMMIT}"
    }   
    stages {
        stage('Build') {
            steps {
                echo 'Building..'
                checkout poll: false, scm: scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/cjohnhelms/wifi-webserver']])
                sh 'podman build -t docker.io/cjohnhelms/${NAME} .'
                sh 'podman tag docker.io/cjohnhelms/${${NAME}:latest docker.io/cjohnhelms/${NAME}:${VERSION}'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
                sh 'podman run -d --name wifi docker.io/cjohnhelms/${NAME}:latest -p 8000:80'
                try {
                    httpRequest ignoreSslErrors: true, responseHandle: 'NONE', url: '192.168.1.100:8000', wrapAsMultipart: false
                } catch (err) {
                    echo 'Container not running as expected'
                    currentBuild.result = 'FAILURE'
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
                withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
                    sh "podman login -u ${env.dockerHubUser} -p ${env.dockerHubPassword} docker.io"
                    sh 'podman push docker.io/cjohnhelms/wifi-webserver:latest'
                }
            }
        }
        stage('Cleanup') {
            steps {
                echo 'Cleaning up...'
                sh 'podman stop wifi'
                sh 'podman rm wifi'
            }
        }   
    }
}
