#!/bin/bash
#SBATCH --job-name=2_chaning
#SBATCH -e 2_chaning.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=vlamba@uark.edu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1 
#SBATCH --cpus-per-task=32
#SBATCH --partition condo
#SBATCH --qos condo
#SBATCH --constraint 'xz036'
#SBATCH --time=20:00:00

module load gcc-11.2.1/SKYLAKEX/lastz/1.04.15
module load nextflow/20.10.0

cd /home/vlamba/make_lastz_chains

./make_chains.py CotGob DisMaw /home/vlamba/modified_GCF_900634415.1.fa /storage/vlamba/data/Genomes-noto/NOTO-genome/Nototheniinae/Dmawsoni/ncbi_dataset/data/GCA_011823955.1/2_modified_GCA_011823955.1_KU_Dm_1.0_genomic.fna --project_dir /home/vlamba/2_CotDis_chaining -f --chaining_memory 30
