#!/bin/sh
# the runs of test H' (PREREG_fermat.md, section 4); logs in logs/
cd "$(dirname "$0")"
python3 fp_engine.py arcsl 67108837 1 11 > logs/arcsl_p67108837_seed1_N11.log 2>&1
python3 fp_engine.py arcsl 67108819 1 11 > logs/arcsl_p67108819_seed1_N11.log 2>&1
for s in 2 3; do for p in 67108837 67108819; do
  python3 fp_engine.py arcsl $p $s 10 > logs/arcsl_p${p}_seed${s}_N10.log 2>&1
done; done
python3 fp_main.py classes55 12 67108819 > logs/classes55_N12_p67108819.log 2>&1
echo ALLDONE > logs/arcsl_done.flag
