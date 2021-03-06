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
                        echo 'updating flake lock file'
                        sh "#!${which nix-shell} \n" + 'flk update'
                    }
                }
            }
        }
    }
}
