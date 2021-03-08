#!/usr/bin/env groovy
pipeline {
    agent { label 'master' }

    environment {
        PATH = "/run/wrappers/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:$PATH" // Needed for NixOS
    }

    stages {
        stage('Populate Cache') {
            steps {
                withCredentials([file(credentialsId: 'git-crypt-key', variable: 'CRYPT_KEY')]) {
                    echo 'decrypting repo'
                    sh 'git-crypt unlock $CRYPT_KEY'

                    echo 'building hosts'
                    sh '''
                        #!/bin/bash -ex
                        direnv allow .
                        eval "$(direnv export bash)"
                        flk update
                        nixos-rebuild build .#nixos-storage
                        nixos-rebuild build .#nixos-gamer-laptop
                    '''
                }
            }
        }
    }
}
