# hlaminer

HLAminer is a software for HLA predictions from next-generation shotgun (NGS) sequence read data and supports direct read alignment and targeted de novo assembly of sequence reads.

## Overview

## Dependencies

* [hlaminer 1.4](https://github.com/bcgsc/HLAminer/releases/download/v1.4/HLAminer_1-4.tar.gz)
* [bwa 0.7.12](https://github.com/lh3/bwa/archive/0.7.12.tar.gz)
* [samtools 1.9](https://github.com/samtools/samtools/archive/0.1.19.tar.gz)


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
`bwaMem.runBwaMem_bwaRef`|String|The reference genome to align the sample with by BWA
`bwaMem.runBwaMem_modules`|String|Required environment modules
`bwaMem.readGroups`|String|Complete read group header line


#### Optional workflow parameters:
Parameter|Value|Default|Description
---|---|---|---
`outputFileNamePrefix`|String|""|Output prefix, customizable. Default is the first file's basename.


#### Optional task parameters:
Parameter|Value|Default|Description
---|---|---|---
`bwaMem.adapterTrimmingLog_timeout`|Int|48|Hours before task timeout
`bwaMem.adapterTrimmingLog_jobMemory`|Int|12|Memory allocated indexing job
`bwaMem.indexBam_timeout`|Int|48|Hours before task timeout
`bwaMem.indexBam_modules`|String|"samtools/1.9"|Modules for running indexing job
`bwaMem.indexBam_jobMemory`|Int|12|Memory allocated indexing job
`bwaMem.bamMerge_timeout`|Int|72|Hours before task timeout
`bwaMem.bamMerge_modules`|String|"samtools/1.9"|Required environment modules
`bwaMem.bamMerge_jobMemory`|Int|32|Memory allocated indexing job
`bwaMem.runBwaMem_timeout`|Int|96|Hours before task timeout
`bwaMem.runBwaMem_jobMemory`|Int|32|Memory allocated for this job
`bwaMem.runBwaMem_threads`|Int|8|Requested CPU threads
`bwaMem.runBwaMem_addParam`|String?|None|Additional BWA parameters
`bwaMem.adapterTrimming_timeout`|Int|48|Hours before task timeout
`bwaMem.adapterTrimming_jobMemory`|Int|16|Memory allocated for this job
`bwaMem.adapterTrimming_addParam`|String?|None|Additional cutadapt parameters
`bwaMem.adapterTrimming_modules`|String|"cutadapt/1.8.3"|Required environment modules
`bwaMem.slicerR2_timeout`|Int|48|Hours before task timeout
`bwaMem.slicerR2_jobMemory`|Int|16|Memory allocated for this job
`bwaMem.slicerR2_modules`|String|"slicer/0.3.0"|Required environment modules
`bwaMem.slicerR1_timeout`|Int|48|Hours before task timeout
`bwaMem.slicerR1_jobMemory`|Int|16|Memory allocated for this job
`bwaMem.slicerR1_modules`|String|"slicer/0.3.0"|Required environment modules
`bwaMem.countChunkSize_timeout`|Int|48|Hours before task timeout
`bwaMem.countChunkSize_jobMemory`|Int|16|Memory allocated for this job
`bwaMem.numChunk`|Int|1|number of chunks to split fastq file [1, no splitting]
`bwaMem.doTrim`|Boolean|true|if true, adapters will be trimmed before alignment
`bwaMem.trimMinLength`|Int|1|minimum length of reads to keep [1]
`bwaMem.trimMinQuality`|Int|0|minimum quality of read ends to keep [0]
`bwaMem.adapter1`|String|"AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC"|adapter sequence to trim from read 1 [AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC]
`bwaMem.adapter2`|String|"AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT"|adapter sequence to trim from read 2 [AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT]
`runHlaMiner.jobMemory`|Int|8|Memory allocated to the task.
`runHlaMiner.timeout`|Int|20|Timeout in hours, needed to override imposed limits.
`runHlaMiner.hlaMiner`|String|"$HLAMINER_ROOT/bin/HLAminer.pl"|Path to the HLAminer.pl script
`runHlaMiner.hlaFasta`|String|"$HLAMINER_BWA_INDEX_ROOT/HLA-I_II_GEN.fasta"|Path to the reference fasta file
`runHlaMiner.pDesignationFile`|String|"$HLAMINER_BWA_INDEX_ROOT/HLAminer_v1.4/database/hla_nom_p.txt"|P-designation file, contains details of all HLA Sequences having the same antigen binding domains
`runHlaMiner.modules`|String|"hlaminer/1.4 hlaminer-bwa-index/0.7.17 samtools/1.9"|Names and versions of required modules.


### Outputs

Output | Type | Description
---|---|---
`resultFile`|File|Reporting alignment metrics
`logFile`|File|Log file with run info from HLAminer


## Commands
This section lists commands run by HLAminer workflow
 
* Running hlaminer workflow
 
hlaminer wraps HLAminer () tool in a cromwell workflow. HLAminer is used to profile the usage of HLA alleles in a sample. The tool works with sequence data of many types (ie. whole genome, whole transcriptome/RNA-Seq, exome), at the group and allele resolution. It supports predictions from a variety of DNA sequencing technologies including those from Illumina, MGI, PacBio and Oxford Nanopore.
 
The workflow takes fastq files as it's inputs and aligns using HLA-specific indexes using BWA (it is ran as a subworkflow).
Below we have the command used to run HLAminer:
 
 
```
  set -euo pipefail
  samtools view -h INPUT_BAM | HLAMINER -a stream -h HLA_FASTA -p P_DESIGNATION_FILE -l OUTPUT_PREFIX
 
```
## Support

For support, please file an issue on the [Github project](https://github.com/oicr-gsi) or send an email to gsi@oicr.on.ca .

_Generated with generate-markdown-readme (https://github.com/oicr-gsi/gsi-wdl-tools/)_
