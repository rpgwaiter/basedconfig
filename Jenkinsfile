#!/usr/bin/env groovy
pipeline {
    agent { label 'master' }

    environment {
        PATH = "/run/wrappers/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:$PATH" // Needed for NixOS
    }

    stages {
        stage("Upgrade Storage") {
            stages {
                stage("direnv setup") {
                    steps {
                        echo "load devshell"
                        sh "direnv export bash"
                        sh "direnv allow ."
                    }
                }
                stage("update lock file") {
                    steps {
                        sh "flk update"
                    }
                }
            }
        }
    }
}
