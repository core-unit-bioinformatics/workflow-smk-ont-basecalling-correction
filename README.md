# Template for developing Snakemake workflows

Basecalling and correctopn of ONT sequencing data.

## Required software environment

Standardized workflows are designed with minimal assumptions about the local software environment.

In essence, the following should suffice to get started:
1. Linux OS: Debian, Ubuntu, CentOS, Rocky and related distributions should be fine
2. Python3: modern is likely better (3.8 or 3.9)
3. Conda (or mamba): for automatic setup of all software dependencies
    - Note that you can run the workflow w/o Conda, but then all tools listed under `workflow/envs/*.yaml` [not `dev_env.yaml`] need to be in your `$PATH`.

For a detailed setup guide, please refer to [the workflow documentation](docs/README.md).

**Internal (template) remark**: adapt the above if the workflow deployment has additional requirements (e.g., Singularity).

## Required input data

- ONT sequencing data for the samples that should be basecalled and corrected.
- Comma-separated samplesheet containing sample ID and path to the sequencing data.
- Dorado, as well as it's basecalling and correction models fitting your type of data.
- More details in [the workflow documentation](docs/README.md).

## Produced output data

- To pod5 converted sequencing data (if fast5 data was provided)
- Basecalled sequencing data.
- Corrected sequencing data.
- More details in [the workflow documentation](docs/README.md).

# Citation

If not indicated otherwise above, please follow [these instructions](CITATION.md) to cite this repository in your own work.
