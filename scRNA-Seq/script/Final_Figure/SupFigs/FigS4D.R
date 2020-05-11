#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(cowplot)
library(ggplot2)

combined <- readRDS(args[1])
combined$CXCL13 <- combined@assays$integrated@scale.data["CXCL13",]
combined$cluster_sampletype <- paste(combined$seurat_clusters,combined$sample_type.new,sep="__")
combined1 <- combined
combined1$cluster_sampletype <- factor(combined1$cluster_sampletype,
                                      levels = c("1__Mock","1__GFPnega","1__GFPposi",
                                                 "2__Mock","2__GFPnega","2__GFPposi",
                                                 "3__Mock","3__GFPnega","3__GFPposi",
                                                 "4__Mock","4__GFPnega","4__GFPposi",
                                                 "5__Mock","5__GFPnega","5__GFPposi",
                                                 "6__Mock","6__GFPnega","6__GFPposi",
                                                 "7__Mock","7__GFPnega","7__GFPposi",
                                                 "8__Mock","8__GFPnega","8__GFPposi",
                                                 "9__Mock","9__GFPnega","9__GFPposi"))
mt1 <- combined1@meta.data

theme <- theme(axis.title.x=element_blank(),axis.text.x=element_text(angle=90),axis.ticks.x=element_blank())

pC_1 <- ggplot(mt1,aes(x=cluster_sampletype, y = CXCL13,color=sample_type.new)) + geom_boxplot(outlier.shape = NA) + theme + geom_jitter(size = 0.5) + NoLegend()

pdf(args[2],height=5,width=10)
print(pC_1)
dev.off()



