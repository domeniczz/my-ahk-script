;;;;;;;;;; ! PLEASE RUN THIS SCRIPT AS ADMINISTRATOR ! ;;;;;;;;;;

;;;;;;;;;;  + is Shift, ! is Alt, ^ is Ctrl, # is Win  ;;;;;;;;;;

;;;;;;;;;; https://www.autohotkey.com/docs/v2/Variables.htm#BuiltIn  ;;;;;;;;;;


#Requires AutoHotkey v2.0

#SingleInstance Force

#Include ..\common\constants.ahk
#Include ..\common\utils.ahk


if not A_IsAdmin
{
    try
    {
        if A_IsCompiled
            Run '*RunAs "' A_ScriptFullPath '" /restart'
        else
            Run '*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"'
    }
    catch
    {
        MsgBox "Failed to restart " . A_ScriptName . " with admin privileges."
        ExitApp
    }
    ExitApp
}


;;;;;;;;;; USER DEFINED FUNCTIONS ;;;;;;;;;;


;; Prepare the network for gaming
;;   Start gaming: Turn off clash, turn on leigod
;;   Stop gaming: Turn on clash, turn off leigod
ToggleGamingNetworkEnv() {
    ; If LeiGod is running, then close it, and turn on Clash
    if ProcessExist("leigod.exe") {
        if !WinExist("ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1") {
            run leishen
        }
        ActivateWindow("ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1")
        SetWindow("ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1", leishenDim.x, leishenDim.y, leishenDim.w, leishenDim.h)
        ActivateWindowAndClick("ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1", , , 1573, 100, "Toggle 雷神时长")
        sleep 1600

        if WinExist("ahk_exe leigod.exe") {
            ; WinClose "ahk_exe leigod.exe"
            ActivateWindow("ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1")
            ; Alt + F4 to exit the app
            Send "!{F4}"
            Send "{Alt up}"
        }

        sleep 200

        ; Turn on Clash
        SendInput "{Ctrl down}{Alt down}{Shift down}"
        SendInput "pmt"
        SendInput "{Ctrl up}{Alt up}{Shift up}"

        ToolTip("Clash Turned On")
        SetTimer () => ToolTip(), -2500  ; Remove the tooltip after 1 seconds
    }
    ; If LeiGod is not running, then run it, and turn off Clash
    else {
        ; Turn off Clash
        SendInput "{Ctrl down}{Alt down}{Shift down}"
        SendInput "pmt"
        SendInput "{Ctrl up}{Alt up}{Shift up}"

        ToolTip("Clash Turned Off")
        SetTimer () => ToolTip(), -2500  ; Remove the tooltip after 1 seconds

        Run leishen

        if !ProcessExist("steam.exe") {
            Run steam
            CloseWindow("ahk_exe ahk_exe steamwebhelper.exe", 10)
        }

        ; Set the window position and size, then focus on the window
        SetAndActivateWindow("ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1", leishenDim.x, leishenDim.y, leishenDim.w, leishenDim.h, 20)
        ActivateWindowAndClick("ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1", , , 1573, 100, "Toggle 雷神时长")
    }
}


; Run the function
ToggleGamingNetworkEnv()
