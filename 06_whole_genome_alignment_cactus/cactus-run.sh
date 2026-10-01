#!/bin/bash
#SBATCH --job-name=seqfile-cactus
#SBATCH --output=seqfile.hal_out
#SBATCH -e seqfile.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=vlamba@uark.edu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1 
#SBATCH --cpus-per-task=32
#SBATCH --partition condo
#SBATCH --qos condo
#SBATCH --constraint 'xz036'
#SBATCH --time=20-00:00:00

#don't run this yet
cd ~
module load gcc/11.2.1 mkl/21.3.0 python/3.13-anaconda cactus/2.6.7
source /share/apps/bin/conda-3.13.sh;conda activate cactus-3.13


#Run Cactus
cactus ./js /storage/vlamba/data/Genomes-noto/seqfile.txt /storage/vlamba/data/Genomes-noto/seqfile.hal 
