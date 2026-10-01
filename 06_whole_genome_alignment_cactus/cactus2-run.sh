#!/bin/bash
#SBATCH --job-name=seqfile2-cactus
#SBATCH --output=seqfile2.hal
#SBATCH -e seqfile2.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=vlamba@uark.edu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1 
#SBATCH --cpus-per-task=30
#SBATCH --partition condo
#SBATCH --qos condo
#SBATCH --constraint 'xz036'
#SBATCH --time=20-00:00:00

#don't run this yet
cd ~
module load gcc/11.2.1 mkl/21.3.0 python/3.13-anaconda cactus/2.6.7
source /share/apps/bin/conda-3.13.sh;conda activate cactus-3.13


#Run Cactus
cactus /storage/vlamba/data/Genomes-noto/job2 /storage/vlamba/data/Genomes-noto/seqfile2.txt /storage/vlamba/data/Genomes-noto/seqfile2.hal 
