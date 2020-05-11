#!/usr/bin/env bash

mkdir -p ../output/summary/markers/SAMHD1

R --vanilla --slave --args \
../output/summary/Seurat/combined.rds \
../output/summary/counts.fil_rpkm_20000.rds \
< transcriptome/cluster_features/SAMHD1/SAMHD1_AddScore.R

R --vanilla --slave --args \
../output/summary/Seurat/combined.rds \
../output/summary/markers/SAMHD1/SAMHD1_pn_wilcoxon_test_greater.txt \
< transcriptome/cluster_features/SAMHD1/SAMHD1_wilcoxon_test.R


