[ $API -ge 26 ] && { rm -rf /data/data/james.dsp; rm -rf /data/app/james.dsp*; rm -f $SDCARD/JamesDSPManager.apk; }

$MAGISK || { for OFILE in ${CFGS}; do
               FILE="$UNITY$(echo $OFILE | sed "s|^/vendor|/system/vendor|g")"
               case $FILE in
                 *.conf) sed -i "/jamesdsp { #$MODID/,/} #$MODID/d" $FILE
                         sed -i "/jdsp { #$MODID/,/} #$MODID/d" $FILE;;
                 *.xml) sed -i "/<!--$MODID-->/d" $FILE;;
               esac
             done }
