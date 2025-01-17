#!/usr/bin/env groovy

pipeline {
  agent { label 'executor-v2' }

  options {
    timestamps()
    buildDiscarder(logRotator(daysToKeepStr: '30'))
  }

  triggers {
    cron(getDailyCronString())
  }

  stages {
    stage('Test 2.4') {
      environment {
        RUBY_VERSION = '2.4'
      }
      steps {
        sh './test.sh'
        junit 'spec/reports/*.xml, features/reports/*.xml'
      }
    }

    stage('Test 2.5') {
      environment {
        RUBY_VERSION = '2.5'
      }
      steps {
        sh './test.sh'
        junit 'spec/reports/*.xml, features/reports/*.xml'
      }
    }

    stage('Test 2.6') {
      environment {
        RUBY_VERSION = '2.6'
      }
      steps {
        sh './test.sh'
        junit 'spec/reports/*.xml, features/reports/*.xml'
      }
    }

    stage('Build standalone image') {
      steps {
        sh './build-standalone'
      }
    }

    stage('Push standalone image to DockerHub') {
      when {
        branch 'master'
      }

      steps {
        sh './push-image'
      }
    }

    // Only publish to RubyGems if the HEAD is
    // tagged with the same version as in version.rb
    stage('Publish to RubyGems') {
      agent { label 'releaser-v2' }

      when {
        expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
        branch "master"
        expression {
          def exitCode = sh returnStatus: true, script: './needs-publishing'
          return exitCode == 0
        }
      }

      steps {
        // Clean up first
        sh 'docker run -i --rm -v $PWD:/src -w /src alpine/git clean -fxd'

        sh './publish.sh'

        // Clean up again...
        sh 'docker run -i --rm -v $PWD:/src -w /src alpine/git clean -fxd'
        deleteDir()
      }
    }
  }

  post {
    always {
      cleanupAndNotify(currentBuild.currentResult)
    }
  }
}
