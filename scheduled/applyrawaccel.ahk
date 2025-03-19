#Requires AutoHotkey v2.0

#SingleInstance Force

; #WinActivateForce

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

#Include ..\common\constants\custom.ahk
#Include ..\common\constants\settings.ahk
#Include ..\common\utils\datautils.ahk
#Include ..\common\utils\controlutils.ahk
#Include ..\common\utils\applications.ahk
#Include ..\common\utils\windowutils.ahk
#Include ..\common\utils\fileutils.ahk
#Include ..\common\utils\logutils.ahk

rawaccel := C_SystemDriveLetter . "\Programs\RawAccel\rawaccel.exe"
ValidateAndUpdatePath(&rawaccel)

/**
 * Run and then close RawAccel
 */
ApplyRawAccel() {
    try {
        Run rawaccel
    }
    CloseRawAccelWin() {
        if ProcessExist("rawaccel.exe") {
            return CloseWindow("ahk_exe rawaccel.exe", , 1000)
        }
        return false
    }
    LoopLogic(CloseRawAccelWin, 300, 200)
}

ApplyRawAccel()

ExitApp