#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(cowplot)
library(ggplot2)
combined <- readRDS(args[1])
Infected <- subset(combined,subset=sample_type.new != "Mock")
scale.data <- Infected@assays$integrated@scale.data
scale.data.noHIV <- scale.data[rownames(scale.data) != "NLCSFV3-EGFP",]
noHIV <- rownames(scale.data.noHIV)
Infected <- RunPCA(Infected,npcs=100,features = noHIV)

stdev <- Infected@reductions$pca@stdev
total.var <- Infected@reductions$pca@misc$total.variance
PC1 <- round(((stdev[1])^2)/total.var*100,0)
PC2 <- round(((stdev[2])^2)/total.var*100,0)

p <- DimPlot(Infected, reduction = "pca",group.by ="sample_type.new",pt.size=1)# + NoLegend()
p <- p + xlab(paste("PC_1 (",PC1,"%)",sep="")) + ylab(paste("PC_2 (",PC2,"%)",sep=""))
pdf(args[2],height=5,width=7)
p
dev.off()

