#!/bin/sh
mkdir downloads
wget --no-check-certificate -c https://github.com/alxchk/python-for-android/archive/master.zip -O downloads/python-for-android.zip & \
wget --no-check-certificate -c https://github.com/kivy/buildozer/archive/5af135fca460b2191942d57c753352b17a0ecac9.zip -O downloads/buildozer.zip & \
wget --no-check-certificate -c http://archive.apache.org/dist/ant/binaries/apache-ant-1.9.4-bin.tar.gz -O downloads/apache-ant-1.9.4-bin.tar.gz & \
wget --no-check-certificate -c http://dl.google.com/android/android-sdk_r20-linux.tgz -O downloads/android-sdk_r20-linux.tgz & \
wget --no-check-certificate -c http://dl.google.com/android/ndk/android-ndk-r9c-linux-x86_64.tar.bz2 -O downloads/android-ndk-r9c-linux-x86_64.tar.bz2


