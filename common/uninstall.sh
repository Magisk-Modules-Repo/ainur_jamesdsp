if [ $API -ge 26 ]; then
  $BOOTMODE && { ui_print "   Uninstalling JamesDSPManager apk..."; pm uninstall james.dsp >/dev/null 2>&1; }
  rm -rf /data/app/james.dsp*
  rm -rf /data/data/james.dsp
  rm -f $SDCARD/JamesDSPManager.apk
fi

$MAGISK || { for OFILE in ${CFGS}; do
               FILE="$UNITY$(echo $OFILE | sed "s|^/vendor|/system/vendor|g")"
               case $FILE in
                 *.conf) sed -i "/jamesdsp { #$MODID/,/} #$MODID/d" $FILE
                         sed -i "/jdsp { #$MODID/,/} #$MODID/d" $FILE;;
                 *.xml) sed -i "/<!--$MODID-->/d" $FILE;;
               esac
             done }
