# basecalling pod5 files into fastq files
rule basecall:
    input:
        pod5=lambda wc: (
            # if fast5, use converted pod5
            DIR_RES.joinpath(f"converted_pod5/{wc.sample}.pod5")
            if samples_dict[wc.sample]["type"] == "fast5"
            # if pod5, use original path
            else samples_dict[wc.sample]["path"]
        )
    output:
        fastq = DIR_RES.joinpath("basecalled_fastq/{sample}_basecalled.fastq")       # 
    params:
        dorado_bin=lambda wc: (
            DORADO_BIN_OLD if samples_dict[wc.sample]["type"] == "fast5"
            else DORADO_BIN_NEW
        ),
        dorado_model=lambda wc: (
            DORADO_MODEL_OLD if samples_dict[wc.sample]["type"] == "fast5"
            else DORADO_MODEL_NEW
        )
    benchmark:
        DIR_RES.joinpath("benchmarks/{sample}_basecall_benchmark.txt")   # writing needed ressources to a benchmark file
    resources:
        mem_mb = MEM_BASECALL,          # parameter taken from and changable in "config/config.yaml"
        gpu = GPU_BASECALL,             # ^^
        time_hrs = WALLTIME_BASECALL    # ^^
    threads:
        CPU_BASECALL                    # ^^
    run:
        try:
            shell(f"{params.dorado_bin} basecaller --device cuda:all {params.dorado_model} --kit-name {DORADO_KIT} {input.pod5} --trim all --emit-fastq > {output.fastq}")
            log_step(wildcards.sample, "BASECALL", "SUCCESS")
        except Exception as e:
            log_step(wildcards.sample, "BASECALL", "FAILURE", str(e))

# output definition
BASECALL_OUTPUT = expand(
    DIR_RES.joinpath("basecalled_pod5/{sample}_basecalled.fastq"),
    sample=SAMPLES
)