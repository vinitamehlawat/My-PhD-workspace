# command_script_used — Miscellaneous Commands and Utilities

The one-liners, format conversions and small helper scripts used throughout the PhD that
don't belong to a single pipeline stage. In day-to-day work this was the most-used folder.

---

## `lab_notebook_all_commands.txt` — start here

The running lab notebook of ad-hoc commands, accumulated over several years and last
updated June 2026. Roughly organised by topic. Contents include:

- **awk filters for gene-loss status tables** — extracting genes that are I/PI in the
  outgroups and L/UL across the Antarctic species. Two versions, one anchored on EleMac and
  one on CotGob. These implement the actual gene-loss criteria used in the paper.
- **FASTA header cleanup** (see below) and BED/GTF/genePred conversions
- **BLASTn / tblastx / DIAMOND** invocations with the thresholds actually used
- **Post-TOGA** status counting, I/PI/UL extraction, protein and codon extraction
- **HAL chaining** command sequence
- **CAFE** and **BUSCO** invocations
- **Full cluster paths for every genome used in the gene-loss analysis** — the single most
  useful lookup table in this repo if you need to find the original data
- The flatfish comparison set: reference, chains, 2bits and isoform files for all 8 query
  species
- All 12 EleMac-referenced chains (`Chaining_with_Emac/<SP>-chain/EleMac.<SP>.chain`)
- Notes from Hiller lab correspondence on how TOGA treats terminal mutations and
  co-orthologous loci

An older January 2026 copy of this file existed in Drive with no extension; its content is
a strict subset, so only the newer version was kept.

### The three FASTA header fixes you will need

```bash
sed -r 's/^(>\S+)\s.*/\1/' in.fna > out.fna   # drop everything after first space
sed '/^>/ s/\./_/g'        in.fna > out.fna   # dots -> underscores
awk '/^>/ {$0=$1} 1'       in.fna > out.fna   # keep only first field
```

`make_lastz_chains` and TOGA both fail on raw NCBI headers. Files named `modified_*` or
`2_modified_*` anywhere in this project have had one or both applied.

---

## Format conversion

### `gtfTobed.sh`
GTF → genePred → BED12 → bigBed, using UCSC tools (`gtfToGenePred`, `genePredToBed`,
`bedToBigBed`). Includes the `wget` lines to fetch the tools themselves.

This is the route used to make the **bed12 reference annotation TOGA requires**. It also
covers making bigBed for UCSC track hubs (needed when a BED is too large to upload
directly), and a Dec-2016 update section showing the shorter `genePredToBigGenePred` route.

Written against hg19 as the worked example; substitute your own chrom.sizes.
Remember to sort (`sort -k1,1 -k2,2n`) before `bedToBigBed` — it will refuse unsorted input.

---

## BED coordinate utilities

### `extract_exon_cordinates_from_bed.py`
Expands a bed12 line's `blockSizes` / `blockStarts` into absolute per-exon coordinates.
**The BED line is hard-coded as a string at the top of the file** — it was written for a
single gene (a CotGob SGCE transcript). Replace `bed_line`, or wrap it in a loop over a
file, before reuse. Prints to stdout.

### `extract_intron_from_bed.py`
Takes a 4-column exon BED and emits the gaps between consecutive exons as introns.
Input/output filenames are hard-coded at the top (`PseGeo_SGCE_exons.bed` →
`PseGeo_SGCE_introns.bed`).

Caveat: assumes exons are already sorted by position and all on one transcript, and uses
`start+1`/`end-1` boundaries — check the off-by-one convention against your downstream tool
before trusting the coordinates.

### `combined_exon_intron_as_gene.py`
Reconstructs a full genomic gene sequence by interleaving exon and intron FASTAs
(exon1, intron1, exon2, intron2, …). Sorts both sets by the start coordinate parsed out of
the `chr:start-end` FASTA headers that `bedtools getfasta` produces. Filenames hard-coded.

These three form a sequence: bed12 → exon coords → `bedtools getfasta` → intron coords →
`bedtools getfasta` → recombined gene. Used to pull out full gene sequences (introns
included) for manual inspection of specific gene-loss candidates.

---

## Sequence cleanup for selection tests

### `filter_stopcodon.py`
Scans a directory of `.fa` codon alignments and reports which sequences end in a stop codon
(TAG/TAA/TGA), writing `stop_codons_summary.txt`.

### `removestopcodon_after_filtering.py`
Reads that summary and trims the terminal stop codon, then writes corrected files to a new
directory.

Run them in that order. **Note the hard-coded behaviour:** the trimming script only trims
the record whose ID is exactly `CotGob` (`if record.id == "CotGob"`). If your reference is
EleMac or turbot, change that string or nothing will be trimmed. Input/output directories
are hard-coded at the top of both files.

Why this matters: HyPhy (`10_selection_and_gene_families`) rejects alignments containing
stop codons, so this cleanup is a prerequisite for the selection tests.

---

## Batch job helpers

### `divide_aa_seq.py`
Splits a large protein FASTA into roughly N chunks so BLAST can be array-jobbed across the
cluster.

```
python divide_aa_seq.py <aa_seqs.fasta> <outfolder> <divide_by>
```

Output files are named `tmp_<start>_<end>.fasta` — that naming is not cosmetic, the merge
script below parses it.

### `merge_blasted_sequences.py`
Reassembles the per-chunk `.tsv` BLAST annotation results back into one table, in the
correct order, by walking the `tmp_<start>_<end>` filenames.

```
python merge_blasted_sequences.py <directory> <outname.tsv>
```

Two warnings, both flagged in the original code:
- Its own comment: *"this code is extremely fragile and only works if the files are named
  in a very specific way and none are missing."* If one chunk failed, the loop stops early
  and silently gives you a truncated table. Check the row count.
- Uses `DataFrame.append()`, **removed in pandas 2.0**. On a modern pandas this will crash;
  replace with `pd.concat`.

---

## `gene_loss_summary_script_notes.txt`
Usage notes for an externally-written gene-loss summarising script (delivered via Box, not
present in this repo). Documents its four arguments, the outgroup-is-first-species
convention, and the tolerance-threshold logic. Kept because the same logic is implemented
by the awk one-liners at the top of the lab notebook — if you need the behaviour, the awk
is here and the Python is not.
