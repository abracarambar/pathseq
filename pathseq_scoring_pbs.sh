#!/bin/bash

### Job name
#PBS -N pathseq_testing

### Join queuing system output and error files into a single output file
#PBS -j oe

### Send email to user when job ends or aborts
#PBS -m ae

### email address for user
#PBS -M m.gauthier@garvan.org.au

### Queue name that job is submitted to
#PBS -q normal

### Provide project to be billed
#PBS -P jp48

### Make the data readable to everyone in the group
#PBS -W umask=027

### Set out (Use job ID so it's unique)
#PBS -e /g/data3/ba08/pathseq/pathseq_tutorial.${ERRFILE}_${TASK_ID}

### Request nodes, memory, walltime. NB THESE ARE REQUIRED.
##### run, change these entries
#PBS -l ncpus=1
#PBS -l mem=8Gb
#PBS -l walltime=1:00:00

# Load required modules
module load java
module load gatk/4.0
module load BWA/0.7.17
module load samtools

#https://software.broadinstitute.org/gatk/documentation/tooldocs/4.0.1.1/org_broadinstitute_hellbender_tools_spark_pathseq_PathSeqScoreSpark.php

echo Running on host `hostname`
echo Time is `date`

# This jobs working directory
echo Working directory is ${PBS_O_WORKDIR}
cd ${PBS_O_WORKDIR}
SAMPLE=184577_T


#samtools index ${SAMPLE}_bwa_paired.bam
#samtools index ${SAMPLE}_unpaired.bam

#gatk PathSeqScoreSpark  \
#   --paired-input /g/data3/ba08/pathseq/${SAMPLE}_bwa_paired.bam \
#   --unpaired-input /g/data3/ba08/pathseq/${SAMPLE}_unpaired.bam \
#   --taxonomy-file /g/data3/ba08/pathseq/pathseq_taxonomy.db \
#   --scores-output /g/data3/ba08/pathseq/scores.txt \
#   --output /g/data3/ba08/pathseq/output_reads.bam \
#   --min-score-identity 0.90 \
#   --identity-margin 0.02


gatk --java-options "-Xmx8g" PathSeqScoreSpark  \
     --paired-input ${SAMPLE}_bwa_paired.bam \
     --unpaired-input /g/data3/ba08/pathseq/${SAMPLE}_bwa_unpaired.bam \
     --taxonomy-file /g/data3/ba08/pathseq/pathseq_taxonomy.db \
     --scores-output ${SAMPLE}_scores.txt \
     --output ${SAMPLE}_output_reads.bam \
     --min-score-identity 0.90 \
     --identity-margin 0.02 \
     --TMP_DIR ${PBS_O_WORKDIR}
