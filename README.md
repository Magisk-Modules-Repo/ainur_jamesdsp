# Ainur JamesDSPManager
This module enables JamesDSPManager. [More details in support thread](https://forum.xda-developers.com/android/software/soundmod-ainur-audio-t3450516).

### Dependencies
* [Audio Modification Library](https://forum.xda-developers.com/apps/magisk/module-audio-modification-library-t3579612) @ XDA Developers

## Compatibility
* Android Jellybean+
* Magisk install (MagiskSU)
* Pixel support
* System install
* Works with [AM3D Zirene Sound](https://forum.xda-developers.com/android/apps-games/mod-zirene-sound-am3d-t3396698/post71580634#post71580634}, [Dolby Atmos](https://github.com/therealahrion/Dolby-Atmos-ZTE-Axon-7), & ViPER4Android XHiFi

## Change Log
v1.5
	- AudModLib v1.5: Update sepolicy for magisk 13
	- AudModLib v1.5: Add unity system props
	- AudModLib v1.5: Added file backup/restore of modified files
	- AudModLib v1.5: Added vendor fix for nexus devices
	- Audmodlib v1.5: Added system_root support for pixel devices
	- Audmodlib v1.5: Added phh superuser and LOS su support (note, LOS doesn't support sepolicy patching)
	- Audmodlib v1.5: Added support for magisk imgs located in /cache/audmodlib
	- Audmodlib v1.5: Added @Osm0sis at xda-developers uninstaller idea (just add "uninstall" to zip name and it'll function as uninstaller)
	- Audmodlib v1.5: Added autouninstall (if mod is already installed and you flash same version zip again, it'll uninstall)
	- Audmodlib v1.5: Added system override (if you're on magisk but would rather have it install to system, add word "system" to zip name and it'll install everything but scripts to system)
	- Audmodlib v1.5: Added file/folder backup/restore of normally wiped files
	- Audmodlib v1.5: New modular approach - no need to modify update-binary anymore

v1.4
	- AudModLib v1.4 update which changes SELinux live patching to allow better compatibility between different devices, kernels, and roms; while also keeping the amount of "allowances" to a minumum
	- AudModLib v1.4: changed post-fs-data(.d)/service(.d) shell script names for cosmetic recognition
	- AudModLib v1.4: merge SuperSU shell script with MagiskSU post-fs-data(.d) script for less fragmentation
	- AudModLib v1.4: added /cache/audmodlib.log to determine if script has run successfully
	- AudModLib v1.4: more audio policy files and various mixer_paths files are now included in the framework
	- Install script changes that include: major update to Pixel (A/B OTA) support, mounting changes, improved script efficiency, fixes & consolidation, and cosmetic fixes
	- Add/fix proper addon.d support
	- App smali hacks

v1.3
	- AudModLib v1.3 update push which includes the script addition to allow various audio mods working with SELinux Enforcing
	- Remove (audmodlib)service.sh and replace with post-fs-data(.d) audmodlib.sh, which should fix when root may be lost upon installing certain mods
	- System install will now have the same script updates as the AudModLib v1.3 to allow to work in SELinux Enforcing

v1.2
	- Added audmodlib.sh post-fs-data.d script
	- Install script fixes
	- post-fs-data.d script fixes
	- Push AudModLib v1.2 hotfixes

v1.1
	- AudModLib v1.1 hotfix for bootloops issues on some devices

v1.0
	- Initial Magisk release

## Credits
* [ViPER's Audio](http://vipersaudio.com/blog/)
* [ViPER520](http://vipersaudio.com/blog/) @ XDA Developers
* [zhuhang](https://forum.xda-developers.com/showthread.php?t=2191223) @ XDA Developers

## Source Code
* Module [GitHub](https://github.com/therealahrion/ViPER4Android-FX)