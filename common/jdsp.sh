#!/system/bin/sh
MODID=<MODID>
pm list packages -3
while [ $? -ne 0 ]; do
  sleep 1
  pm list packages -3
done
APP=$(pm list packages -3 | grep james.dsp)

if [ ! -d "$UNITY/$MODID" ]; then
  if [ "$APP" ]; then
    pm uninstall james.dsp
    rm -rf /data/data/james.dsp
  fi
  rm $0
  exit 0
elif [ "$APP" ]; then
  STATUS="$(pm list packages -d | grep 'james.dsp')"
  if [ -f "$UNITY/$MODID/disable" ] && [ ! "$STATUS" ]; then
    pm disable james.dsp
  elif [ ! -f "$UNITY/$MODID/disable" ] && [ "$STATUS" ]; then
    pm enable james.dsp
  fi
elif [ ! -f "$UNITY/$MODID/disable" ] && [ ! "$APP" ]; then
  pm install $UNITY/$MODID/JamesDSPManager.apk
  while [ $? -ne 0 ]; do
    sleep 1
    pm install $UNITY/$MODID/JamesDSPManager.apk
  done
  pm disable james.dsp
  pm enable james.dsp
fi
