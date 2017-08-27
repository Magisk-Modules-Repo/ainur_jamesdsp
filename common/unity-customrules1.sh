# v DO NOT MODIFY v
# See instructions file for predefined variables
# User defined custom rules
# Can have multiple ones based on when you want them to be run
# You can create copies of this file and name is the same as this but with the next number after it (ex: unity-customrules2.sh)
# See instructions for TIMEOFEXEC values, do not remove it
# Do not remove last 3 lines (the if statement). Add any files added in custom rules before the sed statement and uncomment the whole thing (ex: echo "$UNITY$SYS/lib/soundfx/libv4a_fx_ics.so" >> $INFO)
# ^ DO NOT MODIFY ^
TIMEOFEXEC=3
if [ "$ABI" == "arm" ]; then
  ui_print "    Installing lib for arm/arm64 device"
  $CP_PRFX $INSTALLER/system/lib/arm/libjamesdsp.so $UNITY$SYS/lib/soundfx/libjamesdsp.so$CP_SFFX
  unzip -pq $INSTALLER/system/app/$APP1/$APP1.apk lib/armeabi-v7a/libjamesDSPImpulseToolbox.so > $UNITY$SYS/lib/libjamesDSPImpulseToolbox.so
else
  ui_print "    Installing lib for x86 device"
  $CP_PRFX $INSTALLER/system/lib/x86/libjamesdsp.so $UNITY$SYS/lib/soundfx/libjamesdsp.so$CP_SFFX
  unzip -pq $INSTALLER/system/app/$APP1/$APP1.apk lib/x86/libjamesDSPImpulseToolbox.so > $UNITY$SYS/lib/libjamesDSPImpulseToolbox.so
fi
if [ "$MAGISK" == false ]; then
	echo "$UNITY$SYS/lib/soundfx/libjamesDSPImpulseToolbox.so" >> $INFO
    sed -i 's/\/system\///g' $INFO
fi
