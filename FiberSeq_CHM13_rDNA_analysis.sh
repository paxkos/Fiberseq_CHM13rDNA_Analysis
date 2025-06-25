#!/bin/bash
#SBATCH --job-name=45S_FibSeq     # Job name
#SBATCH --cpus-per-task=24              #Cores requested
#SBATCH --nodes=1                    # Run all processes on a single node
#SBATCH --ntasks=1                   # Run a single task
#SBATCH --mem=100gb                    # Job memory request
#SBATCH --time=10-00:00:00              # Time limit hrs:min:sec

ml samtools
ml minimap2

#ensure fibertools environment is loaded

#obtain kinetics information for the data and generate a consensus sequence bam file
ccs --report-file kinetics_report.txt --hifi-kinetics m54329U_210418_025202.subreads.bam ccs_CHM13.bam

ft predict-m6a ccs_CHM13.bam m6a_CHM13.bam

samtools fastq  -T "*" m6a_CHM13.bam | minimap2 -a -x map-pb -y RefLong/KY962518double.fa -o m6a_CHM13_doublealn.sam -t 8 -

#convert sam to an aligned bam file
samtools view -b m6a_CHM13_doublealn.sam > m6a_CHM13_doublealn.bam

#sorted the now aligned bam file in the aim of creating a coverage file to read into R and into IGV
samtools sort -o m6a_CHM13_doublealn_sorted.bam m6a_CHM13_doublealn.bam

samtools index m6a_CHM13_doublealn_sorted.bam

# to read into R you must remove hard clipping and convert to a bed
samtools view -b -F 2304 m6a_CHM13_doublealn_sorted.bam > noHC_m6a_CHM13_doublealn_sorted.bam

ft extract noHC_m6a_CHM13_doublealn_sorted.bam --m6a noHC_m6a_CHM13_aln_sorted.bed.gz

