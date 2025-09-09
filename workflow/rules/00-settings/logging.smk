import datetime

# create a log file for the pipeline run
LOG_FILE = DIR_RES.joinpath("ont-basecalling-correction.log")

# write header if the file does not exist yet
if not LOG_FILE.exists():
    with open(LOG_FILE, "w") as f:
        f.write("TIMESTAMP | SAMPLE | STEP | STATUS | MESSAGE\n")
        f.write("-" * 60 + "\n")
		
# logging for the modules
def log_step(sample, step, status, msg=""):	
    with open(LOG_FILE, "a") as f:
        f.write(f"{datetime.datetime.now()} | {sample} | {step} | {status} | {msg}\n")