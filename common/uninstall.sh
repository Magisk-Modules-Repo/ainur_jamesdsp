if [ $API -ge 26 ]; then
  $BOOTMODE && pm uninstall james.dsp || rm -rf /data/app/james.dsp* 
  rm -rf /data/data/james.dsp
  rm -f $SDCARD/JamesDSPManager.apk
fi
