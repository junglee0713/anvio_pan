# anvio_pan
## Pangenome analysis using Anvio

- This borrows lots of scripts from https://github.com/sunbeam-labs/sbx_anvio

- Run under an environment with anvio-6.1 installed in it. Once you installed anvio-6.1, run `anvi-setup-ncbi-cogs --just-do-it --num-threads 4` to set up NCBI's Clusters of Orthologous Groups database (one-time procedure). 

- How to run:
  - Input: contig fasta files (file names should end with .fa)
  - (Desired) Output: pangenome analysis result that could be visualized using `anvi-display-pan`
