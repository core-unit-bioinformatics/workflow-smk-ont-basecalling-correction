"""
Use this module to extend the default
workflow output (a list of target files)
per sub-module.
The WORKFLOW_OUTPUT list is referenced
in the main Snakefile
"""

WORKFLOW_OUTPUT = []

# output from module "sorado_setup.smk"
WORKFLOW_OUTPUT.extend(rules.run_all_dorado_setup.input.dorado_fast5)
WORKFLOW_OUTPUT.extend(rules.run_all_dorado_setup.input.dorado_pod5)
WORKFLOW_OUTPUT.extend(rules.run_all_dorado_setup.input.model_fast5)
WORKFLOW_OUTPUT.extend(rules.run_all_dorado_setup.input.model_pod5)
WORKFLOW_OUTPUT.extend(rules.run_all_dorado_setup.input.model_herro)

# output from module "convert_pod5.smk"
#WORKFLOW_OUTPUT.extend(rules.run_all_convert_to_pod5.input.pod5)	# removed since this should be deleted if the basecalled file exists
# output from module "basecall.smk"
WORKFLOW_OUTPUT.extend(rules.run_all_basecall.input.fastq)
# output from module "correct.smk"
# WORKFLOW_OUTPUT.extend(rules.run_all_correct_reads.input.fasta)	# removed since this should be deleted if the zipped file exists
WORKFLOW_OUTPUT.extend(rules.run_all_correct_reads.input.gz)



# Example for extending the output
# with output from another module
# (remember to include that module
# in 00_modules.smk):
# WORKFLOW_OUTPUT.extend(MODULE_OUTPUT)


