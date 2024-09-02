;; This file contains the functions related to keyboard shortcuts and hotkeys.

;;;;;;;;;; KEYBOARD FUNCTIONS ;;;;;;;;;;

;; Toggle Notepad++
ToggleNotepadPP() {
    ; If it is running, toggle the window
    if ProcessExist("notepad++.exe") {
        if WinActive("ahk_exe notepad++.exe") {
            ; Window is active, minimize it to taskbar
            WinMinimize
        } else {
            WinActivate "ahk_exe notepad++.exe"
        }
    }
    ; If it is not running, run it
    else {
        Run notepadpp
        SetAndActivateWindow("ahk_exe notepad++.exe", notepadppDim.x, notepadppDim.y, notepadppDim.w, notepadppDim.h)
    }
}

;; Toggle Notepad2
ToggleNotepad2() {
    ; If it is running, toggle the window
    if ProcessExist("Notepad2.exe") {
        if WinActive("ahk_exe Notepad2.exe") {
            ; Window is active, minimize it to taskbar
            WinMinimize
        } else {
            WinActivate "ahk_exe Notepad2.exe"
        }
    }
    ; If it is not running, run it
    else {
        Run notepad2
        ActivateWindow("ahk_exe Notepad2.exe")
        ; SetAndActivateWindow("ahk_exe Notepad2.exe", notepad2Dim.x, notepad2Dim.y, notepad2Dim.w, notepad2Dim.h)
    }
}

;; Toggle Visual Studio Code
ToggleVSCode() {
    ; If it is running, toggle the window
    if ProcessExist("Code.exe") {
        if WinActive("ahk_exe Code.exe") {
            ; Window is active, minimize it to taskbar
            WinMinimize
        } else {
            WinActivate "ahk_exe Code.exe"
        }
    }
    ; If it is not running, run it
    else {
        Run vscode
        SetAndActivateWindow("ahk_exe Code.exe", vscodeDim.x, vscodeDim.y, vscodeDim.w, vscodeDim.h)
    }
}

;; Toggle Windows Terminal
ToggleWindowsTerminal() {
    ; If it is running, toggle the window
    if ProcessExist("WindowsTerminal.exe") {
        if WinActive("ahk_exe WindowsTerminal.exe") {
            ; Window is active, minimize it to taskbar
            WinMinimize
        } else {
            WinActivate "ahk_exe WindowsTerminal.exe"
        }
    }
    ; If it is not running, run it
    else {
        Run terminal
        ActivateWindow("ahk_exe WindowsTerminal.exe")
    }
}

;; Toggle Spotify
ToggleSpotify() {
    ; If it is running, toggle the window
    if ProcessExist("Spotify.exe") {
        if WinActive("ahk_exe Spotify.exe") {
            ; Window is active, close to minimize it to the system tray
            WinClose
        } else if WinExist("ahk_exe Spotify.exe") and !WinActive("ahk_exe Spotify.exe") {
            WinActivate "ahk_exe Spotify.exe"
        } else {
            Run spotify
        }
    }
    ; If it is not running, run it
    else {
        Run spotify
        SetAndActivateWindow("ahk_exe Spotify.exe", spotifyDim.x, spotifyDim.y, spotifyDim.w, spotifyDim.h)
    }
}

;; Toggle Telegram
ToggleTelegram() {
    ; If it is running, toggle the window
    if ProcessExist("Telegram.exe") {
        if WinActive("ahk_exe Telegram.exe") {
            ; Window is active, close to minimize it to the system tray
            WinClose
        } else if WinExist("ahk_exe Telegram.exe") and !WinActive("ahk_exe Telegram.exe") {
            WinActivate "ahk_exe Telegram.exe"
        } else {
            Run telegram
        }
    }
    ; If it is not running, run it
    else {
        Run telegram
        SetAndActivateWindow("ahk_exe Telegram.exe", telegramDim.x, telegramDim.y, telegramDim.w, telegramDim.h)
    }
}

;; Toggle Discord
ToggleDiscord() {
    global discord

    ; If it is running, toggle the window
    if ProcessExist("Discord.exe") {
        if WinActive("ahk_exe Discord.exe") {
            ; Window is active, close to minimize it to the system tray
            WinClose
        } else if WinExist("ahk_exe Discord.exe") and !WinActive("ahk_exe Discord.exe") {
            WinActivate "ahk_exe Discord.exe"
        } else {
            if discord != "" {
                Run discord
            } else {
                discord := GetExePath(EnvGet("LocalAppData") . "\Discord" . "\app-*", "Discord.exe")
                if discord != "" {
                    Run discord
                } else {
                    MsgBox "ERROR! Discord.exe not found in the expected directory `"" . discord . "`"."
                }
            }
        }
    }
    ; If it is not running, run it
    else {
        ; Get the path to the executable
        discord := GetExePath(EnvGet("LocalAppData") . "\Discord" . "\app-*", "Discord.exe")
        if discord != "" {
            Run discord
            SetAndActivateWindow("ahk_exe Discord.exe", discordDim.x, discordDim.y, discordDim.w, discordDim.h)
        } else {
            MsgBox "ERROR! Discord.exe not found in the expected directory `"" . discord . "`"."
        }
    }
}

;; Toggle WeChat
ToggleWeChat() {
    ; If it is running, toggle the window
    if ProcessExist("WeChat.exe") {
        if WinActive("ahk_exe WeChat.exe ahk_class WeChatMainWndForPC") {
            ; Window is active, close to minimize it to the system tray
            WinClose
        } else if WinExist("ahk_exe WeChat.exe") and !WinActive("ahk_exe WeChat.exe") {
            WinActivate "ahk_exe WeChat.exe"
        } else {
            Run wechat
        }
    }
    ; If it is not running, run it
    else {
        Run wechat
        ActivateWindowAndClick("ahk_exe WeChat.exe ahk_class WeChatLoginWndForPC", , , wechatLoginBtnX, wechatLoginBtnY
        )

        ; Show a notification
        ToolTip("WeChat Login")
        SetTimer () => ToolTip(), -1000  ; Remove the tooltip after 1 seconds

        if WinWait("ahk_exe WeChat.exe ahk_class WeChatMainWndForPC", , 8) {
            SetAndActivateWindow("ahk_exe WeChat.exe ahk_class WeChatMainWndForPC", wechatDim.x, wechatDim.y, wechatDim
                .w, wechatDim.h)
        } else {
            MsgBox "ERROR! WeChat.exe window could not be found!"
        }
    }
}

;; Toggle Eudic
ToggleEudic() {
    ; If it is running, toggle the window
    if ProcessExist("eudic.exe") {
        if WinActive("ahk_exe eudic.exe") {
            ; Window is active, close to minimize it to the system tray
            WinClose "ahk_exe eudic.exe"
        } else if WinExist("ahk_exe eudic.exe") and !WinActive("ahk_exe eudic.exe") {
            WinActivate "ahk_exe eudic.exe"
        } else {
            Run eudic
            ; ActivateWindow("ahk_exe eudic.exe")
        }
    }
    ; If it is not running, run it
    else {
        Run eudic
        SetAndActivateWindow("ahk_exe eudic.exe", eudicDim.x, eudicDim.y, eudicDim.w, eudicDim.h)
    }
}

;; Toggle Bilibili
ToggleBilibili() {
    global bilibiliWinId

    ; If it is running, toggle the window
    if ProcessExist("哔哩哔哩.exe") {
        winList := WinGetList("ahk_exe 哔哩哔哩.exe ahk_class Chrome_WidgetWin_1")

        switch winList.Length {
            ; No bilibili window, run it
            case 0:
                Run bilibili
                if bilibiliWinId == "" {
                    bilibiliWinId := WinGetID("ahk_exe 哔哩哔哩.exe ahk_class Chrome_WidgetWin_1")
                }
                ; Only one bilibili window, toggle the window
            case 1:
                if WinActive("ahk_id " . winList[1]) {
                    WinMinimize
                } else {
                    WinActivate "ahk_id " . winList[1]
                }
                if bilibiliWinId == "" {
                    bilibiliWinId := WinGetID("ahk_exe 哔哩哔哩.exe ahk_class Chrome_WidgetWin_1")
                }
                ; Two bilibili windows (home window & video window), activate the video window
            case 2:
                for win_id in winList {
                    ; Find the window that's not bilibiliWinId (video window)
                    if win_id != bilibiliWinId {
                        if WinActive("ahk_exe 哔哩哔哩.exe ahk_id " . win_id) {
                            WinMinimize
                        } else {
                            SetAndActivateWindow("ahk_exe 哔哩哔哩.exe ahk_id " . win_id, bilibiliVidDim.x, bilibiliVidDim.y,
                                bilibiliVidDim.w, bilibiliVidDim.h)
                        }
                        break
                    }
                }
            default:
                MsgBox "ERROR! Unexpected number of bilibili windows: " . winList.Length
        }
    }
    ; If it is not running, run it
    else {
        Run bilibili
        SetAndActivateWindow("ahk_exe 哔哩哔哩.exe ahk_class Chrome_WidgetWin_1", bilibiliDim.x, bilibiliDim.y, bilibiliDim
            .w, bilibiliDim.h)
        bilibiliWinId := WinGetID("ahk_exe 哔哩哔哩.exe ahk_class Chrome_WidgetWin_1")
    }
}

;; Toggle Sandboxed Bilibili (Running in Sanboxie)
ToggleSandboxedBilibili() {
    global bilibiliSandboxedWinId

    ; If it is running, toggle the window
    if ProcessExist("哔哩哔哩.exe") {
        winList := WinGetList("ahk_exe 哔哩哔哩.exe ahk_class Sandbox:MultiAccount:Chrome_WidgetWin_1")

        switch winList.Length {
            ; No bilibili window, run it
            case 0:
                Run bilibiliSandboxed
                if bilibiliSandboxedWinId == "" {
                    bilibiliSandboxedWinId := WinGetID(
                        "ahk_exe 哔哩哔哩.exe ahk_class Sandbox:MultiAccount:Chrome_WidgetWin_1")
                }
                ; Only one bilibili window, toggle the window
            case 1:
                if WinActive("ahk_id " . winList[1]) {
                    WinMinimize
                } else {
                    WinActivate "ahk_id " . winList[1]
                }
                if bilibiliSandboxedWinId == "" {
                    bilibiliSandboxedWinId := WinGetID(
                        "ahk_exe 哔哩哔哩.exe ahk_class Sandbox:MultiAccount:Chrome_WidgetWin_1")
                }
                ; Two bilibili windows (home window & video window), activate the video window
            case 2:
                for win_id in winList {
                    ; Find the window that's not bilibiliSandboxedWinId (video window)
                    if win_id != bilibiliSandboxedWinId {
                        if WinActive("ahk_exe 哔哩哔哩.exe ahk_id " . win_id) {
                            WinMinimize
                        } else {
                            SetAndActivateWindow("ahk_exe 哔哩哔哩.exe ahk_id " . win_id, bilibiliVidDim.x, bilibiliVidDim.y,
                                bilibiliVidDim.w, bilibiliVidDim.h)
                        }
                        break
                    }
                }
            default:
                MsgBox "ERROR! Unexpected number of bilibili (sandboxed) windows: " . winList.Length
        }
    }
    ; If it is not running, run it
    else {
        Run bilibiliSandboxed
        SetAndActivateWindow("ahk_exe 哔哩哔哩.exe ahk_class Sandbox:MultiAccount:Chrome_WidgetWin_1", bilibiliDim.x,
            bilibiliDim.y, bilibiliDim.w, bilibiliDim.h)
        bilibiliSandboxedWinId := WinGetID("ahk_exe 哔哩哔哩.exe ahk_class Sandbox:MultiAccount:Chrome_WidgetWin_1")
    }
}

;; Open YouTube with browser
OpenYouTube() {
    Run '"' . browser . '" "https://www.youtube.com"'
}

;; Open YouTube with browser
OpenYouTube2() {
    ; With the help of browser extension "Open external links in a container"
    ; Extension Repo: https://github.com/honsiorovskyi/open-url-in-container
    Run '"' . browser . '" "ext+container:name=Dintionte&url=https://www.youtube.com"'
}

;; Run Spotify and Lyricify together
RunSpotifyAndLyricify() {
    if !WinActive("ahk_exe Spotify.exe") {
        ToggleSpotify()
        sleep 100
    }
    ; Run Lyricify if it's not running
    if ProcessExist("ahk_exe Lyricify for Spotify.exe") == 0 {
        Run lyricify
        CloseWindow("ahk_exe Lyricify for Spotify.exe")
    }
}

;; Start Ollama and Docker container for chat webui
StartOllamaAndDockerWebUI() {
    ; Start Docker Desktop if it's not running
    if ProcessExist("Docker Desktop.exe") == 0 {
        Run docker
        CloseWindow("ahk_exe Docker Desktop.exe", 5)
        Sleep 3500
    }

    ; Start open-webui container
    Run "pwsh.exe -Command " . "docker start " . dockerContainerName, , "Hide"

    ; Start Ollama if it's not running
    if ProcessExist("ollama.exe") == 0 {
        Run A_ComSpec . ' /c "' . ollama . '"', , "Hide"
    }

    sleep 500

    ; Show a notification
    if ProcessExist("Docker Desktop.exe") != 0 and ProcessExist("ollama.exe") != 0 {
        ToolTip("Docker & Ollama started")
        SetTimer () => ToolTip(), -1000  ; Remove the tooltip after 1 seconds
        sleep 500
        Run '"' . browser . '" "' . openWebuiUrl . '"'
    } else {
        if ProcessExist("Docker Desktop.exe") == 0 {
            ToolTip("ERROR! Docker Desktop not started")
            SetTimer () => ToolTip(), -2000
        } else if ProcessExist("ollama.exe") == 0 {
            ToolTip("ERROR! Ollama not started")
            SetTimer () => ToolTip(), -2000
        }
    }
}

;; Toggle the help window
ToggleHelpWindow() {
    window := helpWindow.gui
    lv := helpWindow.lv

    if !WinExist("ahk_id " . window.Hwnd) {
        ; Update colors before showing the window
        SetHelpWindowColors(window, lv)

        ; Show the help window
        window.Show("w" . A_ScreenWidth . " h" . A_ScreenHeight)

        ; Set opacity (200/255)
        WinSetTransparent(200, window)

        ; Hide the window after an interval (4 seconds)
        ; SetTimer(() => window.Hide(), -4000)
    } else {
        window.Hide()
        ; Cancel the timer if manually hidden
        ; SetTimer(() => window.Hide(), 0)
    }
}

;; Close currently active window
CloseCurrentWindow() {
    ; Close the active window
    ; "A" is a special value in AHK v2 that always refers to the active window
    WinClose("A")
}

;; Put the computer to sleep
PutComputerToSleep() {
    DllCall("PowrProf.dll\SetSuspendState", "Int", 0, "Int", 0, "Int", 0)
}

;; Restart the computer (* seconds countdown)
PutComputerToRestart() {
    countDownSeconds := 5
    Run(
        'pwsh.exe -Command "for ($i = ' . countDownSeconds .
        '; $i -gt 0; $i--) { Write-Host \"Restarting in $i seconds...\"; Start-Sleep -Seconds 1 }; Restart-Computer"'
    )
}
