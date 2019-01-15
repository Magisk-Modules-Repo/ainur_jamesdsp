(
while [ $(getprop sys.boot_completed) -ne 1 ] || [ "$(getprop init.svc.bootanim | tr '[:upper:]' '[:lower:]')" != "stopped" ]; do
  sleep 1
done

APP=$(pm list packages -3 | grep james.dsp)

if [ ! -d "$UNITY" ]; then
  if [ "$APP" ]; then
    pm uninstall james.dsp
    rm -rf /data/data/james.dsp
  fi
  rm $0
  exit 0
elif [ "$APP" ]; then
  STATUS="$(pm list packages -d | grep 'james.dsp')"
  if [ -f "$UNITY/disable" ] && [ ! "$STATUS" ]; then
    pm disable james.dsp
  elif [ ! -f "$UNITY/disable" ] && [ "$STATUS" ]; then
    pm enable james.dsp
  fi
elif [ ! -f "$UNITY/disable" ] && [ ! "$APP" ]; then
  pm install $UNITY/JamesDSPManager.apk
  pm disable james.dsp
  pm enable james.dsp
fi
)&
