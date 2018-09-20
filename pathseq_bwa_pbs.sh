#!/bin/bash

#PBS -N pathseq_bwa
#PBS -j oe
#PBS -m ae
#PBS -M m.gauthier@garvan.org.au
#PBS -q normal
#PBS -P jp48
#PBS -W umask=027
#PBS -e /g/data3/ba08/pathseq/pathseq_tutorial.${ERRFILE}_${TASK_ID}
#PBS -l ncpus=12
#PBS -l mem=36gb
#PBS -l walltime=48:00:00


################
##Overview
##Align reads to a microbe reference using BWA-MEM and Spark. Second step in the PathSeq pipeline.
##See PathSeqPipelineSpark for an overview of the PathSeq pipeline.

##This is a specialized version of BwaSpark designed for the PathSeq pipeline. The main difference is that alignments with SAM bit flag 0x100 or 0x800 (indicating secondary or supplementary alignment) are omitted in the output.

##Inputs
##Unaligned queryname-sorted BAM file containing only paired reads (paired-end reads with mates)
##Unaligned BAM file containing only unpaired reads (paired-end reads without mates and/or single-end reads)
##*Microbe reference BWA-MEM index image generated using BwaMemIndexImageCreator
##*Indexed microbe reference FASTA file
##*A standard microbe reference is available in the GATK Resource Bundle.
##Output
##Aligned BAM file containing the paired reads (paired-end reads with mates)
##Aligned BAM file containing the unpaired reads (paired-end reads without mates and/or single-end reads)

##To do:reduce size of partition to speed up job??
#run on NCI using qsub -v SAMPLE=TCGA_BA_6873_T pathseq_bwa_pbs.sh 

module load java
module load gatk/4.0
module load BWA/0.7.17
module load samtools

echo Running on host `hostname`
echo Time is `date`

echo Working directory is ${PBS_O_WORKDIR}
cd ${PBS_O_WORKDIR}

#gatk --java-options "-Xmx24g"  PathSeqBwaSpark  \
#     --paired-input ${SAMPLE}_paired.bam \
#     --unpaired-input ${SAMPLE}_unpaired.bam \
#     --paired-output ${SAMPLE}_bwa_paired.bam \
#     --unpaired-output ${SAMPLE}_bwa_unpaired.bam \
#     --microbe-fasta pathseq_microbe_complete.fa \
#     --microbe-bwa-image pathseq_microbe_complete.fa.img \
#     --TMP_DIR ${PBS_O_WORKDIR}


#samtools index ${SAMPLE}_bwa_paired.bam
#samtools index ${SAMPLE}_unpaired.bam

gatk --java-options "-Xmx24g" PathSeqScoreSpark  \
     --paired-input ${SAMPLE}_bwa_paired.bam \
     --unpaired-input /g/data3/ba08/pathseq/${SAMPLE}_bwa_unpaired.bam \
     --taxonomy-file /g/data3/ba08/pathseq/pathseq_taxonomy.db \
     --scores-output ${SAMPLE}_scores.txt \
     --output ${SAMPLE}_output_reads.bam \
     --min-score-identity 0.90 \
     --identity-margin 0.02
     --TMP_DIR ${PBS_O_WORKDIR}
