# Ainur JamesDSPManager
This module enables JamesDSPManager. [More details in support thread](https://forum.xda-developers.com/android/software/soundmod-ainur-audio-t3450516).
## Special features:
### Full featured:
Standard JDSP library. Highly recommend
### Bit Perfect:
Double precision (float64) processing. Note that some features are missing from this one like trusurround (virtual surround spatializer

## Compatibility
* Android Jellybean+
* Selinux enforcing
* All root solutions (requires init.d support if not using magisk or supersu. Try [Init.d Injector](https://forum.xda-developers.com/android/software-hacking/mod-universal-init-d-injector-wip-t3692105))

## Change Log
### v1.9.8 - 2.21.2019
* Added Samsung Galaxy S9 and Zuk Z2 Pro to lib workaround
* Made lib workaround a choice so I don't have to keep updating this
* Unity v3.3 update

### v1.9.7 - 1.16.2019
* Forgot to move apk back to priv-app (needed for unity 3.2)

### v1.9.6 - 1.15.2019
* Unity v3.2 update

### v1.9.5 - 1.11.2019
* Unity hotfix

### v1.9.4 - 1.10.2019
* Unity v3.1 update

### v1.9.3 - 1.5.2019
* Unity v3.0 update

### v1.9.2 - 12.23.2018
* Fixed hua/nhua zipname trigger for real this time
* Unity v2.2 update

### v1.9.1 - 12.20.2018
* Fixed hua/nhua zipname trigger
* Fix lib workaround
* Update to Unity v2.1

### v1.9 - 12.18.2018
* Unity v2.0 update
* Fixed limitation in zipname triggers - you can use spaces in the zipname now and trigger is case insensitive
* Improved boot script for user app install - should fix bootloop issues

### v1.8 - 11.21.2018
* Updated JDSP to 11.20.18 release (Change FFT to slower but a commercial friendly implementation, Improve TruCentre separation, Reduce TruCentre latency to 21 ms(from 32 ms), Fix arbitrary response equalizer memory leaks)

### v1.7.5 - 11.8.2018
* Add libstdc++ workaround for pixel 2's, 3's, and essential phone

### v1.7.4 - 10.29.2018
* Switch to manual huawei selection - too much variation with custom roms for consistent huawei device detection

### v1.7.3 - 10.24.2018
* Unity v1.7.2 update
* Bug fix for arm64 devices
* Bug fixes for huawei devices

### v1.7.2 - 10.23.2018
* Fixed awesome boot script for pie - magisk apk stuff is automated once again :)

### v1.7.1 - 10.22.2018
* Fix boot hanging on Pie roms

### v1.7 - 9.20.2018
* Update to unity 1.7.1
* Widen detection for huawei devices

### v1.6.9.1 - 9.16.2018
* Hotfix for Huawei devices

### v1.6.9 -9.13.2018
* Updated JDSP to 9.13 release (adds huawei support, adds auto DDC resampler for device running on 96k sample rate or above, fixes some device volume issue caused by bit depth)

### v1.6.8 - 9.3.2018
* Updated JDSP to 8.31 release

### v1.6.7 - 9.2.2018
* Unity v1.7 update
* Added auto-install/uninstall of apk for magisk only (works for disable/enabling mod in magisk manager as well)
* Add compression to save space/bandwidth

### v1.6.6 - 8.30.2018
* Unity v1.6.1 update

### v1.6.5 - 8.26.2018
* New JamesDSP build (Now supports HTC devices) 
* Fixed bit depth problem from HTC and Android Pie
* Upgraded Fast Fourier Transform libraryand  Android NDK

### v1.6.4 - 8.24.2018
* Unity v1.6 update

### v1.6.3 - 7.17.2018
* Unity v1.5.5 update

### v1.6.2 - 5.7.2018
* Unity v1.5.4 update

### v1.6.1 - 4.26.2018
* Unity v1.5.3 update

### v1.6 - 4.16.2018
* Unity v1.5.2 update
* Add AML detection/notification
* Add auto install for apk if in bootmode

### v1.5.9 - 4.12.2018
* Reworking/fixing of audio file patching

### v1.5.8 - 4.12.2018
* Unity v1.5.1 update

### v1.5.7 - 4.12.2018
* Unity v1.5 update

### v1.5.6 - 4.9.2018
* Use dynamic effect removal

### v1.5.5 - 3.30.2018
* Fix effect removals

### v1.5.4 - 3.29.2018
* Unity v1.4.1 update

### v1.5.3 - 3.18.2018
* Unity v1.4 update

### v1.5.2 - 3.1.2018
* Real fix for vol key logic

### v1.5.1 - 2.26.2018
* Quick fix for vol key logic

### v1.5 - 2.25.2018
* Fixed vendor files in bootmode for devices with separate vendor partitions
* Bring back old keycheck method or devices that don't like the newer chainfire method
* Fix seg faults on system installs

### v1.4.2 - 2.17.2018
* Boot script not working, have user do it manually for oreo

### v1.4.1 - 2.16.2018
* Updated jdsp to new version

### v1.4 - 2.16.2018
* Add file backup on system installs
* Fine tune unity prop logic
* Update util_functions with magisk 15.4 stuff
* Fix music_helper/sa3d removal in xml files

### v1.3 - 2.12.2018
* Fix vendor cfg creation for devices that don't have it
* Fix sepolicy patching

### v1.2 - 2.10.2018
* Added sa3d removal for samsung devices

### v1.1 - 2.6.2018
* Fixes for xml cfg files

### v1.0 - 2.5.2018
* Initial rerelease

## Credits
* [James34602](https://forum.xda-developers.com/android/apps-games/app-reformed-dsp-manager-t3607970)

## Source Code
* Module [GitHub](https://github.com/therealahrion/JamesDSPManager)
* App [GitHub](https://github.com/james34602/JamesDSPManager)
