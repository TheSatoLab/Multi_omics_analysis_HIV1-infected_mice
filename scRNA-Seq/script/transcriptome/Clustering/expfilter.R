#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(pforeach)
data <- readRDS(args[1])
data <- data[apply(data,1,sum) != 0,]

### MT filter
data_MT <- data[grep("^MT_",rownames(data)),]

### TRA/B bind
data_TRAV <- data[grep("^TRAV",rownames(data)),]
data_TRAJ <- data[grep("^TRAJ",rownames(data)),]
data_TRBV <- data[grep("^TRBV",rownames(data)),]
data_TRBJ <- data[grep("^TRBJ",rownames(data)),]
data_TRs <- rbind(data_TRAV,data_TRAJ,data_TRBV,data_TRBJ)
data <- data[setdiff(rownames(data),rownames(data_TRs)),]
data["TRAVs",] <- apply(data_TRAV,2,sum)
data["TRAJs",] <- apply(data_TRAJ,2,sum)
data["TRBVs",] <- apply(data_TRBV,2,sum)
data["TRBJs",] <- apply(data_TRBJ,2,sum)

total_c <- apply(data,2,sum)
total_g <- apply(data,1,sum)
ll <- read.table(args[2],header=T)
rownames(ll) <- ll$Geneid
ll <- ll[rownames(ll) %in% rownames(data),]
data <- as.data.frame(data[rownames(data) %in% rownames(ll),])
calc_rpm <- function(x) return(x/total_c*1000000)
rpm <- as.data.frame(apply(data,1,calc_rpm))
calc_RPKM <- function(x) return(x/as.vector(as.numeric(ll[,"Length"]))*1000)
rpkm <- as.data.frame(apply(rpm,1,calc_RPKM))

sum_rpkm <- sort(apply(rpkm,1,sum), decreasing=T)
calc_0.90 <- function(x) quantile(x,0.90)
rpkm.fil <- rpkm[which(apply(rpkm,1,calc_0.90) >= 0.5),]
sum_rpkm.fil <- head(sum_rpkm[names(sum_rpkm) %in% rownames(rpkm.fil)],2000)
sum_rpkm_20000 <- sort(apply(rpkm,1,sum), decreasing=T)
sum_rpkm.fil_20000 <- head(sum_rpkm_20000,20000)
rpkm.fil <- rpkm.fil[rownames(rpkm.fil) %in% names(sum_rpkm.fil),]
rpkm.fil <- rpkm.fil[setdiff(rownames(rpkm.fil),rownames(data_MT)),]
saveRDS(rpkm.fil,args[3])

rpkm_20000 <- rpkm[rownames(rpkm) %in% names(sum_rpkm.fil_20000),]
rpkm_20000 <- rpkm_20000[setdiff(rownames(rpkm_20000),rownames(data_MT)),]
saveRDS(rpkm_20000,args[4])





