;;;;;;;;;; ! PLEASE RUN THIS SCRIPT AS ADMINISTRATOR ! ;;;;;;;;;;

#Requires AutoHotkey v2.0

#SingleInstance Force

#NoTrayIcon

#WinActivateForce

ProcessSetPriority "High"

A_MaxHotkeysPerInterval := 99999999
A_HotkeyInterval := 99999999

KeyHistory 0
ListLines False

SetKeyDelay -1, -1
SetMouseDelay -1
SetDefaultMouseSpeed 0
SetWinDelay 0
SetControlDelay 0

SendMode "Input"

if not A_IsAdmin {
    try
    {
        if A_IsCompiled
            Run '*RunAs "' A_ScriptFullPath '" /restart'
        else
            Run '*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"'
    } catch {
        MsgBox "Failed to restart " . A_ScriptName . " with admin privileges."
        ExitApp
    }
    ExitApp
}

#Include ..\common\utils\windowutils.ahk
#Include ..\common\utils\logutils.ahk

;;;;;;;;;; GLOBAL VARIABLES ;;;;;;;;;;

OnError LogError

logfile := A_ScriptDir . "\log\other.log"

explorer := A_WinDir . "\explorer.exe"

explorerDim := { x: 920, y: 380, w: 2000, h: 1400
}

/**
 * Toggle Windows File Explorer
 * - Not running: Open Windows File Explorer and set windows position and size
 * - Already Running: Toggle Windows File Explorer and set windows position and size
 */
ToggleFileExplorer() {
    ; If it is running, toggle the window
    if WinExist("ahk_exe explorer.exe ahk_class CabinetWClass") {
        if WinActive("ahk_exe explorer.exe ahk_class CabinetWClass") {
            ; Window is active, minimize it to taskbar
            WinMinimize
        } else {
            ActivateWindow("ahk_exe explorer.exe ahk_class CabinetWClass")
            SetWindow("ahk_exe explorer.exe ahk_class CabinetWClass", explorerDim.x, explorerDim.y, explorerDim.w, explorerDim.h)
        }
    }
    ; If it is not running, run it
    else {
        Run explorer
        ActivateWindow("ahk_exe explorer.exe ahk_class CabinetWClass")
        SetWindow("ahk_exe explorer.exe ahk_class CabinetWClass", explorerDim.x, explorerDim.y, explorerDim.w, explorerDim.h)
    }
}

ToggleFileExplorer()