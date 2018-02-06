rm -rf $SDCARD/.jdsptempdonotdelete
[ $API -ge 26 ] && { rm -rf /data/data/james.dsp; rm -rf /data/app/james.dsp*; }

$MAGISK || { for FILE in ${CFGS}; do
               case $FILE in
                 *.conf) sed -i "/jamesdsp { #$MODID/,/} #$MODID/d" $UNITY$FILE
                         sed -i "/jdsp { #$MODID/,/} #$MODID/d" $UNITY$FILE;;
                 *.xml) sed -i "/<!--$MODID-->/d" $UNITY$FILE;;
               esac
             done }
