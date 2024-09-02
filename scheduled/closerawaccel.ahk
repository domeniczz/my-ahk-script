#Requires AutoHotkey v2.0

#SingleInstance Force

#Include ..\common\constants.ahk
#Include ..\common\utils.ahk


;; Toggle RawAccel
ToggleRawAccel() {
    sleep 5000
    MaxAttempts := 300
    Loop MaxAttempts{
        ; If it is running, toggle the window
        if ProcessExist("rawaccel.exe") {
            ; Close the window after 200ms
            CloseWindow("ahk_exe rawaccel.exe", , 200)
            break
        }
        sleep 200
    }

    if (MaxAttempts = A_Index) {
        Run rawaccel
        Loop MaxAttempts{
            if ProcessExist("rawaccel.exe") {
                CloseWindow("ahk_exe rawaccel.exe", , 200)
                break
            }
            sleep 200
        }
    }
}


ToggleRawAccel()


ExitApp
