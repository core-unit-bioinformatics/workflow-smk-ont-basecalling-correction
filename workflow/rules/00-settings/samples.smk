import pandas as pd
from pathlib import Path

# Read samplesheet
SAMPLESHEET = Path(SAMPLESHEET)
if not SAMPLESHEET.exists():
    raise FileNotFoundError(f"\n\nSamplesheet not found:\t{SAMPLESHEET}\n\n")

# Save sample IDs and pathways
samples_in = pd.read_csv(SAMPLESHEET, sep="\t")
samples_dict = samples_in.set_index("sample_name")["file_path"].to_dict()
SAMPLES = list(samples_dict.keys())

