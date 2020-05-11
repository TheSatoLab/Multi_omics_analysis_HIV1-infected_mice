#!/usr/bin/env bash

mkdir -p ../output/Final_Figure/Figs

R --vanilla --slave --args \
../output/summary/Seurat/combined.rds \
../output/Final_Figure/Figs/Fig4A1.pdf \
< Final_Figure/Figs/Fig4A1.R

R --vanilla --slave --args \
../output/summary/Seurat/combined.rds \
../output/Final_Figure/Figs/Fig4A2.pdf \
< Final_Figure/Figs/Fig4A2.R

R --vanilla --slave --args \
../output/summary/Seurat/combined.rds \
../output/Final_Figure/Figs/Fig4B.pdf \
< Final_Figure/Figs/Fig4B.R

R --vanilla --slave --args \
../output/summary/Seurat/combined.rds \
../output/Final_Figure/Figs/Fig4C.pdf \
< Final_Figure/Figs/Fig4C.R

R --vanilla --slave --args \
../output/summary/Seurat/combined.rds \
../output/Final_Figure/Figs/Fig4D.pdf \
< Final_Figure/Figs/Fig4D.R

R --vanilla --slave --args \
../output/summary/markers/Markers_merged.txt \
../input/Cluster_Marker_genes.txt \
../output/Final_Figure/Figs/Fig4E.pdf \
< Final_Figure/Figs/Fig4E.R

R --vanilla --slave --args \
../output/summary/Seurat/combined.rds \
../output/Final_Figure/Figs/Fig4F.pdf \
< Final_Figure/Figs/Fig4F.R

R --vanilla --slave --args \
../output/summary/Seurat/combined.rds \
../output/Final_Figure/Figs/Fig4H.pdf \
< Final_Figure/Figs/Fig4H.R

R --vanilla --slave --args \
../output/summary/Seurat/combined.rds \
../output/Final_Figure/Figs/Fig4I.pdf \
< Final_Figure/Figs/Fig4I.R

R --slave --vanilla --args \
../output/NatCom/Seurat/Runs/SRR8526551_Clustering.rds \
../output/NatCom/Seurat/Runs/SRR8526557_Clustering.rds \
../output/NatCom/HuMi_donor_relation/LN_rest_correlation_matrix.txt \
../output/Final_Figure/Figs/Fig4J.pdf \
< Final_Figure/Figs/Fig4J.R




