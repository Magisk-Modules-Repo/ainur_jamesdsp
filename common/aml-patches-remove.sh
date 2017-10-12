for CFG in $CONFIG_FILE $HTC_CONFIG_FILE $OTHER_V_FILE $OFFLOAD_CONFIG $V_CONFIG_FILE; do
  if [ -f $CFG ]; then
    sed -i '/jamesdsp {/,/}/d' $AMLPATH$CFG
    sed -i '/jdsp {/,/}/d' $AMLPATH$CFG
  fi
done
