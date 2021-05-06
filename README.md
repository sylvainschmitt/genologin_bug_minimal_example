genologin bug minimal example
================
Sylvain Schmitt
May 6, 2021

The aim of this repository is to provide a minimal example to a bug
encountered on [genologin](http://bioinfo.genotoul.fr/). Using a
[`snakemake`](https://snakemake.readthedocs.io/en/stable/) workflow with
[`singularity`](https://sylabs.io/singularity/) pulling images from
[`dockerhub`](https://hub.docker.com/) doesn’t work on the cluster
(`singularity-3.6.4`), whereas it works perfectly locally
(`singularity-3.7.3`). And this bug is specific to docker images because
singularity images are working fine on the cluster. One way to fix the
bug is to manually pull the docker image with `singularity pull` where
it is supposed to be, but this is obviously a dirty hack.

# Bug

To trigger the bug I will simply use
[`fastQC`](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/)
on a generated `data/test.fastq` file using the `fastQC` image from
dockerhub with `singularity` :
docker://biocontainers/fastqc:v0.11.9\_cv8

``` bash
sbatch job.sh
tail bugex.*.err
```

``` bash
Error executing rule fastqc on cluster (jobid: 1, external: Submitted batch job 25131997, jobscript: /work/sschmitt/genologin_bug_minimal_example/.snakemake/tmp.0k0vwqnm/snakejob.fastqc.1.sh). For error details see the cluster log and the log files of the involved rule(s).
Shutting down, this might take some time.
Exiting because a job execution failed. Look above for error message
Complete log: /work/sschmitt/genologin_bug_minimal_example/.snakemake/log/2021-05-06T141323.151716.snakemake.log
```

``` bash
cat snake_subjob_log/fastqc.*.err
```

``` bash
Activating singularity image /work/sschmitt/genologin_bug_minimal_example/.snakemake/singularity/d3082de3ae9394fe1ccbc66f42ffee32.simg
FATAL:   could not open image /work/sschmitt/genologin_bug_minimal_example/.snakemake/singularity/d3082de3ae9394fe1ccbc66f42ffee32.simg: failed to retrieve path for /work/sschmitt/genologin_bug_minimal_example/.snakemake/singularity/d3082de3ae9394fe1ccbc66f42ffee32.simg: lstat /work/sschmitt/genologin_bug_minimal_example/.snakemake/singularity/d3082de3ae9394fe1ccbc66f42ffee32.simg: no such file or directory
```

# Dirty hack

Building manually the singularity image where it is supposed to be fixed
the bug with a dirty hack:

``` bash
module load system/singularity-3.6.4
singularity build .snakemake/singularity/d3082de3ae9394fe1ccbc66f42ffee32.simg docker://biocontainers/fastqc:v0.11.9_cv8
module purge
sbatch job.sh
ls data
```

``` bash
test.fastq  test_fastqc.html  test_fastqc.zip
```

So I could manually build locally all the images I need, but I would
prefer to use the `singularity` option in `snakemake` rules which deal
with that.
