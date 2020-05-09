#!/usr/bin/env bash

mkdir -p ../output/STARIndex2nd
cd ../output/STARIndex2nd/
STAR \
--runThreadN 24 \
--runMode genomeGenerate \
--limitGenomeGenerateRAM 65000000000 \
--genomeDir ./ \
--genomeFastaFiles ../../input/hg38_HIVGFP_RU3.fa \
--sjdbGTFfile ../../input/gencode.v22.annotation.without_retained_intron_sorted.unique.Id_HIVGFP_RU3_1row.gtf \
--sjdbFileChrStartEnd ../../output/STAR1st/allscSJ.out.tab.filtered \
--sjdbOverhang 35
cd ../../script/



