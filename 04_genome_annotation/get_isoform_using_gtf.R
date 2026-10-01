# Load required libraries
library(rtracklayer)

# Set input file
i <- "GCF_036324505.1_JC_Emac_rtc_rv5.ncbiRefSeq.gtf"

# Define output file names
l_gff3 <- gsub(".ncbiRefSeq.gtf", ".coding.gtf", i)
l_bed <- gsub(".ncbiRefSeq.gtf", ".transcript.bed", i)
l_transcripts <- gsub(".ncbiRefSeq.gtf", ".transcripts.tsv", i)

# Manually read the GTF file
gtf <- read.delim(i, header = FALSE, comment.char = "#", sep = "\t", quote = "",
                  col.names = c("seqname", "source", "feature", "start", "end",
                                "score", "strand", "frame", "attributes"))

# Filter for transcripts
transcripts <- gtf[gtf$feature == "transcript",]

# Extract gene_id and transcript_id from the attributes column
transcripts$gene_id <- sapply(transcripts$attributes, function(x) {
  regmatches(x, regexpr('gene_id "[^"]+"', x)) |>
    sub('gene_id "([^"]+)"', "\\1", x = _)
})

transcripts$transcript_id <- sapply(transcripts$attributes, function(x) {
  regmatches(x, regexpr('transcript_id "[^"]+"', x)) |>
    sub('transcript_id "([^"]+)"', "\\1", x = _)
})

# Filter for coding features (CDS, start_codon, stop_codon)
coding_features <- gtf[gtf$feature %in% c("CDS", "start_codon", "stop_codon"),]

# Extract transcript_id from coding_features
coding_features$transcript_id <- sapply(coding_features$attributes, function(x) {
  regmatches(x, regexpr('transcript_id "[^"]+"', x)) |>
    sub('transcript_id "([^"]+)"', "\\1", x = _)
})

# Check for matching transcript_ids
matching_ids <- intersect(transcripts$transcript_id, coding_features$transcript_id)
print(paste("Matching transcript_ids:", matching_ids))

# Filter for protein-coding transcripts (those with a CDS)
protein_coding_transcripts <- transcripts[transcripts$transcript_id %in% matching_ids,]

# Check if protein_coding_transcripts is empty
if (nrow(protein_coding_transcripts) == 0) {
  stop("No protein-coding transcripts found. Check the filtering criteria.")
} else {
  # Export protein-coding transcripts to a GTF file
  export(protein_coding_transcripts, con = l_gff3)
}

# Extract gene and transcript IDs
transcript_data <- protein_coding_transcripts[, c("gene_id", "transcript_id")]
colnames(transcript_data) <- c("geneId", "TransID")

# Write gene and transcript IDs to a tab-separated file
write.table(transcript_data, file = l_transcripts,
            quote = FALSE, row.names = FALSE, col.names = TRUE, sep = "\t")

print("Processing complete. Output files generated:")
print(paste("Coding features GTF:", l_gff3))
print(paste("Transcript IDs TSV:", l_transcripts))
