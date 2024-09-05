;;;;;;;;;; ! PLEASE RUN THIS SCRIPT AS ADMINISTRATOR ! ;;;;;;;;;;

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

; SendMode "InputThenPlay"

#Include ..\common\constants.ahk
#Include ..\common\utils.ahk

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

;;;;;;;;;; USER DEFINED FUNCTIONS ;;;;;;;;;;

/*
Prepare the network for gaming
  Start gaming: Turn off clash, turn on leigod
  Stop gaming: Turn on clash, turn off leigod
*/
ToggleGamingNetworkEnv() {
    ; If LeiGod is running, then close it, and turn on Clash
    if ProcessExist("leigod.exe") {
        if !WinExist("ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1") {
            run leishen
        }
        ActivateWindow("ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1")
        SetWindow("ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1", leishenDim.x, leishenDim.y, leishenDim.w, leishenDim.h)
        ActivateWindowAndClick("ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1", , , 1573, 100, "Toggle 雷神时长")
        sleep 2000

        if WinExist("ahk_exe leigod.exe") {
            ; WinClose "ahk_exe leigod.exe"
            ActivateWindow("ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1")
            ; Alt + F4 to exit the app
            Send "{LAlt down}{F4}{LAlt up}"
        }

        sleep 200

        ; Turn on Clash
        Send "{LCtrl down}{LAlt down}{LShift down}pmt{LCtrl up}{LAlt up}{LShift up}"

        ToolTip("Clash Turned On")
        SetTimer () => ToolTip(), -1000, -1

        ; Move the cursor to the center
        centerX := A_ScreenWidth // 2
        centerY := A_ScreenHeight // 2
        MouseMove(centerX, centerY)

        sleep 1500
        ToolTip("Remember to un-suspend AHK!")
        SetTimer () => ToolTip(), -2000, -1
    }
    ; If LeiGod is not running, then run it, and turn off Clash
    else {
        ; Turn off Clash
        Send "{LCtrl down}{LAlt down}{LShift down}pmt{LCtrl up}{LAlt up}{LShift up}"

        ToolTip("Clash Turned Off")
        SetTimer () => ToolTip(), -1000, -1

        Run leishen
        ; Set the window position and size, then focus on the window
        SetAndActivateWindow("ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1", leishenDim.x, leishenDim.y, leishenDim.w, leishenDim.h, 60)
        ActivateWindowAndClick("ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1", , , 1573, 100, "Toggle 雷神时长")

        ; if !ProcessExist("steam.exe") {
        ;     steamLoginWinID := ""
        ;     Run steam
        ;     if WinWait("ahk_exe ahk_exe steamwebhelper.exe", , 10) {
        ;         steamLoginWinID := WinGetID("ahk_exe steamwebhelper.exe")
        ;         MaxAttempts := 100
        ;         loop MaxAttempts {
        ;             if WinGetID("ahk_exe steamwebhelper.exe") != steamLoginWinID {
        ;                 CloseWindow(steamLoginWinID, , 200)
        ;             }
        ;             sleep 200
        ;         }
        ;     }
        ; }

        ; Move the cursor to the center
        centerX := A_ScreenWidth // 2
        centerY := A_ScreenHeight // 2
        MouseMove(centerX, centerY)

        sleep 1500
        ToolTip("Remember to suspend AHK!")
        SetTimer () => ToolTip(), -2000, -1
    }
}

ToggleGamingNetworkEnv()