#!/bin/bash
#SBATCH --job-name=hal2chains-cactus
#SBATCH --output=hal2chains
#SBATCH -e hal2chains.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=vlamba@uark.edu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1 
#SBATCH --cpus-per-task=40
#SBATCH --partition condo
#SBATCH --qos condo
#SBATCH --constraint 'xz036'
#SBATCH --time=90:00:00

#don't run this yet
cd ~
module load gcc/11.2.1 mkl/21.3.0 python/3.13-anaconda cactus/2.6.7
source /share/apps/bin/conda-3.13.sh;conda activate cactus-3.13


#Run Cactus

cactus-hal2chains ./jschain /storage/vlamba/data/Genomes-noto/seqfile.hal chains-dir  --refGenome DisMaw 
