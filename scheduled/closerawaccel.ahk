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

OnError LogError

logfile := A_ScriptDir . "\logs\scheduled.log"

#Include ..\common\constants\applications.ahk
#Include ..\common\utils\windowutils.ahk
#Include ..\common\utils\logutils.ahk

/*
Toggle RawAccel
*/
ToggleRawAccel() {
    MaxAttempts := 400
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

    ; If it is not running, run it
    if MaxAttempts <= A_Index {
        Run rawaccel
        loop MaxAttempts {
            if ProcessExist("rawaccel.exe") {
                CloseWindow("ahk_exe rawaccel.exe", , 300)
                break
            }
            sleep 200
        }
    }
}

ToggleRawAccel()

ExitApp