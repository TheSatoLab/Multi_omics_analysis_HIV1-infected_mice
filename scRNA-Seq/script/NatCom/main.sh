#!/usr/bin/env bash

mkdir -p ../output/NatCom/GSE126030_RAW
wget -P ../output/NatCom/GSE126030_RAW \
https://ftp.ncbi.nlm.nih.gov/geo/samples/GSM3589nnn/GSM3589410/suppl/GSM3589410_PP005swap.filtered.matrix.txt.gz
wget -P ../output/NatCom/GSE126030_RAW \
https://ftp.ncbi.nlm.nih.gov/geo/samples/GSM3589nnn/GSM3589416/suppl/GSM3589416_PP013swap.filtered.matrix.txt.gz
gunzip -k ../output/NatCom/GSE126030_RAW/GSM3589410_PP005swap.filtered.matrix.txt.gz
gunzip -k ../output/NatCom/GSE126030_RAW/GSM3589416_PP013swap.filtered.matrix.txt.gz

mkdir -p ../output/NatCom/Seurat/Runs
tail -n +2 ../input/NatCom.txt | cut -f 1,6-9 | xargs -n 5 -P 2 bash -c \
'
Run=${0}
stimulation=${1}
tissue=${2}
donor=${3}
GSM=${4}
R --slave --vanilla --args \
${Run} \
${stimulation} \
${tissue} \
${donor} \
../input/NatCom_Fig6.txt \
../output/NatCom/GSE126030_RAW/${GSM}swap.filtered.matrix.txt \
../output/NatCom/Seurat/Runs/${Run}.rds \
< NatCom/CreateSeuratObject.R

R --slave --vanilla --args \
../output/NatCom/Seurat/Runs/${Run}.rds \
../output/summary/Seurat/combined.rds \
../output/NatCom/Seurat/Runs/${Run}_HuMiGenes.rds \
< NatCom/HuMiGenes.R

R --slave --vanilla --args \
../output/NatCom/Seurat/Runs/${Run}.rds \
../output/NatCom/Seurat/Runs/${Run}_HuMiGenes.rds \
../input/ISGlist.txt \
< NatCom/add_ISG_Run.R

R --slave --vanilla --args \
../output/NatCom/Seurat/Runs/${Run}_HuMiGenes.rds \
../output/NatCom/Seurat/Runs/${Run}_Clustering.rds \
< NatCom/Clustering.R
'

mkdir -p ../output/NatCom/HuMi_donor_relation
R --slave --vanilla --args \
../input/ISGlist.txt \
../output/NatCom/Seurat/Runs/SRR8526551_Clustering.rds \
../output/NatCom/Seurat/Runs/SRR8526557_Clustering.rds \
../output/NatCom/HuMi_donor_relation/LN_rest_mean_df.rds \
< NatCom/cluster_mean.R

R --slave --vanilla --args \
../output/summary/Seurat/combined.rds \
../output/NatCom/HuMi_donor_relation/LN_rest_mean_df.rds \
../output/NatCom/HuMi_donor_relation/LN_rest_correlation_matrix.txt \
< NatCom/HuMi_donor_correlation.R

