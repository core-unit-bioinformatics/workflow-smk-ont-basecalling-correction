# correcting basecalled fastq files into fasta files
rule correct_reads:
    input:
        fastq = DIR_RES.joinpath("basecalled_pod5/{sample}_basecalled.fastq"),  
        model = DORADO_CORRECTION_MODEL     # parameter taken from and changable in "config/config.yaml"
    output:
        fasta = DIR_RES.joinpath("corrected_fasta/{sample}_corrected.fasta")
    conda:
        DIR_ENVS.joinpath("dorado.yaml")      # activating conda environment needed for this module
    benchmark:
        DIR_RES.joinpath("benchmarks/{sample}_correct_benchmark.txt")   # writing needed ressources to a benchmark file
    resources:
        mem_mb = MEM_CORRECT,       # parameter taken from and changable in "config/config.yaml"
    #    gpu = GPU_CORRECT           # ^^
    threads:
        CPU_CORRECT                 # ^^
    run:
        try:
            # shell(f"{DORADO_BIN} correct --device cuda:all -m {input.model} {input.fastq} --index-size 4G > {output.fasta}")
            shell(f"{DORADO_BIN} correct --device cuda:all -m {input.model} {input.fastq} --verbose > {output.fasta}")
            # shell(f"{DORADO_BIN} correct --device CPU -m {input.model} {input.fastq} > {output.fasta}")
            log_step(wildcards.sample, "CORRECT", "SUCCESS")
        except Exception as e:
            log_step(wildcards.sample, "CORRECT", "FAILURE", str(e))

# output definition
CORRECT_OUTPUT = expand(
    DIR_RES.joinpath("corrected_fasta/{sample}_corrected.fasta"),
    sample=SAMPLES
)