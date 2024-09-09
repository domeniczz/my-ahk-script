;; This file contains the functions related to keyboard shortcuts and hotkeys.

;;;;;;;;;; TOGGLE FUNCTIONS ;;;;;;;;;;

/**
 * Toggle Notepad++
 */
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

/**
 * Toggle Notepad2
 */
ToggleNotepad2() {
    ; If it is running, toggle the window
    if ProcessExist("Notepad2.exe") {
        winList := WinGetList("ahk_exe Notepad2.exe")
        if winList.Length == 1 {
            if WinActive("ahk_id " . winList[1]) {
                ; Window is active, minimize it to taskbar
                WinMinimize
            } else {
                WinActivate "ahk_id " . winList[1]
            }
        }
        ; More than one expected window, cycle through them
        else if winList.Length > 1 {
            for win_id in winList {
                if win_id == winList[winList.Length] {
                    if WinActive("ahk_id " . win_id) {
                        WinMinimize
                    } else {
                        WinActivate "ahk_id " . win_id
                    }
                    break
                }
            }
        }
    }
    ; If it is not running, run it
    else {
        Run notepad2
        ActivateWindow("ahk_exe Notepad2.exe")
        ; SetAndActivateWindow("ahk_exe Notepad2.exe", notepad2Dim.x, notepad2Dim.y, notepad2Dim.w, notepad2Dim.h)
    }
}

/**
 * Toggle Visual Studio Code
 */
ToggleVSCode() {
    ; If it is running, toggle the window
    if ProcessExist("Code.exe") {
        winList := WinGetList("ahk_exe Code.exe")
        if winList.Length == 1 {
            if WinActive("ahk_id " . winList[1]) {
                ; Window is active, minimize it to taskbar
                WinMinimize
            } else {
                WinActivate "ahk_id " . winList[1]
            }
        }
        ; More than one expected window, cycle through them
        else if winList.Length > 1 {
            for win_id in winList {
                if win_id == winList[winList.Length] {
                    if WinActive("ahk_id " . win_id) {
                        WinMinimize
                    } else {
                        WinActivate "ahk_id " . win_id
                    }
                    break
                }
            }
        }
    }
    ; If it is not running, run it
    else {
        Run vscode
        SetAndActivateWindow("ahk_exe Code.exe", vscodeDim.x, vscodeDim.y, vscodeDim.w, vscodeDim.h, , 10)
    }
}

/**
 * Toggle Windows Terminal
 */
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

firefoxWinId := ""
firefoxPrivateWinId := ""

/**
 * Toggle Firefox
 * 
 * @param {Boolean} isPrivate - Whether to toggle the private window (default: false)
 */
ToggleFirefox(isPrivate := false) {
    global firefoxWinId, firefoxPrivateWinId

    ; If it is running, toggle the window
    if ProcessExist("firefox.exe") {
        allWinList := WinGetList("ahk_exe firefox.exe")
        winList := []
        for windowId in allWinList {
            winTitleToExclude := isPrivate ? "Mozilla Firefox$" : "Mozilla Firefox Private Browsing$"
            if !RegExMatch(WinGetTitle("ahk_id " windowId), winTitleToExclude) {
                winList.Push(windowId)
            }
        }

        ; No expected window, run it
        if winList.Length == 0 {
            Run !isPrivate ? firefox : firefoxPrivate
        }
        ; Only one expected window, toggle it
        else if winList.Length == 1 {
            if WinActive("ahk_id " . winList[1]) {
                WinMinimize
            } else {
                WinActivate "ahk_id " . winList[1]
            }
        }
        ; More than one expected window, cycle through them
        else if winList.Length > 1 {
            for win_id in winList {
                if win_id == winList[winList.Length] {
                    if WinActive("ahk_id " . win_id) {
                        WinMinimize
                    } else {
                        WinActivate "ahk_id " . win_id
                    }
                    break
                }
            }
        }
    }
    ; If it is not running, run it
    else {
        Run !isPrivate ? firefox : firefoxPrivate
        ActivateWindow("ahk_exe firefox.exe")
    }
}

/**
 * Toggle Spotify
 */
ToggleSpotify() {
    ; If it is running, toggle the window
    if ProcessExist("Spotify.exe") {
        if WinActive("ahk_exe Spotify.exe") {
            ; Window is active, close to minimize it to the system tray
            WinClose
        } else if WinExist("ahk_exe Spotify.exe") and !WinActive("ahk_exe Spotify.exe") {
            WinActivate
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

/**
 * Toggle Telegram
 */
ToggleTelegram() {
    ; If it is running, toggle the window
    if ProcessExist("Telegram.exe") {
        if WinActive("ahk_exe Telegram.exe") {
            ; Window is active, close to minimize it to the system tray
            WinClose
        } else if WinExist("ahk_exe Telegram.exe") and !WinActive("ahk_exe Telegram.exe") {
            WinActivate
        } else {
            Run telegram
        }
    }
    ; If it is not running, run it
    else {
        Run telegram
        SetWindow("ahk_exe Telegram.exe", telegramDim.x, telegramDim.y, telegramDim.w, telegramDim.h)
        ActivateWindow("ahk_exe Telegram.exe")
    }
}

/**
 * Toggle Discord
 */
ToggleDiscord() {
    global discord

    ; If it is running, toggle the window
    if ProcessExist("Discord.exe") {
        if WinActive("ahk_exe Discord.exe") {
            ; Window is active, close to minimize it to the system tray
            WinClose
        } else if WinExist("ahk_exe Discord.exe") and !WinActive("ahk_exe Discord.exe") {
            WinActivate
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

/**
 * Toggle WeChat
 */
ToggleWeChat() {
    ; If it is running, toggle the window
    if ProcessExist("WeChat.exe") {
        if WinActive("ahk_exe WeChat.exe ahk_class WeChatMainWndForPC") {
            ; Window is active, close to minimize it to the system tray
            WinClose
        } else if WinExist("ahk_exe WeChat.exe") and !WinActive("ahk_exe WeChat.exe") {
            Run wechat
            WinActivate
        } else {
            Run wechat
        }
    }
    ; If it is not running, run it
    else {
        Run wechat
        ActivateWindowAndClick("ahk_exe WeChat.exe ahk_class WeChatLoginWndForPC", , , wechatLoginBtnX, wechatLoginBtnY)

        ToolTip("WeChat Login")
        SetTimer () => ToolTip(), -1000, -1

        if WinWait("ahk_exe WeChat.exe ahk_class WeChatMainWndForPC", , 8) {
            SetAndActivateWindow("ahk_exe WeChat.exe ahk_class WeChatMainWndForPC", wechatDim.x, wechatDim.y, wechatDim.w, wechatDim.h)
        } else {
            MsgBox "ERROR! WeChat.exe window could not be found!"
        }
    }
}

/**
 * Toggle Tencent TIM
 */
ToggleTencentTIM() {
    ; If it is running, toggle the window
    if ProcessExist("TIM.exe") {
        if WinActive("ahk_exe TIM.exe") {
            ; Window is active, close to minimize it to the system tray
            WinClose
        } else {
            Send "{LAlt down}q{LAlt up}"
        }
    }
    ; If it is not running, run it
    else {
        Run tim
        ; SetWindow("ahk_exe Telegram.exe", telegramDim.x, telegramDim.y, telegramDim.w, telegramDim.h)
        ActivateWindow("ahk_exe TIM.exe")
        loginPageId := WinGetID("ahk_exe TIM.exe")
        MaxAttempts := 40
        loop MaxAttempts {
            if WinGetID("ahk_exe TIM.exe") != loginPageId {
                SetAndActivateWindow("ahk_exe TIM.exe", timDim.x, timDim.y, timDim.w, timDim.h)
                break
            }
            sleep 100
        }
        if MaxAttempts <= A_Index {
            MsgBox "ERROR! TIM.exe main window could not be found!"
        }
    }
}

/**
 * Toggle DingTalk
 */
ToggleDingTalk() {
    ; If it is running, toggle the window
    if ProcessExist("DingTalk.exe") {
        if WinActive("ahk_exe DingTalk.exe") {
            ; Window is active, close to minimize it to the system tray
            WinClose
            ToolTip("11111")
            SetTimer () => ToolTip(), -1000, -1
        } else if WinExist("ahk_exe DingTalk.exe") and !WinActive("ahk_exe DingTalk.exe") {
            Run dingtalk
            WinActivate
            ToolTip("22222")
            SetTimer () => ToolTip(), -1000, -1
        } else {
            Run dingtalk
            ToolTip("33333")
            SetTimer () => ToolTip(), -1000, -1
        }
    }
    ; If it is not running, run it
    else {
        Run dingtalk
        MaxAttempts1 := 40
        loop MaxAttempts1 {
            ; Login window shows at first
            if WinExist("ahk_exe DingTalk.exe ahk_class Qt51511QWindowIcon") {
                MaxAttempts2 := 80
                loop MaxAttempts2 {
                    if WinExist("ahk_exe DingTalk.exe ahk_class StandardFrame_DingTalk") {
                        ActivateWindow("ahk_exe DingTalk.exe ahk_class StandardFrame_DingTalk")
                        SetWindow("ahk_exe DingTalk.exe ahk_class StandardFrame_DingTalk", dingtalkDim.x, dingtalkDim.y, dingtalkDim.w, dingtalkDim.h)
                        break
                    }
                    sleep 50
                }
                break
            }
            sleep 100
        }
        if MaxAttempts1 <= A_Index {
            MsgBox "ERROR! DingTalk.exe window could not be found!"
        }
    }
}

/**
 * Toggle Eudic
 */
ToggleEudic() {
    ; If it is running, toggle the window
    if ProcessExist("eudic.exe") {
        if WinActive("ahk_exe eudic.exe") {
            ; Window is active, close to minimize it to the system tray
            WinClose "ahk_exe eudic.exe"
        } else if WinExist("ahk_exe eudic.exe") and !WinActive("ahk_exe eudic.exe") {
            WinActivate
        } else {
            Run eudic
            ActivateWindow("ahk_exe eudic.exe")
        }
    }
    ; If it is not running, run it
    else {
        Run eudic
        SetAndActivateWindow("ahk_exe eudic.exe", eudicDim.x, eudicDim.y, eudicDim.w, eudicDim.h)
    }
}

; ahk_id of bilibili home page window
bilibiliWinId := ""

/**
 * Toggle Bilibili
 * When there are two windows, home window and video window, then toggle the video window
 */
ToggleBilibili() {
    global bilibiliWinId

    ; If it is running, toggle the window
    if ProcessExist("哔哩哔哩.exe") {
        winList := WinGetList("ahk_exe 哔哩哔哩.exe ahk_class Chrome_WidgetWin_1")

        switch winList.Length {
            case 0:
                ; No window, run it
                Run bilibili
                if bilibiliWinId == "" and WinWait("ahk_exe 哔哩哔哩.exe ahk_class Chrome_WidgetWin_1", , 10) {
                    SetAndActivateWindow("ahk_exe 哔哩哔哩.exe ahk_class Chrome_WidgetWin_1", bilibiliDim.x, bilibiliDim.y, bilibiliDim.w, bilibiliDim.h)
                    bilibiliWinId := WinGetID("ahk_exe 哔哩哔哩.exe ahk_class Chrome_WidgetWin_1")
                }
            case 1:
                ; Only one window, toggle the window
                if WinActive("ahk_id " . winList[1]) {
                    WinMinimize
                } else {
                    WinActivate "ahk_id " . winList[1]
                }
                if bilibiliWinId == "" {
                    bilibiliWinId := winList[1]
                }
            case 2:
                if bilibiliWinId == "" {
                    bilibiliWinId := WinGetList("哔哩哔哩 (゜-゜)つロ 干杯~-bilibili ahk_exe 哔哩哔哩.exe ahk_class Sandbox:MultiAccount:Chrome_WidgetWin_1")[1]
                }
                ; Two windows (home window & video window), activate the video window
                for win_id in winList {
                    ; Find the video window (bilibiliWinId represents the home window)
                    if win_id != bilibiliWinId {
                        if WinActive("ahk_id " . win_id) {
                            WinMinimize
                        } else {
                            SetAndActivateWindow("ahk_id " . win_id, bilibiliVidDim.x, bilibiliVidDim.y, bilibiliVidDim.w, bilibiliVidDim.h)
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
        SetAndActivateWindow("ahk_exe 哔哩哔哩.exe ahk_class Chrome_WidgetWin_1", bilibiliDim.x, bilibiliDim.y, bilibiliDim.w, bilibiliDim.h)
        bilibiliWinId := WinGetID("ahk_exe 哔哩哔哩.exe ahk_class Chrome_WidgetWin_1")
    }
}

; ahk_id of bilibili (sandboxed) home page window
bilibiliSandboxedWinId := ""

/**
 * Toggle Sandboxed Bilibili (Running in Sanboxie)
 * When there are two windows, home window and video window, then toggle the video window
 */
ToggleSandboxedBilibili() {
    global bilibiliSandboxedWinId

    ; If it is running, toggle the window
    if ProcessExist("哔哩哔哩.exe") {
        winList := WinGetList("ahk_exe 哔哩哔哩.exe ahk_class Sandbox:MultiAccount:Chrome_WidgetWin_1")

        switch winList.Length {
            case 0:
                ; No window, run it
                Run bilibiliSandboxed
                if bilibiliSandboxedWinId == "" and WinWait("ahk_exe 哔哩哔哩.exe ahk_class Sandbox:MultiAccount:Chrome_WidgetWin_1", , 10) {
                    SetAndActivateWindow("ahk_exe 哔哩哔哩.exe ahk_class Sandbox:MultiAccount:Chrome_WidgetWin_1", bilibiliDim.x, bilibiliDim.y, bilibiliDim.w, bilibiliDim.h)
                    bilibiliSandboxedWinId := WinGetID("ahk_exe 哔哩哔哩.exe ahk_class Sandbox:MultiAccount:Chrome_WidgetWin_1")
                }
            case 1:
                ; Only one window, toggle the window
                if WinActive("ahk_id " . winList[1]) {
                    WinMinimize
                } else {
                    WinActivate "ahk_id " . winList[1]
                }
                if bilibiliSandboxedWinId == "" {
                    bilibiliSandboxedWinId := winList[1]
                }
            case 2:
                ; Two windows (home window & video window), activate the video window
                for win_id in winList {
                    if bilibiliSandboxedWinId == "" {
                        bilibiliSandboxedWinId := WinGetList("哔哩哔哩 (゜-゜)つロ 干杯~-bilibili ahk_exe 哔哩哔哩.exe ahk_class Sandbox:MultiAccount:Chrome_WidgetWin_1")[1]
                    }
                    ; Find the video window (bilibiliWinId represents the home window)
                    if win_id != bilibiliSandboxedWinId {
                        if WinActive("ahk_id " . win_id) {
                            WinMinimize
                        } else {
                            SetAndActivateWindow("ahk_id " . win_id, bilibiliVidDim.x, bilibiliVidDim.y, bilibiliVidDim.w, bilibiliVidDim.h)
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
        SetAndActivateWindow("ahk_exe 哔哩哔哩.exe ahk_class Sandbox:MultiAccount:Chrome_WidgetWin_1", bilibiliDim.x, bilibiliDim.y, bilibiliDim.w, bilibiliDim.h)
        bilibiliSandboxedWinId := WinGetID("ahk_exe 哔哩哔哩.exe ahk_class Sandbox:MultiAccount:Chrome_WidgetWin_1")
    }
}

/**
 * Open YouTube with browser
 */
OpenYouTube() {
    Run '"' . browser . '" "https://www.youtube.com"'
}

/**
 * Open YouTube with browser
 */
OpenYouTube2() {
    ; With the help of browser extension "Open external links in a container"
    ; Extension Repo: https://github.com/honsiorovskyi/open-url-in-container
    Run '"' . browser . '" "ext+container:name=Dintionte&url=https://www.youtube.com"'
}

/**
 * Run Spotify and Lyricify together
 */
RunSpotifyAndLyricify() {
    if !WinActive("ahk_exe Spotify.exe") {
        ToggleSpotify()
    }

    sleep 1000

    ; Run Lyricify if it's not running
    if !ProcessExist("Lyricify for Spotify.exe") {
        Run lyricify
        CloseWindow("ahk_exe Lyricify for Spotify.exe", 10)
    } else {
        if WinExist("ahk_exe Lyricify for Spotify.exe") {
            CloseWindow("ahk_exe Lyricify for Spotify.exe", 10)
        }
    }
}

/**
 * Start Ollama and Docker container for chat webui
 */
StartOllamaAndDockerWebUI() {
    isDockerAlreadyRunning := ProcessExist("Docker Desktop.exe")
    ; Start Docker Desktop if it's not running
    if !isDockerAlreadyRunning {
        Run docker
        CloseWindow("ahk_exe Docker Desktop.exe", 5)
        sleep 2000
    }

    isOllamaAlreadyRunning := ProcessExist("ollama.exe")
    ; Start Ollama if it's not running
    if !isOllamaAlreadyRunning {
        Run A_ComSpec . ' /c "' . ollama . '"', , "Hide"
        sleep 500
    }

    isContainerStarted := IsDockerContainerRunning(openWebuiDockerContainerName)

    if !isContainerStarted {
        ; Start open-webui container
        Run "pwsh.exe -Command " . "docker start " . openWebuiDockerContainerName, , "Hide"
        sleep 1000
        MaxAttempts := 20
        loop MaxAttempts {
            if IsDockerContainerRunning(openWebuiDockerContainerName) {
                isContainerStarted := true
                break
            } else if Round(Mod(A_Index, 5)) == 2 {
                Run "pwsh.exe -Command " . "docker start " . openWebuiDockerContainerName, , "Hide"
            }
            sleep 500
        }
    }

    if isContainerStarted and ProcessExist("Docker Desktop.exe") and ProcessExist("ollama.exe") {
        ToolTip("Docker & Ollama started")
        SetTimer () => ToolTip(), -2000, -1
        if !isDockerAlreadyRunning {
            sleep 4500
        }
        Run '"' . browser . '" "' . openWebuiUrl . '"'
        if !isDockerAlreadyRunning {
            sleep 1600
            Send "{F5}"
        }
    } else {
        msg := !ProcessExist("Docker Desktop.exe") ? "Docker Desktop &" : ""
        msg .= !ProcessExist("ollama.exe") ? " Ollama" : ""
        ToolTip("ERROR! " . msg . " not started")
        SetTimer () => ToolTip(), -2000, -1
    }
}

/**
 * Toggle MSI Afterburner (it will also toggle RivaTuner Statistics Server)
 */
ToggleMSIAfterburner() {
    ; If it is running, toggle the window
    if ProcessExist("MSIAfterburner.exe") {
        if WinExist("ahk_exe MSIAfterburner.exe") and !WinActive("ahk_exe MSIAfterburner.exe") {
            WinActivate
        } else {
            Run msiafterburner
        }
    }
    ; If it is not running, run it
    else {
        Run msiafterburner
        ToolTip("MSI Afterburner started")
        SetTimer () => ToolTip(), -2500, -1
    }
}

/**
 * Close currently active window
 */
CloseCurrentWindow() {
    ; Close the active window
    ; "A" is a special value in AHK v2 that always refers to the active window
    WinClose("A")
}

/**
 * Put the computer to sleep
 */
PutComputerToSleep() {
    DllCall("PowrProf.dll\SetSuspendState", "Int", 0, "Int", 0, "Int", 0)
}

/**
 * Restart the computer (* seconds countdown)
 */
PutComputerToRestart() {
    countDownSeconds := 5
    Run('pwsh.exe -Command "for ($i = ' . countDownSeconds . '; $i -gt 0; $i--) { Write-Host \"Restarting in $i seconds...\"; Start-Sleep -Seconds 1 }; Restart-Computer"')
}
