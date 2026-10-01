# 01 — Genome Assembly

Genome-size estimation and Hi-C scaffolding. Used for the winter flounder and grubby sculpin
(*Myoxocephalus aenaeus*) assembly; notothenioid genomes were downloaded from NCBI
rather than assembled here (see `08_orthology_orthofinder/Noto_MCScanX_commands.txt`
for the NCBI datasets API download commands).

## `GenomeEstimationScript.sh`
Counts 21-mers across all raw reads with **Jellyfish**, producing the k-mer count file
you then feed to GenomeScope to estimate genome size, heterozygosity and repeat content.

- In: `*.fastq.gz` in the working directory
- Out: `21mer_out` (Jellyfish binary count file)
- Note: this is an **SGE** script (`#$` directives), not SLURM — it predates the move to
  Pinnacle. Convert the header before reuse.
- `-C` counts canonical k-mers (both strands collapsed), which is what GenomeScope expects.
  Next step, not scripted here: `jellyfish histo 21mer_out > 21mer.histo`, then upload
  the histogram to GenomeScope.

## `run_yahs.sh`
**YaHS** Hi-C scaffolding of contigs into chromosome-scale scaffolds, plus optional
generation of Hi-C contact maps for manual curation.

- In: indexed contig FASTA (`.fasta.gz` + `.fai`) and a Hi-C alignment file
  (`.bam`, `.bed` or `.bin`)
- Out: `*_scaffolds_final.fa` + `*_scaffolds_final.agp`
- **This is the upstream YaHS demo script, run as-is on their test data** (it `wget`s
  `LYZE01` from Zenodo). It was kept as a working template. To use it on real data,
  replace the download block and set `contigs=` and `hicaln=` to your own files.
- Set `doplot=1` to generate contact maps. That branch needs `juicer_tools`,
  `PretextMap`, `PretextSnapshot` and `samtools`, and the hard-coded `/bin/...` paths at
  the top of that section must be corrected first.
- Two map flavours are produced: a plain `.hic` for viewing, and a `_JBAT.hic` for
  assembly editing in JuiceBox. After manual curation in JuiceBox, the final
  `juicer post` line (commented out at the very bottom) converts the reviewed assembly
  back into a FASTA.
