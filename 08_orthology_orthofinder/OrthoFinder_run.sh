#!/bin/bash
#SBATCH --job-name=Denovo-gene_OrthoFinder
#SBATCH -e Denovo-gene_OrthoFinder.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=vlamba@uark.edu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1 
#SBATCH --cpus-per-task=30
#SBATCH --partition condo
#SBATCH --qos condo
#SBATCH --constraint 'xz036'
#SBATCH --time=100:00:00

module load orthofinder/2.5.2 
module load mafft/7.505 
module load fasttree/2.1.10
 
orthofinder -M msa -f /storage/vlamba/data/Denovo_gene-Noto/Orthofinder
