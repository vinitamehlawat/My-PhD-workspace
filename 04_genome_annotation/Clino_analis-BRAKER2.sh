#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --partition condo
#SBATCH --qos condo
#SBATCH --constraint 'xz036'
#SBATCH --time=100:00:00
#SBATCH --output=BRAKER2.out


#don't run this yet
cd ~
BRAKER=/share/apps/python/anaconda-3.11/envs/braker2tabix-3.11
GENEMARK=/share/apps/bioinformatics/GeneMark/gmes_linux_64
module load gcc/8.3.1 mkl/19.0.5 genemark/2.6-3 java/sunjdk_1.8.0 python/3.11-anaconda
source /share/apps/bin/conda-3.11.sh;conda activate braker2tabix-3.11
export PATH=$PATH:$BRAKER/ProtHint/bin
rsync -av $BRAKER/GUSHR .
cp $GENEMARK/gm_key ~/.gm_key
rsync -av $BRAKER/config .
export AUGUSTUS_CONFIG_PATH=/home/$USER/config
export AUGUSTUS_BIN_PATH=$BRAKER/bin
export AUGUSTUS_SCRIPTS_PATH=$BRAKER/bin
rsync -av $GENEMARK/GeneMark-E-tests .

#Run BRKAER2 

braker.pl --genome=/home/vlamba/GCA_023055335.1_fCliAna1.0.p_genomic.fna --prot_seq=/storage/vlamba/data/Genome-files/GCF_016920845.1_GAculeatus_UGA_version5_protein.faa --softmasking --core 20
