nextflow.enable.dsl = 2

include { fastqc }  from './modules/qc.nf'
include { multiqc } from './modules/qc.nf'

workflow {
  if (params.samplesheet_input != 'NO_FILE') {
    ch_fastq = Channel.fromPath(params.samplesheet_input).splitCsv(header: true).map{ it -> [it['ID'], it['R1'], it['R2']] }
  } else {
    ch_fastq = Channel.fromFilePairs( params.fastq_search_path, flat: true ).map{ it -> [it[0].split('_')[0], it[1], it[2]] }.unique{ it -> it[0] }
  }

  main:
    fastqc(ch_fastq)
    multiqc(fastqc.out.zips.collect())
}