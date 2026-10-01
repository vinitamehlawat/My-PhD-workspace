#!/bin/bash
#SBATCH --job-name=Trinity_trimmed
#SBATCH --output=Trinity_trimmed.%J.out
#SBATCH -e Trinity_trimmed.%J.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=vlamba@uark.edu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --partition condo
#SBATCH --qos condo
#SBATCH --constraint 'xz036'
#SBATCH --time=190:00:00

module load gcc/9.3.1 trinity/2.15.1 salmon/1.4.0 samtools/1.15.1 jellyfish/2.3.0  
module load bowtie2/2.4.1 rsem/1.3.3 gcc-11.2.1/SKYLAKEX/kallisto/0.48.0 java/sunjdk_1.8.0 
module load R/4.3.0 mkl/21.3.0 intel/19.0.5 fastqc/0.12.1 blast/2.15.0+bin hisat2/2.2.1 
module load subread/2.0.1 gmap/23-07-20 picard-tools/2.17.10 gatk/4.4.0.0 salmon/1.4.0 STAR/2.7.10a

#change to appropriate fast drives
cd /local_scratch/$SLURM_JOB_ID/

#move a copy of input data to fast drives
rsync -av /storage/vlamba/data/Sculpin-transcriptome/trimmed/*.gz

#run Trinity

Trinity --seqType fq --max_memory 180G --left /storage/vlamba/data/Sculpin-transcriptome/trimmed/22179-04-01_S43_L001_R1_001_R1.fastq.gz,22179-04-02_S44_L001_R1_001_R1.fastq.gz,22179-04-03_S45_L001_R1_001_R1.fastq.gz,22179-04-04_S46_L001_R1_001_R1.fastq.gz,22179-04-05_S47_L001_R1_001_R1.fastq.gz,22179-04-06_S48_L001_R1_001_R1.fastq.gz,22179-04-07_S49_L001_R1_001_R1.fastq.gz,22179-04-08_S50_L001_R1_001_R1.fastq.gz, --right /storage/vlamba/data/Sculpin-transcriptome/trimmed/22179-04-01_S43_L001_R2_001_R1.fastq.gz,22179-04-02_S44_L001_R2_001_R1.fastq.gz,22179-04-03_S45_L001_R2_001_R1.fastq.gz,22179-04-04_S46_L001_R2_001_R1.fastq.gz,22179-04-05_S47_L001_R2_001_R1.fastq.gz,22179-04-06_S48_L001_R2_001_R1.fastq.gz,22179-04-07_S49_L001_R2_001_R1.fastq.gz,22179-04-08_S50_L001_R2_001_R1.fastq.gz --SS_lib_type FR --output /storage/vlamba/data/Sculpin-transcriptome/trinity_trimmed_out/ --CPU 30

#move completed data back to your storage
rsync -av trinity_trimmed_out /storage/vlamba/data/Sculpin-transcriptome/
