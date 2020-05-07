#!/usr/bin/env python

"""
Usage:
python unique_flagment.py <input.sam> <minimum quality> <maximum number of bases with low qality> > <output.txt>

*This program requires bedtools.
"""

import sys, subprocess
argvs = sys.argv

def qualityCheck(Scores,Min_fg_score,Max_bad_base):
  Scores_l = sorted([ord(c) - 33 for c in Scores])
  Test_score = Scores_l[Max_bad_base-1]
  if Test_score >= Min_fg_score:
    return True

sam_f_name = argvs[1]
min_fg_score = int(argvs[2])
max_bad_base = int(argvs[3])

sam_f = open(sam_f_name)
quality_d = {}
for line in sam_f:
  line = line.strip()
  if line[0] != '@':
    line = line.split("\t")
    fg_name = line[0]
    scores = line[10]
    if fg_name not in quality_d:
      quality_d[fg_name] = 0
    if qualityCheck(scores,min_fg_score,max_bad_base):
      quality_d[fg_name] += 1

cmd = 'samtools view -Sb %(f)s | bedtools bamtobed -i "stdin"' % {"f":sam_f_name}
res_l = subprocess.check_output(cmd, shell=True).strip().split("\n")

fg_d = {}
for line in res_l:
  chrom,start,end,name,score,strand = line.split()
  start = int(start)
  end = int(end)
  fg_name = name.split('/')[0]
  read = int(name.split('/')[1])
  if quality_d[fg_name] ==2:
    if fg_name not in fg_d:
      fg_d[fg_name] = {}
    fg_d[fg_name][read] = [chrom,start,end,name,score,strand]

uniq_fg_d = {}
for fg_name in fg_d :
  if len(fg_d[fg_name]) ==2:
    chrom_1,start_1,end_1,name_1,score_1,strand_1 = fg_d[fg_name][1]
    chrom_2,start_2,end_2,name_2,score_2,strand_2 = fg_d[fg_name][2]
    if chrom_1 == chrom_2:
      if strand_1 == "+":
        IS = start_1 + 1
        BP = end_2
        name = chrom_1 + ":" + str(IS) + "-" + str(BP)
      else:
        IS = end_1
        BP = start_2 + 1
        name = chrom_1 + ":" + str(BP) + "-" + str(IS)
      t = (chrom_1,IS,BP,strand_1,name)
      if t not in uniq_fg_d:
        uniq_fg_d[t] = []
      if quality_d[fg_name] == 2:
        uniq_fg_d[t].append(fg_name)

print "#Chrom\tIntegration_site\tBreak_posint\tStrand\tPosition\tDuplication_number"
for t in uniq_fg_d:
  count = len(set(uniq_fg_d[t]))
  print "\t".join([str(i) for i in t]) + "\t" + str(count)
