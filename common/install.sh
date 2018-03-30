ospeff_rem() {
  case $2 in
    *.conf) [ "$(sed -n "/^output_session_processing {/,/^}/ {/$1/p}" $2)" ] && sed -i "/effects {/,/^}/ {/^ *$1 {/,/}/ s/^/#/g}" $2;;
    *.xml) sed -ri "/^ *<postprocess>$/,/<\/postprocess>/ {/<stream type=\"music\">/,/<\/stream>/ s/^( *)<apply effect=\"$1\"\/>/\1<\!--<apply effect=\"$1\"\/>-->/}" $2;;
  esac
}

# GET HQ/SQ FROM ZIP NAME
case $(basename $ZIP) in
  *sq*|*Sq*|*SQ*) QUAL=sq;;
  *hq*|*Hq*|*HQ*) QUAL=hq;;
esac

# Keycheck binary by someone755 @Github, idea for code below by Zappo @xda-developers
chmod 755 $INSTALLER/common/keycheck

keytest() {
  ui_print "- Vol Key Test -"
  ui_print "   Press Vol Up:"
  (/system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > $INSTALLER/events) || return 1
  return 0
}   
                                                                            
chooseport() {
  #note from chainfire @xda-developers: getevent behaves weird when piped, and busybox grep likes that even less than toolbox/toybox grep
  while (true); do
    /system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > $INSTALLER/events
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
  # Calling it first time detects previous input. Calling it second time will do what we want
  $INSTALLER/common/keycheck
  $INSTALLER/common/keycheck
  SEL=$?
  if [ "$1" == "UP" ]; then
    UP=$SEL
  elif [ "$1" == "DOWN" ]; then
    DOWN=$SEL
  elif [ $SEL -eq $UP ]; then
    return 0
  elif [ $SEL -eq $DOWN ]; then
    return 1
  else
    ui_print "   Vol key not detected!"
    abort "   Use name change method in TWRP"
  fi
}
ui_print " "
if [ -z $QUAL ]; then
  if keytest; then
    FUNCTION=chooseport
  else
    FUNCTION=chooseportold
    ui_print "   ! Legacy device detected! Using old keycheck method"
    ui_print " "
    ui_print "- Vol Key Programming -"
    ui_print "   Press Vol Up Again:"
    $FUNCTION "UP"
    ui_print "   Press Vol Down"
    $FUNCTION "DOWN"
  fi
  ui_print " "
  ui_print "- Select Driver -"
  ui_print "   Choose which drivers you want installed:"
  ui_print "   Vol Up = HQ, Vol Down = SQ"
  if $FUNCTION; then 
    QUAL=hq
  else 
    QUAL=sq
  fi
else
  ui_print "   Driver quality specified in zipname!"
fi

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
  cp_ch $ORIGDIR$FILE $UNITY$FILE
  ospeff_rem "music_helper" $UNITY$FILE
  ospeff_rem "sa3d" $UNITY$FILE
  ospeff_rem "soundalive" $UNITY$FILE
  ospeff_rem "dha" $UNITY$FILE
  case $FILE in
    *.conf) sed -i "/jamesdsp {/,/}/d" $UNITY$FILE
            sed -i "/jdsp {/,/}/d" $UNITY$FILE
            sed -i "s/^effects {/effects {\n  jamesdsp { #$MODID\n    library jdsp\n    uuid f27317f4-c984-4de6-9a90-545759495bf2\n  } #$MODID/g" $UNITY$FILE
            sed -i "s/^libraries {/libraries {\n  jdsp { #$MODID\n    path $LIBPATCH\/lib\/soundfx\/libjamesdsp.so\n  } #$MODID/g" $UNITY$FILE;;
    *.xml) sed -i "/jamesdsp/d" $UNITY$FILE
           sed -i "/jdsp/d" $UNITY$FILE
           sed -i "/<libraries>/ a\        <library name=\"jdsp\" path=\"libjamesdsp.so\"\/><!--$MODID-->" $UNITY$FILE
           sed -i "/<effects>/ a\        <effect name=\"jamesdsp\" library=\"jdsp\" uuid=\"f27317f4-c984-4de6-9a90-545759495bf2\"\/><!--$MODID-->" $UNITY$FILE;;
  esac
done
