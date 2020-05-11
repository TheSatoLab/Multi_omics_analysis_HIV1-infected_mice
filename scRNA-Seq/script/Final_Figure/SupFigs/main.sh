#!/usr/bin/env bash

mkdir -p ../output/Final_Figure/SupFigs

R --vanilla --slave --args \
../output/summary/Seurat/combined.rds \
../output/Final_Figure/SupFigs/FigS4A.pdf \
< Final_Figure/SupFigs/FigS4A.R

R --vanilla --slave --args \
../output/summary/Seurat/combined.rds \
../output/Final_Figure/SupFigs/FigS4B.pdf \
< Final_Figure/SupFigs/FigS4B.R

R --vanilla --slave --args \
../output/summary/Seurat/combined.rds \
../output/Final_Figure/SupFigs/FigS4C.pdf \
< Final_Figure/SupFigs/FigS4C.R

R --vanilla --slave --args \
../output/summary/Seurat/combined.rds \
../output/Final_Figure/SupFigs/FigS4D.pdf \
< Final_Figure/SupFigs/FigS4D.R

R --vanilla --slave --args \
../output/summary/Seurat/combined.rds \
../output/Final_Figure/SupFigs/FigS4F.pdf \
< Final_Figure/SupFigs/FigS4F.R

R --vanilla --slave --args \
../output/summary/Seurat/combined.rds \
../output/Final_Figure/SupFigs/FigS4G.pdf \
< Final_Figure/SupFigs/FigS4G.R

R --vanilla --slave --args \
../output/summary/Seurat/combined.rds \
../output/Final_Figure/SupFigs/FigS4H.pdf \
< Final_Figure/SupFigs/FigS4H.R

R --slave --vanilla --args \
../output/NatCom/Seurat/Runs/SRR8526551_Clustering.rds \
../output/NatCom/Seurat/Runs/SRR8526557_Clustering.rds \
../output/NatCom/HuMi_donor_relation/LN_rest_correlation_matrix.txt \
Donor1 \
Donor2 \
../output/Final_Figure/SupFigs/FigS4I.pdf \
< Final_Figure/SupFigs/FigS4I.R




