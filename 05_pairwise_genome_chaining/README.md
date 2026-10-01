# 05 — Pairwise Genome Chaining

Produces the `.chain` file that TOGA consumes. A chain is a co-linear set of pairwise
alignments between a **reference** genome (with a good annotation) and a **query** genome
(the one you want annotated / gene-loss-called).

Two independent routes, both represented here.

---

## Route A — `make_lastz_chains` (preferred, used for the final runs)

Nextflow pipeline: lastz alignment → axtChain → chainMergeSort → chainNet, all handled
for you. Repo: https://github.com/hillerlab/make_lastz_chains

### `makelastz_chain.sh`
EleMac (reference) vs CotGob (query), 50 GB chaining memory, 2bit inputs.
Note it runs `pip3 install -r requirements.txt` and `./install_dependencies.py` inside the
job — the pipeline self-installs on first use. Uses `--pd` (short form of `--project_dir`).

### `2_chaning_genome.sh`
CotGob (reference) vs DisMaw (query), 30 GB, FASTA inputs. Note the input filenames:
`modified_GCF_...` and `2_modified_GCA_...` — those prefixes mean the header-cleanup
steps below were already applied. That is the whole reason the file is named `2_`.

### `sumaira_makelastz.sh`
TaeGut (zebra finch) vs Pkram — **bird genomes, a collaborator's data, not part of the
notothenioid project.** Kept because it is a clean worked example of the same pipeline on
a different clade, and it uses the longest runtime setting (190 h, 50 CPU).

---

## Route B — extract chains from an existing Cactus HAL

If a Cactus alignment already exists (see `06_whole_genome_alignment_cactus`), you can
pull pairwise chains straight out of it instead of realigning.

### `genome_chaining_via_hal.sh`
The complete four-command sequence, PseGeo → CotGob:

```
hal2fasta <hal> <QUERY> | faToTwoBit stdin QUERY.2bit
halStats --bedSequences <QUERY> <hal> > QUERY.bed
halLiftover --outPSL <hal> <QUERY> QUERY.bed <TARGET> /dev/stdout | pslPosTarget stdin QUERY-to-TARGET.psl
axtChain -psl -linearGap=loose QUERY-to-TARGET.psl TARGET.2bit QUERY.2bit QUERY-TARGET.chain
```

(Original filename `genome_chaining.sh`; renamed here to say what it actually does.)

`pslPosTarget` is not optional — it forces all alignments onto the target's + strand,
which `axtChain` requires. `-linearGap=loose` is the right setting for cross-species
comparisons at this divergence.

### `LepNud_chaining.sh`
Just the `halLiftover` step, EleMac → CotGob. A fragment of the sequence above, kept
because it was run separately. The filename says LepNud but the job name and the actual
command say EleMac — **trust the command, not the filename.**

---

## Header cleanup — do this before chaining, every time

`make_lastz_chains` fails on NCBI-style FASTA headers. Fix with one of:

```bash
sed -r 's/^(>\S+)\s.*/\1/' in.fna > out.fna   # drop everything after first space
sed '/^>/ s/\./_/g'        in.fna > out.fna   # dots -> underscores
awk '/^>/ {$0=$1} 1'       in.fna > out.fna   # keep only first field
```

Then, **after** chaining, restore the original chromosome names or your chain will not
match your reference BED:

```bash
./rename_chromosomes_back.py \
  --rename_table_reference <REF>-chain/<REF>_chrom_rename_table.tsv \
  --rename_table_query     <QRY>-chain/<QRY>_chrom_rename_table.tsv \
  <QRY>-chain/<REF>.<QRY>.final.chain > <REF>.<QRY>.chain
```

`rename_chromosomes_back.py` lives in `make_lastz_chains-main/standalone_scripts/`.

Full command history: `../command_script_used/lab_notebook_all_commands.txt`.
