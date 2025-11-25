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
        fastq = DIR_RES.joinpath("basecalled_fastq/{sample}_basecalled.fastq")
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
        DIR_BENCHMARK.joinpath("{sample}_basecall_benchmark.txt")   # writing to directory "rsrc
    resources:
        mem_mb = mem_mb = lambda wc, attempt: (128 * 1024) + (128 * 1024) * attempt,
        time_hrs = 71,
        ### time_hrs = 1,   # swap with active time_hrs for small tests
        gpu = (4) + (2) * attempt
        ### gpu = 1         # swap with active gpu for small tests
    threads:
        CPU_HIGH
    run:
        cmd = f"{params.dorado_bin} basecaller --device cuda:all {params.dorado_model} --kit-name {DORADO_KIT} {input.pod5} --trim all --emit-fastq > {output.fastq}"
        
        if snakemake.printshellcmds:    # command only printed when "-p" is used on the snakemake call
        print(cmd, flush=True)

        try:
            shell(cmd)
            log_step(wildcards.sample, "BASECALL", "SUCCESS")
        except Exception as e:
            log_step(wildcards.sample, "BASECALL", "FAILURE", str(e))
            raise

# output definition
rule run_all_basecall:
    input:
        fastq = expand(
            rules.basecall.output.fastq,
            sample=SAMPLES
        )