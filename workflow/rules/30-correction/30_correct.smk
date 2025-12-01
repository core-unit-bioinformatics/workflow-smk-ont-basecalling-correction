# correcting basecalled fastq files into fasta files
rule correct_reads:
    input:
        fastq = DIR_RES.joinpath("basecalled_fastq/{sample}_basecalled.fastq")
    output:
        fasta = DIR_RES.joinpath("corrected_fasta/{sample}_corrected.fasta")
        gz = DIR_RES.joinpath("corrected_fasta/{sample}_corrected.fasta.gz")
    conda:
        DIR_ENVS.joinpath("gzip.yaml")
    params:
        dorado_bin = lambda wc: CORRECT_DORADO_BIN[wc.sample],  
        dorado_model = MODEL_PATH_CORRECTION 
    benchmark:
        DIR_BENCHMARK.joinpath("{sample}_correct_benchmark.txt")   # writing to directory "rsrc
    resources:
        mem_mb = mem_mb = mem_mb = lambda wc, attempt: (128 * 1024) + (128 * 1024) * attempt,
        time_hrs = 71,
        ### time_hrs = 1,   # swap with active time_hrs for small tests
        gpus = (4) + (2) * attempt
        ### gpus = 1         # swap with active gpu for small tests
    threads:
        CPU_HIGH
    run:
        cmd1 = f"{params.dorado_bin} correct --device cuda:all -m {params.dorado_model} {input.fastq} --verbose > {output.fasta}"
        cmd2 = f"gzip -c {output.fasta} > {output.gz}

        if snakemake.printshellcmds:    # command only printed when "-p" is used on the snakemake call
            print(cmd1, flush=True)
            print(cmd2, flush=True)

        try:
            shell(cmd1)
            shell(cmd2)
            log_step(wildcards, "CORRECT", "SUCCESS")
        except Exception as e:
            log_step(wildcards, "CORRECT", "FAILURE", str(e))
            raise

# output definition
rule run_all_correct_reads:
    input:
        fasta = expand(rules.correct_reads.output.fasta, sample=SAMPLES)
        gz = expand(rules.correct_reads.output.gz, sample=SAMPLES)
        