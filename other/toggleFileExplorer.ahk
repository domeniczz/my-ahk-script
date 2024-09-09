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
            WinActivate "ahk_exe explorer.exe ahk_class CabinetWClass"
            SetWindow("ahk_exe explorer.exe ahk_class CabinetWClass", explorerDim.x, explorerDim.y, explorerDim.w, explorerDim.h)
        }
    }
    ; If it is not running, run it
    else {
        Run explorer
        SetWindow("ahk_exe explorer.exe ahk_class CabinetWClass", explorerDim.x, explorerDim.y, explorerDim.w, explorerDim.h)
        WinActivate "ahk_exe explorer.exe ahk_class CabinetWClass"
    }
}

/**
 * Set app window position and size.
 * 
 * @param target - The window identifier (e.g., "ahk_exe explorer.exe")
 * @param {Number} x - The x-coordinate of the window (optional)
 * @param {Number} y - The y-coordinate of the window (optional)
 * @param {Number} width - The width of the window (optional)
 * @param {Number} height - The height of the window (optional)
 * @param {Integer} waitDuration - Total seconds to wait before the action (default: 4)
 * @param {Integer} sleepDuration - Total milliseconds to sleep before setting the window position and size (default: 0)
 * 
 * Displays an error message box if the window is not found after all attempts.
 */
SetWindow(target, x := -1, y := -1, width := -1, height := -1, waitDuration := 4, sleepDuration := 0) {
    if WinWait(target, , waitDuration) {
        ; Move and resize the window only if needed
        ; Use provided values or current values if not provided
        if (x != -1 or y != -1 or width != -1 or height != -1) {
            ; Get current window position and size
            WinGetPos &currentX, &currentY, &currentWidth, &currentHeight
            if (x == currentX and y == currentY and width == currentWidth and height == currentHeight) {
                return  ; No need to change the window position and size
            }
            WinMove(
                x != -1 ? x : currentX,
                y != -1 ? y : currentY,
                width != -1 ? width : currentWidth,
                height != -1 ? height : currentHeight,
                target
            )
        }
    } else {
        MsgBox('ERROR Setting Window! The "' . target . '" window could not be found!')
    }
}

ToggleFileExplorer()