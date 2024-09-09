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

/**
 * Run and then close RawAccel
 */
ApplyRawAccel() {
    Run rawaccel
    MaxAttempts := 300
    loop MaxAttempts {
        if ProcessExist("rawaccel.exe") {
            CloseWindow("ahk_exe rawaccel.exe", , 600)
            break
        }
        sleep 200
    }
}

ApplyRawAccel()

ExitApp