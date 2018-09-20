#!/bin/bash
### Job name
#PBS -N pathseq_scoring
#PBS -j oe
#PBS -m ae
#PBS -M m.gauthier@garvan.org.au
#PBS -q normal
#PBS -P jp48
#PBS -W umask=027
#PBS -e /g/data3/ba08/pathseq/pathseq_tutorial.${ERRFILE}_${TASK_ID}
#PBS -l ncpus=1
#PBS -l mem=8Gb
#PBS -l walltime=1:00:00

module load java
module load gatk/4.0
module load BWA/0.7.17
module load samtools

#https://software.broadinstitute.org/gatk/documentation/tooldocs/4.0.1.1/org_broadinstitute_hellbender_tools_spark_pathseq_PathSeqScoreSpark.php

echo Running on host `hostname`
echo Time is `date`

echo Working directory is ${PBS_O_WORKDIR}
cd ${PBS_O_WORKDIR}

#Either specify name in script or on command line 
#qsub -v SAMPLE=TCGA_CV_7255_N pathseq_scoring_pbs.sh 
#SAMPLE=184577_T

gatk --java-options "-Xmx8g" PathSeqScoreSpark  \
     --paired-input ${SAMPLE}_bwa_paired.bam \
     --unpaired-input /g/data3/ba08/pathseq/${SAMPLE}_bwa_unpaired.bam \
     --taxonomy-file /g/data3/ba08/pathseq/pathseq_taxonomy.db \
     --scores-output ${SAMPLE}_scores.txt \
     --output ${SAMPLE}_output_reads.bam \
     --min-score-identity 0.90 \
     --identity-margin 0.02 \
     --TMP_DIR ${PBS_O_WORKDIR}
