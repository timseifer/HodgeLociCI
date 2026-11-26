#!/bin/sh
# the runs of test H (PREREG_fermat.md, section 3); logs in logs/
cd "$(dirname "$0")"
python3 fp_engine.py arcs 67108837 1 12 > logs/arcs_p67108837_seed1_N12.log 2>&1
python3 fp_engine.py arcs 67108819 1 12 > logs/arcs_p67108819_seed1_N12.log 2>&1
for s in 2 3; do for p in 67108837 67108819; do
  python3 fp_engine.py arcs $p $s 11 > logs/arcs_p${p}_seed${s}_N11.log 2>&1
done; done
for p in 67108837 67108819; do python3 fp_engine.py arcs $p 4 8 4 > logs/arcs_p${p}_seed4_N8_dense4.log 2>&1; done
echo ALLDONE > logs/arcs_done.flag
