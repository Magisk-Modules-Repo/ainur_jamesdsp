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
FILES=$(find $NVBASE/modules/*/system $MODULEROOT/*/system -type f -name "*audio_effects*.conf" -o -name "*audio_effects*.xml" 2>/dev/null)
if [ ! -z "$FILES" ] && [ ! "$(echo $FILES | grep '/aml/')" ]; then
  ui_print " "
  ui_print "   ! Conflicting audio mod found!"
  ui_print "   ! You will need to install !"
  ui_print "   ! Audio Modification Library !"
  sleep 3
fi

ui_print " "
ui_print "- Select Version -"
ui_print "  New or Old app?"
ui_print "  Vol+ New (recommended), Vol- Old"
if $VKSEL; then
  VER=new
  ui_print "  Note that profiles for old jdsp are incompatible"
  ui_print "  And will cause app to crash!"
else
  VER=old
  # Check for devices that need lib workaround
  if device_check -m "Essential Products" || device_check -m "Google" || device_check "sailfish" || device_check "marlin"; then
    LIBWA=true
  fi
  ui_print " "
  ui_print "- Select Driver -"
  ui_print "   Choose which drivers you want installed:"
  ui_print "   Vol Up = Full feature (Highly recommended)"
  ui_print "   Vol Down = Bit perfect"
  if $VKSEL; then
    QUAL=ff
  else
    QUAL=bp
  fi
  ui_print " "
  ui_print " - Use lib workaround? -"
  ui_print "   Only choose yes if you're having issues"
  ui_print "   Vol+ = yes, Vol- = no (recommended)"
  if $VKSEL; then
    LIBWA=true
  else
    LIBWA=false
  fi
fi

ui_print " "
ui_print "- Select Huawei -"
ui_print "   Is this a Huawei device?"
ui_print "   Vol Up = Yes, Vol Down = No"
if $VKSEL; then
  HUAWEI=true
else
  HUAWEI=false
fi

tar -xf $MODPATH/common/$VER.tar.xz -C $MODPATH/common 2>/dev/null
[ "$VER" == "new" ] && cp -rf $MODPATH/common/$VER/JamesDSP /storage/emulated/0/
$HUAWEI && { QARCH="huawei"; cp_ch $MODPATH/common/$VER/$QUAL/$QARCH/libjamesdsp.so $MODPATH/system/lib64/soundfx/libjamesdsp.so; } || QARCH=$ARCH32
cp_ch $MODPATH/common/$VER/$QUAL/$QARCH/libjamesdsp.so $MODPATH/system/lib/soundfx/libjamesdsp.so
# App only works when installed normally to data in oreo+
if [ $API -ge 26 ] || [ "$VER" == "new" ]; then
  install_script -l $MODPATH/common/jdsp.sh
  cp -f $MODPATH/common/$VER/$QUAL/JamesDSPManager.apk $MODPATH/JamesDSPManager.apk
else
  cp_ch $MODPATH/common/$VER/$QUAL/JamesDSPManager.apk $MODPATH/system/priv-app/JamesDSPManager/JamesDSPManager.apk
  cp_ch $MODPATH/common/$VER/$QUAL/$QARCH/libjamesDSPImpulseToolbox.so $MODPATH/system/lib/libjamesDSPImpulseToolbox.so
  cp_ch $MODPATH/common/$VER/privapp-permisisons-james.dsp.xml $MODPATH/system/etc/privapp-permisisons-james.dsp.xml
fi

ui_print " "
# Lib fix for pixel 2's, 3's, and essential phone
if $LIBWA; then
  ui_print "   Applying lib workaround..."
  if [ -f $ORIGDIR/system/lib/libstdc++.so ] && [ ! -f $ORIGDIR/vendor/lib/libstdc++.so ]; then
    cp_ch $ORIGDIR/system/lib/libstdc++.so $MODPATH/system/vendor/lib/libstdc++.so
  elif [ -f $ORIGDIR/vendor/lib/libstdc++.so ] && [ ! -f $ORIGDIR/system/lib/libstdc++.so ]; then
    cp_ch $ORIGDIR/vendor/lib/libstdc++.so $MODPATH/system/lib/libstdc++.so
  fi
fi

ui_print "   Patching existing audio_effects files..."
CFGS="$(find /system /vendor -type f -name "*audio_effects*.conf" -o -name "*audio_effects*.xml")"
for OFILE in ${CFGS}; do
  FILE="$MODPATH$(echo $OFILE | sed "s|^/vendor|/system/vendor|g")"
  cp_ch -n $ORIGDIR$OFILE $FILE
  osp_detect $FILE
  case $FILE in
    *.conf) sed -i "/jamesdsp {/,/}/d" $FILE
            sed -i "/jdsp {/,/}/d" $FILE
            sed -i "s/^effects {/effects {\n  jamesdsp {\n    library jdsp\n    uuid f27317f4-c984-4de6-9a90-545759495bf2\n  }/g" $FILE
            sed -i "s/^libraries {/libraries {\n  jdsp {\n    path $LIBPATCH\/lib\/soundfx\/libjamesdsp.so\n  }/g" $FILE;;
    *.xml) sed -i "/jamesdsp/d" $FILE
           sed -i "/jdsp/d" $FILE
           sed -i "/<libraries>/ a\        <library name=\"jdsp\" path=\"libjamesdsp.so\"\/>" $FILE
           sed -i "/<effects>/ a\        <effect name=\"jamesdsp\" library=\"jdsp\" uuid=\"f27317f4-c984-4de6-9a90-545759495bf2\"\/>" $FILE;;
  esac
done

[ $API -gt 29 ] && { ui_print "   Enabling hidden api policy"; settings put global hidden_api_policy 1; }
