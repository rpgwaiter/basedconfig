#!/usr/bin/env groovy
pipeline {
    agent { label 'master' }

    environment {
        PATH = "/run/wrappers/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:$PATH" // Needed for NixOS
    }

    stages {
        stage("Upgrade Storage") {
            stages {
                stage("flk update") {
                    steps {
                        echo 'entering nix-shell'
                        sh 'nix-shell'
                        echo 'updating flake lock file'
                        sh 'flk update'
                    }
                }
            }
        }
    }
}
