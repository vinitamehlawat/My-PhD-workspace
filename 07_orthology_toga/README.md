# 07 — Orthology & Gene Loss (TOGA)

**TOGA** (Tool to infer Orthologs from Genome Alignments) projects a well-annotated
reference's genes onto a query genome through a chain, classifies each projection as
orthologous or not, and calls whether each gene is **Intact / Partially Intact / Uncertain
Loss / Lost / Missing**. This is the engine of the gene-loss paper.

Repo: https://github.com/hillerlab/TOGA
Post-TOGA output guide: https://genome.senckenberg.de/download/TOGA/README.txt

## Read `TOGA_FAQ_hillerlab.md` first

Converted from a Box note of questions put to the Hiller lab and their replies. It covers
what `UL` actually means, how to build the bed12 reference, how to pull one-to-one
orthologues, what each `gene_rejection_reasons.tsv` category means, and how to count
copies from `orthology_classification.tsv`. It will save you a week.

## The four inputs TOGA needs

1. **chain** — from `05_pairwise_genome_chaining`
2. **reference annotation as bed12** — `gff3ToGenePred` then `genePredToBed`, or `gffread`
3. **reference and query `.2bit`** — `faToTwoBit`
4. **isoform table** (`-i`) — two columns, geneId → transcriptId. Generate with
   `04_genome_annotation/get_isoform_using_gtf.R`

## Run scripts

### `toga_run.sh`
The notothenioid run: EleMac reference → CotGob query.
Flags used throughout the project: `--kt --cb 10,100 --cjn 500 --ms`
- `--kt` keep temporary files (you will want them when a gene call looks wrong)
- `--cb 10,100` chain bucket sizes for job batching
- `--cjn 500` split into 500 cluster jobs
- `--ms` skip the "missing" sanity check

### `toga_run_flatfish.sh`
Same pipeline on the flatfish comparison set: turbot (ScoMax) reference → ReiHip query.
This is the parallel dataset used to ask whether patterns seen in notothenioids are
Antarctic-specific or general. Repeat per query species by swapping the chain, the query
2bit and `--project_dir`.

Both were run once per query species — 14 notothenioid project directories and 8 flatfish
ones. The full list of TOGA project dirs is at the bottom of `plot_mutations_command.txt`.

## Interpreting the output

`TOGA_commands_used.txt` has the post-processing one-liners: counting genes by status,
pulling I/PI/UL projections and joining them back to `query_annotation.bed`, extracting
QUERY-only vs REFERENCE-only protein and codon sequences from `prot.fasta` / `codon.fasta`
(needed to feed selection tests in `10_selection_and_gene_families`), and counting how many
genes were annotated.

The two most-used status queries:

```bash
# how many genes are Lost
grep -w "GENE" loss_summ_data.tsv | awk -F'\t' '$3 == "L" {print $2}' | wc -l
# full status breakdown
grep GENE loss_summ_data.tsv | cut -f3 | sort | uniq -c
```

**Important caveat on TOGA's calls** (from the Hiller lab): mutations in the first and
last 10% of the CDS are *not* treated as inactivating, because those regions are under
weaker constraint. Missing start codons are detected but not used for classification. So
a gene with a frameshift near its terminus will not be called Lost — check this before
trusting or disputing any individual call.

## Visualising inactivating mutations

`plot_mutations_command.txt` — the three-step recipe and the 14 real invocations used to
draw PNPLA2 across every species:

```
1. cat ${PROJECT_DIR}/inact_mut_data/* > ${PROJECT_DIR}/inact_mut_data.txt
2. ./mut_index.py <project>/inact_mut_data.txt <project>/inact_mut_data.hdf5
3. ./plot_mutations.py <ref.bed> <project>/inact_mut_data.hdf5 <GENE_ID> <out.svg> -i <isoform.txt> --pmh
```

`plot_mutations.py` and `mut_index.py` ship with TOGA (in `supply/`); they are not
duplicated here. `--pmh` plots mutations in the human-readable layout used for the figures.
Gene IDs are reference gene IDs (`ENSCGOG...` for CotGob, `LOC...`/symbols for EleMac).

## `grep-transcript.sh`
Small helper: reads a list of transcript headers from a file and pulls each matching
sequence (header + one line) out of a multi-FASTA into a new file. Used to subset
`REFERENCE-PROT.fasta` down to a one-to-one orthologue set before tree building.
Assumes single-line sequences — `grep -A1` will truncate wrapped FASTA.
