#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(ggplot2)
library(cowplot)
library(future)
plan("multiprocess",workers=10)

combined <- readRDS(args[1])
mt <- combined@meta.data

p1 <- ggplot(mt,aes(x=sample_type.new, y = commonISG)) + geom_boxplot(outlier.shape = NA)   + geom_jitter(aes(color=sample_type.new),size = 0.5)
pdf(args[2],height=5,width=5)
print(p1)
dev.off()



