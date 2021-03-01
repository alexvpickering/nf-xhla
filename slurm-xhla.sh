#!/bin/bash
#SBATCH -c 6                               # Request one core
#SBATCH -N 1                               # Request one node
#SBATCH -t 0-23:59                         # Runtime in D-HH:MM format
#SBATCH -p medium                          # Partition to run in
#SBATCH --mem=10G                           # Memory total in MB (for all cores)
#SBATCH -o xhla/hostname_%j.out            # File to which STDOUT will be written, including job ID
#SBATCH -e xhla/hostname_%j.err            # File to which STDERR will be written, including job ID
#SBATCH --mail-type=FAIL                   # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=alex_pickering@hms.harvard.edu   # Email to which notifications will be sent

module load gcc/6.2.0 samtools/1.3.1 bwa/0.7.15 bedtools/2.26.0 R/4.0.1 java/jdk-1.8u112
conda activate XHLA

# get PID from command line
PID="$1"
data_dir="/n/scratch3/users/a/ap491/F20FTSUSAT1396_HUMooaR/Reads/Clean"
ref_path="/n/scratch3/users/a/ap491/hg38/Homo_sapiens_assembly38.fasta"
run_path="/home/ap491/HLA/bin/run.py"

cd /n/scratch3/users/a/ap491/nf-xhla

nextflow run main.nf \
 --reads "$data_dir/$PID/PID${PID}_{1,2}.fq.gz" \
  --samplename $PID \
   --reference $ref_path \
    --run_path $run_path