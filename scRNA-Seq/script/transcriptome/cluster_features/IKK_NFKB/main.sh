#!/usr/bin/env bash

mkdir -p ../output/summary/markers/IKK_NFKB
R --vanilla --slave --args \
../output/summary/Seurat/combined.rds \
../input/association_msigdbGO_BP.txt \
../output/summary/counts.fil_rpkm_20000.rds \
< transcriptome/cluster_features/IKK_NFKB/NFKB_curated_20000.R

R --vanilla --slave --args \
../output/summary/Seurat/combined.rds \
../output/summary/markers/IKK_NFKB/IKK_NFKB_plot_20000_pn_wilcoxon_test_curated_greater.txt \
< transcriptome/cluster_features/IKK_NFKB/NFKB_20000_wilcoxon_test_curated.R

