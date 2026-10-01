# 10 — Selection Tests and Gene Family Evolution

Downstream of orthology. Two threads: per-gene selection tests (HyPhy) and gene-family
size evolution across the tree (CAFE).

## Selection tests — HyPhy aBSREL and RELAX

The HyPhy runs themselves were driven by a separate pipeline (referenced in the notes as
"Ethan's selection pipeline"; its working directory was
`/storage/vlamba/data/Ethan_selection_pipeline_test/`). What is preserved here is the
**post-processing**, which is the part that was hand-rolled.

Input alignments come from TOGA codon output — see the `QUERY-Codon.fasta` /
`Ref-Codon.fasta` extraction one-liners in `07_orthology_toga/TOGA_commands_used.txt`, and
the stop-codon cleanup scripts in `command_script_used/` (HyPhy rejects sequences with
internal stops).

### `selection_test_grep_commands.txt`
Pulls significant results out of a directory of HyPhy `.out` files by grepping for the
exact significance sentence HyPhy prints, then copying the `.out`, `.json` and `.err` for
each hit into a `significant` subdirectory.

- **aBSREL** — episodic diversifying positive selection, Holm-Bonferroni corrected p = 0.05
- **RELAX** — relaxation of selection in test vs reference branches, P ≤ 0.05

These greps match a *literal sentence* from HyPhy's output. If you upgrade HyPhy and the
wording changes, they will silently return nothing. Check the match count first.

Also records the ObservableHQ notebook used to plot RELAX k-values on the tree:
https://observablehq.com/@spond/plotting-relax-k-values-on-branches-of-the-tree

### `absrel_benjamini_hochberg.py`
Applies a Benjamini-Hochberg FDR correction across all tested genes — necessary because
you are running thousands of independent tests and per-gene p-values alone will drown you
in false positives.

```
python absrel_benjamini_hochberg.py <sig_results_dir> <all_results_dir> <bh_out> <candidates_out> <FDR>
```

- `<sig_results_dir>` — the `.out` files that passed the grep above
- `<all_results_dir>` — **all** `.json` results; used only to count the total number of
  tests *m*. Getting this directory wrong silently changes your correction.
- `<bh_out>` — rank / gene / p-value table
- `<candidates_out>` — surviving gene IDs, one per line
- `<FDR>` — q, e.g. 0.05

Parses p-values by looking for the literal `, p-value =  ` in each `.out`. Same fragility
caveat as the greps. Gene ID is taken as everything before the first `_` in the filename.

## Gene families — CAFE

### `cafetutorial_report_analysis_run.sh`
Summarises a finished CAFE `Base_report.cafe` into a readable report.

- Requires **python/2.7.3** — this is a Python 2 script from the CAFE tutorial. It will not
  run under Python 3.
- Script source: https://github.com/shanedenecke/SLC_ID_SCRIPTS (`Fulton_python_scripts/`)
- CAFE pipeline reference:
  https://github.com/harish0201/Analyses_Pipelines/blob/main/7.CAFE.sh

CAFE inputs came from the OrthoFinder run in `08_orthology_orthofinder`:
- gene counts: `.../OrthoFinder/Results_Mar12/Orthogroups/cafe.input.tsv`
- ultrametric tree: `.../Results_Mar12/Species_Tree/SpeciesTree_rooted.txt.ultrametric.tre`

The CAFE run itself is not scripted here — only the report step was kept.
