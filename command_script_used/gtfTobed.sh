# see below for UPDATES that include more shorter ways of conversions

# How to convert GTF format into BED12 format (Human-hg19)?
# How to convert GTF or BED format into BIGBED format?
# Why BIGBED (If GTF or BED file is very large to upload in UCSC, you can use trackHubs. However trackHubs do not accept either of the formats. Therefore you would need bigBed format)

# First, download UCSC scripts
wget http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/gtfToGenePred
wget http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/genePredToBed
wget http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/bedToBigBed

# Second, download chromosome sizes and filter out unnecessary chromosomes
wget http://hgdownload.cse.ucsc.edu/goldenPath/hg19/bigZips/hg19.chrom.sizes
grep -v chrM hg19.chrom.sizes| grep -v _hap | grep -v Un_gl |grep -v random > hg19.chrom.filtered.sizes
rm hg19.chrom.sizes

# Third, make them executable
chmod +x gtfToGenePred genePredToBed bedToBigBed

# Convert Gtf to genePred
./gtfToGenePred 1st_53_tissues.combined.gtf 1st_53_tissues.combined.genePred

# Convert genPred to bed12
./genePredToBed 1st_53_tissues.combined.genePred 1st_53_tissues.combined.bed12

# sort bed12
sort -k1,1 -k2,2n 1st_53_tissues.combined.bed12 > 1st_53_tissues.combined.sorted.bed

# Convert sorted bed12 to bigBed (useful for trackhubs)
./bedToBigBed 1st_53_tissues.combined.sorted.bed hg19.chrom.filtered.sizes 1st_53_tissues.combined.bb

# Useful:
# If you see bigBed as blocks in UCSC ass 12 to type in trackhub.txt - 'type bigBed 12'. This helps to see full transcript with exons and introns. 


# Update (Dec 9, 2016):

# wget http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/genePredToBigGenePred
# wget http://genome.ucsc.edu/goldenPath/help/examples/bigGenePred.as
# chmod 765 genePredToBigGenePred

# genePredToBigGenePred 1st_53_tissues.combined.genePred 1st_53_tissues.combined.bedPlus
# bedToBigBed -type=bed12+8 -tab -as=bigGenePred.as 1st_53_tissues.combined.bedPlus hg19.chrom.filtered.sizes 1st_53_tissues.combined.bb

# Change trackhub like this
# track bigGenePred2
# bigDataUrl http://hgwdev.cse.ucsc.edu/~braney/myHub/hg38/wgEncodeGencodeBasicV20.bb 
# shortLabel bigGenePred.bb
# longLabel This is Braney's example genePred.bb with type bigGenePred
# type bigGenePred
# visibility dense
