;;;;;;;;;; ! PLEASE RUN THIS SCRIPT AS ADMINISTRATOR ! ;;;;;;;;;;

;;;;;;;;;;  + is Shift, ! is Alt, ^ is Ctrl, # is Win  ;;;;;;;;;;

;;;;;;;;;; https://www.autohotkey.com/docs/v2/Variables.htm#BuiltIn  ;;;;;;;;;;


#Requires AutoHotkey v2.0

#SingleInstance Force


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


;;;;;;;;;; APPLICATION PATHS ;;;;;;;;;;


leishen := "C:\Program Files (x86)\LeiGod_Acc\leigod_launcher.exe"


;;;;;;;;;; USER DEFINED FUNCTIONS ;;;;;;;;;;


;; Prepare the network for gaming
;;   Start gaming: Turn off clash, turn on leigod
;;   Stop gaming: Turn on clash, turn off leigod
ToggleGamingNetworkEnv() {
    ; If LeiGod is running, then close it, and turn on Clash
    if ProcessExist("leigod.exe") {
        FocusWindowAndClick("ahk_exe leigod.exe", , , 1500, 100, "雷神关闭")
        sleep 1600
        if WinExist("ahk_exe leigod.exe") {
            WinClose "ahk_exe leigod.exe"
        }

        sleep 200

        ; Turn on Clash
        SendInput "{Ctrl down}{Alt down}{Shift down}"
        SendInput "pmt"
        SendInput "{Ctrl up}{Alt up}{Shift up}"

        ToolTip("Clash Turned On")
        SetTimer () => ToolTip(), -1000  ; Remove the tooltip after 1 seconds
    }
    ; If LeiGod is not running, then run it, and turn off Clash
    else {
        ; Turn off Clash
        SendInput "{Ctrl down}{Alt down}{Shift down}"
        SendInput "pmt"
        SendInput "{Ctrl up}{Alt up}{Shift up}"

        ToolTip("Clash Turned Off")
        SetTimer () => ToolTip(), -1000  ; Remove the tooltip after 1 seconds

        Run leishen

        FocusWindowAndClick("ahk_exe leigod.exe", 20, , 1500, 100, "雷神启动")
    }
}


;; Focus app window and click.
;; Parameters:
;;   target: The window identifier (e.g., "ahk_exe Spotify.exe")
;;   duration: Total seconds to wait (default: 4)
;;   ClickType: The type of click (default: "left")
;;   ClickX: The X coordinate of the click (default: 0)
;;   ClickY: The Y coordinate of the click (default: 0)
;;   ClickInfo: The tooltip message to display after the click (default: "")
;; Displays an error message box if the window is not found after all attempts.
FocusWindowAndClick(target, duration := 4, ClickType := "left", ClickX := 0, ClickY := 0, ClickInfo := "") {
    if WinWait(target, , duration) {
        WinActivate
        MouseClick ClickType, ClickX, ClickY
        ToolTip(ClickInfo)
        SetTimer () => ToolTip(), -1000  ; Remove the tooltip after 1 seconds
    } else {
        MsgBox 'ERROR ' . ClickType . ' Click (' . ClickX . ', ' . ClickY . ')! The "' . target . '" window could not be found!'
    }
}


; Run the function
ToggleGamingNetworkEnv()