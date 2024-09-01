;;;;;;;;;;  + is Shift, ! is Alt, ^ is Ctrl, # is Win  ;;;;;;;;;;

;;;;;;;;;; https://www.autohotkey.com/docs/v2/Variables.htm#BuiltIn  ;;;;;;;;;;


#Requires AutoHotkey v2.0

#SingleInstance Force

;; Use `#Include` without any path:
;;   AHK will first look for the ahk script in the same directory as the script that contains the #Include directive.
;;   If not found there, it will search in the user's standard library folder (usually Documents\AutoHotkey\Lib).
;;   If still not found, it will look in the standard library folder of AHK's installation directory.
#Include common\constants.ahk
#Include common\gui.ahk
#Include common\utils.ahk
#Include function\keyboard.ahk
#Include function\mouse.ahk
#Include function\typing.ahk


;;;;;;;;;; SCHEDULED TASKS ;;;;;;;;;;


;;;;;;;;;; HOTKEYS BINDINGS ;;;;;;;;;;


; `LAlt + 1` to toggle Notepad++
<!1::ToggleNotepadPP()

; `LAlt + 2` to toggle Notepad2
<!2::ToggleNotepad2()

; `LAlt + 3` to toggle Visual Studio Code
<!3::ToggleVSCode()

; `LAlt + 4` to toggle Windows Terminal
<!4::ToggleWindowsTerminal()

; `RAlt + P` to toggle Spotify
>!p::ToggleSpotify()

; `LAlt + R` to toggle Telegram
<!r::ToggleTelegram()

; `LAlt + D` to toggle Discord
<!d::ToggleDiscord()

; `LAlt + W` to toggle WeChat
<!w::ToggleWeChat()

; `RAlt + L` to toggle Eudic
>!l::ToggleEudic()

; `RAlt + =` to toggle Bilibili
>!=::ToggleBilibili()

; `RAlt + -` to toggle Sandboxed Bilibili
>!-::ToggleSandboxedBilibili()

; `RAlt + 0` to open YouTube
>!0::OpenYouTube()

; `RAlt + 9` to open YouTube in a container
>!9::OpenYouTube2()

; `RAlt + RShift + P` to run Both Spotify and Lyricify
>+>!p::RunSpotifyAndLyricify()

; `RAlt + C` to start Ollama and Docker container for chat webui to chat with LLMs
>!c::StartOllamaAndDockerWebUI()

; `RAlt + K` to toggle Gaming Network Environment (Toggle the action after keys are released)
>!k up::
{
    KeyWait "Alt"
    KeyWait "k"
    if (A_PriorKey = "k")
    {
        RunAsAdmin(toggleGameEnv)
    }
}

; `RAlt + \` to send text
#HotIf WinActive("ahk_exe firefox.exe") or WinActive("ahk_exe chrome.exe") or WinActive("ahk_exe msedge.exe") or WinActive("ahk_exe brave.exe")
>!\::SendTextLLMGeneralPrompt()
#HotIf

; `LAlt + `` to close currently active window
<!`::CloseCurrentWindow()

; `RAlt + F12` to put the computer to sleep
>!F12::SendComputerToSleep()

; `LCtrl + LShift + RAlt + F12` to restart the computer
<^<+>!F12::SendComputerToRestart()

; `LAlt + /` to toggle the help window
<!/::ToggleHelpWindow()


;;;;;;;;;; MOUSE BINDINGS ;;;;;;;;;;


; Right mouse button
; Press and hold right button, then scroll wheel up/down to trigger infinite scrolling
; End infinite scrolling by releasing the right button or clicking the left button
RButton::RButtonHandler()
