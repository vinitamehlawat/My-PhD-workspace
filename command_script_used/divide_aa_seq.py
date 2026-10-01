from Bio import SeqIO
from Bio.Blast import NCBIXML
import pandas as pd
import sys
import os

aa_seqs = sys.argv[1]
outfolder = sys.argv[2]
divide_by = int(sys.argv[3])
#the divide_by number might not be exact because of rounding
#this is fine: we only need to make sure the true number of divisions is not greater than divide_by

if not os.path.exists(outfolder):
    os.makedirs(outfolder)

num_seqs = 0
with open(aa_seqs, "r") as f:
    for line in f:
        if line.startswith(">"):
            num_seqs += 1


interval = int(num_seqs / divide_by)
interval = interval + 1

outfile = outfolder + "/tmp" + "_" + str(0) + "_" + str(interval) + ".fasta"
out = open(outfile, "w")
num_seqs = 0
for seq_record in SeqIO.parse(aa_seqs, "fasta"):
    num_seqs += 1
    if num_seqs % interval == 0:
        out.close()
        outfile = outfolder + "/tmp" + "_" + str(num_seqs) + "_" + str(num_seqs + interval) + ".fasta"
        out = open(outfile, "w")
    SeqIO.write(seq_record, out, "fasta")
out.close()
