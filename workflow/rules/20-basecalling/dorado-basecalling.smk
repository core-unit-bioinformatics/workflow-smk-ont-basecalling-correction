import pandas as pd

# Run: snakemake --core 15

sample_paths = pd.read_csv('/home/sebastian/Data/GitLab/project-4mrgn-assembly/data/sample-sheet_4mrgn_test-1.csv')
sample_dict = sample_paths.set_index('sample_name')['file_path'].to_dict()

SAMPLES = list(sample_dict.keys())
input_dirs = sample_dict.values()

print(input_dirs)

rule all:
    input:
        expand("/home/sebastian/Data/4MRGN/results_basecalling/{sample}_basecalled.fastq", sample=SAMPLES)

rule basecalling:
    input:
        pod5_1 = lambda wildcards: sample_dict[wildcards.sample]  # !!! if pod5 in samplesheet, use this
        pod5_2 = "/home/sebastian/Data/4MRGN/{sample}_pod5"       # !!! if pod5 converted from fast5, use this
    output:
        "/home/sebastian/Data/4MRGN/results_basecalling/{sample}_basecalled.fastq"
    params:
        model = "sup",
        # model = "/home/sebastian/Tools/dorado-0.9.6-linux-x64/models/models/dna_r10.4.1_e8.2_400bps_sup@v4.1.0",
        kit = "SQK-NBD114-24"
    resources:
        cpus = 15,
        mem_gb = 40,
        # gpus = '8',
        # walltime = '08:00:00'
    shell:
        "/home/sebastian/Tools/dorado-0.9.6-linux-x64/bin/dorado basecaller --device cuda:0 {params.model} --kit-name {params.kit} {input.pod5} --trim 'all' --emit-fastq > {output}"
        # "/home/sebastian/Tools/dorado-0.9.6-linux-x64/bin/dorado basecaller --device cuda:0 /home/sebastian/Tools/dorado-0.9.6-linux-x64/models/dna_r10.4.1_e8.2_400bps_sup@v4.1.0 --kit-name SQK-NBD114-24 /home/sebastian/Data/4MRGN/output.pod5 --trim 'all' --emit-fastq > /home/sebastian/Data/4MRGN/MRGN_1_pod5_barcode01_test_basecalled.fastq"

