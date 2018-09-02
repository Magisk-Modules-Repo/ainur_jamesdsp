if [ $API -ge 26 ] && ! $MAGISK; then
  rm -rf /data/app/james.dsp*
  rm -rf /data/data/james.dsp
  rm -f $SDCARD/JamesDSPManager.apk
fi

if ! $MAGISK || $SYSOVERRIDE; then
  for OFILE in ${CFGS}; do
    FILE="$UNITY$(echo $OFILE | sed "s|^/vendor|/system/vendor|g")"
    case $FILE in
      *.conf) sed -i "/jamesdsp { #$MODID/,/} #$MODID/d" $FILE
              sed -i "/jdsp { #$MODID/,/} #$MODID/d" $FILE;;
      *.xml) sed -i "/<!--$MODID-->/d" $FILE;;
    esac
  done
fi
