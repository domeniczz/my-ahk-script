;;;;;;;;;;  + is Shift, ! is Alt, ^ is Ctrl, # is Win  ;;;;;;;;;;

;;;;;;;;;; https://www.autohotkey.com/docs/v2/Variables.htm#BuiltIn  ;;;;;;;;;;

#Requires AutoHotkey v2.0

#SingleInstance Force

#WinActivateForce

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

;; Use `#Include` without any path:
;; - AHK will first look for the ahk script in the same directory as the script that contains the #Include directive.
;; - If still not found, it will look in the standard library folder of AHK's installation directory.
;; - If not found there, it will search in the user's standard library folder (usually Documents\AutoHotkey\Lib).
#Include common\constants\applications.ahk
#Include common\constants\settings.ahk
#Include common\constants\autodarkmode.ahk
#Include common\constants\keybindings.ahk
#Include common\constants\scripts.ahk
#Include common\utils\windowutils.ahk
#Include common\utils\fileutils.ahk
#Include common\utils\scriptutils.ahk
#Include common\utils\systemutils.ahk
#Include common\utils\commandutils.ahk
#Include common\utils\timeutils.ahk
#Include common\utils\textutils.ahk
#Include common\utils\logutils.ahk
#Include function\toggle.ahk
#Include function\mouse.ahk
#Include function\typing.ahk
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

; `LWin + Z` to show the menu
<#z:: OpenMenu()

#SuspendExempt False

#HotIf !CapsLockState and !IsExcludedProgram()

; `LAlt + 1` to toggle Notepad++
<!1:: ToggleNotepadPP()

; `LAlt + 2` to toggle Notepad2
<!2:: ToggleNotepad2()

; `LAlt + 3` to toggle Cursor AI Editor
<!3:: ToggleCursor()

; `LAlt + 4` to toggle Visual Studio Code
<!4:: ToggleVSCode()

; `LAlt + 5` to toggle Windows Terminal
<!5:: ToggleWindowsTerminal()

; `LWin + 1` to toggle Firefox
<#1:: ToggleFirefox()

; `LWin + LShift + 1` to toggle Private Firefox
; By default, `Win + Shift + number` will launch firefox in safe (diagnose) mode
; Disable launch in safe mode: [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Mozilla\Firefox] "DisableSafeMode"=dword:00000001
<#<+1:: ToggleFirefox(true)

; `LWin + 2` to toggle Brave
<#2:: ToggleBrave()

; `LWin + LShift + 2` to toggle Brave in private mode
<#<+2:: ToggleBrave(true)

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
<^`::
>!=:: ToggleBilibili()

; `RAlt + -` to toggle Sandboxed Bilibili
<^1::
>!-:: ToggleSandboxedBilibili()

; `RAlt + 0` to open YouTube
<^2::
>!0:: OpenYouTube()

; `RAlt + 9` to open YouTube in a container
<^3::
>!9:: OpenYouTube2()

; `RAlt + RShift + P` to run Both Spotify and Lyricify
>+>!p:: RunSpotifyAndLyricify()

; `RAlt + C` to start Ollama and Docker container for chat webui to chat with LLMs
>!c:: StartOllamaAndDockerWebUI()

; `RAlt + O` to open MSI Afterburner
>!o:: ToggleMSIAfterburner()

; `LAlt + LShift + C` to open Clash for Windows
<!<+c:: ToggleClash()

; `RAlt + Enter` to toggle system proxy (Clash for Windows) on/off
>!Enter:: ToggleProxyOnOff()

; `RAlt + K` to toggle Gaming Network Environment
>!k up:: RunScriptAsAdmin(toggleGameEnv)

; `LAlt + `` to close currently active window
<!`:: CloseCurrentWindow()

; `LWin + E` to toggle File Explorer
<#e::
{
    ; Wait Win key release to avoid toggling Windows start menu
    KeyWait("LWin")
    RunScriptAsAdmin(toggleFileExplorer)
}

; `RAlt + F12` to put the computer to sleep
>!F12:: PutComputerToSleep()

; `LCtrl + LShift + RAlt + F12` to restart the computer
<^<+>!F12:: PutComputerToRestart()

; `LAlt + /` to toggle the help window
<!/:: ToggleHelpWindow()

#HotIf !CapsLockState and WinActive("ahk_exe firefox.exe") and !IsExcludedProgram()
; `RAlt + \` to send text
>!\:: SendTextLLMGeneralPrompt()

#HotIf

;;;;;;;;;; MOUSE BINDINGS ;;;;;;;;;;

; Right mouse button
; Press and hold right button, then scroll wheel up/down to trigger infinite scrolling
; End infinite scrolling by releasing the right button or clicking the left button
RButton:: InfiniteScrollHandler()

; Middle mouse button
MButton:: MiddleButtonHandler()