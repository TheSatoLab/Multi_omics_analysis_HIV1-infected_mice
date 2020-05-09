#!/usr/bin/env bash

R --slave --vanilla --args \
../output/summary/counts.fil.rds \
../output/summary/counts.fil_MTfil.rds \
< transcriptome/Clustering/MTfilter.R

R --slave --vanilla --args \
../output/summary/counts.fil_MTfil.rds \
../output/summary/GeneLength.txt \
../output/summary/counts.fil_rpkmfil.rds \
../output/summary/counts.fil_rpkm_20000.rds \
< transcriptome/Clustering/expfilter.R

mkdir -p ../output/summary/Seurat
R --vanilla --slave --args \
../output/summary/counts.fil_rpkmfil.rds \
../output/summary/Seurat/combined.rds \
< transcriptome/Clustering/Seurat.pnm_allgenes_impute.R

R --vanilla --slave --args \
../output/summary/Seurat/combined.rds \
< transcriptome/Clustering/Clustering.R


