#!/usr/bin/env bash

mkdir -p ../output/summary/markers/CXCL13

R --vanilla --slave --args \
../output/summary/Seurat/combined.rds \
../output/summary/markers/CXCL13/CXCL13_wilcoxon_test_greater.txt \
< transcriptome/cluster_features/CXCL13/CXCL13_wilcoxon_test.R


