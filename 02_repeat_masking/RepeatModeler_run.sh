#!/bin/bash
#SBATCH --job-name=Sculpin-RepeatModeler
#SBATCH -e Sculpin-RepeatModeler.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=vlamba@uark.edu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1 
#SBATCH --cpus-per-task=32
#SBATCH --partition condo
#SBATCH --qos condo
#SBATCH --constraint 'xz036'
#SBATCH --time=90:00:00

conda activate RepeatModeler

cd ~

# make a directory for storing logs
mkdir -p repeatmodeler-logs

# build new RepeatModeler BLAST database with a name that includes an ID (e.g., a species code, specimen ID, etc.) 
# and genus/species. Modify accordingly.

BuildDatabase -name Myoxocephalus_aenaeus -engine ncbi /storage/vlamba/data/Genome-files/Sculpin.fa

# now run RepeatModeler with 16 cores and send results from STDOUT and STDERR streams to 1_repeatmodeler.log
# in my experience, this command takes 1-3 days with vertebrate genomes

RepeatModeler -pa 32 -engine ncbi -database Myoxocephalus_aenaeus 2>&1 | tee repeatmodeler.log
