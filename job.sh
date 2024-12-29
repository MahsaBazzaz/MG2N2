#!/bin/bash
#SBATCH --partition=gpu
#SBATCH --nodes=1
#SBATCH --gres=gpu:v100-pcie:1
#SBATCH --time=07:59:00
#SBATCH --mem=10GB
#SBATCH --ntasks=1
#SBATCH --job-name=MG2N2
#SBATCH --output=./log/MG2N2/output_%j.txt
#SBATCH --error=./log/MG2N2/error_%j.txt

source ../../../scratch/bazzaz.ma/oldenv
module load python/2.7.15 cuda/9.0
pip install virtualenv
virtualenv ../../../scratch/bazzaz.ma/oldenv
source ../../../scratch/bazzaz.ma/oldenv/bin/activate
pip install -r requirements.txt
# Path to your virtual environment
VENV_PATH=../../../scratch/bazzaz.ma/oldenv

# Check if the virtual environment exists
if [ -d "$VENV_PATH" ]; then
    echo "Activating existing virtual environment..."
    # Activate the virtual environment
    source $VENV_PATH/bin/activate
else
    echo "Creating virtual environment..."
    module load python/2.7.15
    pip install virtualenv
    virtualenv $VENV_PATH
    # Activate the virtual environment
    source $VENV_PATH/bin/activate
    # Install required packages
    pip install -r requirements.txt
fi

python translate_dataset.py
python train_generator.py 0 full
deactivate