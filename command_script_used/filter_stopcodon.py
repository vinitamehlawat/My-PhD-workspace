import os
from Bio import SeqIO

# Directory containing the .fa files
input_directory = "/storage/vlamba/data/Ethan_selection_pipeline_test/outdir.nogaps.nox.noempty.15only"
output_summary = "stop_codons_summary.txt"

# Stop codons
STOP_CODONS = {"TAG", "TAA", "TGA"}

# Initialize a summary dictionary
stop_codons_info = {}

# Process each .fa file in the directory
for filename in os.listdir(input_directory):
    if filename.endswith(".fa"):
        file_path = os.path.join(input_directory, filename)
        gene_name = filename.replace(".fa", "")
        
        # Parse the sequences in the .fa file
        for record in SeqIO.parse(file_path, "fasta"):
            sequence = record.seq
            species_id = record.id
            
            # Check if the sequence ends with a stop codon
            if len(sequence) % 3 == 0 and sequence[-3:] in STOP_CODONS:
                if gene_name not in stop_codons_info:
                    stop_codons_info[gene_name] = []
                stop_codons_info[gene_name].append(species_id)

# Write the results to a summary file
with open(output_summary, "w") as summary_file:
    for gene, species_list in stop_codons_info.items():
        summary_file.write(f"{gene}: {', '.join(species_list)}\n")

print(f"Stop codon summary written to {output_summary}")
