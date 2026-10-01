# 06 — Whole-Genome Alignment (Progressive Cactus)

Reference-free multiple whole-genome alignment of all species at once, stored in a **HAL**
file. From the HAL you can extract MAF, pairwise chains, synteny blocks and mutation
summaries — so this one alignment feeds several downstream analyses.

Everything here uses `cactus/2.6.7` + `conda activate cactus-3.13`.

## Building the alignment

### `cactus-run.sh` → `seqfile.hal`
### `cactus2-run.sh` → `seqfile2.hal`
Two runs. `seqfile2.hal` is the one used downstream — treat it as the current alignment
and `seqfile.hal` as the earlier attempt.

Input is a **seqFile**: a Newick guide tree on the first line, then one
`<name> <path-to-fasta>` line per genome. The seqFiles themselves are data and live at
`/storage/vlamba/data/Genomes-noto/seqfile.txt` and `seqfile2.txt`. Genomes should be
soft-masked (`02_repeat_masking`) before this step.

Note the 20-day walltime (`--time=20-00:00:00`). Cactus on ~20 fish genomes is a long run.
`cactus2-run.sh` passes an explicit jobstore directory rather than `./js` — do that, so
you can `--restart` from where it died instead of starting over.

## Extracting things from the HAL

### `hal-to-maf.sh` — `hal2maf`
MAF alignment referenced on DisMaw, with `--noAncestors --noDupes --onlyOrthologs
--maxBlockLen 100000 --maxRefGap 1000`. Those four flags matter: they give you a clean
1-to-1 orthologous alignment suitable for phylogenetics and selection tests, rather than
the full graph.

### `hal-to-chain.sh` — `cactus-hal2chains`
Pairwise chains for every genome against `--refGenome DisMaw`, in one shot. This is the
bulk alternative to the per-pair route in `05_pairwise_genome_chaining`. See also the
`--useHalSynteny` variant recorded in `command_used_in_HAL_alignments.txt`, which is
faster and coarser.

### `halsyntny.sh` — `halSynteny`
Synteny blocks between one pair (PseGeo vs PagMac) as PSL, with
`--maxAnchorDistance 1000000 --minBlockSize 1000000` — i.e. large-scale chromosomal
synteny, not fine alignment. Change the two `--*Genome` flags per pair.

### `halLod-Extract.sh` — `halLodExtract`
Builds a level-of-detail (downsampled) HAL at step 100. This is for **browser display** —
it makes a large HAL viewable in the UCSC assembly hub without loading the full alignment.
Only 1 CPU needed; note this one runs on the `cloud72` partition, not `condo`.

### `halmutation.sh` and `summrise-mutation.sh` — `halSummarizeMutations`
Counts substitutions, indels, inversions, duplications and transpositions on each branch
of the alignment.
- `halmutation.sh` uses `--rootGenome CotGob` (summarise the subtree below CotGob)
- `summrise-mutation.sh` uses `--maxNFraction 0` (exclude any region containing Ns —
  stricter, avoids assembly-gap artefacts)
Run both; they answer slightly different questions.

## `command_used_in_HAL_alignments.txt`
Loose notes: the `cactus-hal2chains --useHalSynteny` invocation, and a copy of the
BovVar HAL→chain job. Superseded by the scripts above but kept as-is.

## `plot_mutations_command.txt`
**Not here — see `07_orthology_toga/plot_mutations_command.txt`.** Despite the name, that
file is about TOGA's inactivating-mutation plots, not HAL mutations.
