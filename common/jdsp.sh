(
while [ "$(getprop sys.boot_completed)" != "1" ] && [ ! -d "/storage/emulated/0/Android" ]; do
  sleep 1
done

APP=$(pm list packages -3 | grep james.dsp)

if [ ! -d "$MODPATH" ]; then
  if [ "$APP" ]; then
    pm uninstall james.dsp
    rm -rf /data/data/james.dsp
  fi
  rm $0
  exit 0
elif [ "$APP" ]; then
  STATUS="$(pm list packages -d | grep 'james.dsp')"
  if [ -f "$MODPATH/disable" ] && [ ! "$STATUS" ]; then
    pm disable james.dsp
  elif [ ! -f "$MODPATH/disable" ] && [ "$STATUS" ]; then
    pm enable james.dsp
  fi
elif [ ! -f "$MODPATH/disable" ] && [ ! "$APP" ]; then
  pm install $MODPATH/JamesDSPManager.apk
  pm disable james.dsp
  pm enable james.dsp
fi
)&
