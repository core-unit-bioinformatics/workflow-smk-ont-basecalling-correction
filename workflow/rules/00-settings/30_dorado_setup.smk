import pathlib as pl

# dorado directory inside WD
DORADO_BINARIES = DIR_WORKING.joinpath("dorado/binaries")
DORADO_MODELS = DIR_WORKING.joinpath("dorado/models")

# extract directory name from URL
def version_from_url(url):
    return pl.Path(url).name.replace(".tar.gz", "")

DIR_FAST5 = DORADO_BINARIES.joinpath(version_from_url(DORADO_FAST5_URL))
DIR_POD5 = DORADO_BINARIES.joinpath(version_from_url(DORADO_POD5_URL))

# download dorado binaries (needs internet connection)
rule dorado_fast5:
    output:
        dorado_fast5 = directory(DIR_FAST5),
        fast5_bin = DIR_FAST5.joinpath("bin/dorado")
    params:
        url = DORADO_FAST5_URL,
        tgz = pl.Path(DORADO_FAST5_URL).name
    shell:
        """
        mkdir -p {DORADO_BINARIES}
        wget -O {DORADO_BINARIES}/{params.tgz} {params.url}
        tar -xzf {DORADO_BINARIES}/{params.tgz} -C {DORADO_BINARIES}
        rm {DORADO_BINARIES}/{params.tgz}
        """

rule dorado_pod5:
    output:
        dorado_pod5 = directory(DIR_POD5),
        pod5_bin = DIR_POD5.joinpath("bin/dorado")
    params:
        url = DORADO_POD5_URL,
        tgz = pl.Path(DORADO_POD5_URL).name
    shell:
        """
        mkdir -p {DORADO_BINARIES}
        wget -O {DORADO_BINARIES}/{params.tgz} {params.url}             
        tar -xzf {DORADO_BINARIES}/{params.tgz} -C {DORADO_BINARIES}
        rm {DORADO_BINARIES}/{params.tgz}
        fi
        """

# download dorado models (needs internet connection)
rule dorado_models:
    input:
        fast5_bin = DIR_FAST5.joinpath("bin/dorado"),
        pod5_bin = DIR_POD5.joinpath("bin/dorado")
    output:
        model_fast5 = directory(DORADO_MODELS / DORADO_MODEL_FAST5),
        model_pod5 = directory(DORADO_MODELS / DORADO_MODEL_POD5),
        model_herro = directory(DORADO_MODELS / DORADO_MODEL_CORRECTION)
    shell:
        """
        mkdir -p {DORADO_MODELS}

        # fast5 model
        if [ ! -f "{DORADO_MODELS}/{DORADO_MODEL_FAST5}" ]; then
            {input.fast5_bin} download \
                --model {DORADO_MODEL_FAST5} \
                --directory {DORADO_MODELS}
        fi

        # pod5 model
        if [ ! -f "{DORADO_MODELS}/{DORADO_MODEL_POD5}" ]; then
            {input.pod5_bin} download \
                --model {DORADO_MODEL_POD5} \
                --directory {DORADO_MODELS}
        fi

        # correction model
        if [ ! -f "{DORADO_MODELS}/{DORADO_MODEL_CORRECTION}" ]; then
            {input.pod5_bin} download \
                --model {DORADO_MODEL_CORRECTION} \
                --directory {DORADO_MODELS}
        fi
        """

# set variables for later use
DORADO_BIN_FAST5 = DIR_FAST5.joinpath("bin/dorado")
DORADO_BIN_POD5 = DIR_POD5.joinpath("bin/dorado")

MODEL_PATH_FAST5 = DORADO_MODELS.joinpath(DORADO_MODEL_FAST5)
MODEL_PATH_POD5 = DORADO_MODELS.joinpath(DORADO_MODEL_POD5)
MODEL_PATH_CORRECTION = DORADO_MODELS.joinpath(DORADO_MODEL_CORRECTION)

rule run_all_dorado_setup:
    input:
        dorado_fast5 = expand(rules.dorado_fast5.output.dorado_fast5),
        dorado_pod5 = expand(rules.dorado_pod5.output.dorado_pod5),
        model_fast5 = expand(rules.dorado_models.output.model_fast5),
        model_pod5 = expand(rules.dorado_models.output.model_pod5),
        model_herro = expand(rules.dorado_models.output.model_herro)
