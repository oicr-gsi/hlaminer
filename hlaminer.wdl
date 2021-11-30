version 1.0

import "imports/pull_bwaMem.wdl" as bwaMem

# ================================================================================
# Workflow accepts two fastq files for paired-end sequencing, with R1 and R2 reads
# ================================================================================
workflow hlaminer {
input {
  File fastqR1 
  File fastqR2
  String outputFileNamePrefix = ""
}

String sampleID = if outputFileNamePrefix=="" then basename(fastqR1, ".fastq.gz") else outputFileNamePrefix

call bwaMem.bwaMem {
  input:
    fastqR1 = fastqR1,
    fastqR2 = fastqR2,
    outputFileNamePrefix = sampleID
}

call runHlaMiner {
  input:
    inputBam = bwaMem.bwaMemBam,
    outputFileNamePrefix = outputFileNamePrefix
}

parameter_meta {
  fastqR1: "Input file with the first mate reads."
  fastqR2: " Input file with the second mate reads."
  outputFileNamePrefix: "Output prefix, customizable. Default is the first file's basename."
}

meta {
    author: "Peter Ruzanov"
    email: "peter.ruzanov@oicr.on.ca"
    description: "HLAminer is a software for HLA predictions from next-generation shotgun (NGS) sequence read data and supports direct read alignment and targeted de novo assembly of sequence reads."
    dependencies: [
      {
        name: "hlaminer/1.4",
        url: "https://github.com/bcgsc/HLAminer/releases/download/v1.4/HLAminer_1-4.tar.gz"
      },
      {
        name: "bwa/0.7.12",
        url: "https://github.com/lh3/bwa/archive/0.7.12.tar.gz"
      },
      {
        name: "samtools/1.9",
        url: "https://github.com/samtools/samtools/archive/0.1.19.tar.gz"
      }
    ]
    output_meta: {
      resultFile: "Reporting alignment metrics",
      logFile: "Log file with run info from HLAminer"
    }
}

output {
  File resultFile = runHlaMiner.resultFile
  File logFile = runHlaMiner.logFile
}
}


# ====================
#    HLAminer
# ====================
task runHlaMiner {
input {
  Int  jobMemory = 8
  Int  timeout   = 20
  File inputBam
  String hlaMiner = "$HLAMINER_ROOT/bin/HLAminer.pl"
  String hlaFasta = "$HLAMINER_BWA_INDEX_ROOT/HLA-I_II_GEN.fasta"
  String pDesignationFile = "$HLAMINER_BWA_INDEX_ROOT/HLAminer_v1.4/database/hla_nom_p.txt"
  String outputFileNamePrefix
  String modules = "hlaminer/1.4 hlaminer-bwa-index/0.7.17 samtools/1.9"
}

command <<<
 set -euo pipefail
 samtools view -h ~{inputBam} | ~{hlaMiner} -a stream -h ~{hlaFasta} -p ~{pDesignationFile} -l ~{outputFileNamePrefix}
>>>

parameter_meta {
 inputBam: "Input BWA bam file"
 hlaMiner: "Path to the HLAminer.pl script"
 hlaFasta: "Path to the reference fasta file"
 pDesignationFile: "P-designation file, contains details of all HLA Sequences having the same antigen binding domains"
 outputFileNamePrefix: "Output prefix for the result file" 
 jobMemory: "Memory allocated to the task."
 modules: "Names and versions of required modules."
 timeout: "Timeout in hours, needed to override imposed limits."
}

runtime {
  memory:  "~{jobMemory} GB"
  modules: "~{modules}"
  timeout: "~{timeout}"
}

output {
  File resultFile = "HLAminer_HPRA_~{outputFileNamePrefix}.csv"
  File logFile = "HLAminer_HPRA_~{outputFileNamePrefix}.log"
}
}

