# v DO NOT MODIFY v
# See instructions file for predefined variables
# Add patches (such as audio config) here (starting at line 9)
# NOTE: Destination variable must have '$AMLPATCH' in front of it
# Patch Ex: sed -i '/v4a_standard_fx {/,/}/d' $AMLPATCH$CONFIG_FILE
#
#
# ^ DO NOT MODIFY ^
for CFG in $CONFIG_FILE $HTC_CONFIG_FILE $OTHER_V_FILE $OFFLOAD_CONFIG $V_CONFIG_FILE; do
  if [ -f $CFG ]; then
    sed -i '/jamesdsp {/,/}/d' $AMLPATCH$CFG
    sed -i '/jdsp {/,/}/d' $AMLPATCH$CFG
  fi
done
