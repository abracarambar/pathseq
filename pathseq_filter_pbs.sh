#!/bin/bash
#PBS -N pathseq_filter
#PBS -j oe
#PBS -m ae
#PBS -M m.gauthier@garvan.org.au
#PBS -q normal
#PBS -P jp48
#PBS -W umask=027
#PBS -e /g/data3/ba08/pathseq/pathseq.${ERRFILE}_${TASK_ID}
#PBS -l ncpus=8
#PBS -l mem=100GB
#PBS -l walltime=36:00:00
#PBS -l jobfs=100GB

module load java
module load gatk/4.0
module load BWA/0.7.17
module load samtools

echo Running on host `hostname`
echo Time is `date`

echo Working directory is ${PBS_O_WORKDIR}
cd ${PBS_O_WORKDIR}

#SAMPLE=TCGA_BA_6873_T
#qsub -v SAMPLE=TCGA_CV_7255_N pathseq_filter_pbs.sh

gatk --java-options "-Xmx100g" PathSeqFilterSpark  \
     --input /g/data1a/jp48/shared/${SAMPLE}.bam \
     --paired-output ${SAMPLE}_paired.bam \
     --unpaired-output ${SAMPLE}_unpaired.bam \
     --min-clipped-read-length 70 \
     --kmer-file pathseq_host.hss \
     --filter-bwa-image /g/data1a/jp48/scripts/human_g1k_v37_decoy.fasta.img \
     --filter-metrics ${SAMPLE}_metrics.txt \
     --is-host-aligned true \
     --TMP_DIR ${PBS_JOBFS}
#     --executor-memory 24G

samtools index ${SAMPLE}_paired.bam
samtools index ${SAMPLE}_unpaired.bam
