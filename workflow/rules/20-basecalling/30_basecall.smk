# basecalling pod5 files into fastq files
rule basecall:
    input:
        pod5=lambda wc: BASECALL_INPUT[wc.sample]
    output:
        fastq = DIR_RES.joinpath("basecalled_fastq/{sample}_basecalled.fastq")
    params:
        dorado_bin = lambda wc: BASECALL_DORADO_BIN[wc.sample],
        dorado_model = lambda wc: BASECALL_DORADO_MODEL[wc.sample]
    benchmark:
        DIR_BENCHMARK.joinpath("{sample}_basecall_benchmark.txt")   # writing to directory "rsrc
    resources:
        mem_mb = mem_mb = lambda wc, attempt: (128 * 1024) + (128 * 1024) * attempt,
        time_hrs = 71,
        ### time_hrs = 1,   # swap with active time_hrs for small tests
        gpus = (4) + (2) * attempt
        ### gpus = 1         # swap with active gpu for small tests
    threads:
        CPU_HIGH
    run:
        cmd = f"{params.dorado_bin} basecaller --device cuda:all {params.dorado_model} --kit-name {DORADO_KIT} {input.pod5} --trim all --emit-fastq > {output.fastq}"
        
        if snakemake.printshellcmds:    # command only printed when "-p" is used on the snakemake call
        print(cmd, flush=True)

        try:
            shell(cmd)
            log_step(wildcards, "BASECALL", "SUCCESS")
        except Exception as e:
            log_step(wildcards, "BASECALL", "FAILURE", str(e))
            raise

# output definition
rule run_all_basecall:
    input:
        fastq = expand(
            rules.basecall.output.fastq,
            sample=SAMPLES
        )
        