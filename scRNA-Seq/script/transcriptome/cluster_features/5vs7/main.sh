#!/usr/bin/env bash

mkdir -p ../output/summary/markers/5vs7

R --vanilla --slave --args \
../output/summary/Seurat/combined.rds \
../output/summary/counts.fil_rpkm_20000.rds \
../output/summary/markers/5vs7/DEG.txt \
< transcriptome/cluster_features/5vs7/DEG.R


