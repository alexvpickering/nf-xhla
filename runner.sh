#!/bin/bash

cd /n/scratch3/users/a/ap491/F20FTSUSAT1396_HUMooaR/Reads/nf-xhla
DONE="200396 1308207 116395 11530251 11036018 103174 200634 200627 200622 200597 200617 200454"

is_done() { echo $DONE | grep -F -q -w "$1"; }

for f in ../Clean/*; do
  PID=`basename ${f}`; 
  echo "PID${PID}"; 
  is_done "$PID" && echo "done!" || sbatch slurm-xhla.sh $PID
done