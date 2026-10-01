# 08 — Orthology (OrthoFinder), Reciprocal BLAST, Synteny Inputs

The sequence-similarity route to orthology, complementing the alignment-based route in
`07_orthology_toga`. Used for orthogroups, species trees, gene-family expansion/contraction
inputs, and cross-validation of gene-loss calls.

## `OrthoFinder_run.sh`
De novo gene work: `orthofinder -M msa` with **MAFFT** + **FastTree**.
- In: a directory of protein FASTAs (`/storage/vlamba/data/Denovo_gene-Noto/Orthofinder`)
- `-M msa` builds gene trees from real alignments rather than the faster DENDROBLAST
  default — slower but more accurate, which is what you want for de novo gene calls.

## `Orthofinder_run2.sh`
The main notothenioid run, on **TOGA-derived peptides**: `-M msa -A muscle -T iqtree`,
30 threads.
- In: `/storage/vlamba/data/TOGA_pep/OrthoFinder_inputs`
- MUSCLE + IQ-TREE instead of MAFFT + FastTree — slower again, better trees.
- This run is what feeds CAFE. Its outputs
  (`Results_Mar12/Orthogroups/cafe.input.tsv` and
  `Results_Mar12/Species_Tree/SpeciesTree_rooted.txt.ultrametric.tre`) are the CAFE inputs
  referenced in `10_selection_and_gene_families`.

Running OrthoFinder on TOGA peptides rather than on the original NCBI annotations is
deliberate: it makes the protein sets consistent across species (all projected from one
reference), so orthogroup sizes reflect real gene content rather than differences in
annotation quality.

## `Reciprocal_blast_commands.txt`
DIAMOND reciprocal best-hit check used to validate the "common loss" sets called against
the two different references (CotGob and EleMac). Builds a DIAMOND db per reference
proteome, then blasts each reference's common-loss set against the *other* reference.

`--evalue 1e-5 --query-cover 80`. The hit counts from the actual runs are recorded in the
file (319/540 and 184/456 queries aligned) — useful as a regression check if you rerun it.

## `Noto_MCScanX_commands.txt`
Inputs for **MCScanX** collinearity/synteny analysis.

Two parts:
1. **NCBI datasets API** `curl` commands to download genome + annotation + protein sets
   (CotGob, EleMac, GymAcu, PseGeo). Reusable for any accession — just swap the accession
   in the URL.
2. **All-vs-all reciprocal `blastp`** across six species (Cgob, Emac, Gacu, Hant, Nros,
   Pse): both directions for all 15 pairs, plus self-comparisons.
   `-evalue 1e-10 -outfmt 6 -num_alignments 5` (self-comparisons use 6).

The `.blastp` outputs plus the matching `.gff` files are the two things MCScanX needs. The
MCScanX run itself is not scripted here.

*(The original file listed every pair explicitly; it has been compressed to a pattern plus
the pair list. Expand the pattern to reproduce it exactly.)*
