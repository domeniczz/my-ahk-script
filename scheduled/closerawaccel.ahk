#Requires AutoHotkey v2.0

#SingleInstance Force

#WinActivateForce

A_MaxHotkeysPerInterval := 99999999
A_HotkeyInterval := 99999999

KeyHistory 0
ListLines False

SetKeyDelay -1, -1
SetMouseDelay -1
SetDefaultMouseSpeed 0
SetWinDelay 0
SetControlDelay 0

SendMode "InputThenPlay"

#Include ..\common\constants.ahk
#Include ..\common\utils.ahk

/*
Toggle RawAccel
*/
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

    if MaxAttempts <= A_Index {
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