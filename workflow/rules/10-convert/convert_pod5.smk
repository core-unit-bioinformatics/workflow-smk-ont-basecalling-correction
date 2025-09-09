# converting fast5 files or a directory of fast5 files into pod5 files
rule convert_to_pod5:
    input:
        fast5 = lambda wc: samples_dict[wc.sample]["path"]
    output:
        pod5 = DIR_RES.joinpath("converted_pod5/{sample}.pod5")
    conda:
        DIR_ENVS.joinpath("pod5.yaml")      # activating conda environment needed for this module
    benchmark:
        DIR_RES.joinpath("benchmarks/convert_{sample}_benchmark.txt")   # writing needed ressources to a benchmark file
    resources:
        mem_mb = 4000 ### MEM_CONVERT        # parameter taken from and changable in "config/config.yaml"
    threads:
        4 ### CPU_CONVERT                 # ^^
    run:
        try:
            shell(f"pod5 convert fast5 {input.fast5} --output {output.pod5}")
            log_step(wildcards.sample, "CONVERT", "SUCCESS")
        except Exception as e:
            log_step(wildcards.sample, "CONVERT", "FAILURE", str(e))

# output definition
CONVERT_OUTPUT = expand(
    DIR_RES.joinpath("converted_pod5/{sample}.pod5"),
    sample=SAMPLES
)
