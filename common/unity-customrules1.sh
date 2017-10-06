# v DO NOT MODIFY v
# See instructions file for predefined variables
# User defined custom rules
# Can have multiple ones based on when you want them to be run
# You can create copies of this file and name is the same as this but with the next number after it (ex: unity-customrules2.sh)
# See instructions for TIMEOFEXEC values, do not remove it
# ^ DO NOT MODIFY ^
TIMEOFEXEC=2
if [ "$ABI" == "arm" ]; then
  ui_print "    Installing libs for arm/arm64 device"
  $CP_PRFX $INSTALLER/custom/lib/arm/libjamesdsp.so $UNITY$SYS/lib/soundfx/libjamesdsp.so
  $CP_PRFX $INSTALLER/custom/lib/arm/libjamesDSPImpulseToolbox.so $UNITY$SYS/lib/libjamesDSPImpulseToolbox.so
else
  ui_print "    Installing libs for x86 device"
  $CP_PRFX $INSTALLER/custom/lib/x86/libjamesdsp.so $UNITY$SYS/lib/soundfx/libjamesdsp.so
  $CP_PRFX $INSTALLER/custom/lib/x86/libjamesDSPImpulseToolbox.so $UNITY$SYS/lib/libjamesDSPImpulseToolbox.so
fi
