"""
Use this module to extend the default
workflow output (a list of target files)
per sub-module.
The WORKFLOW_OUTPUT list is referenced
in the main Snakefile
"""

WORKFLOW_OUTPUT = []

# output from module "convert_pod5.smk"
CONVERT_OUTPUT = rules.run_all_convert_to_pod5.input.pod5
# output from module "basecall.smk"
BASECALL_OUTPUT = rules.run_all_basecall.input.fastq
# output from module "correct.smk"
CORRECT_OUTPUT = rules.run_all_correct_reads.input.fasta



# Example for extending the output
# with output from another module
# (remember to include that module
# in 00_modules.smk):
# WORKFLOW_OUTPUT.extend(MODULE_OUTPUT)


