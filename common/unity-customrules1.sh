TIMEOFEXEC=3
if [ "$ABI" == "arm" ]; then
  $CP_PRFX $INSTALLER/custom/lib/arm/libjamesdsp.so $LIBDIR/lib/soundfx/libjamesdsp.so
  $CP_PRFX $INSTALLER/custom/lib/arm/libjamesDSPImpulseToolbox.so $LIBDIR/lib/libjamesDSPImpulseToolbox.so
else
  $CP_PRFX $INSTALLER/custom/lib/x86/libjamesdsp.so $LIBDIR/lib/soundfx/libjamesdsp.so
  $CP_PRFX $INSTALLER/custom/lib/x86/libjamesDSPImpulseToolbox.so $LIBDIR/lib/libjamesDSPImpulseToolbox.so
fi
# App only works when installed normally to data in oreo
if $OREONEW; then
  if $MAGISK; then
    mkdir -p $SDCARD/.jdsptempdonotdelete
    cp -f $INSTALLER/custom/JamesDSPManager/JamesDSPManager.apk $SDCARD/.jdsptempdonotdelete/JamesDSPManager.apk
  else
    cp -f $INSTALLER/custom/JamesDSPManager/JamesDSPManager.apk $SDCARD/JamesDSPManager.apk
    ui_print " "
    ui_print "   JamesDSPManager.apk copied to root of internal storage (sdcard)"
    ui_print "   Install manually after booting"
    sleep 2
  fi
else
  custom_app_install JamesDSPManager
fi
