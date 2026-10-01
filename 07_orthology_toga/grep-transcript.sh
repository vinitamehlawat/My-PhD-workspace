# Save the fasta headers in a txt file (headers.txt)
# One header per line

# Create a new output file to store the matched sequences
touch /home/vlamba/CotGob-transcript-PROT.fasta

# Loop through each header in the headers.txt file
while IFS= read -r header; do
    # Grep the sequence using the header from the multifasta file (multifasta.fasta)
    grep -A1 -wF "$header" /home/vlamba/1March-BovDia-gene-loss-mlastz/REFERENCE-PROT.fasta >> CotGob-transcript-PROT.fasta
done < /home/vlamba/one2one-gene-sp-tree.txt
