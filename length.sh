#!/usr/bin/env bash
declare -i n=0
declare -i l=0
for line in $(cat seq.seq); do
    l=$l+1
    n=$n+${#line}
done
echo "line are $l"
echo "char are $n"
echo "scale=4;$n/$l" | bc
