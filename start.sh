#!/bin/bash

if [ ! -d "riscv-mini" ]; then
    git clone git@github.com:kabu1204/riscv-mini.git
else
    echo "riscv-mini already exists, skip cloning."
fi

if [ -z "$SSH_DOCKER_PUB_KEY" ]; then
    export SSH_DOCKER_PUB_KEY=$(cat ~/.ssh/id_rsa.pub)
    echo "SSH_DOCKER_PUB_KEY is set to (~/.ssh/id_rsa.pub) by default: $SSH_DOCKER_PUB_KEY"
else
    echo "SSH_DOCKER_PUB_KEY already set: $SSH_DOCKER_PUB_KEY"
fi

docker compose up -d --build
