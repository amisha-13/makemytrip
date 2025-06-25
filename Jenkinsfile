pipeline {

    agent any


    options {
        buildDiscarder(logRotator(numToKeepStr: '3', artifactNumToKeepStr: '3'))
    }

    tools {
        maven 'mvn_3.9.9'  // Make sure this Maven tool is defined in Jenkins global tools
    }

    stages {
        stage('Code Compilation') {
            steps {
                echo 'Starting Code Compilation...'
                sh 'mvn clean compile'
                echo 'Code Compilation Completed Successfully!'
            }
        }

        stage('Code QA Execution') {
            steps {
                echo 'Running JUnit Test Cases...'
                sh 'mvn clean test'
                echo 'JUnit Test Cases Completed Successfully!'
            }
        }

        stage('Code Package') {
            steps {
                echo 'Creating WAR Artifact...'
                sh 'mvn clean package'
                echo 'WAR Artifact Created Successfully!'
            }
        }


        stage ('Building & Tag Docker Image') {
            steps {
                echo 'Starting Building Docker Image'
                sh 'docker build -t amishajoshi/makemytrip .'
                sh 'docker build -t makemytrip .'
                echo 'Completed Building Docker Image'
            }
        }

        stage ('Docker Image Scanning') {
            steps {
                echo 'Docker Image Scanning Started'
                sh 'java -version'
                echo 'Docker Image Scanning Started'
            }
        }

        stage (' Docker push to DockerHub ') {
            steps {
                script {
                    withCredentials ([string (credentialsId: 'dockerhubCred', variable: 'dockerhubCred' ) ]){
                    sh 'docker login docker.io -u amishajoshi -p ${dockerhubCred}'
                    echo "Push Docker Image to DockerHub : In Progress"
                    sh 'docker push amishajoshi/makemytrip:latest'
                    echo "Push Docker Image to DockerHub : In Progress"
                    sh 'whoami'
                    }
                }
            }
        }
        stage(' Docker Image Push to Amazon ECR') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'ecr:ap-south-1:ecr-credentials', url:"https://197823316368.dkr.ecr.ap-south-1.amazonaws.com"]) {
                    sh '''
                    echo "List the docker images present in local"
                    docker images
                    echo "Tagging the Docker Image: In Progress"
                    docker tag makemytrip:latest 197823316368.dkr.ecr.ap-south-1.amazonaws.com/makemytrip:latest
                    echo "Tagging the Docker Image: Completed"
                    echo "Push Docker Image to ECR : In Progress"
                    docker push 197823316368.dkr.ecr.ap-south-1.amazonaws.com/makemytrip:latest
                    echo "Push Docker Image to ECR : Completed"
                    '''
                    }
                }
            }
        }

        stage('Tag and Upload to Nexus') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'nexus-docker-creds', usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASS')]) {

                        // ✅ Correct Docker registry login (no /repository path)
                        sh "docker login http://3.110.188.132:8085 -u ${NEXUS_USER} -p ${NEXUS_PASS}"

                        echo "Push Docker Image to Nexus: In Progress"

                        // ✅ Properly tag image with registry and repo name
                        sh "docker tag makemytrip 3.110.188.132:8085/makemytrip:latest"

                        // ✅ Push the full tag
                        sh "docker push 3.110.188.132:8085/makemytrip:latest"

                        echo "Push Docker Image to Nexus: Completed"
                    }
                }
            }
        }

        stage ('Clean Up Local Docker Images') {
            steps {
                echo 'Cleaning Up Local Docker Images...'
                sh '''
                    docker rmi amishajoshi/makemytrip:latest || echo "Image not found or already deleted"
                    docker rmi makemytrip:latest || echo "Image not found or already deleted"
                    docker rmi 197823316368.dkr.ecr.ap-south-1.amazonaws.com/makemytrip:latest || echo "Image not found or already deleted"
                    docker image prune -f
                '''
        echo 'Local Docker Images Cleaned Up Successfully!'
            }
        }
    }
    post {
        success {
            echo '✅ Build completed successfully.'
        }
        failure {
            echo '❌ Build failed.'
        }
    }
}