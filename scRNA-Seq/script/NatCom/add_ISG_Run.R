#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(GSVA)
library(future)
plan("multiprocess",workers=24)
options(future.globals.maxSize = 16000000000)

combined <- readRDS(args[1])
geneset <- read.table(args[3], header=T, check.names=F)
commonISG.df <- geneset[geneset$category %in% c("commonISG","commonISG*"),]
combined <- NormalizeData(combined,verbose=F)
exp <- as.matrix(combined@assays$RNA@data)
commonISG <- commonISG.df[commonISG.df$ISG %in% rownames(exp),]
ISG <- gsva(exp, list(ISG = commonISG$ISG), mx.diff=TRUE, 
                 verbose=T,parallel.sz=3,min.sz=10,max.sz=500,method="ssgsea")

exp.fil <- exp[rownames(exp) %in% commonISG$ISG,]
cor <- apply(exp.fil,1,cor,as.numeric(ISG),method="pearson")
cor.fil <- cor[which(cor >= quantile(cor)["25%"])]
commonISG <- commonISG[commonISG$ISG %in% names(cor.fil),]
ISG <- gsva(exp, list(ISG = commonISG$ISG), mx.diff=TRUE, 
                 verbose=T,parallel.sz=3,min.sz=10,max.sz=500,method="ssgsea")

Seurat <- readRDS(args[2])
Seurat$commonISG <- as.numeric(t(ISG))
saveRDS(Seurat,args[2])


