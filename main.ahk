;;;;;;;;;;  + is Shift, ! is Alt, ^ is Ctrl, # is Win  ;;;;;;;;;;

;;;;;;;;;; https://www.autohotkey.com/docs/v2/Variables.htm#BuiltIn  ;;;;;;;;;;

#Requires AutoHotkey v2.0

#SingleInstance Force

; #WinActivateForce

; #NoTrayIcon

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

; Turn CapsLock off initially
SetCapsLockState "AlwaysOff"

; The keyboard hook will be used to implement all keyboard hotkeys
; If this directive is unspecified in the script, it will behave as though set to False, meaning the windows API function RegisterHotkey() is used to implement a keyboard hotkey whenever possible.
#UseHook true
; Install keyboard hook and mouse hook unconditionally and immediately after the script starts
InstallKeybdHook
InstallMouseHook

; Use `#Include` without any path:
; - AHK will first look for the ahk script in the same directory as the script that contains the #Include directive.
; - If still not found, it will look in the standard library folder of AHK's installation directory.
; - If not found there, it will search in the user's standard library folder (usually Documents\AutoHotkey\Lib).
#Include common\constants\logs.ahk
#Include common\constants\applications.ahk
#Include common\constants\settings.ahk
#Include common\constants\autodarkmode.ahk
#Include common\constants\keybindings.ahk
#Include common\constants\scripts.ahk
#Include common\utils\scriptutils.ahk
#Include common\utils\windowutils.ahk
#Include common\utils\fileutils.ahk
#Include common\utils\systemutils.ahk
#Include common\utils\commandutils.ahk
#Include common\utils\timeutils.ahk
#Include common\utils\textutils.ahk
#Include common\utils\logutils.ahk
#Include function\toggle.ahk
#Include function\mouse.ahk
#Include function\autodarkmode.ahk
#Include function\folder.ahk
#Include gui\help.ahk
#Include gui\menu.ahk
#Include gui\input.ahk
#Include capslockplus\capslock.ahk
#Include hotstring\hotstring.ahk

;;;;;;;;;; AUTOMATIC TASKS ;;;;;;;;;;

; Setting a negative priority makes this timer run only when the script is idle
; -1 represents a priority level that is lower than the default level of 0
SetTimer AutoDarkMode, autoDarkModeCheckInterval, -1

OnError LogError

;;;;;;;;;; HOTKEYS BINDINGS ;;;;;;;;;;

#SuspendExempt

; `LCtrl + LShift + LWin + S` to toggle suspend
<^<+<#s:: SuspendScript()

#SuspendExempt False

#HotIf !CapsLockState and !IsExcludedProgram()

; `LAlt + 1` to toggle Notepad++
<!1:: ToggleNotepadPP()

; `LAlt + 2` to toggle Notepad2
<!2:: ToggleNotepad2()

; `LAlt + LShift + 2` to toggle a new instance of Notepad2
<!<+2:: ToggleNotepad2(true)

; `LAlt + 3` to toggle Cursor AI Editor
<!3:: ToggleCursor()

; `LAlt + LShift + 3` to toggle a new instance of Cursor AI Editor
<!<+3:: ToggleCursor(true)

; `LAlt + 4` to toggle Visual Studio Code
<!4:: ToggleVSCode()

; `LAlt + LShift + 4` to toggle a new instance of Visual Studio Code
<!<+4:: ToggleVSCode(true)

; `LAlt + 5` to toggle Windows Terminal
<!5:: ToggleWindowsTerminal()

; `LAlt + LShift + 5` to toggle a new instance of Windows Terminal
<!<+5:: ToggleWindowsTerminal(true)

; `LWin + `` to toggle Firefox
<#`:: ToggleGecko()

; `LWin + LShift + `` to toggle Private Firefox
; By default, `Win + Shift + number` will launch firefox in safe (diagnose) mode
; Disable launch in safe mode: [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Mozilla\Firefox] "DisableSafeMode"=dword:00000001
<#<+`:: ToggleGecko(, true)

; `LWin + 1` to toggle Brave
<#1:: ToggleChromium(brave)

; `LWin + LShift + 1` to toggle Brave in private mode
<#<+1:: ToggleChromium(brave, true)

; `LWin + 2` to toggle Chrome
<#2:: ToggleChromium()

; `LWin + LShift + 2` to toggle Chrome in private mode
<#<+2:: ToggleChromium(, true)

; `LWin + 3` to toggle Microsoft Edge
<#3:: ToggleChromium(msedge)

; `LWin + LShift + 3` to toggle Microsoft Edge in private mode
<#<+3:: ToggleChromium(msedge, true, "-inprivate")

; `RAlt + P` to toggle Spotify
>!p:: ToggleSpotify()

; `LAlt + R` to toggle Telegram
<!r:: ToggleTelegram()

; `LAlt + D` to toggle Discord
<!t:: ToggleDiscord()

; `LAlt + W` to toggle WeChat
<!w:: ToggleWeChat()

; `LAlt + Q` to toggle Tencent TIM
<!q:: ToggleTencentTIM()

; `LAlt + E` to toggle DingTalk
<!e:: ToggleDingTalk()

; `RAlt + L` to toggle Eudic
>!l:: ToggleEudic()

; `RAlt + =` to toggle Bilibili
>!=:: ToggleBilibili()

; `RAlt + -` to toggle Sandboxed Bilibili
>!-:: ToggleSandboxedBilibili()

; `RAlt + 0` to open YouTube
>!0:: OpenYouTube()

; `RAlt + 9` to open YouTube in a container
>!9:: OpenYouTube2()

; `RAlt + RShift + P` to run Both Spotify and Lyricify
>+>!p:: RunSpotifyAndLyricify()

; `RAlt + C` to start Ollama and Docker container for chat webui to chat with LLMs
>!c:: StartOllamaAndDockerWebUI()

; `LWin + E` to toggle File Explorer
<#e:: ToggleExplorer()

; `LWin + LShift + E` to open a new instance of File Explorer
<#<+e:: ToggleExplorer(true)

; `RAlt + I` to toggle HWiNFO64
>!i:: ToggleHWiNFO()

; `RAlt + O` to open MSI Afterburner
>!o:: ToggleMSIAfterburner()

; `LAlt + LShift + C` to open Clash for Windows
<!<+c:: ToggleClash()

; `RAlt + Enter` to toggle system proxy (Clash for Windows) on/off
>!Enter:: ToggleProxyOnOff()

; `RAlt + K` to toggle Gaming Network Environment
>!k:: ToggleGameEnv()

; `LAlt + `` to close currently active window
<!`:: CloseCurrentWindow()

; `RAlt + F12` to put the computer to sleep
>!F12:: PutComputerToSleep()

; `LCtrl + LShift + RAlt + F12` to restart the computer
<^<+>!F12:: PutComputerToRestart()

; `LAlt + /` to toggle the help window, hide the window after LAlt is released
<!/::
{
    ToggleHelpWindow()
    KeyWait "LAlt"
    ToggleHelpWindow()
}

; `LWin + Z` to show the menu
<#z:: OpenMenu()

#HotIf

;;;;;;;;;; MOUSE BINDINGS ;;;;;;;;;;

; Right mouse button
; Press and hold right button, then scroll wheel up/down to trigger infinite scrolling
; End infinite scrolling by releasing the right button or clicking the left button
RButton:: InfiniteScrollHandler()

; Middle mouse button
MButton:: MiddleButtonHandler()

;;;;;;;;;; STARTUP CLEANUP ;;;;;;;;;;

; Delete the "game_env_started.tmp" file if it exists
if FileExist("game_env_started.tmp") {
    FileDelete("game_env_started.tmp")
}

; Delete old log files under the "log" folder
; Remove log files older than 2 days
loop files, A_ScriptDir . "\log" . "\*", "D" {
    monthDir := A_LoopFilePath
    ; Get the current date
    dateNow := DateAdd(A_Now, 0, "days")
    ; Get the cutoff date (2 days ago)
    cutoffDate := DateAdd(dateNow, -2, "days")
    dateNowFormatted := FormatTime(dateNow, "yyyyMMdd")
    cutoffDateFormatted := FormatTime(cutoffDate, "yyyyMMdd")
    ; Loop through all log files in the month directory
    loop files, monthDir . "\*.log" {
        logFile := A_LoopFilePath
        ; Extract date from filename (assuming format MM-dd.log)
        fileNameNoExt := GetPathComponent(logFile, "nameNoExt")
        fileDate := SubStr(A_Now, 1, 4) . SubStr(fileNameNoExt, 1, 2) . SubStr(fileNameNoExt, 4, 2)
        ; Check if the file date is within the range
        ; If the file date is older than the cutoff date or newer than the current date, delete it
        if fileDate < cutoffDateFormatted or fileDate > dateNowFormatted {
            ; Delete the file if it's older than the cutoff date
            try {
                FileDelete(logFile)
            } catch as err {
                LogError(err)
            }
        }
    }
    ; Remove empty directories
    if !FileExist(monthDir . "\*.*") {
        try {
            DirDelete(monthDir)
        } catch as err {
            LogError(err)
        }
    }
}
