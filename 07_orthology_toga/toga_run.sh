#!/bin/bash
#SBATCH --job-name=CotGob_toga
#SBATCH -e CotGob_toga.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=vlamba@uark.edu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1 
#SBATCH --cpus-per-task=40
#SBATCH --partition condo
#SBATCH --qos condo
#SBATCH --constraint 'xz036'
#SBATCH --time=30:00:00


module load gcc-11.2.1/SKYLAKEX/lastz/1.04.15
module load nextflow/22.10.1

cd /home/vlamba/TOGA

./toga.py /storage/vlamba/data/Chaining_with_Emac/CotGob-chain/EleMac.CotGob.chain /storage/vlamba/data/Genomes-noto/NOTO-genome/Emaclovinus/ncbi_dataset/data/GCF_036324505.1/GCF_036324505.1_JC_Emac_rtc_rv5.ncbiRefSeq.bed /storage/vlamba/data/Genomes-noto/NOTO-genome/Emaclovinus/ncbi_dataset/data/GCF_036324505.1/Emac.2bit /home/vlamba/make_genome-chaining-Feb3/CotGob.2bit -i /storage/vlamba/data/Genomes-noto/NOTO-genome/Emaclovinus/ncbi_dataset/data/GCF_036324505.1/Emac_isoform.txt --project_dir /storage/vlamba/data/Chaining_with_Emac/CotGob2_gene_loss  --kt --cb 10,100 --cjn 500 --ms
