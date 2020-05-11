#!/usr/bin/env python

import sys,re
args = sys.argv

NM_l = []
f1 = open(args[1])
for line in f1:
  NM_l.append(line.strip())

symbol_l = []
f2 = open(args[2])
f2.next()
for line in f2:
  line = line.strip().split()
  symbol_l.append(line[0])

f3 = open(args[3])
f3.next()
for line in f3:
  line = line.strip().split()
  if line[2] in NM_l:
    if line[0] in symbol_l:
      print str(line[0])
    else:
      if line[1] in symbol_l:
        print str(line[1])
