#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(ggplot2)

combined <- readRDS(args[1])
#combined$CXCL13 <- combined@assays$integrated@scale.data["CXCL13",]
Infected <- subset(combined, subset=sample_type.new!="Mock") 
mt.i <- Infected@meta.data
theme <- theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())

pd2_pn <- ggplot(mt.i,aes(x=seurat_clusters, y = commonISG)) + geom_boxplot(outlier.shape = NA) + theme  + geom_jitter(aes(color=seurat_clusters),size = 0.5) + NoLegend()

pdf(args[2], height=5, width=5)
pd2_pn
dev.off()


