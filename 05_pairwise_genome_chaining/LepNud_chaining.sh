#!/bin/bash
#SBATCH --job-name=EleMac-chaning
#SBATCH -e EleMac-chaning.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=vlamba@uark.edu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1 
#SBATCH --cpus-per-task=32
#SBATCH --partition condo
#SBATCH --qos condo
#SBATCH --constraint 'xz036'
#SBATCH --time=20:00:00

module load gcc/11.2.1 mkl/21.3.0 python/3.13-anaconda cactus/2.6.7
conda activate cactus-3.13

cd /home/vlamba

halLiftover --outPSL /storage/vlamba/data/Genomes-noto/2-alignment/seqfile2.hal EleMac EleMac.bed CotGob /dev/stdout | ./pslPosTarget stdin EleMac-to-CotGob.psl
