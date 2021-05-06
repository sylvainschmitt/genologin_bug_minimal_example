## Sylvain SCHMITT
## 06/05/2021

configfile: "config/config.yml"

rule all:
    input:
       multiext("data/test_fastqc", ".html", ".zip")

rule fastqc:
    input:
        "data/test.fastq"
    output:
        multiext("data/test_fastqc", ".html", ".zip")
    singularity: 
        "docker://biocontainers/fastqc:v0.11.9_cv8"
    shell:
        "fastqc -t {threads} -q {input}"