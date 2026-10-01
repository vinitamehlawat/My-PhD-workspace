# 04 — Genome Annotation

Structural gene annotation with **BRAKER2** in protein-evidence mode, plus the R script
that turns an annotation into the isoform table TOGA needs.

## `BRAKER2.sh` and `Clino_analis-BRAKER2.sh`
The same pipeline run on two genomes. Both use three-spined stickleback
(*Gasterosteus aculeatus*, `GCF_016920845.1`) proteins as the homology evidence — the
nearest well-annotated relative available.

- `BRAKER2.sh` → *Tautogolabrus* / `GCA_910589615.1_fTauBub2.1`
- `Clino_analis-BRAKER2.sh` → *Clinocottus analis* / `GCA_023055335.1_fCliAna1.0.p`

The difference between the two files is only the anaconda version (3.10 vs 3.11) and the
target genome. Use the `Clino_analis` one as your template — it is the later, corrected
version (it writes `gm_key` to `~/.gm_key`, which is where GeneMark actually looks; the
older script writes it to the CWD).

**Setup burden, which is the real content of these scripts.** BRAKER2 needs its
`config` directory to be *writable*, so both scripts `rsync` AUGUSTUS's config into your
home directory and point `AUGUSTUS_CONFIG_PATH` there. They also copy the GeneMark
licence key (`gm_key`) into place — GeneMark silently fails without it. Do not delete
these lines thinking they are boilerplate.

- Requires soft-masked genomes from `02_repeat_masking` (`--softmasking`)
- Out: `braker/braker.gtf`
- To count features in the output:
  `cat braker.gtf | awk '{a[$3]++}END{for(k in a){print k,a[k]}}'`
  (a without-masking run gave 44,114 genes / 48,145 transcripts — see the lab notebook)

## `get_isoform_using_gtf.R`
Converts an NCBI RefSeq GTF into the two things TOGA wants: a coding-only GTF and a
two-column `geneId → TransID` isoform table (`-i` argument of `toga.py`).

Parses the GTF with `read.delim` rather than `rtracklayer::import` (deliberate — gives
direct control over attribute parsing), keeps only transcripts that have a CDS /
start_codon / stop_codon, and writes:

- `*.coding.gtf`
- `*.transcripts.tsv` — the isoform file for TOGA

Set the input filename at the top (`i <- "..."`). Written against the EleMac RefSeq GTF.
Uses the native R pipe `|>` and `_` placeholder, so needs R ≥ 4.2.
