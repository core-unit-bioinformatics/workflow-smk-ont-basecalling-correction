import datetime

# correcting basecalled fastq files into fsta files
rule correct_reads:
    input:
        fastq = DIR_RES.joinpath("basecalled_pod5/{sample}_basecalled.fastq"),  
        model = DORADO_CORRECTION_MODEL     # parameter taken from and changable in "config/config.yaml"
    output:
        fasta = DIR_RES.joinpath("corrected.fasta/{sample}_corrected.fasta")
    resources:
        mem_mb = MEM_HIGH,            # arameter taken from and changable in "config/config.yaml"
        cpu = CPU_HIGH              # parameter taken from and changable in "config/config.yaml"
#        time = ???
#    threads:
#        cpu = CPU_HIGH              # parameter taken from and changable in "config/config.yaml"   # TO DO: cpu should belong here
    run:
        shell(f"mkdir -p $(dirname {output.fasta})")        # create output directory   ### TO Do: is this necessary???
        shell(f"{DORADO_BIN} correct --device cuda:0 -m {input.model} {input.fastq} > {output.fasta}")  # run program
