;;;;;;;;;;  + is Shift, ! is Alt, ^ is Ctrl, # is Win  ;;;;;;;;;;

;;;;;;;;;; https://www.autohotkey.com/docs/v2/Variables.htm#BuiltIn  ;;;;;;;;;;

#Requires AutoHotkey v2.0

#SingleInstance Force

; #NoTrayIcon

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

SendMode "InputThenPlay"

;; Use `#Include` without any path:
;;   AHK will first look for the ahk script in the same directory as the script that contains the #Include directive.
;;   If not found there, it will search in the user's standard library folder (usually Documents\AutoHotkey\Lib).
;;   If still not found, it will look in the standard library folder of AHK's installation directory.
#Include common\constants.ahk
#Include common\utils.ahk
#Include gui\help.ahk
#Include gui\menu.ahk
#Include function\keyboard.ahk
#Include function\mouse.ahk
#Include function\typing.ahk
#Include function\autodarkmode.ahk

;;;;;;;;;; AUTOMATIC TASKS ;;;;;;;;;;

; Setting a negative priority makes this timer run only when the script is idle
SetTimer AutoDarkMode, autoDarkModeCheckInterval, -1

OnError LogError

;;;;;;;;;; HOTKEYS BINDINGS ;;;;;;;;;;

#UseHook

#SuspendExempt

; `LCtrl + LShift + LWin + S` to toggle suspend
<^<+<#s:: SuspendScript()

; `LWin + Z` to show the menu
<#z:: OpenMenu()

#SuspendExempt False

#HotIf !IsExcludedProgram()

; `LAlt + 1` to toggle Notepad++
<!1:: ToggleNotepadPP()

; `LAlt + 2` to toggle Notepad2
<!2:: ToggleNotepad2()

; `LAlt + 3` to toggle Visual Studio Code
<!3:: ToggleVSCode()

; `LAlt + 4` to toggle Windows Terminal
<!4:: ToggleWindowsTerminal()

; `LWin + 1` to toggle Firefox
<#1:: ToggleFirefox()

; `LWin + LShift + 1` to toggle Private Firefox
; By default, `Win + Shift + number` will launch firefox in safe (diagnose) mode
; Disable launch in safe mode: [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Mozilla\Firefox] "DisableSafeMode"=dword:00000001
<#<+1:: ToggleFirefox(true)

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

; `RAlt + O` to open MSI Afterburner
>!o:: ToggleMSIAfterburner()

; `RAlt + K` to toggle Gaming Network Environment
>!k up:: RunScriptAsAdmin(toggleGameEnv)

; `RAlt + \` to send text
#HotIf WinActive("ahk_exe firefox.exe") or WinActive("ahk_exe chrome.exe") or WinActive("ahk_exe msedge.exe") or WinActive("ahk_exe brave.exe")
>!\:: SendTextLLMGeneralPrompt()
#HotIf

; `LAlt + `` to close currently active window
<!`:: CloseCurrentWindow()

; `RAlt + F12` to put the computer to sleep
>!F12:: PutComputerToSleep()

; `LCtrl + LShift + RAlt + F12` to restart the computer
<^<+>!F12:: PutComputerToRestart()

; `LAlt + /` to toggle the help window
<!/:: ToggleHelpWindow()

#HotIf

;;;;;;;;;; MOUSE BINDINGS ;;;;;;;;;;

; Right mouse button
; Press and hold right button, then scroll wheel up/down to trigger infinite scrolling
; End infinite scrolling by releasing the right button or clicking the left button
RButton:: InfiniteScrollHandler()

; Middle mouse button
MButton:: MiddleButtonHandler()