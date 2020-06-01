function wait_emulator_to_be_ready() {
  adb devices | grep emulator | cut -f1 | while read line; do adb -s $line emu kill; done
  emulator -avd Android_7.1_API_25 -no-audio -no-boot-anim -no-window -gpu swiftshader_indirect &
  
  boot_completed=false
  while [ "$boot_completed" == false ]; do
    status=$(adb wait-for-device shell getprop sys.boot_completed | tr -d '\r')
    echo "Boot Status: $status"

    if [ "$status" == "1" ]; then
      boot_completed=true
    else
      sleep 1
    fi
  done
}

function disable_animation() {
  adb shell "settings put global window_animation_scale 0.0"
  adb shell "settings put global transition_animation_scale 0.0"
  adb shell "settings put global animator_duration_scale 0.0"
  adb shell "su root pm disable com.google.android.googlequicksearchbox"
}

wait_emulator_to_be_ready
sleep 1
disable_animation