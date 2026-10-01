## Link for understanding Post-TOGA
https://genome.senckenberg.de/download/TOGA/README.txt

# Count all number of gene in loss_sum.tsv####
grep GENE loss_summ_data.tsv | cut -f3 | sort | uniq -c

# NOTE: the remainder of this file duplicated the general command notebook.
# The full, most recent version of those notes lives in:
#     ../command_script_used/lab_notebook_all_commands.txt
# Kept here is only what is TOGA-specific:

### Pre-TOGA: build the chain
./make_chains.py CotGob DisMaw /home/vlamba/modified_GCF_900634415.1.fa <query.fna> --project_dir /home/vlamba/2_CotDis_chaining -f --chaining_memory 30

./rename_chromosomes_back.py --rename_table_reference DisMac-chain/CotGob_chrom_rename_table.tsv --rename_table_query DisMac-chain/DisMac_chrom_rename_table.tsv DisMac-chain/CotGob.DisMac.final.chain > CotGob.DisMac.chain

### Run TOGA
./toga.py <chain> <reference.bed12> <reference.2bit> <query.2bit> -i <isoform.txt> --project_dir <out> --kt --cb 10,100 --cjn 500 --ms

### Post-TOGA: pull out I/PI/UL projections and join to the query annotation
grep PROJECTION loss_summ_data.tsv | awk '{if ($3 == "I" || $3 == "PI" || $3 == "UL") print $2}' | sort > I_PI_UL.txt
sort -k4,4 query_annotation.bed -o query_annotation.sorted.bed
join -1 1 -2 4 I_PI_UL.txt query_annotation.sorted.bed -t $'\t' > query_annotation.I_PI_UL.bed

### Extract QUERY-only protein sequences from prot.fasta
cat prot.fasta | grep "PROT | QUERY" -w -A 1 | grep "^\-\-$" -v | awk '{if ($1 ~ /^>/) printf $1"\t"; else print $0}' | sed 's/-//g' | awk -F "\t" '{if ($2 != "") print $1"\n"$2}' > QUERY-PROT.fasta

### Same for REFERENCE, and for codon alignments
cat prot.fasta  | grep "PROT | REFERENCE"  -w -A 1 | grep "^\-\-$" -v | awk '{if ($1 ~ /^>/) printf $1"\t"; else print $0}' | sed 's/-//g' | awk -F "\t" '{if ($2 != "") print $1"\n"$2}' > REFERENCE-PROT.fasta
cat codon.fasta | grep "CODON | QUERY"     -w -A 1 | grep "^\-\-$" -v | awk '{if ($1 ~ /^>/) printf $1"\t"; else print $0}' | sed 's/-//g' | awk -F "\t" '{if ($2 != "") print $1"\n"$2}' > QUERY-Codon.fasta
cat codon.fasta | grep "CODON | REFERENCE" -w -A 1 | grep "^\-\-$" -v | awk '{if ($1 ~ /^>/) printf $1"\t"; else print $0}' | sed 's/-//g' | awk -F "\t" '{if ($2 != "") print $1"\n"$2}' > Ref-Codon.fasta

### Number of genes annotated
awk '{print $4}' query_annotation.bed | awk -v FS="." '{print $2}' | sort -u | wc -l

# Building multiple codon alignments:
https://github.com/hillerlab/TOGA/wiki/Building-multiple-codon-alignments
# bed file conversion from gtf/gff:
https://github.com/hillerlab/TOGA/issues/196
