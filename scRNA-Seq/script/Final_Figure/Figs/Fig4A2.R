#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(cowplot)
combined <- readRDS(args[1])
pdf(args[2],height=5,width=6)
DimPlot(combined, reduction = "umap",label = T,pt.size=1)
dev.off()



