#!/usr/bin/env python

"""
Usage:
python seqFinder.py <input.sam> <reference_genome.fa> <viral_end_seq> > <output.sam>

*This program requires bedtools and samtools.
"""

import sys, subprocess
argvs = sys.argv

def parse_fasta(f):
  d = {}
  name = ""
  seq = []
  for s in f:
    if s[0] == ">":
      d[name] = seq
      name = s.strip()[1:]
      seq = []
    else:
     seq.extend(list(s.strip().lower()))
  d[name] = seq
  del d[""]
  return d

def ReverseComplement(Seq):
    seq_dict = {'a':'t','t':'a','g':'c','c':'g'}
    return "".join([seq_dict[base] for base in reversed(Seq)])

def getLastSeq(Bed_l,Length,Seq_d):
  Chrom,Start,End,Name,_,Strand = Bed_l
  Start = int(Start)
  End = int(End)
  if Strand == "+":
    LastSeq_Start = Start - Length
    LastSeq_End = Start
    LastSeq = "".join(Seq_d[Chrom][LastSeq_Start:LastSeq_End])
  else:
    LastSeq_Start = End
    LastSeq_End = End + Length
    LastSeq = "".join(Seq_d[Chrom][LastSeq_Start:LastSeq_End])
    LastSeq = ReverseComplement(LastSeq)
  return LastSeq


sam_f_name = argvs[1]
fasta_f = open(argvs[2])
viral_end_seq = argvs[3].lower()
viral_end_seq_len = len(viral_end_seq)

sam_f = open(sam_f_name)
sam_d = {}
header_l = []
for line in sam_f:
  line = line.strip()
  if line[0] == "@":
    header_l.append(line) 
  else:
    line = line.split()
    name = line[0]
    if name not in sam_d:
      sam_d[name] = []
    sam_d[name].append(line)

seq_d = parse_fasta(fasta_f)

cmd = 'samtools view -Sb -f 67 -F 256 %(f)s | bedtools bamtobed -i "stdin"' % {"f":sam_f_name}
res_l = subprocess.check_output(cmd, shell=True).strip().split("\n")
filtered_name_l = []
read_num = len(res_l)


for i in range(read_num):
  bed_l = res_l[i].split("\t")
  name = bed_l[3].split('/')[0]
  last_seq = getLastSeq(bed_l,viral_end_seq_len,seq_d)
  if last_seq != viral_end_seq :
    filtered_name_l.append(name)
filtered_name_l = list(set(filtered_name_l))


for line in header_l:
  print line
for name in filtered_name_l:
  for l in sam_d[name]:
    print "\t".join(l)

