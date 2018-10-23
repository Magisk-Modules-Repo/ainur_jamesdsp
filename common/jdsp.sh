#!/system/bin/sh
MODID=<MODID>
if [ ! -d "$UNITY/$MODID" ]; then
  if [ "$(find /data/app -type d -name "james.dsp*")" ]; then
    pm uninstall james.dsp
    while [ $? -ne 0 ]; do
      pm uninstall james.dsp
    done
    rm -rf /data/data/james.dsp
  fi
  rm $0
  [ "$SELINUX" == "Enforcing" ] && setenforce 1
  exit 0
elif [ "$(find /data/app -type d -name "james.dsp*")" ]; then
  pm list packages -d
  while [ $? -ne 0 ]; do
    pm list packages -d
  done
  STATUS="$(pm list packages -d | grep 'james.dsp')"
  if [ -f "$UNITY/$MODID/disable" ] && [ ! "$STATUS" ]; then
    pm disable james.dsp
  elif [ ! -f "$UNITY/$MODID/disable" ] && [ "$STATUS" ]; then
    pm enable james.dsp
  fi
elif [ ! -f "$UNITY/$MODID/disable" ] && [ ! "$(find /data/app -type d -name "james.dsp*")" ]; then
  pm install $UNITY/$MODID/JamesDSPManager.apk
  while [ $? -ne 0 ]; do
    pm install $UNITY/$MODID/JamesDSPManager.apk
  done
  pm disable james.dsp
  pm enable james.dsp
fi
