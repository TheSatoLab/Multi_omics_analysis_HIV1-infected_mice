#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(cowplot)
library(ggplot2)

combined <- readRDS(args[1])
mt <- combined@meta.data
Infected <- subset(combined, subset=sample_type.new!="Mock") 
mt.i <- Infected@meta.data
theme <- theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())

###d5(NFKB_regulated)
pd5_pn <- ggplot(mt.i,aes(x=seurat_clusters, y = NFKB_regulated_genes)) + geom_boxplot(outlier.shape = NA) + theme + geom_jitter(aes(color=seurat_clusters),size = 0.5) + NoLegend() 

###d6(NFKB_signal)
pd6_pn <- ggplot(mt.i,aes(x=seurat_clusters, y = GO_I_KAPPAB_KINASE_NF_KAPPAB_SIGNALING)) + geom_boxplot(outlier.shape = NA) + theme + geom_jitter(aes(color=seurat_clusters),size = 0.5) + NoLegend()

p <- plot_grid(pd5_pn,pd6_pn,ncol=2)

pdf(args[2],height=5,width=10)
p
dev.off()



