#!/bin/bash
#SBATCH --job-name=PseGeo-chaning
#SBATCH -e PseGeo-chaning.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=vlamba@uark.edu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1 
#SBATCH --cpus-per-task=32
#SBATCH --partition condo
#SBATCH --qos condo
#SBATCH --constraint 'xz036'
#SBATCH --time=8:00:00

module load gcc/11.2.1 mkl/21.3.0 python/3.13-anaconda cactus/2.6.7
conda activate cactus-3.13

cd /home/vlamba

hal2fasta /storage/vlamba/data/Genomes-noto/2-alignment/seqfile2.hal PseGeo | ./faToTwoBit stdin /home/vlamba/PseGeo.2bit

halStats --bedSequences PseGeo /storage/vlamba/data/Genomes-noto/2-alignment/seqfile2.hal > /home/vlamba/PseGeo.bed


halLiftover --outPSL /storage/vlamba/data/Genomes-noto/2-alignment/seqfile2.hal PseGeo /home/vlamba/PseGeo.bed CotGob /dev/stdout | ./pslPosTarget stdin /home/vlamba/PseGeo-to-CotGob.psl

./axtChain -psl -linearGap=loose /home/vlamba/PseGeo-to-CotGob.psl /home/vlamba/New-gene-Noto/CotGob.2bit /home/vlamba/PseGeo.2bit /home/vlamba/PseGeo-CotGob.chain
