#Requires AutoHotkey v2.0

#SingleInstance Force

#Include ..\common\constants.ahk
#Include ..\common\utils.ahk

;; Toggle RawAccel
ToggleRawAccel() {
    MaxAttempts := 300
    loop MaxAttempts {
        ; If it is running, toggle the window
        if ProcessExist("rawaccel.exe") {
            if WinExist("ahk_exe rawaccel.exe") {
                ; Close the window after 300ms
                CloseWindow("ahk_exe rawaccel.exe", , 300)
                break
            }
        }
        sleep 200
    }

    if (MaxAttempts = A_Index) {
        Run rawaccel
        loop MaxAttempts {
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