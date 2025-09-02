"""
Use this module to list all includes
required for your pipeline - do not
add your pipeline-specific modules
to "commons/00_commons.smk"
"""

# Include settings and samples
include: "00-settings/settings.smk"		# setting variables
include: "00-settings/samples.smk"		# reading samples
include: "00-settings/logging.smk"		# personal log file

# Include pipeline steps
include: "10-convert/convert_pod5.smk"	# module 1 - conversion
include: "20-basecalling/basecall.smk"	# module 2 - basecalling
include: "30-correction/correct.smk"	# module 3 - correction