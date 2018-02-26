# GET HQ/SQ FROM ZIP NAME
case $(basename $ZIP) in
  *sq*|*Sq*|*SQ*) QUAL=sq;;
  *hq*|*Hq*|*HQ*) QUAL=hq;;
esac

# Keycheck binary by someone755 @Github, idea for code below by Zappo @xda-developers
chmod 755 $INSTALLER/common/keycheck
FUNCTION=chooseport

chooseport() {
  ui_print "   Choose which drivers you want installed:"
  ui_print "   Vol Up = HQ, Vol Down = SQ"
  #note from chainfire @xda-developers: getevent behaves weird when piped, and busybox grep likes that even less than toolbox/toybox grep
  while (true); do
    (getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > $INSTALLER/events) || { FUNCTION=chooseportold; chooseportold; break; }
    if (`cat $INSTALLER/events 2>/dev/null | /system/bin/grep VOLUME >/dev/null`); then
      break
    fi
  done
  if (`cat $INSTALLER/events 2>/dev/null | /system/bin/grep VOLUMEUP >/dev/null`); then
    return 0
  else
    return 1
  fi
}

chooseportold() {
  ui_print "   ! Legacy device detected!"
  ui_print "   ! Restarting selection w/ old keycheck method"
  ui_print " "
  ui_print "   Enter selection again:"
  $INSTALLER/common/keycheck
  SEL=$?
  shift
  if [ $SEL -eq 42 ]; then
    return 0
  elif [ $SEL -eq 21 ]; then
    return 1
  else
    ui_print "Vol key not detected! Defaulting to Vol Up! "
    return 0
  fi
}

[ -z $QUAL ] && { if $FUNCTION; then QUAL=hq; else QUAL=sq; fi; }
cp_ch $INSTALLER/custom/$QUAL/$ABI/libjamesdsp.so $INSTALLER/system/lib/soundfx/libjamesdsp.so
cp_ch $INSTALLER/custom/$ABI/libjamesDSPImpulseToolbox.so $INSTALLER/system/lib/libjamesDSPImpulseToolbox.so
# App only works when installed normally to data in oreo
if [ $API -ge 26 ]; then
  cp -f $INSTALLER/system/app/JamesDSPManager/JamesDSPManager.apk $SDCARD/JamesDSPManager.apk
  ui_print " "
  ui_print "   JamesDSPManager.apk copied to root of internal storage (sdcard)"
  ui_print "   Install manually after booting"
  sleep 2
  rm -rf $INSTALLER/system/app
fi
ui_print "   Patching existing audio_effects files..."
for FILE in ${CFGS}; do
  if $MAGISK; then
    cp_ch $ORIGDIR$FILE $UNITY$FILE
  else
    [ ! -f $ORIGDIR$FILE.bak ] && cp_ch $ORIGDIR$FILE $UNITY$FILE.bak
  fi
  case $FILE in
    *.conf) sed -i "/effects {/,/^}/ {/^ *music_helper {/,/}/ s/^/#/g}" $UNITY$FILE
            sed -i "/effects {/,/^}/ {/^ *sa3d {/,/^  }/ s/^/#/g}" $UNITY$FILE
            sed -i "/jamesdsp {/,/}/d" $UNITY$FILE
            sed -i "/jdsp {/,/}/d" $UNITY$FILE
            sed -i "s/^effects {/effects {\n  jamesdsp { #$MODID\n    library jdsp\n    uuid f27317f4-c984-4de6-9a90-545759495bf2\n  } #$MODID/g" $UNITY$FILE
            sed -i "s/^libraries {/libraries {\n  jdsp { #$MODID\n    path $LIBPATCH\/lib\/soundfx\/libjamesdsp.so\n  } #$MODID/g" $UNITY$FILE;;
    *.xml) sed -ri "/^ *<postprocess>$/,/<\/postprocess>/ {/<stream type=\"music\">/,/<\/stream>/ s/^( *)<apply effect=\"music_helper\"\/>/\1<\!--<apply effect=\"music_helper\"\/>-->/}" $UNITY$FILE
           sed -ri "/^ *<postprocess>$/,/<\/postprocess>/ {/<stream type=\"music\">/,/<\/stream>/ s/^( *)<apply effect=\"sa3d\"\/>/\1<\!--<apply effect=\"sa3d\"\/>-->/}" $UNITY$FILE
           sed -i "/jamesdsp/d" $UNITY$FILE
           sed -i "/jdsp/d" $UNITY$FILE
           sed -i "/<libraries>/ a\        <library name=\"jdsp\" path=\"libjamesdsp.so\"\/><!--$MODID-->" $UNITY$FILE
           sed -i "/<effects>/ a\        <effect name=\"jamesdsp\" library=\"jdsp\" uuid=\"f27317f4-c984-4de6-9a90-545759495bf2\"\/><!--$MODID-->" $UNITY$FILE;;
  esac
done
