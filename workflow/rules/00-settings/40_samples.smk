import pandas as pd
import pathlib as pl

# read samplesheet
SAMPLESHEET = pl.Path(SAMPLESHEET)
if not SAMPLESHEET.exists():
    raise FileNotFoundError(
        f"\n\nSamplesheet not found:\n{SAMPLESHEET}\n\n"
    )

# load samplesheet into dataframe
try:
    samples_in = pd.read_csv(SAMPLESHEET, sep="\t", dtype={"sample_name": str})
except pd.errors.EmptyDataError:
    raise ValueError(
        f"\n\nSamplesheet is empty:\”{SAMPLESHEET}\n\n"
    )

# check for required column headers
required_cols = {"sample_name", "file_path"}
missing = required_cols - set(samples_in.columns)
if missing:
    raise ValueError(
        f"\n\nSamplesheet is missing required column(s):\n"
        f"{', '.join(missing)}\n"
        f"Found columns:\n{', '.join(samples_in.columns)}\n"
        f"Please check for typing errors.\n\n"
    )

# check for empty data rows
if samples_in.empty or len(samples_in.index) == 0:
    raise ValueError(
        f"\n\nSamplesheet contains no sample entries:\n\n"
        f"{SAMPLESHEET}\n"
    )

# build dictionary: sample, path and type
samples_dict = {}
for _, row in samples_in.iterrows():
    sample = str(row["sample_name"])
    path = pl.Path(row["file_path"])

    if not path.exists():               # check for input paths
        raise FileNotFoundError(
            f"\n\nInput path not found for sample '{sample}':\n"
            f"{path}\n\n"
        )

    # case 1: Direct file
    if path.is_file():                              # save file type fast5 od pod5
        if path.suffix == ".fast5":
            ftype = "fast5"
        elif path.suffix == ".pod5":
            ftype = "pod5"
        else:
            raise ValueError(
                f"\n\nInvalid file type for sample '{sample}':\n"
                f"{path.suffix}\n"
                f"Expected .fast5 or .pod5\n\n"
            )

    # case 2: Directory (check contents)
    elif path.is_dir():                             # save file type fast5 od pod5
        fast5_files = list(path.glob("*.fast5"))
        pod5_files = list(path.glob("*.pod5"))
        if fast5_files and not pod5_files:
            ftype = "fast5"
        elif pod5_files and not fast5_files:
            ftype = "pod5"
        else:
            raise ValueError(
                f"\n\nAmbiguous/invalid directory content for sample '{sample}':\n"
                f"{path}\n"
                f"Must contain either only fast5 OR only pod5 files.\n\n"
            )
    else:
        raise ValueError(
            f"\n\nInvalid input for sample '{sample}':\n"
            f"{path}\n"
            f"Must be a file or directory of fast5/pod5.\n\n"
        )

    samples_dict[sample] = {"path": str(path), "type": ftype}

# list of all sample names
SAMPLES = list(samples_dict.keys())
