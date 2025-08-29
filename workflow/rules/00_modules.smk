"""
Use this module to list all includes
required for your pipeline - do not
add your pipeline-specific modules
to "commons/00_commons.smk"
"""

# Include settings and samples
include: "00-settings/settings.smk"
include: "00-settings/samples.smk"

# Include pipeline steps
include: "10-convert/convert_pod5.smk"
include: "20-basecalling/basecall.smk"
include: "30-correction/correct.smk"