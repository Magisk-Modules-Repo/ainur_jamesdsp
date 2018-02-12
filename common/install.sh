cp_ch $INSTALLER/custom/lib/$ABI/libjamesdsp.so $INSTALLER/system/lib/soundfx/libjamesdsp.so
cp_ch $INSTALLER/custom/lib/$ABI/libjamesDSPImpulseToolbox.so $INSTALLER/system/lib/libjamesDSPImpulseToolbox.so
# App only works when installed normally to data in oreo
if [ $API -ge 26 ]; then
  if $MAGISK; then
    LATESTARTSERVICE=true
    cp_ch $INSTALLER/system/app/JamesDSPManager/JamesDSPManager.apk $SDCARD/.jdsptempdonotdelete/JamesDSPManager.apk
  else
    cp_ch $INSTALLER/system/app/JamesDSPManager/JamesDSPManager.apk $SDCARD/JamesDSPManager.apk
    ui_print " "
    ui_print "   JamesDSPManager.apk copied to root of internal storage (sdcard)"
    ui_print "   Install manually after booting"
    sleep 2
  fi
  rm -rf $INSTALLER/system/app
fi
ui_print "   Patching existing audio_effects files..."
# Create vendor audio_effects.conf if missing
if [ -f $ORIGDIR/system/etc/audio_effects.conf ] && [ ! -f $ORIGDIR/system/vendor/etc/audio_effects.conf ] && [ ! -f $ORIGDIR/system/vendor/etc/audio_effects.xml ]; then
  cp_ch_nb $ORIGDIR/system/etc/audio_effects.conf $UNITY/system/vendor/etc/audio_effects.conf
  CFGS="${CFGS} /system/vendor/etc/audio_effects.conf"
fi
for FILE in ${CFGS}; do
  $MAGISK && cp_ch $ORIGDIR$FILE $UNITY$FILE
  case $FILE in
    *.conf) [ ! "$(grep '^ *# *music_helper {' $UNITY$FILE)" -a "$(grep '^ *music_helper {' $UNITY$FILE)" ] && sed -i "/effects {/,/^}/ {/music_helper {/,/}/ s/^/#/g}" $UNITY$FILE
            [ ! "$(grep '^ *# *sa3d {' $UNITY$FILE)" -a "$(grep '^ *sa3d {' $UNITY$FILE)" ] && sed -i "/effects {/,/^}/ {/sa3d {/,/^  }/ s/^/#/g}" $UNITY$FILE
            sed -i "/jamesdsp {/,/}/d" $UNITY$FILE
            sed -i "/jdsp {/,/}/d" $UNITY$FILE
            sed -i "s/^effects {/effects {\n  jamesdsp { #$MODID\n    library jdsp\n    uuid f27317f4-c984-4de6-9a90-545759495bf2\n  } #$MODID/g" $UNITY$FILE
            sed -i "s/^libraries {/libraries {\n  jdsp { #$MODID\n    path $LIBPATCH\/lib\/soundfx\/libjamesdsp.so\n  } #$MODID/g" $UNITY$FILE;;
    *.xml) [ ! "$(grep '^ *<\!--<effect name=\"music_helper\"*' $UNITY$FILE)" -a "$(grep '^ *<effect name=\"music_helper\"*' $UNITY$FILE)" ] && sed -i "s/^\( *\)<effect name=\"music_helper\"\(.*\)/\1<\!--<effect name=\"music_helper\"\2-->/" $UNITY$FILE
           [ ! "$(grep '^ *<\!--<effect name=\"sa3d\"*' $UNITY$FILE)" -a "$(grep '^ *<effect name=\"sa3d\"*' $UNITY$FILE)" ] && sed -i "s/^\( *\)<effect name=\"sa3d\"\(.*\)/\1<\!--<effect name=\"sa3d\"\2-->/" $UNITY$FILE
           sed -i "/jamesdsp/d" $UNITY$FILE
           sed -i "/jdsp/d" $UNITY$FILE
           sed -i "/<libraries>/ a\        <library name=\"jdsp\" path=\"libjamesdsp.so\"\/><!--$MODID-->" $UNITY$FILE
           sed -i "/<effects>/ a\        <effect name=\"jamesdsp\" library=\"jdsp\" uuid=\"f27317f4-c984-4de6-9a90-545759495bf2\"\/><!--$MODID-->" $UNITY$FILE;;
  esac
done
