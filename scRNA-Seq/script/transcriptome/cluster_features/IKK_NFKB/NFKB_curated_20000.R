#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(GSVA)
library(future)
library(pforeach)
plan("multiprocess",workers=10)

combined <- readRDS(args[1])
combined$cluster_sampletype <- paste(combined$seurat_clusters,combined$sample_type.new,sep="__")
geneset <- read.table(args[2], header=T, check.names=F)
geneset <- geneset[geneset$geneSetName == "GO_I_KAPPAB_KINASE_NF_KAPPAB_SIGNALING",]
exp <- readRDS(args[3])
geneset <- geneset[geneset$symbol %in% rownames(exp),]
T_l <- list(geneset$symbol)
names(T_l) <- "GO_I_KAPPAB_KINASE_NF_KAPPAB_SIGNALING"
Th <- gsva(as.matrix(log10(exp + 1)), T_l, mx.diff=TRUE, 
                 verbose=T,parallel.sz=4,min.sz=10,max.sz=500,method="ssgsea")

exp.fil <- exp[rownames(exp) %in% geneset$symbol,]
cor <- pforeach (i = rownames(exp.fil)) ({cor(as.numeric(Th),as.numeric(exp[i,]),method="pearson")})
names(cor) <- rownames(exp.fil)
cor.fil <- cor[which(cor >= quantile(cor)["25%"])]
geneset <- geneset[geneset$symbol %in% names(cor.fil),]
T_l <- list(geneset$symbol)
names(T_l) <- "GO_I_KAPPAB_KINASE_NF_KAPPAB_SIGNALING"
Th <- gsva(as.matrix(log10(exp + 1)), T_l, mx.diff=TRUE, 
                 verbose=T,parallel.sz=4,min.sz=10,max.sz=500,method="ssgsea")

combined$GO_I_KAPPAB_KINASE_NF_KAPPAB_SIGNALING <- as.numeric(t(Th))
saveRDS(combined,args[1])



