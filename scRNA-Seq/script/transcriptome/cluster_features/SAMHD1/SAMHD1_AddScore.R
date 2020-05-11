#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(future)
plan("multiprocess",workers=10)

combined <- readRDS(args[1])
exp <- readRDS(args[2])
exp <- exp[,colnames(exp) %in% colnames(combined)]
combined$SAMHD1_log10RPKM <- as.numeric(log10(exp["SAMHD1",] + 1))
saveRDS(combined,args[1])


