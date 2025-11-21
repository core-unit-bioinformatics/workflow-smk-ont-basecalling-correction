"""
Use this module to list all includes
required for your pipeline - do not
add your pipeline-specific modules
to "commons/00_commons.smk"
"""

# Include settings and samples
include: "00-settings/20_settings.smk"		# setting variables
include: "00-settings/40_samples.smk"		# reading samples
include: "00-settings/60_logging.smk"		# personal log file

# Include pipeline steps
include: "10-convert/30_convert_pod5.smk"	# module 1 - conversion
include: "20-basecalling/30_basecall.smk"	# module 2 - basecalling
include: "30-correction/30_correct.smk"		# module 3 - correction