#!/bin/bash
#SBATCH CCS HiFi Kinetics
#SBATCH --nodes = 1
#SBATCH --mem=100G
#SBATCH --72:00:00
#SBATCH --output=CCS_HiFiKinetics.out
#SBATCH --error=CCS_HIFIKinetics.err

conda activate ccs

ccs --report-file kinetics_report.txt --hifi-kinetics m54329U_210418_025202.subreads.bam ccs_CHM13.bam
