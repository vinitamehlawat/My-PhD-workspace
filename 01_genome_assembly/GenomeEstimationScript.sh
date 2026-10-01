#!/bin/bash
#$ -N jellyfish
#$ -M vlamba@uark.edu
#$ -q highmem.q
#$ -m bea
#$ -S /bin/bash
#$ -cwd
#$ -pe smp 8
#$ -o JellyFish_$JOB_ID.out
#$ -e Jellyfish_$JOB_ID.err

module load jellyfish/2.3.0
zcat *.fastq.gz | jellyfish count -t 20 -C -m 21 -s 5G -o 21mer_out
