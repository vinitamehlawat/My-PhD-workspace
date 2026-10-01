#!/bin/bash
#SBATCH --job-name=DENSE_PogAlb
#SBATCH -e DENSE_PogAlb.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=vlamba@uark.edu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=45
#SBATCH --partition condo
#SBATCH --qos condo
#SBATCH --constraint 'xz036'
#SBATCH --time=100:00:00


# 1. load following modules
eval "$(conda shell.bash hook)"
conda activate nextflow-25.3.0-el9
module load blast
module load diamond
module load java/sunjdk_17.0.8
module load apptainer

# 2. Navigate to your working directory (optional, but good practice) 
cd /storage/vlamba/data/Denovo_gene-Noto/

# 3. Execute the pipeline
nextflow run i2bc/dense -profile apptainer -c vini.config -resume
