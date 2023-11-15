#!/bin/bash
cd $1

# We have only two output files, .csv file with predictions and
# .log file which contains additional information on low-scoring allele
# predictions not available in the main output file

echo ".csv file:"
for c in *csv;do md5sum $c;done 
echo ".log file:"
find . -name "*.log" | xargs awk '/Gene,HLA Supertype\/Group/{flag=1} flag' | md5sum
