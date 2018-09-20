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
#PBS -l ncpus=4
#PBS -l mem=100gb
#PBS -l walltime=24:00:00

###
## Download required files at http://hgdownload.cse.ucsc.edu/goldenPath/hg19/encodeDCC/wgEncodeRegTfbsClustered/
##
###


# Load required modules
module load java
module load gatk/4.0
module load BWA/0.7.17

echo Running on host `hostname`
echo Time is `date`

# This jobs working directory
echo Working directory is ${PBS_O_WORKDIR}
cd ${PBS_O_WORKDIR}

#create image file for host
#gatk BwaMemIndexImageCreator \
#      -I /g/data1a/jp48/scripts/human_g1k_v37_decoy.fasta \
#      --TMP_DIR ${PBS_O_WORKDIR}

#increase memory requirements to 128 Gb
#create kmer file for host
#bring up the memory requirements for this step
#gatk --java-options "-Xmx128g" PathSeqBuildKmers \
#     --reference /g/data1a/jp48/scripts/human_g1k_v37_decoy.fasta \
#     -O /g/data3/ba08/pathseq/pathseq_host.hss \
#     --kmerMask 15 \
#     --kSize 31 \
#     --bloomFalsePositiveProbability 0.001 \
#     --TMP_DIR ${PBS_O_WORKDIR}


gatk BwaMemIndexImageCreator -I pathseq_microbe_complete.fa --TMP_DIR ${PBS_O_WORKDIR}
