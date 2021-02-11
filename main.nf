 //  example:
 // cat ../Clean/test/*_1.fq.gz > ../Clean/test/test_1.fq.gz
 // cat ../Clean/test/*_2.fq.gz > ../Clean/test/test_2.fq.gz
// nextflow run main.nf --reads "../Clean/test/test_{1,2}.fq.gz" --samplename test
 
 
 
 // Define the default parameters
params.reads = ""
params.outdir = "./results"
params.samplename = ""
params.readgroup = "${params.samplename}"
params.reference = "~/hg38/Homo_sapiens_assembly38.fasta"

/*
 * Create the `read_pairs_ch` channel that emits tuples containing three elements:
 * the pair ID, the first read-pair file and the second read-pair file
 */
Channel
    .fromFilePairs( params.reads )
    .ifEmpty { error "Cannot find any reads matching: ${params.reads}" }
    .set { read_pairs_ch } 


process map_and_sort {
	publishDir "${params.outdir}/mapped_reads"

	input:
	tuple val(pair_id), path(reads) from read_pairs_ch

	output:
	file "${params.samplename}.bam" into bamfile_ch1, bamfile_ch2
	
	"""
	bwa mem -t 6 -M -R '@RG\\tID:${params.readgroup}\\tSM:${params.samplename}\\tPL:ILLUMINA' $params.reference $reads \
	| samtools sort -@6 -o ${params.samplename}.bam -
	"""	
}

process index_bam {
	publishDir "${params.outdir}/mapped_reads"

	input:
	file bamfile from bamfile_ch1

	output:
	file "${bamfile}.bai" into bamindx_ch

	script:
	"""
	samtools index $bamfile
	"""
}

process run_xhla {
    publishDir "${params.outdir}/reports", mode: 'copy'

    input:
	file bamfile from bamfile_ch2
    file bamindx from bamindx_ch

    output:
    file "${params.samplename}/report-${params.samplename}-hla.json" into result_ch

    script:
    """
    python /opt/bin/run.py \
    --sample_id ${params.samplename} --input_bam_path $bamfile \
    --output_path ${params.samplename}
    """
}