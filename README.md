# Comparative Genomics — PhD Code Archive

Code used during my PhD in Zhuang Lab, University of Arkansas. Every folder has its own `README.md` explaining what
each script does, what it takes in, and what it give as output.
---

## Pipeline order

```
01_genome_assembly              genome size estimation, Hi-C scaffolding
02_repeat_masking               de novo TE libraries, soft-masking
03_transcriptome_assembly       SRA retrieval, trimming, Trinity
04_genome_annotation            BRAKER2 structural annotation, isoform tables
05_pairwise_genome_chaining     make_lastz_chains, and the HAL-liftover chain route
06_whole_genome_alignment_cactus  Cactus MSA + the whole HAL toolkit
07_orthology_toga               TOGA annotation projection & gene-loss calling
08_orthology_orthofinder        OrthoFinder orthogroups, reciprocal BLAST, MCScanX inputs
09_bulk_rnaseq_analysis         read mapping, counting, DE (edgeR / DESeq2 / limma)
10_selection_and_gene_families  HyPhy aBSREL/RELAX filtering, FDR, CAFE
11_de_novo_gene_origination     DENSE nextflow pipeline for de novo genes
command_script_used             the misc one-liners and utility scripts
```

Stages 05 → 07 are the spine of the gene-loss work: build a chain between a reference
and a query genome (makelastz aligned whole-genome), hand that chain to TOGA.
Stage 06 is an alternative route to the same chains (cactus multiple
alignment used for synteny).

---

## The two ways chains were made — read this first

There are **two independent routes** to a `.chain` file in this repo:

1. **`make_lastz_chains`** (`05_pairwise_genome_chaining/makelastz_chain.sh`,
   `2_chaning_genome.sh`) — pairwise lastz + chaining, run via Nextflow. This is the
   route used for the final TOGA runs.
2. **From an existing Cactus HAL** (`05_pairwise_genome_chaining/genome_chaining_via_hal.sh`,
   `LepNud_chaining.sh`, and `06_.../hal-to-chain.sh`) — `hal2fasta` → `faToTwoBit`,
   `halStats --bedSequences`, `halLiftover --outPSL`, `pslPosTarget`, `axtChain`.

Both provided chains TOGA accepts. Route 1 was preferred later on; route 2 was used when
a Cactus alignment already existed (TOGA output was similar)

## FASTA header hygiene — the most common failure while running make_lastz_chains on existing NCBI style header

`make_lastz_chains` and TOGA both break on messy NCBI FASTA headers. The fixes are in
`command_script_used/lab_notebook_all_commands.txt`, and you will need them:

```bash
sed -r 's/^(>\S+)\s.*/\1/' in.fna > out.fna   # drop everything after first space
sed '/^>/ s/\./_/g'        in.fna > out.fna   # dots -> underscores
awk '/^>/ {$0=$1} 1'       in.fna > out.fna   # keep only first field
```

After chaining, put the original chromosome names back with
`TOGA/../../standalone_scripts/rename_chromosomes_back.py` — otherwise your chain will not match
your reference BED.

---

## Species codes

| Code | Species | Group |
|---|---|---|
| CotGob | *Cottoperca gobio* | outgroup (non-Antarctic), primary reference |
| EleMac | *Eleginops maclovinus* | outgroup (non-Antarctic), second reference |
| BovVar | *Bovichtus variegatus* | Bovichtidae (non-Antarctic) |
| BovDia | *Bovichtus diacanthus* | Bovichtidae (non-Antarctic) |
| DisMaw / DisMac | *Dissostichus mawsoni* | Nototheniinae |
| DisEle | *Dissostichus eleginoides* | Nototheniinae |
| TreBer | *Trematomus bernacchii* | Nototheniinae |
| TreLoe | *Trematomus loennbergii* | Nototheniinae |
| NotRos | *Notothenia rossii* | Nototheniinae |
| LepNud | *Lepidonotothen nudifrons* | Nototheniinae |
| GobGib | *Gobionotothen gibberifrons* | Nototheniinae |
| GymAcu | *Gymnodraco acuticeps* | Bathydraconidae |
| HarAnt | *Harpagifer antarcticus* | Bathydraconidae |
| HisVel | *Histiodraco velifer* | Bathydraconidae |
| AkaNud | *Akarotaxis nudiceps* | Bathydraconidae |
| ChaAce | *Champsocephalus aceratus* | Channichthyidae (icefish) |
| ChaGun | *Champsocephalus gunnari* | Channichthyidae (icefish) |
| ChaSox | *Chaenocephalus* sp. | Channichthyidae (icefish) |
| ChaWil | *Chionodraco wilsoni* | Channichthyidae (icefish) |
| CryAnt | *Cryodraco antarcticus* | Channichthyidae (icefish) |
| PseGeo | *Pseudochaenichthys georgianus* | Channichthyidae (icefish) |
| PagMac / PagBor | *Pagetopsis macropterus* / *borchgrevinki* | Channichthyidae (icefish) |
| PogAlb | *Pogonophryne albipinna* | Artedidraconidae |



---

## Environment

All scripts are SLURM batch jobs for the University of Arkansas **Pinnacle** cluster


Several conda environments were used on HPC: `RepeatModeler`, `cactus-3.13`, `Lastz`,
`nextflow-25.3.0-el9`, `braker2tabix-3.10` / `-3.11`, `busco`, `salmon`.

Key module versions as used: cactus/2.6.7, lastz/1.04.15, trinity/2.15.1,
orthofinder/2.5.2, nextflow/20.10.0–25.3.0, BUSCO 5.4.2.

Two SLURM settings to sanity-check before reusing anything: `--time` (some jobs are set
to 2 days) and `--chaining_memory` (30–50 GB). Both were tuned for specific genome
sizes.

---

## Data is NOT in this repo
Only code that were used for different programs are here.
