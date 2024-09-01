#Requires AutoHotkey v2.0

#SingleInstance Force

#Include ..\common\constants.ahk
#Include ..\common\utils.ahk


rawaccel := "C:\Programs\RawAccel\rawaccel.exe"


;; Toggle RawAccel
ToggleRawAccel() {
    ; If it is running, toggle the window
    if ProcessExist("rawaccel.exe") {
        ; Close the window after 150ms
        CloseWindow("ahk_exe rawaccel.exe", 60, 160)
    }
    ; If it is not running, run it
    ; else {
    ;     Run rawaccel
    ;     sleep 100
    ;     CloseWindow("ahk_exe rawaccel.exe", , 150)
    ; }
}


ToggleRawAccel()


ExitApp
