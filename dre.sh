#!/usr/bin/env bash
# 计算水稻dre原件数目

# 将每一行变为一个基因
cat rice_all.cdna | tr -d "\n" | sed "s/>/\n>/g" >new_rice_all.cdna

chr=">Chr"

for i in $(seq 1 12); do
    echo "$chr$i:"
    grep "$chr$i" rice.genome | grep -o '[AG]CCGC.T' | wc -l
done
