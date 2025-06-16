
// ==========================================================
// Jenkins Pipeline script to manage a dummy repostory
// Author: Juan Jose Solorzano
// Date: 12/10/2024
// ==========================================================
//
// The pipeline block defines the Jenkins Job configuration
pipeline {
  agent {
    label 'AgentNumberOne' // Use a Linux agent
  }

  triggers {
    // Fires only on GitHub push events
    githubPush()
  }

  stages {
    stage('Checkout') {
      steps {
        // Replace URL and credentialsId with your own
        git(
          url: 'https://github.com/JuanJoseSolorzano/Bash_Scripting.git',
          branch: 'master'
        )
      }
    }

    stage('Build') {
      steps {
        echo 'Building...'
        // Add your build command; example:
      }
    }

    stage('Test') {
      steps {
        echo 'Testing...'
        // Add your test command; example:
      }
    }

    stage('Deploy') {
      when {
        branch 'master'
      }
      steps {
        echo 'Deploying build from master...'
        // Example deploy script:
      }
    }
  }

  post {
    success {
      echo 'Pipeline completed successfully!'
    }
    failure {
      echo 'Pipeline failed. Please review the logs.'
    }
  }
}
