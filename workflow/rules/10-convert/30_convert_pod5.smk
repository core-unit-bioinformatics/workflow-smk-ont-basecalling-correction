# converting fast5 files or a directory of fast5 files into pod5 files
rule convert_to_pod5:
    input:
        fast5 = lambda wc: samples_dict[wc.sample]["path"]
    output:
        pod5 = DIR_RES.joinpath("converted_pod5/{sample}.pod5")
#    conda:
#        DIR_ENVS.joinpath("pod5.yaml")
    container:
        str(DIR_WORKING.joinpath("container/workflow_full.sif"))
    benchmark:
        DIR_BENCHMARK.joinpath("{sample}_convert_benchmark.txt")   # writing to directory "rsrc
    resources:
        mem_mb = lambda wc, attempt: (6 * 1024) + (4 * 1024) * (attempt-1),
        time_hrs = lambda wc, attempt: (23) + (12) * (attempt-1)
    threads:
        CPU_LOW
    run:
        cmd = (
            f"pod5 convert "
            f"  fast5 {input.fast5} "
            f"  --output {output.pod5}"
        )
        print("Shell command: ", cmd, "\n", flush=True)
        try:
            shell(cmd)
            log_step(wildcards, "CONVERT", "SUCCESS")
        except Exception as e:
            log_step(wildcards, "CONVERT", "FAILURE", str(e))
            raise

# output definition
rule run_all_convert_to_pod5:
    input:
        pod5 = expand(rules.convert_to_pod5.output.pod5, sample=SAMPLES)
