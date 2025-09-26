#!/bin/bash
#SBATCH --job-name=tick_structure_threader_iscap
#SBATCH --partition=batch
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12  # Allocate 12 threads
#SBATCH --mem=50G
#SBATCH --time=7-00:00:00

# load required modules
module load structure-threader/1.3
module load structure/2.3

# set infile and output directory
INFILE=/work/fauverlab/zachpella/scripts_ticksJune2025_10_scatter/structure_files/clean_structure_fixed.str
OUTDIR=/work/fauverlab/zachpella/scripts_ticksJune2025_10_scatter/structure_files/structure_results

# Define the absolute path to mainparams. structure_threader will find extraparams in the same directory.
PARAM_FILE=/work/fauverlab/zachpella/scripts_ticksJune2025_10_scatter/structure_files/mainparams

# Change to working directory (where mainparams and extraparams are located)
cd /work/fauverlab/zachpella/scripts_ticksJune2025_10_scatter/structure_files

# CRITICAL FIX: Replace the problematic -m and -e flags with the documented --params flag
structure_threader \
    run \
    -st /util/opt/anaconda/deployed-conda-envs/packages/structure/envs/structure-2.3.4/bin/structure \
    -K 10 \
    -R 10 \
    -i ${INFILE} \
    -o ${OUTDIR} \
    --params ${PARAM_FILE} \
    -t 12
