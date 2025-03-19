/************************************************************************
 * @description AutoHotkey script for Windows (Personal Usage)
 * @author Domenic
 ***********************************************************************/

;;;;;;;;;;  + is Shift, ! is Alt, ^ is Ctrl, # is Win  ;;;;;;;;;;

;;;;;;;;;; https://www.autohotkey.com/docs/v2/Variables.htm#BuiltIn  ;;;;;;;;;;

#Requires AutoHotkey v2.0
#SingleInstance Force
#WinActivateForce
#UseHook true
#MaxThreads 20
#MaxThreadsPerHotkey 1

ProcessSetPriority "High"
KeyHistory 0
ListLines False
SetKeyDelay -1, -1
SetMouseDelay -1
SetDefaultMouseSpeed 0
SetWinDelay 0
SetControlDelay 0
SendMode "Input"
SetWorkingDir A_ScriptDir
InstallKeybdHook
InstallMouseHook

A_MaxHotkeysPerInterval := 99999999
A_HotkeyInterval := 99999999

; Turn CapsLock off initially
SetCapsLockState "AlwaysOff"

; Store the CapsLock activation state (0 = Off, 1 = On)
CapsLockState := 0

; Use `#Include` without any path:
; - AHK will first look for the ahk script in the same directory as the script that contains the #Include directive.
; - If still not found, it will look in the standard library folder of AHK's installation directory.
; - If not found there, it will search in the user's standard library folder (usually Documents\AutoHotkey\Lib).
#Include common\constants\custom.ahk
#Include common\constants\settings.ahk
#Include common\constants\logs.ahk
#Include common\constants\applications.ahk
#Include common\constants\autodarkmode.ahk
#Include common\constants\keybindings.ahk
#Include common\constants\scripts.ahk
#Include common\utils\datautils.ahk
#Include common\utils\controlutils.ahk
#Include common\utils\scriptutils.ahk
#Include common\utils\windowutils.ahk
#Include common\utils\fileutils.ahk
#Include common\utils\systemutils.ahk
#Include common\utils\imeutils.ahk
#Include common\utils\commandutils.ahk
#Include common\utils\timeutils.ahk
#Include common\utils\textutils.ahk
#Include common\utils\logutils.ahk
#Include common\utils\applications.ahk
#Include function\toggle.ahk
#Include function\mouse.ahk
#Include function\autodarkmode.ahk
#Include function\folder.ahk
#Include capslockplus\capslock.ahk
#Include hotstring\hotstring.ahk
#Include gui\help.ahk
#Include gui\menu.ahk
#Include gui\input.ahk
#Include lib\Gdip_All.ahk

; Check windows color mode immediately after script starts
AutoDarkMode()

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

#HotIf !CapsLockState and !IsWindowExcludedProgram()

; `LAlt + 1` to toggle Cursor AI Editor
<!1:: ToggleCursor()

; `LAlt + LShift + 1` to toggle a new instance of Cursor AI Editor
<!<+1:: ToggleCursor(true)

; `LAlt + 2` to toggle Visual Studio Code
<!2:: ToggleVSCode()

; `LAlt + LShift + 2` to toggle a new instance of Visual Studio Code
<!<+2:: ToggleVSCode(true)

; `LAlt + 3` to toggle Notepad2
<!3:: ToggleNotepad2()

; `LAlt + LShift + 3` to toggle a new instance of Notepad2
<!<+3:: ToggleNotepad2(true)

; `LAlt + 4` to toggle Notepad++
<!4:: ToggleNotepadPP()

; `LAlt + 5` to toggle Windows Terminal
<!5:: ToggleWindowsTerminal()

; `LAlt + LShift + 5` to toggle a new instance of Windows Terminal
<!<+5:: ToggleWindowsTerminal(true)

; `LCtrl + `` to toggle Heynote
<^`:: ToggleHeynote()

; `LCtrl + 1` to toggle Typora
<^1:: ToggleTypora()

; `LCtrl + LShift + 1` to toggle a new instance of Typora
<^<+1:: ToggleTypora(true)

; `LCtrl + 2` to toggle Obsidian
<^2:: ToggleObsidian()

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

; `RAlt + M` to toggle Thunderbird
>!m:: ToggleThunderbird()

; `RAlt + P` to toggle Spotify
>!p:: ToggleSpotify()

; `LAlt + R` to toggle Telegram
<!r:: ToggleTelegram()

; `LAlt + D` to toggle Discord
<!t:: ToggleDiscord()

; `LAlt + W` to toggle Sandboxed WeChat
<!w:: ToggleWechat()

; `LAlt + Q` to toggle Sandboxed Tencent TIM
<!q:: ToggleSandboxedTIM()

; `LAlt + E` to toggle DingTalk
<!e:: ToggleDingTalk()

; `RAlt + L` to toggle Eudic
>!l:: ToggleEudic()

; `LAlt + LShift + P` to toggle 1Password
<!<+p:: Toggle1Password()

; `RAlt + RShift + =` to toggle Bilibili
>!=:: ToggleBilibili()

; `RAlt + RShift + -` to toggle Sandboxed Bilibili
>!-:: ToggleSandboxedBilibili()

; `RAlt + =` to open Bilibili web interface
>!>+=:: OpenBilibiliWeb()

; `RAlt + -` to open Bilibili web interface in a firefox container
>!>+-:: OpenBilibiliWeb2()

; `RAlt + 0` to open YouTube web interface
>!0:: ToggleYouTube()

; `RAlt + 9` to open YouTube web interface in a firefox container
>!9:: OpenYouTubeWeb2()

; `RAlt + RShift + P` to run Both Spotify and Lyricify
>!>+p:: RunSpotifyAndLyricify()

; `RAlt + C` to start Ollama and Docker container for chat webui to chat with LLMs
>!c:: StartOllamaAndWebUI()

; `LWin + E` to toggle File Explorer
<#e:: ToggleExplorer()

; `LWin + LShift + E` to open a new instance of File Explorer
<#<+e:: ToggleExplorer(true)

; `RAlt + I` to toggle HWiNFO64
>!i:: ToggleHWiNFO()

; `RAlt + O` to open MSI Afterburner
>!o:: ToggleMSIAfterburner()

; `LAlt + LShift + C` to toggle Mihomo Party Proxy
<!<+c:: ToggleMihomo()

; `RAlt + Enter` to toggle system proxy (Clash for Windows) on/off
>!Enter:: ToggleProxyOnOff()

; `RAlt + K` to toggle Gaming Network Environment
>!k:: ToggleGameEnv()

; `LAlt + Esc` to close currently active window
<!Esc:: CloseCurrentWindow()

; `RAlt + F12` to put the computer to sleep
>!F12:: PutComputerToSleep()

; `LCtrl + LShift + RAlt + F12` to restart the computer
<^<+>!F12:: PutComputerToRestart()

; `LAlt + /` to toggle the help window
<!/:: ToggleHelpWindow()

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

if FileExist("game_env_started.tmp") {
    FileDelete("game_env_started.tmp")
}

; Delete old log files under the "log" folder
; Remove log files older than 2 days
loop files, A_ScriptDir . "\log" . "\*", "D" {
    monthDir := A_LoopFilePath

    dateNow := DateAdd(A_Now, 0, "days")
    cutoffDate := DateAdd(dateNow, -2, "days")
    dateNowFormatted := FormatTime(dateNow, "yyyyMMdd")
    cutoffDateFormatted := FormatTime(cutoffDate, "yyyyMMdd")

    loop files, monthDir . "\*.log" {
        logFile := A_LoopFilePath

        ; Extract date from filename (assuming format MM-dd.log)
        fileNameNoExt := GetPathComponent(logFile, "nameNoExt")
        ; Concatenate the year, month, and day from the current date with the filename
        fileDate := SubStr(A_Now, 1, 4) . SubStr(fileNameNoExt, 1, 2) . SubStr(fileNameNoExt, 4, 2)

        if fileDate != dateNowFormatted and FileRead(logFile) == "" {
            try {
                FileDelete(logFile)
                continue
            }
        }
        if fileDate < cutoffDateFormatted or fileDate > dateNowFormatted {
            try {
                FileDelete(logFile)
            }
        }
    }
    ; Remove empty directories
    if !FileExist(monthDir . "\*.*") {
        try {
            DirDelete(monthDir)
        }
    }
}

/**
 * Detect if Chinese input method is installed
 */
DetectKBL() {
    ChineseKBL := false
    loop reg, "HKEY_CURRENT_USER\Keyboard Layout\Preload" {
        outputVar := RegRead()
        outputVar := SubStr(outputVar, -4)
        if outputVar == "0804" {
            ChineseKBL := true
            break
        }
    }
    if !ChineseKBL {
        MsgBox "Chinese input method is not installed!", , "T4"
    }
}

DetectKBL()