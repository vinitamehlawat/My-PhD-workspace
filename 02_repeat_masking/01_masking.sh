#!/bin/bash
#SBATCH --job-name=genome_masking
#SBATCH -e genome_masking.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=vlamba@uark.edu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=30
#SBATCH --partition condo
#SBATCH --qos condo
#SBATCH --constraint 'xz036'
#SBATCH --time=700:00:00

# 1. Fix Conda Activation for SLURM
source $(conda info --base)/etc/profile.d/conda.sh
conda activate RepeatModeler

# Note: Removed "module load RepeatMasker/4.1.3" to avoid the TRF error. 
# The Conda environment should provide both RepeatModeler and RepeatMasker.

# Define your genome directory
GENOME_DIR="/storage/vlamba/data/Denovo_gene-Noto/new_workflow/Genomes"

# 0. Unmask the NCBI genomes (convert lowercase to uppercase)
for GENOME_PATH in ${GENOME_DIR}/*.fna; do
    PREFIX=$(basename ${GENOME_PATH})
    # Translate a-z to A-Z and save to the new unmasked directory
    tr 'a-z' 'A-Z' < ${GENOME_PATH} > unmasked_genomes/${PREFIX}
done

# 1. Generate de novo repeat libraries using the UNMASKED genomes
for GENOME_PATH in unmasked_genomes/*.fna; do
    PREFIX=$(basename ${GENOME_PATH}.fna)
    
    BuildDatabase -name ${PREFIX}_db -engine ncbi ${GENOME_PATH}
    RepeatModeler -database ${PREFIX}_db -engine ncbi -pa 30
done

# 2. Combine into a pan-nototheniid TE library
cat *-families.fa > pan_noto_repeats.fasta

# 3. Soft-mask the unmasked genomes with your custom library
for GENOME_PATH in unmasked_genomes/*.fna; do
    RepeatMasker -pa 30 -lib pan_noto_repeats.fasta -xsmall -dir masked_genomes/ ${GENOME_PATH}
done
