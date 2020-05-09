#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(ggplot2)
library(cowplot)

combined <- readRDS(args[1])
combined$SAMHD1 <- combined@assays$integrated@scale.data["SAMHD1",]
Infected <- subset(combined, subset=sample_type.new!="Mock") 
mt.i <- Infected@meta.data
theme <- theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())

ph1 <- ggplot(mt.i,aes(x=seurat_clusters, y = SAMHD1)) + geom_boxplot(outlier.shape = NA) +  geom_jitter(aes(color=seurat_clusters),size = 0.5) + NoLegend()

pdf(args[2], height=5, width=5)
ph1
dev.off()


