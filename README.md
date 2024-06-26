# hlaminer

HLAminer is a software for HLA predictions from next-generation shotgun (NGS) sequence read data and supports direct read alignment and targeted de novo assembly of sequence reads.

## Overview

## Dependencies

* [hlaminer 1.4](https://github.com/bcgsc/HLAminer/releases/download/v1.4/HLAminer_1-4.tar.gz)
* [bwa 0.7.17](https://github.com/lh3/bwa/releases/download/v0.7.17/bwa-0.7.17.tar.bz2)


## Usage

### Cromwell
```
java -jar cromwell.jar run hlaminer.wdl --inputs inputs.json
```

### Inputs

#### Required workflow parameters:
Parameter|Value|Description
---|---|---
`fastqR1`|File|Input file with the first mate reads.
`fastqR2`|File| Input file with the second mate reads.
`outputFileNamePrefix`|String|Output prefix, customizable. Default is the first file's basename.


#### Optional task parameters:
Parameter|Value|Default|Description
---|---|---|---
`runHlaMiner.jobMemory`|Int|8|Memory allocated to the task.
`runHlaMiner.timeout`|Int|20|Timeout in hours, needed to override imposed limits.
`runHlaMiner.hlaMiner`|String|"$HLAMINER_ROOT/bin/HLAminer.pl"|Path to the HLAminer.pl script
`runHlaMiner.hlaFasta`|String|"$HLAMINER_BWA_INDEX_ROOT/HLA-I_II_GEN.fasta"|Path to the reference fasta file
`runHlaMiner.pDesignationFile`|String|"$HLAMINER_BWA_INDEX_ROOT/HLAminer_v1.4/database/hla_nom_p.txt"|P-designation file, contains details of all HLA Sequences having the same antigen binding domains
`runHlaMiner.modules`|String|"hlaminer/1.4 hlaminer-bwa-index/0.7.17 bwa/0.7.17"|Names and versions of required modules.


### Outputs

Output | Type | Description | Labels
---|---|---|---
`resultFile`|File|Reporting alignment metrics|vidarr_label: resultFile
`logFile`|File|Log file with run info from HLAminer|vidarr_label: logFile


## Commands
This section lists command(s) run by the hlaminer workflow
 
* Running hlaminer
 
hlaminer wraps HLAminer () tool in a cromwell workflow. HLAminer is used to profile the usage of HLA alleles in a sample. The tool works with sequence data of many types (ie. whole genome, whole transcriptome/RNA-Seq, exome), at the group and allele resolution. It supports predictions from a variety of DNA sequencing technologies including those from Illumina, MGI, PacBio and Oxford Nanopore.

The workflow takes fastq files as it's inputs and aligns using HLA-specific indexes using BWA (it is ran as a subworkflow).
Below we have the command used to run HLAminer:
 
```
  set -euo pipefail
 
  bwa aln -e 0 -o 0 HLA_FASTA FASTQ1 > "ALIGNMENT1_SAI"
  bwa aln -e 0 -o 0 HLA_FASTA FASTQ2 > "ALIGNMENT2_SAI"
  bwa sampe -o 1000 HLA_FASTA "ALIGNEMNT1_SAI" "ALIGNMENT2_SAI" FASTQ1 FASTQ2 > "ALIGNMENT_SAM"
  
  HLAMINER -a "ALIGNMENT_SAM" -h HLA_FASTA -p P_DESIGNATION_FILE -l OUTPUT_PREFIX
```
## Support

For support, please file an issue on the [Github project](https://github.com/oicr-gsi) or send an email to gsi@oicr.on.ca .

_Generated with generate-markdown-readme (https://github.com/oicr-gsi/gsi-wdl-tools/)_
