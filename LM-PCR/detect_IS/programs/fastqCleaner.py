#!/usr/bin/env python

"""
Usage:
python fastqCleaner <R1.fastq> <R2.fastq> <R1_out.fastq> <R2_out.fastq>

*This program can use only for fastq with Phred+33.
"""

#Default threasholds:
max_N = 6
min_read_len = 20
min_base_quality = 20
min_prop_of_good_base = 0.8 #minimum proportion of nucleotides with good quality


import sys
argvs = sys.argv

def fastqTolist(f) :
  l = []
  for line in f:
    line = line.strip()
    l.append(line)
  return l

def listTodict(l):
  d = {}
  if  ' ' in l[0]:
    version = '>=1.8'
  else:
    version = '<1.8'
  if version == '>=1.8': 
    for i in range(0,len(l),4):
      name = l[i].split(' ')[0] 
      d[name] = l[i:i+4]
  else:
    for i in range(0,len(l),4):
      name = l[i].split('/')[0] 
      d[name] = l[i:i+4]    
  return d

def qualityCheck(d):
  filtered_name_l = []
  for name in d:
    l = d[name]
    seq = l[1]
    seq_len = len(seq)
    scores = l[3]
    scores_l =  [ord(c) - 33 for c in scores]
    num_N = len([c for c in seq if c =="N"])
    prop_good_base = len([q for q in scores_l if q >= min_base_quality]) / float(seq_len)
    if (seq_len >= min_read_len) and (num_N <= max_N) and (prop_good_base >= min_prop_of_good_base):
      filtered_name_l.append(name)
  return filtered_name_l

r1_f = open(argvs[1])
r1_l = fastqTolist(r1_f)
r1_d = listTodict(r1_l)
r1_filtered_name_l = qualityCheck(r1_d)

r2_f = open(argvs[2])
r2_l = fastqTolist(r2_f)
r2_d = listTodict(r2_l)
r2_filtered_name_l = qualityCheck(r2_d)

r1_out_f = open(argvs[3],"w")
r2_out_f = open(argvs[4],"w")
name_set = set(r1_filtered_name_l) & set(r2_filtered_name_l)

for name in sorted(name_set):
  r1_out_l = r1_d[name]
  r2_out_l = r2_d[name]
  print >> r1_out_f, "\n".join(r1_out_l)
  print >> r2_out_f, "\n".join(r2_out_l)

