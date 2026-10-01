from Bio import SeqIO

# Load exon sequences
exons = {record.id: str(record.seq) for record in SeqIO.parse("PseGeo_SGCE_exons.fasta", "fasta")}
print(f"Loaded {len(exons)} exons: {exons.keys()}")

# Load intron sequences
introns = {record.id: str(record.seq) for record in SeqIO.parse("PseGeo_SGCE_introns.fasta", "fasta")}
print(f"Loaded {len(introns)} introns: {introns.keys()}")

# Sort exon and intron IDs by their start positions
exon_ids = sorted(exons.keys(), key=lambda x: int(x.split(":")[1].split("-")[0]))
intron_ids = sorted(introns.keys(), key=lambda x: int(x.split(":")[1].split("-")[0]))

# Combine sequences in order: exon1, intron1, exon2, intron2, ...
combined_sequence = ""
for i in range(len(exon_ids)):
    exon_id = exon_ids[i]
    combined_sequence += exons[exon_id]  # Add exon sequence
    print(f"Added {exon_id}: {len(exons[exon_id])} bp")

    if i < len(intron_ids):
        intron_id = intron_ids[i]
        combined_sequence += introns[intron_id]  # Add intron sequence
        print(f"Added {intron_id}: {len(introns[intron_id])} bp")

# Write combined sequence to a new FASTA file
with open("PseGeo_SGCE_combined.fasta", "w") as outfile:
    outfile.write(f">Combined_Exons_Introns\n{combined_sequence}\n")

print(f"Combined sequence length: {len(combined_sequence)} bp")
