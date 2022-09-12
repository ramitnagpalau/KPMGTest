#!/usr/bin/env groovy
pipeline {
    agent any
    tools {
       terraform 'terraform'
    }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
    }
    stages {
        stage('Git') {
           steps{
                git url: 'https://github.com/ramitnagpalau/KPMGTest.git', branch: 'main'
            }
        }
        stage('terraform format check') {
            steps{
                sh 'terraform fmt'
            }
        }
        stage('terraform Init') {
            steps{
                sh 'terraform init'
            }
        }
		stage('terraform plan') {
			steps{
				withCredentials([sshUserPrivateKey( credentialsId: 'PUBLIC_KEY',keyFileVariable: 'PUBLIC_KEY')])
				sh 'cp "$PUBLIC_KEY" files/jenkins-aws.pem'
				sh 'terraform plan -out tfplan'
				}
			}
        stage('terraform apply') {
            steps{
			sh '''
                ls -al
                cd Infrastructure/
                terraform apply --auto-approve
                '''
            }
			}
        }
    }