# Samplesheet
SAMPLESHEET = config["samplesheet"]

# Tools
DORADO_BIN_OLD = config["dorado_bin_old"]
DORADO_BIN_NEW = config["dorado_bin_new"]
POD5_BIN = config["pod5_convert_bin"]

# Models and kit
DORADO_MODEL_OLD = config["dorado_sup_model_old"]
DORADO_MODEL_NEW = config["dorado_sup_model_new"]
DORADO_KIT = config["dorado_kit"]
DORADO_CORRECTION_MODEL = config["dorado_correction_model"]

# Resources
GPU_CORRECT = config["gpu_correct"]
assert isinstance(GPU_CORRECT, int)
GPU_BASECALL = config["gpu_basecall"]
assert isinstance(GPU_BASECALL, int)

CPU_CORRECT = config["cpu_correct"]
assert isinstance(CPU_CORRECT, int)
CPU_BASECALL = config["cpu_basecall"]
assert isinstance(CPU_BASECALL, int)
CPU_CONVERT = config["cpu_convert"]
assert isinstance(CPU_CONVERT, int)

MEM_CORRECT = config["mem_correct"]
assert isinstance(MEM_CORRECT, int)
MEM_BASECALL = config["mem_basecall"]
assert isinstance(MEM_BASECALL, int)
MEM_CONVERT = config["mem_convert"]
assert isinstance(MEM_CONVERT, int)

WALLTIME_CORRECT = config["walltime_correct"]
assert isinstance(WALLTIME_CORRECT, int)
WALLTIME_BASECALL = config["walltime_basecall"]
assert isinstance(WALLTIME_BASECALL, int)
WALLTIME_CONVERT = config["walltime_convert"]
assert isinstance(WALLTIME_CONVERT, int)