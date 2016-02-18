#!/bin/bash

cat -A BART_020410_new-12-1_8_.txt | sed -e 's/\^M\$//' > BART_020410_12.txt
cat -A BART_020410_new-14-1_8_.txt | sed -e 's/\^M\$//' > BART_020410_14.txt

awk -f bart_log.awk BART_020410_12.txt > BART_020410_12_tiempos.txt
awk -f bart_log.awk BART_020410_14.txt > BART_020410_14_tiempos.txt
