#!/usr/bin/env bash

# 分割出fastq文件
fastq-dump SRR10987231
fastq-dump SRR10987232

# fastq质量评估
fastqc -o ./fastqc_results -f fastq SRR10987231 fastq SRR10987231

# 建立索引
# 转录组cDNA不用注释文件。如果用基因组要连着gtf注释文件一起输入(-gtf '注释文件.gtf')，否则会出现索引只能建立到染色体，不能建立到具体的基因上！！！
rsem-prepare-reference -p 6 --bowtie2 GCF_000001735.4_TAIR10.1_genomic.fna ./reference/ref_rsem

# mapping
rsem-calculate-expression -p 6 --bowtie2 --estimate-rspd SRR10987231.1.fastq ./reference/ref_rsem ./mapping/SRR1.map
rsem-calculate-expression -p 6 --bowtie2 --estimate-rspd SRR10987232.1.fastq ./reference/ref_rsem ./mapping/SRR2.map

# 查看alignment质量
rsem-plot-model SRR1.map SRR1_diagnostic.pdf
rsem-plot-model SRR2.map SRR2_diagnostic.pdf

# 合并结果
rsem-generate-data-matrix SRR1.map.isoforms.results SRR2.map.isoforms.results > SRR_all.csv

# 标准化，获得差异表达基因
rsem-run-ebseq SRR_all.csv 1,1 SRR_all_results.csv # 1,1表示有两组，每组内有一个重复

# fdr为0.05时的差异表达基因
rsem-control-fdr SRR_all_results.csv 0.05 SRR_diff.csv

