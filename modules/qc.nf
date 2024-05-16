process fastqc {
  tag { sample_id }
  queue 'bgsi-batch-small-queue'

  publishDir params.versioned_outdir ? "${params.outdir}/${sample_id}/${params.pipeline_short_name}-v${params.pipeline_minor_version}-output" : "${params.outdir}", pattern: "*fastqc.*", mode: 'copy'

  input:
  tuple val(sample_id), path(reads_1), path(reads_2)

  output:
  path "*.html"
  path "*.zip", emit: zips

  script:
  """
  fastqc --threads $task.cpus ${reads_1} ${reads_2}
  """
}

process multiqc {
  queue 'bgsi-batch-small-queue'

  publishDir params.versioned_outdir ? "${params.outdir}/${sample_id}/${params.pipeline_short_name}-v${params.pipeline_minor_version}-output" : "${params.outdir}", pattern: "*", mode: 'copy'
  
  input:
  path(fastqc)

  output:
  path "*.html"

  script:
  """
  multiqc .
  """
}
