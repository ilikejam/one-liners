#!/bin/bash
# Script to calculate e to an arbitrary number of decimal places.
# Result is rounded to that precision.
# v0.1 David Stark dave@davidstark.name 2012-06-06
# https://news.ycombinator.com/item?id=4072637

if [ $# -ne 1 ] || [ -z $1 ] || [ ! -z `echo $1 | tr -d '[0-9]'` ]
then
    echo "Error: Specify number of decimal places as only argument." 1>&2
    exit 1
fi

PREC=$1
# An internal precision of requested+3 seems to be the sweet-spot for accuracy vs speed.
# Increase SCALE for better accuracy.
# SCALE=$(($PREC*2)) should be bullet-proof, but is slow for large precisions
SCALE=$((PREC+3))

#-----functions-----#

# output a 1/(1+2+3...$1) precision part to be added to getepart(${1}-1)
epart()
{
    seq=`seq 1 $1`
    scale=$2
    denom=`echo $seq | sed 's/ /*/g' | bc`
    echo "scale=$scale; $denom ^ -1" | bc
}

#-----main-----#

# Keep adding parts until the result stabilises at $SCALE precision
E=2
i=2
lastE=-1
while [ "$lastE" != "$E" ]
do
    lastE=$E
    e=`epart $i $SCALE`
    E=`echo "scale=$SCALE; $E + $e" | bc`
    ((i++))
done

# Clean, chop, round, clean, chop
preround=`echo $E | sed 's/\\\//g; s/ //g' | cut -c "1-$(($PREC + 3))"`
ld=${preround#${preround%?}}
if [ $ld -ge 5 ]
then
    round=`echo "scale=$PREC; 10 ^ -$PREC" | bc`
else
    round=0
fi
echo "$preround + $round" | bc | tr -d '\n' | sed 's/\\//g; s/.$//; s/\.$//'
echo
exit 0
# Relax
