# Define the full path to the STRUCTURE results directory for "just our data"
RESULTS_DIR="/work/fauverlab/zachpella/structure_no_threader_but_k10_r10_our_data_only/structure_files/structure_results"

# Define the descriptive output directory name
OUTPUT_DIR="./harvester_output_just_our_data"

python structureHarvester.py \
--dir=$RESULTS_DIR \
--out=$OUTPUT_DIR \
--evanno \
--clumpp
