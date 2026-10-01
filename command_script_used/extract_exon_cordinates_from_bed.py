# Input BED line
bed_line = "NC_047513.1	22972629	22978132	ENSCGOT00000034148.1.17	1000	-	22972629	22978132	255,50,50	10	52,189,27,215,163,118,63,145,139,65,	0,451,1060,1549,1841,2639,3559,4116,4519,5438,"

# Split the BED line into fields
fields = bed_line.strip().split("\t")
chrom = fields[0]
chrom_start = int(fields[1])
exon_sizes = list(map(int, fields[10].strip(',').split(',')))
exon_starts = list(map(int, fields[11].strip(',').split(',')))

# Calculate exon coordinates
exon_coords = []
for i in range(len(exon_sizes)):
    exon_start = chrom_start + exon_starts[i]
    exon_end = exon_start + exon_sizes[i]
    exon_coords.append((chrom, exon_start, exon_end))

# Print exon coordinates
for i, (chrom, start, end) in enumerate(exon_coords, 1):
    print(f"Exon {i}: {chrom}:{start}-{end}")
