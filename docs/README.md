# Documentation for Snakemake workflow "smk-ont-basecalling-correction"

This workflow (re)-basecalls and corrects Oxford Nanopore Technologies sequencing data.

## Required input data

- Oxford Nanopore Technologies sequencing data for the samples that should be (re-)basecalled and corrected. Either fast5 oder pod5 files are possible. fast5 files will automatically be converted to pod5 files before the basecalling.
- Please insert the following information into the config file at the mentioned position (workflow-smk-ont-basecalling-correction/config/config.yaml). 
    - The path to a tab-separated sample sheet containing the coulumn headers "sample_name" and "file_path", as well as one entry of data per line in the format `[SAMPLE_ID]   [/PATH/TO/DATA/FILE.ENDING]` or `[SAMPLE_ID]   [/PATH/TO/DATA/]`, one sample per line (The sample sheet paths accept either fast5 files, pod5 files, or directories containing one of these formats).
    - The kit used for sequencing (e.g. "SQK-NBD114-24")
    - The needed versions of Dorado and it's models (for basecalling and correction), should others than the provided ones be desired. 
- IMPORTANT: The download of dorado, the models, as well as the creation of conda environments needs an internet connection!

## Running the workflow

1. The workflow envoironment needs to be set up according to [this tutorial](concepts/running.md). If no internet connection is available, the corresponding conda environment needs to be creates somewhere else and moved to the mentioned loaction via `conda-pack`.
2. Activate the conda environment `conda activate ../exec_env/`
3. option a: If an internet connection is available the pipeline will install dorado, models and the needed conda environments on its own.
   
The workflow can be run like this from within the directory `workflow-smk-ont-basecalling-correction`.
- run twice in dryrun mode before normal execution:
```
snakemake -p -d ../wd/ --configfiles config/config.yaml --use-conda --resources mem_mb=256000 --resources gpu=4 --resources time_hrs 71:59 --cores 24 run_all --dryrun
```
 - run normally:
```
snakemake -p -d ../wd/ --configfiles config/config.yaml --use-conda --resources mem_mb=256000 --resources gpu=4 --resources time_hrs 71:59 --cores 24 run_all
```
3. option b: if NO internet connection is available:
    - The Dorado binaries and models mentioned in the config file (workflow-smk-ont-basecalling-correction/config/config.yaml) need to be downloaded somewhere else and moved to the following directories (which were created my the init.py script mentioned in [this tutorial](concepts/running.md)). The paths should then be `project_dir/wd/dorado/binaries/dorado-VERSION/` (for both binaries) and `project_dir/wd/dorado/models/MODEL-NAME/` (for all three models). Please put the correct name of the binary/model directories into the config file at the mentioned position.
    - The container directory (found in the main workflow folder) needs to be moved into `project_dir/wd/.`. Additionally, the usage of conda needs to be swapped with the usage of the just muved container in the corresponding modules.
        - workflow-smk-ont-basecalling-correction/workflow/rules/10-convert/30_convert_pod5.smk: comment out line 7 and 8, comment in line 9 and 10
        - workflow-smk-ont-basecalling-correction/workflow/rules/30-correction/30_correct.smk: comment out line 9 and 10, comment in line 11 and 12

The workflow then can be run like this from within the directory `workflow-smk-ont-basecalling-correction/`.
- run twice in dryrun mode before normal execution:
```
snakemake -p -d ../wd/ --configfiles config/config.yaml --use-apptainer --resources mem_mb=256000 --resources gpu=4 --resources time_hrs 71:59 --cores 24 run_all --apptainer-args "--nv --bind /path/to/sample/data/from/the/samplesheet/" --dryrun
```
- run normally:
```
snakemake -p -d ../wd/ --configfiles config/config.yaml --use-apptainer --resources mem_mb=256000 --resources gpu=4 --resources time_hrs 71:59 --cores 24 run_all --apptainer-args "--nv --bind /path/to/sample/data/from/the/samplesheet/"
```
----
- The resource numbers depicted in the command calls are the current recommended minumum requirements to run this workflow and can be upscaled however much the user desires.
- Somewhen in the future CUBI's snakemake-utils tool might be available to create a snakemake profile for local- or cluster-usage. At that point, the current instructions may change accordingly.


## Produced output data

- Converted pod5 files, if fast5 input was provided by the user. See path:  /wd/results/converted_pod5/[SAMPLE_ID].pod5
    (these will again be removed during the workflow, since they are not needed in the end)
- Basecalled sequencing data, before the correction step. See path:         /wd/results/basecalled_pod5/[SAMPLE_ID]_basecalled.fastq
- Basecalled AND corrected sequencing data. See path:                       /wd/results/corrected_fasta/[SAMPLE_ID]_corrected.fasta
    (these will again be removed during the workflow, since they are not needed in the end)
- The zipped version of the above file. See path:                           /wd/results/corrected_fasta/[SAMPLE_ID]_corrected.fasta.gz
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
