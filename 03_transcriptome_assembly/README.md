# 03 — Transcriptome Assembly

De novo transcriptome assembly with **Trinity**. Two sources of reads: public SRA data for
notothenioid species, and in-house sequencing for the sculpin.

These transcriptomes are used downstream as (a) BLAST databases for checking whether a
"lost" gene is still expressed anywhere, and (b) expression evidence for the de novo gene
work in `11_de_novo_gene_origination`.

## `Transcriptome_assembly_commands.txt` — the recipe
The full workflow, written out step by step. Read this before the .sh file.

1. `prefetch` + `fastq-dump --split-files` — pull paired reads from SRA
2. `fastqc` — check read quality
3. `trimmomatic PE` with `ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3
   SLIDINGWINDOW:4:15 MINLEN:36`
4. `Trinity --seqType fq --SS_lib_type FR` — assemble
5. `busco -m transcriptome` — completeness check; `TransDecoder.LongOrfs` +
   `TransDecoder.Predict` — call ORFs
6. `blastp` against `nr` — functional annotation

Also records the **stricter trimming parameters the Cheng lab used** for the EleMac
reference transcriptome (`LEADING:20 TRAILING:20 MINLEN:70`) — use those if you want to
match their assembly rather than the defaults above.

Worked examples included for ChaGun (SRR20313222) and ChaSox (SRR20313223).
`module --ignore_cache load` is noted as a workaround when sratoolkit fails to load.

## `Trinity.sh`
The sculpin assembly: 8 paired-end libraries, strand-specific (`--SS_lib_type FR`),
180 GB memory, 30 CPUs.

Worth copying from this script: it stages input onto node-local fast storage
(`/local_scratch/$SLURM_JOB_ID/`) with `rsync` before running, then `rsync`s results back
to `/storage`. Trinity is I/O-heavy and this matters a lot for runtime.

- In: trimmed `.fastq.gz` from `/storage/vlamba/data/Sculpin-transcriptome/trimmed/`
- Out: `trinity_trimmed_out/Trinity.fasta`
- Caution: the `--left` list ends with a trailing comma before `--right`. Trinity tolerated
  it, but clean it up if you adapt this.
