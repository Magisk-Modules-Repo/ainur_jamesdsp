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
if $MAGISK && ! $SYSOVERRIDE; then
  if $BOOTMODE; then LOC="/sbin/.core/img/*/system $MOUNTPATH/*/system"; else LOC="$MOUNTPATH/*/system"; fi
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
case $(echo $(basename $ZIP) | tr '[:upper:]' '[:lower:]') in
  *sq*) QUAL=sq;;
  *hq*) QUAL=hq;;
esac
case $(echo $(basename $ZIP) | tr '[:upper:]' '[:lower:]') in
  *nhua*) HUAWEI=false;;
  *hua*) HUAWEI=true;;
esac
IFS=$OIFS

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
  while true; do
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
if [ -z $QUAL ] || [ -z $HUAWEI ]; then
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
  if [ -z $QUAL ]; then
    ui_print " "
    ui_print "- Select Driver -"
    ui_print "   Choose which drivers you want installed:"
    ui_print "   Vol Up = HQ (Slow, bit perfect)"
    ui_print "   Vol Down = SQ (Fast, full feature)"
    if $FUNCTION; then
      QUAL=hq
    else
      QUAL=sq
    fi
  else
    ui_print "   Driver quality specified in zipname!"
  fi
  if [ -z $HUAWEI ]; then
    ui_print " "
    ui_print "- Select Huawei -"
    ui_print "   Is this a Huawei device?"
    ui_print "   Vol Up = Yes, Vol Down = No"
    if $FUNCTION; then
      HUAWEI=true
    else
      HUAWEI=false
    fi
  else
    ui_print "   Driver quality specified in zipname!"
  fi
else
  ui_print "   Options specified in zipname!"
fi

if [ "$QUAL" == "hq" ]; then
  ui_print "   High Quality drivers selected!"
else
  ui_print "   Standard Quality drivers selected!"
fi

tar -xf $INSTALLER/custom/$QUAL.tar.xz -C $INSTALLER/custom 2>/dev/null
QARCH=$ARCH32
$HUAWEI && { QARCH="huawei"; ui_print "   Huawei device selected!"; cp_ch $INSTALLER/custom/$QUAL/$QARCH/libjamesdsp.so $INSTALLER/system/lib64/soundfx/libjamesdsp.so; }

ui_print " "

cp_ch $INSTALLER/custom/$QUAL/$QARCH/libjamesdsp.so $INSTALLER/system/lib/soundfx/libjamesdsp.so
cp_ch $INSTALLER/custom/$QUAL/JamesDSPManager.apk $INSTALLER/system/app/JamesDSPManager/JamesDSPManager.apk
# App only works when installed normally to data in oreo+
if [ $API -ge 26 ]; then
  if $MAGISK; then
    install_script -l $INSTALLER/common/jdsp.sh
    cp -f $INSTALLER/system/app/JamesDSPManager/JamesDSPManager.apk $UNITY/JamesDSPManager.apk
  else
    cp -f $INSTALLER/system/app/JamesDSPManager/JamesDSPManager.apk $SDCARD/JamesDSPManager.apk
    ui_print " "
    ui_print "   JamesDSPManager.apk copied to root of internal storage (sdcard)"
    ui_print "   Install manually after booting"
    sleep 2
  fi
  rm -rf $INSTALLER/system/app
else
  cp_ch $INSTALLER/custom/$QUAL/$QARCH/libjamesDSPImpulseToolbox.so $INSTALLER/system/lib/libjamesDSPImpulseToolbox.so
fi

# Lib fix for pixel 2's, 3's, and essential phone
if device_check "walleye" || device_check "taimen" || device_check "crosshatch" || device_check "blueline" || device_check "mata" || device_check "jasmine"; then
  if [ -f $ORIGDIR/system/lib/libstdc++.so ] && [ ! -f $ORIGVEN/lib/libstdc++.so ]; then
    cp_ch $ORIGDIR/system/lib/libstdc++.so $UNITY$VEN/lib/libstdc++.so
  elif [ -f $ORIGVEN/lib/libstdc++.so ] && [ ! -f $ORIGDIR/system/lib/libstdc++.so ]; then
    cp_ch $ORIGVEN/lib/libstdc++.so $UNITY/system/lib/libstdc++.so
  fi
fi

ui_print "   Patching existing audio_effects files..."
for OFILE in ${CFGS}; do
  FILE="$UNITY$(echo $OFILE | sed "s|^/vendor|/system/vendor|g")"
  cp_ch -nn $ORIGDIR$OFILE $FILE
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
