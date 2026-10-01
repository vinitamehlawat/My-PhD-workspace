# Input BED file
input_bed = "PseGeo_SGCE_exons.bed"
# Output BED file for introns
output_bed = "PseGeo_SGCE_introns.bed"

# Read exon coordinates
exons = []
with open(input_bed, "r") as infile:
    for line in infile:
        chrom, start, end, name = line.strip().split("\t")
        exons.append((chrom, int(start), int(end), name))

# Calculate intron coordinates
introns = []
for i in range(len(exons) - 1):
    chrom = exons[i][0]
    intron_start = exons[i][2] + 1  # End of current exon + 1
    intron_end = exons[i + 1][1] - 1  # Start of next exon - 1
    intron_name = f"Intron{i + 1}"
    introns.append((chrom, intron_start, intron_end, intron_name))

# Write intron coordinates to BED file
with open(output_bed, "w") as outfile:
    for chrom, start, end, name in introns:
        outfile.write(f"{chrom}\t{start}\t{end}\t{name}\n")
