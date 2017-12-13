for FILE in ${CFGS}; do
  sed -i "/jamesdsp {/,/}/d" $AMLPATH$FILE
  sed -i "/jdsp {/,/}/d" $AMLPATH$FILE
done
for FILE in ${CFGSXML}; do
  sed -i "/jamesdsp/d" $AMLPATH$FILE
  sed -i "/jdsp/d" $AMLPATH$FILE
done
