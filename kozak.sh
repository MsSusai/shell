#!/usr/vin/env bash
# 计算kozak规则

cp /home/rice_all.cdna .
cat rice_all.cdna | tr -d [[:space:]] | sed "s/>/\n>/g" >sativa_cDNA.fasta

declare -i kozak=1 sum=1
declare -i p2
echo "Waiting..."

for line in $(cat sativa_cDNA.fasta); do
    p1=$(echo $line | grep -bo 'ATG')
    p2=$(echo ${p1%%:*}) # 删掉p1右边的字符串

    if [[ ${line:p2-3:7} =~ [AG]..ATGG ]]; then # 在line从p2-3位置处向后取七个碱基
        echo "$kozak/$sum $p2   ${line:p2-3:7}  kozak found!"
        ((kozak++))
    fi
    ((sum++))
done

echo "Total Kozak: $kozak"
echo "Total Genes: $sum"
