# v DO NOT MODIFY v
# Uncomment AUDMODLIB=true if using audio modifcation library (if you're using a sound module). Otherwise, keep it commented
# Uncomment and change 'MINAPI' and 'MAXAPI' to the minimum and maxium android version for your mod (note that magisk has it's own minimum api: 21 (lollipop))
# ^ DO NOT MODIFY ^
#MINAPI=21
#MAXAPI=25
AUDMODLIB=true
if $BOOTMODE; then SDCARD=/storage/emulated/0; else SDCARD=/data/media/0; fi
if $OREONEW && $MAGISK; then LATESTARTSERVICE=true; fi
