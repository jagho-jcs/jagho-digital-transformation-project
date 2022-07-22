#!/usr/bin/env groovy

properties(
    [
        parameters(
            [
                string(
                    name: 'Branch_To_Checkout',
                    defaultValue: '',
                    description: "Please enter the name of the Branch you would like to checkout."
                ),
                choice(
                    name: 'build_option',
                    choices: ['', 'plan', 'apply', 'destroy'],
                    description: 'Apply will deploy the resources, Destroy will destroy the resources'
                )
            ]
        ),
        buildDiscarder(
            logRotator(
                artifactDaysToKeepStr: '5',
                artifactNumToKeepStr: '1',
                daysToKeepStr: '30',
                numToKeepStr: '20'
            )
        ),
        disableConcurrentBuilds(),
        gitLabConnection(),
        pipelineTriggers(
            [[
                $class                            : "GitLabPushTrigger",
                triggerOnPush                     : true,
                triggerOnMergeRequest             : true,
                triggerOpenMergeRequestOnPush     : "never",
                triggerOnNoteRequest              : true,
                noteRegex                         : "Jenkins please retry a build",
                skipWorkInProgressMergeRequest    : true,
                ciSkip                            : false,
                setBuildDescription               : true,
                branchFilterType                  : "NameBasedFilter"
                includeBranchesSpec               : "master",
                excludeBranchesSpec               : ""               
            ]]
        )
    ]
)

def gitSource = ''
def gitCredentialsId = 's.rft.ciBuild_ssh'
def useTag = true
def tag = params.tag
def build_option = params.build_option
def TF_WORKING_FOLDER = 'terraform-infra/env/us-east-1/dev'
def TF_VAR_BUILD_NUMBER = 'dev-${BUILD_NUMBER}'
def TF_VERSION = '1.0.5'
def envType = 'dev'
def branch = branchToBuild

class AwsInfo implements Serializable {
    public String awsRegion
    public String awsRole
    public String awsRoleAccount
    public String awsProfile
    public String assetID
}

def awsInfo = new AwsInfo(
    awsRegion       : '',
    assetID         : '',
    awsProfile      : 'default',
    awsRole         : '',
    awsRoleAccount  : ''
)

class TfInfo implements Serializable {
    public String state_bucket
    public String state_key
    public String state_lockable_table
}

def tfInfo = new TfInfo(
    state_bucket            : "a${awsInfo.assetID}-sem2dm-terraform-state-${envType}-use1",
    state_lockable_table    : "a${awsInfo.assetID}-sem2dm-terraform-state-lock-${envType}-use1",
    state_key               : "${envType}/sem2dm-infra-resources/terraform.tfstate"
)

echo '\u2600 ftInfo = ' + tfInfo.state_bucket

if (build_option == null || !['plan', 'apply', 'destroy'].contains(build_option)) {
    currentBuild.result = 'Failure'
    error('unsupported build option: ' + build_option)
}

timestamps {
    try {
        node(jenkinsDockerImage) {
            echo '\u2600 Environment Variables'
            sh "env"
            stage('preparation') {
                echo '\u2756 Preparation'
                echo '\u2600 parameter tag = ' + tag
                if (tag == null tag == '') {
                    echo '\u27A1 Checkout branch ' + branch
                    useTag = false
                } else {
                    echo '\u27A1 Checkout by tag ' + tag
                    useTag = true
                }
                if (!useTag) {
                    checkout(
                        [
                            $class                              : 'GitSCM',
                            branches                            : [[name: '*/' + branch]],
                            doGenerateSubmoduleconfigurations   : false
                            extensions                          : [[
                                $class                          : 'submoduleOption',
                                disableSubmodules               : false,
                                parentCredentials               : true,
                                recursiveSubmodules             : true,
                                reference                       : '',
                                trackingSubmodules              : false
                            ]],
                            gitTool                             : 'Default',
                            submoduleCfg                        : [],
                            userRemoteConfigs                   : [[
                                credentialsId                   : gitCredentialsId,
                                url                             : gitSource
                            ]],
                        ]
                    )
                } else {
                    checkout scm:
                    [
                        $class                                  : 'GitSCM',
                        branches:                               : [[
                            name                                : 'refs/tags/' + tag
                        ]],
                        doGenerateSubmoduleconfigurations       : false,
                        extensions                              : [[
                            $class                              : 'SubmoduleOption',
                            disableSubmodules                   : false,
                            parentCredentials                   : true,
                            recursiveSubmodules                 : true,
                            reference                           : '',
                            trackingSubmodules                  : false
                        ]],
                        gitTool                                 : 'Default',
                        submoduleCfg                            : [],
                        userRemoteConfigs                       : [[
                            credentialsId                       : gitCredentialsId,
                            url                                 : gitSource
                        ]]
                    ],
                    poll: false
                }
            }
            withAWS(region: awsInfo.awsRegion, role: awsInfo.awsRole, roleAccount: awsInfo.awsRoleAccount) {
                dir("${TF_WORKING_FOLDER}") {
                    environment {
                        TF_PLUGIN_CACHE_DIR = "../.plugins"
                    }
                    stage ('parameters') {
                        sh """
                            echo "You have selected: ${params.build_option}"
                        """
                    }
                    stage ('Build Phase: Plan') {
                        // Remove terraform state so we always start from a clean state
                        if (fileExists(".terraform/terraform.tfstate"))
                            {
                                sh "rm -rf .terraform/terraform.tfstate"
                            }
                        if (fileExists("status"))
                            {
                                sh "rm status"
                            }
                        sh """
                            rm -rf tf_installer.zip terraform
                            wget -O tf_installer.zip https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
                            unzip tf_installer.zip
                            chmod a+x terraform
                            ./terraform init -no-color -input=true \
                            -backend-config="bucket=${tfInfo.state_bucket}" \
                            -backend-config="region=${awsInfo.awsRegion}" \
                            -backend-config="dynamodb_table=${tfInfo.state_lock_table}" \
                            -backend-config="key=${tfInfo.state_key}" \
                            | grep -v 'Downloading git'
                            ls -a
                            ./terraform -version
                            ./terraform plan -var-file="./env/us-east-1/${envType}/${envType}.tfvars" \
                            -lock=false -no-color -input=false
                        """
                    }
                    stage('Build Phase: Apply') {
                        if (params.build_option == 'apply') {
                            sh """
                            rm -rf tf_installer.zip terraform
                            wget -O tf_installer.zip https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
                            unzip tf_installer.zip
                            chmod a+x terraform
                            ./terraform init -no-color -input=true \
                            -backend-config="bucket=${tfInfo.state_bucket}" \
                            -backend-config="region=${awsInfo.awsRegion}" \
                            -backend-config="dynamodb_table=${tfInfo.state_lock_table}" \
                            -backend-config="key=${tfInfo.state_key}" \
                            | grep -v 'Downloading git'
                            ls -a
                            ./terraform -version
                            ./terraform apply -var-file="./env/us-east-1/${envType}/${envType}.tfvars" -no-color -input=false -auto-approve
                            """
                        }
                    }
                    stage('Build Phase: destroy') {
                        if (params.build_option == destroy) {
                    // Remove terraform state so we always start from a clean state
                        if (fileExists(".terraform/terraform.tfstate")) {
                            sh "rm -rf .terraform/terraform.tfstate"
                        }
                        if (fileExists("status")) {
                            sh "rm status"
                        }
                        sh """
                            rm -rf tf_installer.zip terraform
                            wget -O tf_installer.zip https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
                            unzip tf_installer.zip
                            chmod a+x terraform
                            ./terraform init -no-color -input=true \
                            -backend-config="bucket=${tfInfo.state_bucket}" \
                            -backend-config="region=${awsInfo.awsRegion}" \
                            -backend-config="dynamodb_table=${tfInfo.state_lock_table}" \
                            -backend-config="key=${tfInfo.state_key}" \
                            | grep -v 'Downloading git'
                            ls -a
                            ./terraform -version
                            ./terraform destroy -var-file="./env/us-east-1/${envType}/${envType}.tfvars" -no-color -input=false -auto-approve
                        """
                        }
                    }
                }
            }
            currentBuild.result = 'SUCCESS'
        }
    } catch (exc) {
        currentBuild.result = 'FAILURE'
        throw exc
    }
}
