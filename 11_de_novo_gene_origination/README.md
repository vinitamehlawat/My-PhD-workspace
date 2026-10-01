# 11 — De Novo Gene Origination

Detection of newly expressed ORFs (neORFs) / proto-genes arising within the Antarctic
notothenioid clade — genes with no protein-coding ancestor, born from previously
non-coding sequence (or from transposable elements).

This is the newest thread in the project and is **not finished**. Treat it as
work-in-progress rather than a completed pipeline.

## `run_dense.sbatch`
Runs the **DENSE** Nextflow pipeline (https://github.com/i2bc/dense) for the PogAlb
species, under Apptainer.

```bash
nextflow run i2bc/dense -profile apptainer -c vini.config -resume
```

- Working directory: `/storage/vlamba/data/Denovo_gene-Noto/`
- The pipeline configuration is in `vini.config` — **that file is data-dependent and is not
  in this repo**; it lives in the working directory above and defines the genomes,
  transcriptomes and thresholds for the run. You need it to reproduce anything here.
- `-resume` is set, so a failed run restarts from the last completed process.
- Note the module set: `blast`, `diamond`, `java/sunjdk_17.0.8`, `apptainer`, plus the
  `nextflow-25.3.0-el9` conda env. Nextflow needs Java 17 here.

## Related work not in this folder

- **DESwoMAN** (https://github.com/AnnaGrBio/DESWOMAN) was the other pipeline used for
  this question, run over 9 Antarctic + 2 non-Antarctic genomes with 6 transcriptomes.
  It was run interactively rather than from a committed script, so there is no `.sh` here.
  Its prerequisite — soft-masking all genomes with a shared pan-notothenioid library — is
  `02_repeat_masking/01_masking.sh`, and the genome directory that script points at
  (`Denovo_gene-Noto/new_workflow/Genomes`) is the DESwoMAN input set.
- Orthogroup support for candidate de novo genes came from
  `08_orthology_orthofinder/OrthoFinder_run.sh`.
- A combined outgroup protein database (`EM_CG_TR_GA_Outgroup_protein.faa`, including fugu
  and stickleback) was built to confirm candidate ORFs are absent outside the clade.

## If you are picking this up

The candidate neORF nucleotide and protein sequences already exist for four Antarctic
species (those with multi-tissue transcriptomes). The next planned step was running
**AlphaFold** on the candidates to assess whether the predicted products fold — that had
not been started.
