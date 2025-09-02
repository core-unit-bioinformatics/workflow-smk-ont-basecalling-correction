# correcting basecalled fastq files into fsta files
rule correct_reads:
    input:
        fastq = DIR_RES.joinpath("basecalled_pod5/{sample}_basecalled.fastq"),  
        model = DORADO_CORRECTION_MODEL     # parameter taken from and changable in "config/config.yaml"
    output:
        fasta = DIR_RES.joinpath("corrected_fasta/{sample}_corrected.fasta")
    resources:
        mem_mb = MEM_HIGH,            # arameter taken from and changable in "config/config.yaml"
        cpu = CPU_HIGH              # parameter taken from and changable in "config/config.yaml"
#        time = ???
#    threads:
#        cpu = CPU_HIGH              # parameter taken from and changable in "config/config.yaml"   # TO DO: cpu should belong here
    run:
        #shell(f"mkdir -p $(dirname {output.fasta})")        # create output directory   ### TO Do: is this necessary???
        try:
            shell(f"{DORADO_BIN} correct --device cuda:0 -m {input.model} {input.fastq} > {output.fasta}")
            log_step(wildcards.sample, "CORRECT", "SUCCESS")
        except Exception as e:
            log_step(wildcards.sample, "CORRECT", "FAILURE", str(e))

# output definition
CORRECT_OUTPUT = expand(
    DIR_RES.joinpath("corrected_fasta/{sample}_corrected.fasta"),
    sample=SAMPLES
)