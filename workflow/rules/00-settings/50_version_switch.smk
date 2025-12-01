import pathlib as pl

BASECALL_INPUT = {}
BASECALL_DORADO_BIN = {}
BASECALL_DORADO_MODEL = {}
CORRECT_DORADO_BIN = {}

for sample, info in samples_dict.items():

    ftype = info.get("type", "").lower()

    if ftype == "fast5":
        # input: converted pod5 file
        BASECALL_INPUT[sample] = DIR_RES.joinpath("converted_pod5/{sample}.pod5")
        BASECALL_DORADO_BIN[sample] = DORADO_BIN_FAST5
        BASECALL_DORADO_MODEL[sample] = MODEL_PATH_FAST5
		CORRECT_DORADO_BIN[sample] = DORADO_BIN_FAST5

    elif ftype == "pod5":
        # input: original pod5 file
        BASECALL_INPUT[sample] = pl.Path(info["path"])
        BASECALL_DORADO_BIN[sample] = DORADO_BIN_POD5
        BASECALL_DORADO_MODEL[sample] = MODEL_PATH_POD5
		CORRECT_DORADO_BIN[sample] = DORADO_BIN_POD5

    else:
        # input: invalid type
        BASECALL_INPUT[sample] = None
        BASECALL_DORADO_BIN[sample] = None
        BASECALL_DORADO_MODEL[sample] = None
		CORRECT_DORADO_BIN[sample] = None
        print(f"[WARNING] Sample '{sample}' has unknown type: '{ftype}'")
