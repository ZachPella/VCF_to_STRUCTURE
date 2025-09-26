#!/bin/bash
#SBATCH --job-name=pgdspider_conversion
#SBATCH --output=pgdspider_%j.out
#SBATCH --error=pgdspider_%j.err
#SBATCH --time=10:00:00
#SBATCH --mem=20G
#SBATCH --partition=batch
#SBATCH --ntasks-per-node=1

# Load the PGDSpider module
module load pgdspider

# Define variables for clarity and easy modification
INPUT_VCF="/work/fauverlab/zachpella/scripts_ticksJune2025_10_scatter/structure_files/iscap_fauver61_gatksplitintervals10_snps_basefilt_maf01_miss0_mac2_bi_pruned.vcf"
OUTPUT_DIR="/work/fauverlab/zachpella/scripts_ticksJune2025_10_scatter/structure_files"
SPID_FILE="${OUTPUT_DIR}/spid.spid"
OUTPUT_FILE="${OUTPUT_DIR}/iscap_fauver61_gatksplitintervals10_snps_basefilt_maf01_miss0_mac2_bi_pruned.str"

# Change to the working directory
cd "${OUTPUT_DIR}"

# Run the PGDSpider command
PGDSpider2-cli \
-Xmx20G \
-inputfile "${INPUT_VCF}" \
-inputformat VCF \
-outputfile "${OUTPUT_FILE}" \
-outputformat STRUCTURE \
-spid "${SPID_FILE}"
