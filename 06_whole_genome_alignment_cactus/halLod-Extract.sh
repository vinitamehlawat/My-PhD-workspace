#!/bin/bash
#SBATCH --job-name=halLodExtract-cactus
#SBATCH --output=halLodExtract-OUT
#SBATCH -e halLodExtract.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=vlamba@uark.edu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1 
#SBATCH --cpus-per-task=1
#SBATCH --partition cloud72
#SBATCH --qos cloud
#SBATCH --time=72:00:00

#don't run this yet
cd ~
module load gcc/11.2.1 mkl/21.3.0 python/3.13-anaconda cactus/2.6.7
source /share/apps/bin/conda-3.13.sh;conda activate cactus-3.13


#Run Cactus

halLodExtract /storage/vlamba/data/Genomes-noto/seqfile.hal seqfile_100.hal 100
