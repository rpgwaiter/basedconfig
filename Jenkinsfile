#!/usr/bin/env groovy
pipeline {
    agent { label 'master' }

    environment {
        PATH = "/run/wrappers/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:$PATH" // Needed for NixOS
    }

    stages {
        stage("Upgrade Storage") {
            steps {
                withCredentials([file(credentialsId: 'git-crypt-key', variable: 'CRYPT_KEY')]) {
                    echo "decrypting repo"
                    sh "git-crypt unlock $CRYPT_KEY"

                    sh '''
                        #!/bin/bash -ex
                        direnv allow .
                        eval "$(direnv export bash)"
                        flk update
                        flk nixos-storage switch
                    '''
                }
            }
        }
    }
}
