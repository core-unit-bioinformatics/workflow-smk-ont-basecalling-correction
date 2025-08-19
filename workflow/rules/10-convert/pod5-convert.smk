import pandas as pd

# Run: snakemake --core 15

sample_paths = pd.read_csv('/home/sebastian/Data/GitLab/project-4mrgn-assembly/data/sample-sheet_4mrgn_test-1.csv')
sample_dict = sample_paths.set_index('sample_name')['file_path'].to_dict()

SAMPLES = list(sample_dict.keys())
input_dirs = sample_dict.values()

# print(input_dirs)

rule all:
    input:
        expand("/home/sebastian/Data/4MRGN/{sample}_pod5", sample=SAMPLES)

rule convert:
    input:
        lambda wildcards: sample_dict[wildcards.sample]     # !!! only activate this script, if path in samplesheet end fith "fast5"
        #fast5 = "/home/sebastian/Data/4MRGN/{sample}_fast5"
    output:
        pod5 = "/home/sebastian/Data/4MRGN/{sample}_pod5"
    resources:
        # cpus = 15,
        # mem_gb = 40,

    shell:
        "pod5 convert fast5 {input.fast5} --output {output.pod5}"