import datetime

# create a log file for the pipeline run
LOG_FILE = DIR_LOG.joinpath("ont-basecalling-correction.log")

def log_step(wildcards, step, status, msg=""):
    """
    Log rule produces a TSV with one column per wildcard.
    Order: TIMESTAMP, all wildcards, STEP, STATUS, MESSAGE
    """

    # time
    timestamp = datetime.datetime.now()
    # wildcards
    wc_dict = dict(wildcards)
    # fixed columns
    fixed_cols = {"STEP": step, "STATUS": status, "MESSAGE": msg}
    # combine
    all_cols = {"TIMESTAMP": timestamp, **wc_dict, **fixed_cols}

    # write header if the file does not exist yet
    if not LOG_FILE.exists():
        with open(LOG_FILE, "w") as f:
            header = "\t".join(all_cols.keys())
            f.write(header + "\n")

    # logging for the modules
    with open(LOG_FILE, "a") as f:
        row = "\t".join(str(v) for v in all_cols.values())
        f.write(row + "\n")
