#!/bin/bash

if [ -z "$ENV_NAME" ]; then
    export ENV_NAME="slurm-pytorch-ddp-boilerplate"
fi

setup() {
    echo "Creating mamba environment: $ENV_NAME.."
    echo "Python version: 3.10"  # Specify the desired Python version
    mamba create -y -n $ENV_NAME python=3.10
    source activate $ENV_NAME
    echo "Installing requirements..."
    # Check for the location of requirements.txt
    if [[ -f ./requirements.txt ]]; then
        mamba install -y --file ./requirements.txt
    elif [[ -f ../requirements.txt ]]; then
        mamba install -y --file ../requirements.txt
    else
        echo "ERROR: Could not find requirements.txt file."
        exit 1
    fi
}

gpu_setup() {
    setup
    echo "Setting up GPU dependencies for CUDA 11.7..."
    mamba install -y pytorch torchvision torchaudio cudatoolkit=11.7 -c pytorch
}

cpu_setup() {
    setup
    echo "Setting up CPU dependencies..."
    mamba install -y pytorch torchvision torchaudio cpuonly -c pytorch
}

clean() {
    echo "Deactivating mamba environment..."
    conda deactivate
    echo "Removing mamba environment..."
    mamba env remove -n $ENV_NAME
    echo "Mamba environment removed successfully."
}

case $1 in
    gpu)
        gpu_setup
        ;;
    cpu)
        cpu_setup
        ;;
    clean)
        clean
        ;;
    *)
        echo $"Usage: $0 {gpu|cpu|clean}"
        exit 1
        ;;
esac

