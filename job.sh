#!/bin/bash
#SBATCH --partition=gpu
#SBATCH --nodes=1
#SBATCH --gres=gpu:v100-pcie:1
#SBATCH --time=07:59:00
#SBATCH --mem=10GB
#SBATCH --ntasks=1
#SBATCH --job-name=MG2N2
#SBATCH --output=./log/output_%j.txt
#SBATCH --error=./log/error_%j.txt

module load python/3.7.0 cuda/9.0
pip install virtualenv
# Path to your virtual environment
VENV_PATH=../../../scratch/bazzaz.ma/oldenv

# Check if the virtual environment exists
if [ ! -d "$VENV_PATH" ]; then
    echo "Creating virtual environment..."
    virtualenv --python=python3 ../../../scratch/bazzaz.ma/oldenv
fi

echo "Activating virtual environment..."
source $VENV_PATH/bin/activate
python -m ensurepip --upgrade
python -m pip install --upgrade pip
pip install -r requirements.txt
echo "Finished Setting Up virtual environment..."
echo "running python translate_dataset.py"
python translate_dataset.py
echo "running python train_generator.py"
python train_generator.py 0 full
deactivate