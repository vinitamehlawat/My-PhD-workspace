#!/bin/bash
#SBATCH --job-name=TaePak_makelastz
#SBATCH -e TaePak_makelastz.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=vlamba@uark.edu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1 
#SBATCH --cpus-per-task=50
#SBATCH --partition condo
#SBATCH --qos condo
#SBATCH --constraint 'xz036'
#SBATCH --time=190:00:00

module load python
module load nextflow

conda activate Lastz 

cd make_lastz_chains-main/
pip3 install -r requirements.txt
./install_dependencies.py

./make_chains.py TaeGut  Pkram /home/vlamba/Sumaira_data/Modified_TaeGut.fasta /home/vlamba/Sumaira_data/Modified_P.krameri.fasta  --project_dir /home/vlamba/Sumaira_data/TaePak_chaining_24_Oct -f  --chaining_memory 50
