# basecalling pod5 files into fastq files
rule basecall:
    input:
        pod5 = lambda wc: BASECALL_INPUT[wc.sample],
        dorado_bin = lambda wc: BASECALL_DORADO_BIN[wc.sample]
    output:
        fastq = DIR_RES.joinpath("basecalled_fastq/{sample}_basecalled.fastq")
    params:
        dorado_model = lambda wc: BASECALL_DORADO_MODEL[wc.sample]
    benchmark:
        DIR_BENCHMARK.joinpath("{sample}_basecall_benchmark.txt")   # writing to directory "rsrc
    resources:
        mem_mb = lambda wc, attempt: (128 * 1024) + (128 * 1024) * (attempt - 1),
        ### mem_mb = (64 * 1024),    # swap with active time_hrs for small tests
        time_hrs = 71,
        ### time_hrs = 1,           # swap with active time_hrs for small tests
        gpus = lambda wc, attempt: (4) + (2) * (attempt - 1)
        ### gpus = 1                # swap with active gpu for small tests
    threads:
        CPU_HIGH
        ### CPU_MEDIUM              # swap with active gpu for small tests
    run:
        cmd = (
            f"{input.dorado_bin} basecaller "
            f"  --device cuda:all "
            f"  {params.dorado_model} "
            f"  --kit-name {DORADO_KIT} "
            f"  {input.pod5} "
            f"  --trim all "
            f"  --emit-fastq "
            f"  > {output.fastq}"
        )
        print("Shell command: ", cmd, "\n", flush=True)
        try:
            shell(cmd)
            log_step(wildcards, "BASECALL", "SUCCESS")
        except Exception as e:
            log_step(wildcards, "BASECALL", "FAILURE", str(e))
            raise

# output definition
rule run_all_basecall:
    input:
        fastq = expand(rules.basecall.output.fastq, sample=SAMPLES)
