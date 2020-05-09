#!/usr/bin/env bash

mkdir -p ../output/summary/markers/NFKB
wget -P ../output/summary/markers/NFKB \
https://bioinfo.lifl.fr/NF-KB/NM-human.txt

python transcriptome/cluster_features/NFKB/RefseqToSymbol.py \
../output/summary/markers/NFKB/NM-human.txt \
../output/summary/gene_length.txt \
../input/HGNC.txt \
| uniq \
> ../output/summary/markers/NFKB/NFKB_regulated_genes.txt

R --vanilla --slave --args \
../output/summary/Seurat/combined.rds \
../output/summary/markers/NFKB/NFKB_regulated_genes.txt \
../output/summary/counts.fil_rpkm_20000.rds \
< transcriptome/cluster_features/NFKB/NFKB_curated_20000.R

R --vanilla --slave --args \
../output/summary/Seurat/combined.rds \
../output/summary/markers/NFKB/NFKB_plot_20000_pn_wilcoxon_test_curated_greater.txt \
< transcriptome/cluster_features/NFKB/NFKB_20000_wilcoxon_test_curated.R




