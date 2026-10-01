# 09 — Bulk RNA-seq Analysis

Differential expression analysis in R, applied to the sculpin
(*Myoxocephalus aenaeus*) RNA-seq dataset.

## Provenance — read this

These notebooks began as teaching materials from the **Genomic Data Analysis** course
(Carson Stacy & Jeffrey Lewis, University of Arkansas, Fall 2023;
https://github.com/clstacy/GenomicDataAnalysis_Fa23), which used a yeast
*msn2/4Δ* ethanol-stress dataset as its worked example.

They were then **adapted in place** to run on real project data — the file paths inside
point at `/scrfs/storage/vlamba/data/Sculpin-transcriptome/` (trimmed FASTQs, BAMs,
`sculpin.gtf.gz`, `Counts/Rsubread/`). So parts of each notebook are course exercise and
parts are the actual analysis. When reusing one, check every path and every dataset name
before running: some chunks still load the yeast example, others load sculpin data.

## The notebooks, in order

| File | What it does |
|---|---|
| `01_Getting_Started_in_R.Rmd` | R/RStudio orientation, package loading via `pacman::p_load`, reading data from file and from URL |
| `02_Gene_Ontology.Rmd` | GO term enrichment |
| `03_Working_with_Sequences.Rmd` | Sequence handling in Bioconductor |
| `04_Read_Mapping.Rmd` | Aligning trimmed FASTQs to the reference — produces the `.subread.BAM` files |
| `05_Read_Counting.Rmd` | `Rsubread::featureCounts` over the BAMs against `sculpin.gtf.gz`; also the Salmon pseudo-alignment route (`salmon quant` + `salmon quantmerge`); saves `fc` as `.Rds` and a merged counts `.tsv` |
| `05_Supplement_Generate_salmon_counts_workflow.Rmd` | Salmon counting in more detail |
| `06_DE_edgeR.Rmd` | Differential expression with edgeR |
| `07_DE_DESeq2.Rmd` | Differential expression with DESeq2 |
| `08_DE_limma.Rmd` | Differential expression with limma-voom |
| `09_DE_Visualization.Rmd` | Volcano plots, MA plots, heatmaps |
| `10_Clustering.Rmd` | Sample and gene clustering |

Three DE methods are covered (06/07/08) as alternatives on the same counts, not as a
sequence — pick one and note which in your methods.

## ⚠️ These `.Rmd` files are not yet in this folder

They were left in Google Drive because they are bulky notebook files. **Copy them in from
`vinita_code/codes/Lab Exercises/` before pushing**, then delete this section.

Also in that Drive folder, and deliberately excluded as data rather than code:
`5.RData`, `code4.RData`, and the read-quality plots
(`distribution of quality scores across the sampled reads-Rplot.png` / `.pdf`).

## Running them

Each notebook is self-contained and installs its own dependencies via `pacman::p_load`,
including Bioconductor packages through `BiocManager`. Knit to HTML or PDF. Every notebook
ends with `pander::pander(sessionInfo())` so the exact package versions used are recorded
in the output — keep that.

Note that `05_Read_Counting.Rmd` mixes R and `bash` chunks; the bash chunks assume conda is
available and use `conda activate salmon`.
