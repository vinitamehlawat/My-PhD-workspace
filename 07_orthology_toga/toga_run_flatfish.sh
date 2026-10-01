#!/bin/bash
#SBATCH --job-name=ReiHip_toga
#SBATCH -e ReiHip_toga.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=vlamba@uark.edu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1 
#SBATCH --cpus-per-task=50
#SBATCH --partition condo
#SBATCH --qos condo
#SBATCH --constraint 'xz036'
#SBATCH --time=78:00:00

module load nextflow/20.10.0
module load gcc-11.2.1/SKYLAKEX/lastz/1.04.15


cd /home/vlamba/TOGA
module load python

./toga.py /storage/vlamba/data/flat-fish/Genome-chaining/ReiHip-chain/ScoMax.ReiHip.chain /storage/vlamba/data/flat-fish/turbot/Scophthalmus_maximus.ASM1334776v1.113.chr.bed12 /storage/vlamba/data/flat-fish/turbot/Scomax.2bit /storage/vlamba/data/flat-fish/Rhippoglossoides/ncbi_dataset/data/GCA_006182925.3/ReiHip.2bit -i /storage/vlamba/data/flat-fish/turbot/Turbot_isoform.txt --project_dir /storage/vlamba/data/flat-fish/ReiHip_gene_loss --kt --cb 10,100 --cjn 500 --ms
