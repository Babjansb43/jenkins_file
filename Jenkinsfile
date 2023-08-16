
properties([parameters([choice(choices: ['us-east-1', 'us-east-2', 'us-west-1'], description: 'Select in which region you want to deploy the resource ??', name: 'region')])])


pipeline{
    agent any

      tools {
        terraform 'Terraform'
      }

      parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }
    options {
// Only keep the 5 most recent builds
buildDiscarder(logRotator(numToKeepStr:'5'))
}
    stages(){
        stage('Terraform Version Validation') {
            steps {
                sh 'terraform --version'  // Verify Terraform installation
            }
        }
        stage("Checkot"){
            steps{
        checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Babjansb43/jenkins_file.git']])
            }
        }
        stage("Terraform init"){
            steps{
        sh 'terraform init -input=false'
            }
        }
         stage("Terraform plan"){
            steps{
        sh "terraform plan -input=false -var 'region=${params.region}' -out tfplan"
        sh 'terraform show -no-color tfplan > tfplan.txt'
            }
        }
        stage('Approval') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }
            steps {
                script {
                    def plan = readFile 'tfplan.txt'
                    input message: "Do you want to apply the plan?",
                        parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }
         stage('Terraform Apply') {
            when {
                expression {
                    params.autoApprove == true
                }
            }
            steps {
                // Execute the 'terraform apply' command here
                sh "terraform apply -input=false -var 'region=${params.region}' -auto-approve"
            }
        }
    }
}
