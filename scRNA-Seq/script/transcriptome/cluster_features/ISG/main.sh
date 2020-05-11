#!/usr/bin/env bash

mkdir -p ../output/summary/markers/ISG

R --vanilla --slave --args \
../output/summary/Seurat/combined.rds \
../input/ISGlist.txt \
../output/summary/counts.fil_rpkm_20000.rds \
< transcriptome/cluster_features/ISG/ISG_AddScore.R

R --vanilla --slave --args \
../output/summary/Seurat/combined.rds \
../input/ISGlist.txt \
../output/summary/counts.fil_rpkm_20000.rds \
../output/summary/markers/ISG/ISG_pn_wilcoxon_test_less.txt \
< transcriptome/cluster_features/ISG/ISG_wilcoxon_test.R

