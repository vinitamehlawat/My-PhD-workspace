# TOGA — questions asked of the Hiller lab, and their answers

Converted from `TOGA question.boxnote` (Box note, authored by Vinita Lamba, last edited Jan 2025).
The original `.boxnote` is a JSON container that only Box can open, so the content is preserved
here as plain markdown. Keep this — it answers most of the questions a newcomer will hit.

---

**Q. What does a transcript classified `UL` mean?**

It means *uncertainly lost*. If 49% of the CDS is not conserved, that gene is classified as UL.

More fully: `UL`, or "Uncertain Loss", refers to a situation where there is some evidence suggesting
the reading frame is corrupted, preventing TOGA from classifying the gene as Intact. However, the
evidence is not strong enough to definitively declare the gene as Lost.

---

**Q. How do I prepare a bed12-formatted file as the reference genome annotation?**

You can use `gffread` to convert gff to bed12. There are also two UCSC tools, `gff3ToGenePred` and
`genePredToBed`, which can be used to do so.

---

**Q. Is there existing code for extracting one-to-one orthologues from the TOGA annotations using
the `orthology_classification.tsv` file?**

```
grep one2one orthology_classification.tsv | cut -f4 | sort -u > one2ones.txt
sort query_annotation.bed -o query_annotation.sorted.bed -k4,4
join -1 1 -2 4 one2ones.txt query_annotation.sorted.bed -t $'\t'
```

---

**Q. In `gene_rejection_reasons.tsv`, what do these mean — "out-of-frame gene", "no classifiable
chains", "all exons are deleted", "chromosome is not aligned", "no intersecting chains"?**

Out-of-frame gene refers to a gene annotation in the reference that is not in frame or has an
internal (non-TGA) stop.

No classifiable / intersecting chains and chrom not aligned likely refers to genes that have no
spanning or no chain at all — such genes should be classified as missing.

---

**Q. Command to calculate the number of genes annotated?**

```
awk '{print $4}' query_annotation.bed | awk -v FS="." '{print $2}' | sort -u | wc -l
```

(gave 17764 for this project)

---

**Q. How could I use `loss_summ_data.tsv` combined with `inact_mut_data.txt` to draw the
inactivating-mutation figure?**

Use the script `./supply/plot_mutations.py`. See `plot_mutations_command.txt` in this folder for
the exact invocations used.

---

**Q. Counting the number of copies of genes in `orthology_classification.tsv` — if I grep all
records for AMY and the third column contains three genes (reg_14433, reg_10659, reg_14509), does
that mean three copies of the Amylase gene in this species?**

Yes, this is generally right. Just make sure that your grep expression does not catch any
additional genes. `grep ${gene ID in reference} | cut -f3 | sort -u` should give you a list of
orthologous genes in the query.

---

**Q. To identify the location of gene reg_14433, should I calculate the longest of its several
transcript IDs to represent this gene?**

Actually, depends on what exactly you need. I would recommend finding transcripts with those IDs in
the `query_annotation.bed` and select some isoform. Maybe also look at `gene_loss_summary.tsv` —
maybe the longest isoform is not fully intact (can be a single inactivating mutation such as a
frameshifting indel which is not enough to call the gene "Lost", but definitely something to take
into account).
