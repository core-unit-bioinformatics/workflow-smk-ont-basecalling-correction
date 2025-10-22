"""
Use this module to extend the default
workflow output (a list of target files)
per sub-module.
The WORKFLOW_OUTPUT list is referenced
in the main Snakefile
"""

WORKFLOW_OUTPUT = []

# List outputs from modules
WORKFLOW_OUTPUT.extend(CONVERT_OUTPUT)     # ask for output ot the conversion module
#WORKFLOW_OUTPUT.extend(BASECALL_OUTPUT)     # ask for output ot the basecalling module
#WORKFLOW_OUTPUT.extend(CORRECT_OUTPUT)     # ask for output ot the correction module


# Example for extending the output
# with output from another module
# (remember to include that module
# in 00_modules.smk):
# WORKFLOW_OUTPUT.extend(MODULE_OUTPUT)


