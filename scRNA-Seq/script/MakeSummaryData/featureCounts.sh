#!/usr/bin/env bash

mkdir -p ../output/featureCounts
tail -n +2 ../input/sample.info.txt | cut -f 2 | uniq | xargs -n 1 -P 6 sh -c \
  '
  mkdir -p ../output/featureCounts/${0}
  featureCounts -T 4 -t exon -g gene_name \
  -a ../input/gencode.v22.annotation.without_retained_intron_sorted.unique.Id_HIVGFP_RU3_1row.gtf \
  -o ../output/featureCounts/${0}/counts.txt \
  ../output/STAR/${0}/*/*Aligned.sortedByCoord.out.bam

  tail -n +2 ../output/featureCounts/${0}/counts.txt | cut -f 1,7- \
  | sed -e "s/\.\.\/output\/STAR\/${0}\///g" | sed -e "s/\/${0}_...Aligned.sortedByCoord.out.bam//g" \
  > ../output/featureCounts/${0}/${0}_exp_matrix.txt

  cat ../output/featureCounts/${0}/counts.txt.summary \
  | sed -e "s/\.\.\/output\/STAR\/${0}\///g" | sed -e "s/\/${0}_...Aligned.sortedByCoord.out.bam//g" \
  > ../output/featureCounts/${0}/${0}_counts2.txt.summary.txt
  '

