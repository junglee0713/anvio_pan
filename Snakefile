import configparser
import yaml

contig_dir = config['all']['contig_dir']
anvio_output_dir = config['all']['root'] + '/anvio_output'

files, = glob_wildcards(contig_dir + '/{file}.fa')

workdir: config['all']['root']

rule all:
    input: expand(anvio_output_dir + '/{file}/.DONEncbi_cog', file = files)

########
### If you are running COGs for the first time, 
### you will need to set them up on your computer using 
### anvi-setup-ncbi-cogs
### Refer to http://merenlab.org/2016/06/22/anvio-tutorial-v2/#anvi-run-ncbi-cogs
######## 

rule ncbi_cogs:
    input:
        contig_db = anvio_output_dir + '/{file}/contigs.db',
        sentinel = anvio_output_dir + '/{file}/.DONEhmm'
    output:
        anvio_output_dir + '/{file}/.DONEncbi_cog'
    threads:
        config['ncbi_cog']['threads']
    shell:
        """
            anvi-run-ncbi-cogs --contigs-db {input.contig_db} \
                --num-threads {threads} --search-with blastp && \
            touch {output}
        """

rule hmm:
    input:
        anvio_output_dir + '/{file}/contigs.db'
    output:
        anvio_output_dir + '/{file}/.DONEhmm'
    threads:
        config['hmm']['threads']
    shell:
        """
            anvi-run-hmms --contigs-db {input} \
                --num-threads {threads} && \
            touch {output}
        """

rule get_contig_db:
    input:
        anvio_output_dir + '/{file}/reformatted_contigs.fa'
    output:
        anvio_output_dir + '/{file}/contigs.db'
    params:
        file = '{file}'
    shell:
        """
            anvi-gen-contigs-database --contigs-fasta {input} \
                --output-db-path {output} \
                --project-name {params.file}
        """


rule reformat_fasta:
    input: 
        contig_dir + '/{file}.fa'
    output: 
        anvio_output_dir + '/{file}/reformatted_contigs.fa'
    params:
        min_contig_length = config['reformat']['min_contig_length'],
        report_file = anvio_output_dir + '/{file}/simplify-names.txt'
    shell:
        """
            anvi-script-reformat-fasta {input} \
                --output-file {output} \
                --min-len {params.min_contig_length} \
                --simplify-name \
                --report-file {params.report_file}
        """

onsuccess:
    print('Workflow finished, no error')
    shell('mail -s "Workflow finished successfully" ' + config['all']['admin_email'] + ' < {log}')

onerror:
    print('An error occurred')
    shell('mail -s "An error occurred" ' + config['all']['admin_email'] + ' < {log}')

