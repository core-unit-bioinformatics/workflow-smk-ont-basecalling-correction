# correcting basecalled fastq files into fasta files
rule correct_reads:
    input:
        fastq = DIR_RES.joinpath("basecalled_fastq/{sample}_basecalled.fastq"),
        dorado_bin = lambda wc: CORRECT_DORADO_BIN[wc.sample]
    output:
        fasta = temp(DIR_RES.joinpath("corrected_fasta/{sample}_corrected.fasta")),
        gz = DIR_RES.joinpath("corrected_fasta/{sample}_corrected.fasta.gz")
#    conda:
#        DIR_ENVS.joinpath("gzip.yaml")
    container:
        str(DIR_WORKING.joinpath("container/workflow_full.sif"))
    params:
        dorado_model = MODEL_PATH_CORRECTION 
    benchmark:
        DIR_BENCHMARK.joinpath("{sample}_correct_benchmark.txt")   # writing to directory "rsrc
    resources:
        mem_mb = (250 * 1024),  # maximum available on the m-hpc
        ###mem_mb = lambda wc, attempt: (192 * 1024) + (64 * 1024) * (attempt - 1),   # flexible allocation if enough resources are present
        ### mem_mb = (64 * 1024),    # swap with active time_hrs for small tests
        time_hrs = 71,
        ### time_hrs = 1,   # swap with active time_hrs for small tests
        gpus = 4 # maximum available on the m-hpc
        ###gpus = lambda wc, attempt: (4) + (1) * (attempt - 1)   # flexible allocation if enough resources are present
        ### gpus = 1         # swap with active gpu for small tests
    threads:
        CPU_HIGH
        ### CPU_MEDIUM       # swap with active gpu for small tests
    run:
        cmd1 = (
            f"{input.dorado_bin} correct "
            f"  --device cuda:all "
            f"  -m {params.dorado_model} "
            f"  {input.fastq} "
            f"  --verbose "
            f"  > {output.fasta}"
        )
        cmd2 = (
            f"gzip -c {output.fasta} "
            f"  > {output.gz}"
        )
        print("Shell command 1: ", cmd1, flush=True)
        print("Shell command 2: ", cmd2, "\n", flush=True)
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
        fasta = expand(rules.correct_reads.output.fasta, sample=SAMPLES),
        gz = expand(rules.correct_reads.output.gz, sample=SAMPLES)
        