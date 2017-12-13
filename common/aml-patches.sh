ui_print "    Patching existing audio_effects files..."
for FILE in ${CFGS}; do
  if [ ! "$(grep "jamesdsp" $AMLPATH$FILE)" ] && [ ! "$(grep "jdsp" $AMLPATH$FILE)" ]; then
    sed -i "s/^effects {/effects {\n  jamesdsp {\n    library jdsp\n    uuid f27317f4-c984-4de6-9a90-545759495bf2\n  }/g" $AMLPATH$FILE
    sed -i "s/^libraries {/libraries {\n  jdsp {\n    path $LIBPATCH\/lib\/soundfx\/libjamesdsp.so\n  }/g" $AMLPATH$FILE
  fi
done
for FILE in ${CFGSXML}; do
  if [ ! "$(grep "jamesdsp" $AMLPATH$FILE)" ] && [ ! "$(grep "jdsp" $AMLPATH$FILE)" ]; then
    sed -i "/<libraries>/ a\        <library name=\"jdsp\" path=\"libjamesdsp.so\"\/>" $AMLPATH$FILE
    sed -i "/<effects>/ a\        <effect name=\"jamesdsp\" library=\"jdsp\" uuid=\"f27317f4-c984-4de6-9a90-545759495bf2\"\/>" $AMLPATH$FILE
  fi
done
