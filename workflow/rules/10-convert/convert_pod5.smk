import datetime

# converting fast5 files or a directory of fast5 files into pod5 files
rule convert_to_pod5:
    input:
        fast5 = lambda wc: samples_dict[wc.sample]       # sample wildcards taken from "/workflow/rules/00-settings/samples.smk"
    output:
        pod5 = DIR_RES.joinpath("converted_pod5/{sample}.pod5")
    resources:
        mem_mb = MEM_MED,            # arameter taken from and changable in "config/config.yaml"
        cpu = CPU_MED              # parameter taken from and changable in "config/config.yaml"
#        time = ???
#    threads:
#        cpu = CPU_MED              # parameter taken from and changable in "config/config.yaml"   # TO DO: cpu should belong here
    run:
            shell(f"pod5 convert fast5 {input.fast5} --output {output.pod5}")       # run program
