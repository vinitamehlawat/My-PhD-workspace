#!/bin/bash
#SBATCH --job-name=CG_anotated_OrthoFinder
#SBATCH -e CG_anotated_OrthoFinder.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=vlamba@uark.edu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=30
#SBATCH --partition condo
#SBATCH --qos condo
#SBATCH --constraint 'xz036'
#SBATCH --time=100:00:00

# Load necessary modules
module load orthofinder/2.5.2
module load muscle/3.8.31
module load iqtree/1.6.12  

# Run OrthoFinder
orthofinder -t 30 -a 30 -M msa -A muscle -T iqtree -f /storage/vlamba/data/TOGA_pep/OrthoFinder_inputs
