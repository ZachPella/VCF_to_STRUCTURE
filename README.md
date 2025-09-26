# VCF_to_STRUCTURE

A population genetics pipeline for converting VCF files to STRUCTURE format and performing population structure analysis on tick genomic data.

## Overview

This pipeline processes genomic variant data through several steps:
1. **Linkage Disequilibrium Pruning** - Removes linked SNPs to create an independent marker set
2. **Format Conversion** - Converts VCF to STRUCTURE format using PGDSpider
3. **Population Structure Analysis** - Runs STRUCTURE analysis using structure-threader

## Prerequisites

### Required Software
- **PLINK2** - For LD pruning and data filtering
- **PGDSpider** - For VCF to STRUCTURE format conversion
- **STRUCTURE** (v2.3+) - Population structure analysis
- **structure-threader** (v1.3+) - Parallel STRUCTURE execution

### System Requirements
- High-performance computing cluster with SLURM scheduler
- Minimum 32GB RAM for large datasets
- Multiple CPU cores recommended (12+ for STRUCTURE analysis)

## File Structure

```
VCF_to_STRUCTURE/
├── scripts/
│   ├── plink.sh           # LD pruning with PLINK2
│   ├── pgd_spider.sh      # VCF to STRUCTURE conversion
│   ├── structure.sh       # STRUCTURE analysis execution
│   ├── mainparams         # STRUCTURE main parameters
│   ├── extraparams        # STRUCTURE advanced parameters
│   └── spid.spid         # PGDSpider configuration
└── README.md
```

## Usage

### Step 1: Linkage Disequilibrium Pruning

Remove linked SNPs to create an independent marker set suitable for population structure analysis.

```bash
sbatch scripts/plink.sh
```

**Parameters:**
- Window size: 50 SNPs
- Step size: 10 SNPs  
- r² threshold: 0.1

**Output:** `*_pruned.vcf` - VCF file with unlinked SNPs

### Step 2: Format Conversion

Convert the pruned VCF file to STRUCTURE format using PGDSpider.

```bash
sbatch scripts/pgd_spider.sh
```

**Configuration:** Uses `spid.spid` configuration file for:
- Diploid genotype handling
- SNP-only data export
- Missing data preservation (coded as -9)

**Output:** `*.str` - STRUCTURE format file

### Step 3: Population Structure Analysis

Run STRUCTURE analysis using structure-threader for parallel execution.

```bash
sbatch scripts/structure.sh
```

**Analysis Settings:**
- K values: 1-10 (number of populations)
- Replicates: 10 per K value
- Burn-in: 50,000 iterations
- MCMC: 200,000 iterations
- Threads: 12 (parallel execution)

## Configuration Files

### mainparams
Core STRUCTURE parameters including:
- **NUMINDS**: 61 (number of individuals)
- **NUMLOCI**: 299,218 (number of loci)
- **BURNIN**: 50,000 (burn-in period)
- **NUMREPS**: 200,000 (MCMC iterations)

### extraparams
Advanced model parameters:
- **FREQSCORR**: 1 (correlated allele frequencies)
- **INFERALPHA**: 1 (infer alpha parameter)
- **MIGRPRIOR**: 0.05 (migration prior)
- **NOADMIX**: 0 (allow admixture)

### spid.spid
PGDSpider conversion settings:
- Input: VCF format
- Output: STRUCTURE format
- Data type: SNP only
- Ploidy: Diploid

## Dataset Information

**Current Dataset:** Tick genomic data (June 2025 cohort)
- **Individuals:** 61 samples
- **Original SNPs:** ~299K loci
- **Filtering:** MAF ≥ 0.01, missingness ≤ 0%, MAC ≥ 2, biallelic only
- **Final dataset:** LD-pruned SNP set

## Output Files

### PLINK Output
- `*.prune.in` - List of independent SNPs retained
- `*_pruned.vcf` - Filtered VCF with unlinked SNPs

### STRUCTURE Results
- `structure_results/` directory containing:
  - Individual K value result files
  - Log-likelihood estimates
  - Ancestry coefficient estimates
  - Parameter estimates

## Resource Requirements

| Step | Time | Memory | CPUs |
|------|------|--------|------|
| PLINK | 10h | 32GB | 1 |
| PGDSpider | 10h | 20GB | 1 |
| STRUCTURE | 7 days | 50GB | 12 |

## Troubleshooting

### Common Issues

1. **Memory errors during PLINK**
   - Increase `--mem` parameter in SLURM script
   - Consider chromosome-by-chromosome processing

2. **PGDSpider conversion fails**
   - Verify VCF file format and completeness
   - Check spid.spid configuration file

3. **STRUCTURE crashes**
   - Ensure mainparams and extraparams are in working directory
   - Verify input file format matches STRUCTURE requirements
   - Check memory allocation for large datasets

### File Format Requirements

- **VCF files:** Must be properly formatted with GT field
- **Missing data:** Should be coded consistently
- **Sample names:** Avoid special characters and spaces

## Citation

If using this pipeline, please cite:
- **PLINK:** Purcell et al. (2007) and Chang et al. (2015)
- **PGDSpider:** Lischer & Excoffier (2012)
- **STRUCTURE:** Pritchard et al. (2000)
- **structure-threader:** Pina-Martins et al. (2017)

## Contact

For questions or issues with this pipeline, please contact the Fauver Lab.

## License

This pipeline is provided as-is for research purposes.
