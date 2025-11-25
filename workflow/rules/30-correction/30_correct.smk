# correcting basecalled fastq files into fasta files
rule correct_reads:
    input:
        fastq = DIR_RES.joinpath("basecalled_fastq/{sample}_basecalled.fastq"),  
        model = DORADO_CORRECTION_MODEL
    output:
        fasta = DIR_RES.joinpath("corrected_fasta/{sample}_corrected.fasta")
    params:
        dorado_bin=lambda wc: (
            DORADO_BIN_OLD if samples_dict[wc.sample]["type"] == "fast5"
            else DORADO_BIN_NEW
        )
    benchmark:
        DIR_BENCHMARK.joinpath("{sample}_correct_benchmark.txt")   # writing to directory "rsrc
    resources:
        mem_mb = mem_mb = mem_mb = lambda wc, attempt: (128 * 1024) + (128 * 1024) * attempt,
        time_hrs = 71,
        ### time_hrs = 1,   # swap with active time_hrs for small tests
        gpu = (4) + (2) * attempt
        ### gpu = 1         # swap with active gpu for small tests
    threads:
        CPU_HIGH
    run:
        cmd = f"{params.dorado_bin} correct --device cuda:all -m {input.model} {input.fastq} --verbose > {output.fasta}"
        
        if snakemake.printshellcmds:    # command only printed when "-p" is used on the snakemake call
            print(cmd, flush=True)

        try:
            shell(cmd)
            log_step(wildcards.sample, "CORRECT", "SUCCESS")
        except Exception as e:
            log_step(wildcards.sample, "CORRECT", "FAILURE", str(e))

# output definition
rule run_all_correct_reads:
    input:
        fastq = expand(
            rules.correct_reads.output.fasta,
            sample=SAMPLES
        )