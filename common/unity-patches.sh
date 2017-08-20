# v DO NOT MODIFY v
# See instructions file for predefined variables
# Add patches (such as audio config) here (starting at line 9)
# NOTE: Destination variable must have '$UNITYPATCH' in front of it
# Patch Ex: sed -i '/v4a_standard_fx {/,/}/d' $UNITYPATCH$CONFIG_FILE
#
#
# ^ DO NOT MODIFY ^
ui_print "    Patching existing audio_effects files..."
for CFG in $CONFIG_FILE $HTC_CONFIG_FILE $OTHER_V_FILE $OFFLOAD_CONFIG $V_CONFIG_FILE; do
  if [ -f $CFG ] && [ ! "$(cat $AMLPATH$CFG | grep ' jamesdsp {')" ]; then
    sed -i 's/^effects {/effects {\n  jamesdsp {\n    library jdsp\n    uuid f27317f4-c984-4de6-9a90-545759495bf2\n  }/g' $UNITYPATCH$CFG
    sed -i 's/^libraries {/libraries {\n  jdsp {\n    path \/system\/lib\/soundfx\/libjamesdsp.so\n  }/g' $UNITYPATCH$CFG
  fi
done
