#!/bin/bash

startEmulator() {
    #Start emulator if no already online
    if [ "`adb shell getprop sys.boot_completed | tr -d '\r' `" != "1" ]; then

        adb start-server; \
        echo -ne "n\n" | $ANDROID_HOME/cmdline-tools/latest/bin/avdmanager create avd -n first_avd -k "system-images;android-29;google_apis;x86"
        bash -c 'echo "hw.lcd.density=213" >> $ANDROID_HOME/.android/avd/first_avd.avd/config.ini'
        bash -c 'echo "hw.lcd.height=1280" >> $ANDROID_HOME/.android/avd/first_avd.avd/config.ini'
        bash -c 'echo "hw.lcd.width=800" >> $ANDROID_HOME/.android/avd/first_avd.avd/config.ini'
        bash -c 'echo "hw.mainKeys=no" >> $ANDROID_HOME/.android/avd/first_avd.avd/config.ini'

        $ANDROID_HOME/emulator/emulator -avd first_avd -gpu off -no-window -no-audio -dns-server 8.8.8.8 -skin 800x1280 &

        #Wait for the emulator to boot
        echo "Waiting For the emulator to be online"
        while [ "`adb shell getprop sys.boot_completed | tr -d '\r' `" != "1" ] ; do sleep 1; done
    fi;
}

set -e

source $FLUTTER_WORKSPACE_DIRECTORY/tools/env.env

startEmulator

(cd $FLUTTER_FRONTEND_WORKSPACE_DIRECTORY && flutter test integration_test/tests --verbose --dart-define=BASE_URL=http://10.0.2.2:3000/api --dart-define=FIREBASE_ENABLED=false)
