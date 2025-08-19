"""
Use this module to list all includes
required for your pipeline - do not
add your pipeline-specific modules
to "commons/00_commons.smk"
"""


# include: "00-settings/..."                          # !!! What goes here?

include: "10-convert/pod5-convert.smk"

include: "20-basecalling/dorado-basecalling.smk"

include: "30-correction/dorado-correction.smk"