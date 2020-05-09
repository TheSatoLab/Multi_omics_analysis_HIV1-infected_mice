#!/usr/bin/env bash

mkdir -p ../output/summary/markers/marker_genes
R --vanilla --slave --args \
../output/summary/Seurat/combined.rds \
../output/summary/markers/marker_genes/cluster \
< transcriptome/cluster_features/Markers.R

mkdir -p ../output/summary/markers/marker_genes_addpnm
R --vanilla --slave --args \
../output/summary/Seurat/combined.rds \
../output/summary/markers/marker_genes_addpnm/cluster \
< transcriptome/cluster_features/Markers_addpnm.R

R --vanilla --slave --args \
../output/summary/Seurat/combined.rds \
../output/summary/markers/marker_genes/cluster \
../output/summary/markers/marker_genes_addpnm/cluster \
../output/summary/markers/Markers_merged.txt \
< transcriptome/cluster_features/Markers_merge.R

bash transcriptome/cluster_features/CXCL13/main.sh
bash transcriptome/cluster_features/ISG/main.sh
bash transcriptome/cluster_features/5vs7/main.sh
bash transcriptome/cluster_features/SAMHD1/main.sh
bash transcriptome/cluster_features/NFKB/main.sh
bash transcriptome/cluster_features/IKK_NFKB/main.sh


