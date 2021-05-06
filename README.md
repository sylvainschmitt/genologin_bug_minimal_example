genologin bug minimal example
================
Sylvain Schmitt
May 6, 2021

  - [Bug](#bug)
  - [Dirty hack](#dirty-hack)

The aim of this repository is to provide a minimal example to a bug
encountered on [genologin](http://bioinfo.genotoul.fr/). Using a
[`snakemake`](https://snakemake.readthedocs.io/en/stable/) workflow with
[`singularity`](https://sylabs.io/singularity/) pulling images from
[`dockerhub`](https://hub.docker.com/) doesn’t work on the cluster,
whereas it works perfectly locally. And this bug is specific to docker
images because singularity images are working fine on the cluster. One
way to fix the bug is to manually pull the docker image with
`singularity pull` where it is supposed to be, but this is obviously a
dirty hack.

# Bug

To trigger the bug I will simply use
[`fastQC`](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/)
on a generated `data/test.fastq` file using the `fastQC` image from
dockerhub with `singularity` :
docker://biocontainers/fastqc:v0.11.9\_cv8

``` bash
module purge ; module load bioinfo/snakemake-5.25.0 # for test on node
snakemake -np # dry run
sbatch job.sh ; watch 'squeue -u sschmitt' # run
less detMut.*.err # snakemake outputs, use MAJ+F
less detMut.*.out # snakemake outputs, use MAJ+F
snakemake --dag | dot -Tsvg > dag/dag.svg # dag
module purge ; module load bioinfo/snakemake-5.8.1 ; module load system/Python-3.6.3 # for report
snakemake --report report.html # report
```

# Dirty hack
