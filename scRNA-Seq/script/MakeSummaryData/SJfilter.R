#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
SJ <- read.table(args[1])
SJ.fil <- SJ[SJ$V7 >= 50,]
SJ.HIV <- SJ[SJ$V1 == "NLCSFV3_EGFP",]
write.table(SJ.fil, args[2], quote=F, col.names=F, row.names=F, sep="\t")

