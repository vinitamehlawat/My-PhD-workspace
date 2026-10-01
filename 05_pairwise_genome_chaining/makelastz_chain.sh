#!/bin/bash
#SBATCH --job-name=CotGob_makelastz
#SBATCH -e CotGob_makelastz.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=vlamba@uark.edu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1 
#SBATCH --cpus-per-task=30
#SBATCH --partition condo
#SBATCH --qos condo
#SBATCH --constraint 'xz036'
#SBATCH --time=40:00:00

module load python
conda activate nextflow-25.3.0-el9

conda activate Lastz 

cd make_lastz_chains-main/
pip3 install -r requirements.txt
./install_dependencies.py

./make_chains.py EleMac CotGob /storage/vlamba/data/Genomes-noto/NOTO-genome/Emaclovinus/ncbi_dataset/data/GCF_036324505.1/Emac.2bit /home/vlamba/make_genome-chaining-Feb3/CotGob.2bit  --pd /storage/vlamba/data/Chaining_with_Emac/CotGob-chain -f --chaining_memory 50
