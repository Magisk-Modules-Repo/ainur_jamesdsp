TIMEOFEXEC=2
if [ "$ABI" == "arm" ]; then
  $CP_PRFX $INSTALLER/custom/lib/arm/libjamesdsp.so $UNITY$SYS/lib/soundfx/libjamesdsp.so
  $CP_PRFX $INSTALLER/custom/lib/arm/libjamesDSPImpulseToolbox.so $UNITY$SYS/lib/libjamesDSPImpulseToolbox.so
else
  $CP_PRFX $INSTALLER/custom/lib/x86/libjamesdsp.so $UNITY$SYS/lib/soundfx/libjamesdsp.so
  $CP_PRFX $INSTALLER/custom/lib/x86/libjamesDSPImpulseToolbox.so $UNITY$SYS/lib/libjamesDSPImpulseToolbox.so
fi
