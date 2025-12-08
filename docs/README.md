# Documentation for Snakemake workflow NAME HERE

This workflow (re)-basecalls and corrects Oxford Nanopore Technologies sequencing data.

## Required input data

- Oxford Nanopore Technologies sequencing data for the samples that should be (re-)basecalled and corrected. Either fast5 oder pod5 files are possible. fast5 files will automatically be converted to pod5 files before the basecalling.
- Please insert the following information into the config file at the mentioned position (workflow-smk-ont-basecalling-correction/config/config.yaml). 
    - Tab-separated sample sheet containing the coulumn headers "sample_name" and "file_path", as well as one entry of data per line in the format "[SAMPLE_ID]   [/PATH/TO/DATA/FILE.ENDING]", one sample per line. The path accepts either fast5 files, pod5 files, or directories containing one of these formats.
    - The kit used for sequencing (e.g. "SQK-NBD114-24")
- The needed versions of Dorade and it's models (for basecalling and correction), as well as the pod5 tool (for fast5 to pod5 conversion) and gzip are either downloaded and installed during the process or provided via a conda environment (this needs an internet connection!)

- The tool is run from within the directory "workflow-smk-ont-basecalling-correction" using: 
```
snakemake -p -d ../wd/ --configfiles config/config.yaml --use-conda --resources mem_mb=131072 --resources gpu=4 --resources time_hrs 71:59 --cores 24 run_all
```
- The mentioned resource numbers are the recommended minumum requirements to run this workflow and can be upscaled however much the user desires.

## Produced output data

- Converted pod5 files, if fast5 input was provided by the user. See path:  /wd/results/converted_pod5/[SAMPLE_ID].pod5
- Basecalled sequencing data, before the correction step. See path:         /wd/results/basecalled_pod5/[SAMPLE_ID]_basecalled.fastq
- Basecalled AND corrected sequencing data. See path:                       /wd/results/corrected_fasta/[SAMPLE_ID]_corrected.fasta
- A log file, listing which pipeline steps succeded. See path:              /wd/log/log-file_ont-basecalling-correction.log
- benchmark files for each sample, listing used resources. See path:        /wd/log/[SAMPLE_ID]_correct_benchmark.txt


## User documentation

All standard workflows of the CUBI implement the same user
interface (or at least aim for a highly similar interface).
Hence, before [executing the workflow](concepts/running.md),
we strongly recommend reading the through the documentation
that explains how we help you to keep track of your analysis
results; we refer to this concept as
[**"file accounting"**](concepts/accounting.md). This feature
of standard CUBI workflows enables the pipeline to auto-
matically create a so-called [**"manifest"** file](concepts/accounting.md)
for your analysis run.

In case of questions, please open a GitHub issue in the repository
of the workflow you are trying to execute.

**Note to developers**: the above is the templated user documentation;
make sure to update or link to additional documentation, e.g.
describing workflow-specific parameters etc.

## Developer documentation

Besides reading the user documentation, CUBI developers find more
information regarding standadized workflow development in the
[developer notes](concepts/developing.md). Please keep in mind
to always cross-link that information with the guidelines
published in the
[CUBI knowledge base](https://github.com/core-unit-bioinformatics/knowledge-base/wiki/).

Please raise any issues with these guidelines "close to the code",
i.e., either open an issue in the
[knowledge base repo](https://github.com/core-unit-bioinformatics/knowledge-base)
or in the affected repo for more specific cases.
