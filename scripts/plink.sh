#!/bin/bash
#SBATCH --job-name=f2_plink_ld_prune_10scatter
#SBATCH --time=0-10:00:00
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --nodes=1
#SBATCH --mem=32G
#SBATCH --partition=batch

## record relevant job info
START_DIR=$(pwd)
HOST_NAME=$(hostname)
RUN_DATE=$(date)
echo "Starting working directory: ${START_DIR}"
echo "Host name: ${HOST_NAME}"
echo "Run date: ${RUN_DATE}"
printf "\n"

## set working directory and variables for 10-scatter data
BASEDIR=/work/fauverlab/zachpella/scripts_ticksJune2025_10_scatter
WORKDIR=${BASEDIR}/structure_files
VCF_FILE=iscap_fauver61_gatksplitintervals10_snps_basefilt_maf01_miss0_mac2_bi.vcf
OUT_PREFIX=iscap_fauver61_gatksplitintervals10_snps_basefilt_maf01_miss0_mac2_bi

## load modules
module purge
module load plink2

## move into VCF directory
cd ${WORKDIR}

## Step 1: Filter for linkage disequilibrium to create the prune list
# This command generates a list of variants that are in approximate linkage equilibrium.
# The list of included variants is written to a file with the .prune.in extension.
plink2 \
        --vcf ${VCF_FILE} \
        --double-id \
        --allow-extra-chr \
        --set-missing-var-ids @:# \
        --indep-pairwise 50 10 0.1 \
        --out ${OUT_PREFIX}

## Step 2: Prune the VCF and create a new VCF file
# This command uses the --extract flag to keep only the variants
# identified in the previous step. The --recode vcf-iid flag
# outputs the filtered data as a new VCF file.
plink2 \
        --vcf ${VCF_FILE} \
        --double-id \
        --allow-extra-chr \
        --set-missing-var-ids @:# \
        --extract ${OUT_PREFIX}.prune.in \
        --export vcf \
        --out ${OUT_PREFIX}_pruned

echo "✓ PLINK LD pruning completed."
echo "  LD pruning list: ${OUT_PREFIX}.prune.in"
echo "  New pruned VCF: ${OUT_PREFIX}_pruned.vcf"
echo "Completed at: $(date)"
printf "\n"
