#!/usr/bin/env bash

mkdir -p ../output/STARIndex1st
cd ../output/STARIndex1st/
STAR \
--runThreadN 24 \
--runMode genomeGenerate \
--limitGenomeGenerateRAM 65000000000 \
--genomeDir ./ \
--genomeFastaFiles ../../input/hg38_HIVGFP_RU3.fa \
--sjdbGTFfile ../../input/gencode.v22.annotation.without_retained_intron_sorted.unique.Id_HIVGFP_RU3_1row.gtf \
--sjdbOverhang 35
cd ../../script/



