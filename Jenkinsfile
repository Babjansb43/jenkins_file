
properties([parameters([choice(choices: ['eu-north-1', 'us-east-2', 'us-west-1'], description: 'Select in which region you want to deploy the resource ??', name: 'region')])])


pipeline{
    agent any
      parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
      }
    options {
// Only keep the 5 most recent builds
buildDiscarder(logRotator(numToKeepStr:'8'))
}
    stages(){
        stage('Install and Use Terraform') {
            steps {
                script {
                    sh 'curl -O https://releases.hashicorp.com/terraform/0.15.0/terraform_0.15.0_linux_amd64.zip'
                    sh 'unzip -o terraform_0.15.0_linux_amd64.zip'
                    sh 'chmod +x terraform'
                    sh 'mv terraform /var/lib/jenkins/terraform'
                }
            }
        }
        stage('Terraform Version Validation') {
            steps {
                sh '/var/lib/jenkins/terraform --version'  // Verify Terraform installation
            }
        }
        stage("Terraform init"){
            steps{
                sh '/var/lib/jenkins/terraform init'
            }
        }
         stage("Terraform plan"){
            steps{
                sh "/var/lib/jenkins/terraform plan -var 'region=${params.region}' -out tfplan"
                sh '/var/lib/jenkins/terraform show -no-color tfplan > tfplan.txt'
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
                sh "/var/lib/jenkins/terraform apply  -var 'region=${params.region}' -auto-approve"
            }
        }
    }
}
