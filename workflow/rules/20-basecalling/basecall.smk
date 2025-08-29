import datetime

# basecalling pod5 files into fastq files
rule basecall:
    input:
        pod5 = DIR_RES.joinpath("converted_pod5/{sample}.pod5")       # "RESULT_DIR" is a sibling directory to this workflows main directory
    output:
        fastq = DIR_RES.joinpath("basecalled_pod5/{sample}_basecalled.fastq")       # "RESULT_DIR" is a sibling directory to this workflows main directory
    resources:
        mem_mb = MEM_HIGH,            # arameter taken from and changable in "config/config.yaml"
        cpu = CPU_HIGH              # parameter taken from and changable in "config/config.yaml"
#        time = ???
#    threads:
#        cpu = CPU_HIGH              # parameter taken from and changable in "config/config.yaml"   # TO DO: cpu should belong here
    run:
        #shell(f"mkdir -p $(dirname {output.fastq})")        # create output directory
        shell(f"{DORADO_BIN} basecaller --device cuda:0 {DORADO_MODEL} --kit-name {DORADO_KIT} {input.pod5} --trim all --emit-fastq > {output.fastq}")       # run program
        