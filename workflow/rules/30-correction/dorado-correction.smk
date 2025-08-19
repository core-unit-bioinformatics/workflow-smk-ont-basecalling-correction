import pandas as pd

# Run: snakemake --core 15

sample_paths = pd.read_csv('/home/sebastian/Data/GitLab/project-4mrgn-assembly/data/sample-sheet_4mrgn_test-1.csv')
sample_dict = sample_paths.set_index('sample_name')['file_path'].to_dict()

SAMPLES = list(sample_dict.keys())
input_dirs = sample_dict.values()

# print(input_dirs)

rule all:
    input:
        expand("/home/sebastian/Data/4MRGN/results_correction/{sample}_corrected_reads.fasta", sample=SAMPLES)

rule correction:
    input:
        reads = "/home/sebastian/Data/4MRGN/results_basecalling/{sample}_basecalled.fastq",
        model = "/home/sebastian/Tools/dorado-0.9.6-linux-x64/models/herro-v1"
    output:
        "/home/sebastian/Data/4MRGN/results_correction/{sample}_corrected_reads.fasta"
    resources:
        cpus = 15,
        mem_gb = 40,
        # gpus = '2',
        # walltime = '08:00:00'
    shell:
        "/home/sebastian/Tools/dorado-0.9.6-linux-x64/bin/dorado correct -m {input.model} {input.reads} > {output}"
        # "/home/sebastian/Tools/dorado-0.9.6-linux-x64/bin/dorado correct --device cuda:0 -m /home/sebastian/Tools/dorado-0.9.6-linux-x64/models/herro-v1 /home/sebastian/Data/4MRGN/MRGN_1_pod5_barcode01_test_basecalled.fastq > /home/sebastian/Data/4MRGN/MRGN_1_pod5_barcode01_test_corrected.fasta"

