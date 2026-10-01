import os
from Bio import SeqIO

# Directory containing the .fa files
input_directory = "/storage/vlamba/data/Ethan_selection_pipeline_test/outdir.nogaps.nox.noempty.15only"
output_directory = "/storage/vlamba/data/Ethan_selection_pipeline_test/removed_stopcodon.nogaps.nox.noempty.15only"
os.makedirs(output_directory, exist_ok=True)

# File containing the list of genes with stop codons (stop_codons_summary.txt)
genes_with_stop_codons_file = "stop_codons_summary.txt"

# Read the list of genes with stop codons
with open(genes_with_stop_codons_file, "r") as file:
    genes_with_stop_codons = {line.split(":")[0].strip() for line in file}

# Stop codons
STOP_CODONS = {"TAG", "TAA", "TGA"}

# Process each .fa file
for filename in os.listdir(input_directory):
    if filename.endswith(".fa"):
        gene_name = filename.replace(".fa", "")
        file_path = os.path.join(input_directory, filename)
        
        # Check if the gene is in the list of genes with stop codons
        if gene_name in genes_with_stop_codons:
            corrected_records = []
            
            # Parse the sequences
            for record in SeqIO.parse(file_path, "fasta"):
                sequence = record.seq
                
                # If this is CotGob, check and trim the stop codon
                if record.id == "CotGob" and len(sequence) % 3 == 0 and sequence[-3:] in STOP_CODONS:
                    record.seq = sequence[:-3]  # Trim the stop codon
                
                corrected_records.append(record)
            
            # Save the corrected file
            output_file = os.path.join(output_directory, filename)
            SeqIO.write(corrected_records, output_file, "fasta")

print(f"Corrected files saved in {output_directory}")
