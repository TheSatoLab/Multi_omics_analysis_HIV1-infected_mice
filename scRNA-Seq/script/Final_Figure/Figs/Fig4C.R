#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(ggplot2)

combined <- readRDS(args[1])
combined$HIV <- combined@assays$integrated@scale.data["NLCSFV3-EGFP",]
GFPposi <- subset(combined, subset=sample_type.new=="GFPposi")
mt.p <- GFPposi@meta.data

pdf(args[2],height=5, width=5)
ggplot(mt.p,aes(x=seurat_clusters, y = HIV)) + geom_boxplot(outlier.shape = NA) + ylim(-2,6) + geom_jitter(aes(color = seurat_clusters),size = 0.5) + NoLegend()
dev.off()



