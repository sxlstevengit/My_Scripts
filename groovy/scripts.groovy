#!groovy

pipeline {
	agent any

	environment {
		PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin"
	}

	parameters {
		choice(
			choices: 'dev\nprod',
			description: 'Choose deploy environment',
			name: 'deploy_env'
		)
		string (name: 'branch', defaultValue: 'main', description: 'Fill in your ansible repo branch')
	}

	stages {
		stage ("Pull deploy code") {
			steps{
				sh 'git config --global http.sslVerify false'
				dir ("${env.WORKSPACE}"){
					git branch: 'main', credentialsId: '1', url: 'http://testgit.abc.com/root/wordpress_ansible.git'
				}
			}

		}

		stage ("Check env") {
			steps {
				sh """
				set +x
				echo "hello"
				echo `whoami`
					echo "[INFO] Current deployment user is `whoami`"
					echo "[INFO] Current python version"
					echo "[INFO] Current ansible version"
					ansible-playbook --version
					echo "[INFO] Remote system disk space"
					ssh root@192.168.20.53 df -h
					echo "[INFO] Rmote system RAM"
					ssh root@192.168.20.53 free -m
                set -x
				"""
			}
		}

		stage ("Anisble deployment") {
			steps {
				input "Do you approve the deployment?"
				dir("${env.WORKSPACE}"){
					echo "[INFO] Start deployment"
					sh """
					set +x
					ansible-playbook -i inventory/$deploy_env deploy.yml -e project=wordpress -e branch=$branch -e env=$deploy_env
					set -x
					"""
					echo "[INFO] Deployment finished..."
				}
			}
		}

	}

}