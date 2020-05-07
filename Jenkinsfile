#!groovy

pipeline {
    agent none
    options {
        timeout(time: 10, unit: 'MINUTES')
    }

    parameters {
        string( name: 'USER', defaultValue: '', description: 'Correo electronico')
        string( name: 'IMAGE_NAME', defaultValue: 'oracle-container-master', description: 'Identificador Servicio')
		string( name: 'IMAGE_NUMBER', defaultValue: '1', description: 'Identificador Imagen')
    }

    environment {
        REGISTRY_URL = "${REGISTRY_URL}"
        REGISTRY_URL_IP = "${REGISTRY_URL_IP}"
        REGISTRY_CREDENTIALS = "${REGISTRY_CREDENTIALS}"
	    IMAGE_NAME = "${IMAGE_NAME}"
		IMAGE_NUMBER = "${IMAGE_NUMBER}"		
    }

    stages {
        stage('INITIALIZE') {
            agent any
            steps { initialize() }
        }
      
        stage('BUILD AND REGISTER IMAGE') {
            agent any
            steps { buildAndRegisterDockerImage() }
        }

        stage('Eliminar') {
            agent any
            steps {
            
            echo "Delete image from server"
            echo "${env.REGISTRY_URL_IP}"
            sh"docker rmi ${env.REGISTRY_URL_IP}/${env.IMAGE_NAME}:${env.IMAGE_NUMBER} -f"
            sh"docker rmi ${env.IMAGE_NAME}:${env.IMAGE_NUMBER} -f"
            }
        }
    }
}

def initialize() {
    env.REGISTRY_URL = params["REGISTRY_URL"]
    env.REGISTRY_URL_IP = "REGISTRY_URL_IP"
    env.REGISTRY_CREDENTIALS = params["REGISTRY_CREDENTIALS"]
    env.IMAGE_NAME = params["IMAGE_NAME"]
}

def buildAndRegisterDockerImage() {
    def buildResult
    docker.withRegistry("${env.REGISTRY_URL}","${env.REGISTRY_CREDENTIALS}") {
        echo "Building ${env.IMAGE_NAME}:${env.IMAGE_NUMBER}"
        buildResult = docker.build("${env.IMAGE_NAME}:${env.BUILD_ID}","--build-arg CODE_REGISTRY=wtemp.cem:8445 .")
        echo "Register ${env.IMAGE_NAME} at ${env.REGISTRY_URL}"
        buildResult.push("${env.IMAGE_NUMBER}")
        echo "Disconnect from registry"
        sh "docker logout ${env.REGISTRY_URL}"
    }
}



        

