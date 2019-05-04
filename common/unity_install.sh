osp_detect() {
  case $1 in
    *.conf) SPACES=$(sed -n "/^output_session_processing {/,/^}/ {/^ *music {/p}" $1 | sed -r "s/( *).*/\1/")
            EFFECTS=$(sed -n "/^output_session_processing {/,/^}/ {/^$SPACES\music {/,/^$SPACES}/p}" $1 | grep -E "^$SPACES +[A-Za-z]+" | sed -r "s/( *.*) .*/\1/g")
            for EFFECT in ${EFFECTS}; do
              SPACES=$(sed -n "/^effects {/,/^}/ {/^ *$EFFECT {/p}" $1 | sed -r "s/( *).*/\1/")
              [ "$EFFECT" != "atmos" ] && sed -i "/^effects {/,/^}/ {/^$SPACES$EFFECT {/,/^$SPACES}/ s/^/#/g}" $1
            done;;
     *.xml) EFFECTS=$(sed -n "/^ *<postprocess>$/,/^ *<\/postprocess>$/ {/^ *<stream type=\"music\">$/,/^ *<\/stream>$/ {/<stream type=\"music\">/d; /<\/stream>/d; s/<apply effect=\"//g; s/\"\/>//g; p}}" $1)
            for EFFECT in ${EFFECTS}; do
              [ "$EFFECT" != "atmos" ] && sed -ri "s/^( *)<apply effect=\"$EFFECT\"\/>/\1<\!--<apply effect=\"$EFFECT\"\/>-->/" $1
            done;;
  esac
}

# Tell user aml is needed if applicable
if $MAGISK && ! $SYSOVER; then
  if $BOOTMODE; then LOC="$MOUNTEDROOT/*/system $MODULEROOT/*/system"; else LOC="$MODULEROOT/*/system"; fi
  FILES=$(find $LOC -type f -name "*audio_effects*.conf" -o -name "*audio_effects*.xml" 2>/dev/null)
  if [ ! -z "$FILES" ] && [ ! "$(echo $FILES | grep '/aml/')" ]; then
    ui_print " "
    ui_print "   ! Conflicting audio mod found!"
    ui_print "   ! You will need to install !"
    ui_print "   ! Audio Modification Library !"
    sleep 3
  fi
fi

# GET HQ/SQ AND HUAWEI FROM ZIP NAME
OIFS=$IFS; IFS=\|
case $(echo $(basename $ZIPFILE) | tr '[:upper:]' '[:lower:]') in
  *ff*) QUAL=ff;;
  *bp*) QUAL=bp;;
esac
case $(echo $(basename $ZIPFILE) | tr '[:upper:]' '[:lower:]') in
  *nhua*) HUAWEI=false;;
  *hua*) HUAWEI=true;;
esac
case $(echo $(basename $ZIPFILE) | tr '[:upper:]' '[:lower:]') in
  *lib*) LIBWA=true;;
  *nlib*) LIBWA=false;;
esac
IFS=$OIFS

# Check for devices that need lib workaround
if device_check "walleye" || device_check "taimen" || device_check "crosshatch" || device_check "blueline" || device_check "mata" || device_check "jasmine" || device_check "star2lte" || device_check "z2_row"; then
  LIBWA=true
fi

ui_print " "
if [ -z $QUAL ] || [ -z $HUAWEI ] || [ -z $LIBWA ]; then
  if [ -z $QUAL ]; then
    ui_print "- Select Driver -"
    ui_print "   Choose which drivers you want installed:"
    ui_print "   Vol Up = Full feature (Highly recommended)"
    ui_print "   Vol Down = Bit perfect"
    if $VKSEL; then
      QUAL=ff
    else
      QUAL=bp
    fi
  else
    ui_print "   Driver quality specified in zipname!"
  fi
  if [ -z $HUAWEI ]; then
    ui_print " "
    ui_print "- Select Huawei -"
    ui_print "   Is this a Huawei device?"
    ui_print "   Vol Up = Yes, Vol Down = No"
    if $VKSEL; then
      HUAWEI=true
    else
      HUAWEI=false
    fi
  else
    ui_print "   Driver quality specified in zipname!"
  fi
  if [ -z $LIBWA ]; then
    ui_print " "
    ui_print " - Use lib workaround? -"
    ui_print "   Only choose yes if you're having issues"
    ui_print "   Vol+ = yes, Vol- = no (recommended)"
    if $VKSEL; then
      LIBWA=true
    else
      LIBWA=false
    fi
  else
    ui_print "   Lib workaround option specified in zipname!"
  fi
else
  ui_print "   Options specified in zipname!"
fi

if [ "$QUAL" == "ff" ]; then
  ui_print "   Full feature drivers selected!"
else
  ui_print "   Bit perfect drivers selected!"
fi

tar -xf $TMPDIR/custom/$QUAL.tar.xz -C $TMPDIR/custom 2>/dev/null
QARCH=$ARCH32
$HUAWEI && { QARCH="huawei"; ui_print "   Huawei device selected!"; cp_ch $TMPDIR/custom/$QUAL/$QARCH/libjamesdsp.so $TMPDIR/system/lib64/soundfx/libjamesdsp.so; }

ui_print " "

cp_ch $TMPDIR/custom/$QUAL/$QARCH/libjamesdsp.so $TMPDIR/system/lib/soundfx/libjamesdsp.so
cp_ch $TMPDIR/custom/$QUAL/JamesDSPManager.apk $TMPDIR/system/priv-app/JamesDSPManager/JamesDSPManager.apk
# App only works when installed normally to data in oreo+
if [ $API -ge 26 ]; then
  if $MAGISK; then
    install_script -l $TMPDIR/common/jdsp.sh
    cp -f $TMPDIR/system/priv-app/JamesDSPManager/JamesDSPManager.apk $UNITY/JamesDSPManager.apk
  else
    cp -f $TMPDIR/system/priv-app/JamesDSPManager/JamesDSPManager.apk $SDCARD/JamesDSPManager.apk
    ui_print " "
    ui_print "   JamesDSPManager.apk copied to root of internal storage (sdcard)"
    ui_print "   Install manually after booting"
    sleep 2
  fi
  rm -rf $TMPDIR/system/priv-app
else
  cp_ch $TMPDIR/custom/$QUAL/$QARCH/libjamesDSPImpulseToolbox.so $TMPDIR/system/lib/libjamesDSPImpulseToolbox.so
fi

# Lib fix for pixel 2's, 3's, and essential phone
if $LIBWA; then
  ui_print "   Applying lib workaround..."
  if [ -f $ORIGDIR/system/lib/libstdc++.so ] && [ ! -f $ORIGVEN/lib/libstdc++.so ]; then
    cp_ch $ORIGDIR/system/lib/libstdc++.so $UNITY$VEN/lib/libstdc++.so
  elif [ -f $ORIGVEN/lib/libstdc++.so ] && [ ! -f $ORIGDIR/system/lib/libstdc++.so ]; then
    cp_ch $ORIGVEN/lib/libstdc++.so $UNITY/system/lib/libstdc++.so
  fi
fi

ui_print "   Patching existing audio_effects files..."
for OFILE in ${CFGS}; do
  FILE="$UNITY$(echo $OFILE | sed "s|^/vendor|/system/vendor|g")"
  cp_ch -i $ORIGDIR$OFILE $FILE
  osp_detect $FILE
  case $FILE in
    *.conf) sed -i "/jamesdsp {/,/}/d" $FILE
            sed -i "/jdsp {/,/}/d" $FILE
            sed -i "s/^effects {/effects {\n  jamesdsp { #$MODID\n    library jdsp\n    uuid f27317f4-c984-4de6-9a90-545759495bf2\n  } #$MODID/g" $FILE
            sed -i "s/^libraries {/libraries {\n  jdsp { #$MODID\n    path $LIBPATCH\/lib\/soundfx\/libjamesdsp.so\n  } #$MODID/g" $FILE;;
    *.xml) sed -i "/jamesdsp/d" $FILE
           sed -i "/jdsp/d" $FILE
           sed -i "/<libraries>/ a\        <library name=\"jdsp\" path=\"libjamesdsp.so\"\/><!--$MODID-->" $FILE
           sed -i "/<effects>/ a\        <effect name=\"jamesdsp\" library=\"jdsp\" uuid=\"f27317f4-c984-4de6-9a90-545759495bf2\"\/><!--$MODID-->" $FILE;;
  esac
done
