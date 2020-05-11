#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(cowplot)
combined <- readRDS(args[1])
pdf(args[2],height=5,width=6)
DimPlot(combined, reduction = "umap",group.by ="sample_type.new",pt.size=1) 
dev.off()



