# 02 — Repeat Masking

Builds species-specific repeat libraries, merges them into one pan-notothenioid library,
and soft-masks every genome. Soft-masking (lowercase repeats, `-xsmall`) is required by
BRAKER2 (`--softmasking`) and strongly recommended before chaining and de novo gene work.

## `01_masking.sh` — the full workflow, run this one
Four steps in a single job, over every `.fna` in a genome directory:

1. **Unmask.** NCBI genomes arrive already soft-masked with *their* repeat calls.
   `tr 'a-z' 'A-Z'` strips that so masking is consistent across all species and driven by
   one library. Do not skip this — mixing NCBI masking with your own gives incoherent
   results across species.
2. **RepeatModeler** per species → `*-families.fa` de novo repeat library.
3. **Concatenate** all per-species libraries → `pan_noto_repeats.fasta`. A shared library
   means a repeat is masked in every species even where RepeatModeler happened to miss it
   in one — important when you are comparing genomes to each other.
4. **RepeatMasker** with `-lib pan_noto_repeats.fasta -xsmall` → soft-masked genomes in
   `masked_genomes/`.

Notes:
- Expects `unmasked_genomes/` and `masked_genomes/` to already exist. `mkdir -p` them first.
- RepeatMasker is deliberately taken from the conda env, not the module — the module build
  had a TRF error (see comment in the script).
- Step 1 in the loop has a `basename ${GENOME_PATH}.fna` quirk that leaves `.fna` in the
  prefix; harmless (database names just look odd) but worth knowing.
- Runtime: RepeatModeler is 1–3 days *per vertebrate genome*. Budget accordingly; the
  `--time=700:00:00` is not paranoia.

## `RepeatModeler_run.sh`
Standalone single-species RepeatModeler run for the sculpin genome — same tool as step 2
above, kept separately because it was run on its own outside the notothenioid loop.

- In: `/storage/vlamba/data/Genome-files/Sculpin.fa`
- Out: `Myoxocephalus_aenaeus-families.fa` + `repeatmodeler.log`
