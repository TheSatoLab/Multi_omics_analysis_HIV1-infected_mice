#!/usr/bin/env bash

mkdir -p ../output/STAR1st
cat ../output/fastq/*/*/after.fastq > ../output/STAR1st/allsc.fastq
STAR \
--runThreadN 30 \
--genomeDir ../output/STARIndex1st/ \
--readFilesIn ../output/STAR1st/allsc.fastq \
--outFilterMismatchNmax 2 \
--outSJfilterOverhangMin 12 8 8 8 \
--outFileNamePrefix ../output/STAR1st/allsc \
--outSAMtype None \
--chimSegmentMin 8 \
--chimJunctionOverhangMin 8

R --slave --vanilla --args \
../output/STAR1st/allscSJ.out.tab \
../output/STAR1st/allscSJ.out.tab.filtered \
< MakeSummaryData/SJfilter.R


