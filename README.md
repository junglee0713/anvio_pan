# anvio_pan
## Pangenome analysis using Anvio

- This borrows lots of scripts from https://github.com/sunbeam-labs/sbx_anvio

- How to run:
  - Create an anvio environment: `conda create -n anvio-6.1 python=3.6`
  - Activate the environment: `conda activate anvio-6.1`
  - Install anvio: `conda install -y -c conda-forge -c bioconda anvio=6.1`
  - Install the anvio-compatible version of diamond `conda install -y diamond=0.9.14` (This is optional, as this pipeline uses blastp)
  - To test anvio installation, run `anvi-self-test --suite mini`
  - Run `anvi-setup-ncbi-cogs --just-do-it --num-threads 4` to set up NCBI's Clusters of Orthologous Groups database (one-time procedure)
  - Change the contents of `anvio_pan_config.yml` so that it suits your project (mainly the ones under `all` category)
  - Place all contig fasta files (**extension is assumed to be `.fa`**) in the folder specified in `config['all']['contig_dir']` in `anvio_pan_config.yml`
  - The final desired output are `project_name-GENOMES.db` and `project_name-PAN.db` which can be viewed using `anvi-display-pan` (you might want to run this on your local computer, as its interactive output uses a web browser)
