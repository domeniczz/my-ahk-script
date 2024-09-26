;; This file contains the functions related to keyboard shortcuts and hotkeys.

;;;;;;;;;; GLOBAL VARIABLES ;;;;;;;;;;

/**
 * Global data needed for application toggling
 * 
 * Key:
 * 
 * - application name (String)
 * 
 * Value:
 * 
 * - `allWinIdList`: all windows' ahk_id list (Array)
 * - `nonprivatewinIdList`: non-private browser windows' ahk_id list (Array)
 * - `privateWinIdList`: private browser windows' ahk_id list (Array)
 * - `pid`: process id (String)
 */
appData := Map(
    "explorer", {
        allWinIdList: []
    }, "Notepad2", {
        allWinIdList: []
    }, "Code", {
        allWinIdList: []
    }, "Cursor", {
        allWinIdList: []
    }, "firefox", {
        allWinIdList: [],
        nonprivatewinIdList: [],
        privateWinIdList: [],
        pid: ""
    }, "brave", {
        allWinIdList: [],
        nonprivatewinIdList: [],
        privateWinIdList: [],
        pid: ""
    }, "chrome", {
        allWinIdList: [],
        nonprivatewinIdList: [],
        privateWinIdList: [],
        pid: ""
    }, "msedge", {
        allWinIdList: [],
        nonprivatewinIdList: [],
        privateWinIdList: [],
        pid: ""
    }
)

;;;;;;;;;; TOGGLE FUNCTIONS ;;;;;;;;;;

/**
 * Toggle Notepad++
 */
ToggleNotepadPP() {
    ToggleApplication(notepadpp, notepadppDim)
}

/**
 * Toggle Notepad2
 * 
 * @param {Boolean} newInstance - Whether to open a new instance (default: false)
 */
ToggleNotepad2(newInstance := false) {
    ToggleApplications(notepad2, , , , newInstance)
}

/**
 * Toggle Visual Studio Code
 * 
 * @param {Boolean} newInstance - Whether to open a new instance (default: false)
 */
ToggleVSCode(newInstance := false) {
    ToggleApplications(vscode, vscodeDim, , , newInstance)
}

/**
 * Toggle Cursor AI Editor
 * 
 * @param {Boolean} newInstance - Whether to open a new instance (default: false)
 */
ToggleCursor(newInstance := false) {
    ToggleApplications(cursor, cursorDim, , , newInstance)
}

/**
 * Toggle Windows Terminal
 * 
 * @param {Boolean} newInstance - Whether to open a new instance (default: false)
 */
ToggleWindowsTerminal(newInstance := false) {
    if newInstance {
        Run terminal
        if ActivateWindow("ahk_exe WindowsTerminal.exe") {
            SetWindow("ahk_exe WindowsTerminal.exe", terminalDim.x, terminalDim.y, terminalDim.w, terminalDim.h)
        }
        return
    }
    ToggleApplication(terminal, terminalDim, "WindowsTerminal.exe", "ahk_class CASCADIA_HOSTING_WINDOW_CLASS")
}

/**
 * Toggle specified Gecko based browser
 * 
 * @param {String} browser - The executable path of the browser (default: firefox)
 * @param {Boolean} isPrivate - Whether to toggle the private window (default: false)
 * @param {String} incognitoFlag - The flag to open the browser in incognito mode (default: "--private-window")
 */
ToggleGecko(browser := firefox, isPrivate := false, incognitoFlag := "--private-window") {
    global appData

    exe := GetPathComponent(browser, "name")
    name := GetPathComponent(browser, "nameNoExt")

    ; Check if this `name` exists in map `appData`, if not, create it
    if (!appData.Has(name)) {
        appData[name] := {}
    }
    ; Check if below props exists for this name in map `appData`, if not, create it
    if (!appData[name].HasProp("allWinIdList")) {
        appData[name].allWinIdList := []
    }
    if (!appData[name].HasProp("nonprivatewinIdList")) {
        appData[name].nonprivatewinIdList := []
    }
    if (!appData[name].HasProp("privateWinIdList")) {
        appData[name].privateWinIdList := []
    }
    if (!appData[name].HasProp("pid")) {
        appData[name].pid := ""
    }

    ; If it is running, toggle the window
    if ProcessExist(exe) {
        ; If pid of the window is different, that means the process has been completely restarted
        if appData[name].pid != WinGetPID("ahk_exe " . exe) {
            ; Clear up
            appData[name].allWinIdList := []
            appData[name].nonprivatewinIdList := []
            appData[name].privateWinIdList := []
            appData[name].pid := WinGetPID("ahk_exe " . exe)
        }

        allWinList := WinGetList("ahk_exe " . exe)

        ; Remove the windows that does not exists anymore (for example, some windows were closed manually)
        if !isPrivate {
            tempList := []
            for winId in appData[name].nonprivatewinIdList {
                for id in allWinList {
                    if winId == id {
                        tempList.Push(id)
                    }
                }
            }
            appData[name].nonprivatewinIdList := tempList
        } else {
            tempList := []
            for privateWinId in appData[name].privateWinIdList {
                for id in allWinList {
                    if privateWinId == id {
                        tempList.Push(id)
                    }
                }
            }
            appData[name].privateWinIdList := tempList
        }

        ; Check for new windows
        newWins := []
        for winId in allWinList {
            isNewWindow := true
            for id in appData[name].allWinIdList {
                if winId == id {
                    isNewWindow := false
                    break
                }
            }
            if isNewWindow {
                newWins.Push(winId)
            }
        }

        ; Handle new windows
        for newWinId in newWins {
            if RegExMatch(WinGetTitle("ahk_id " newWinId), "Private Browsing$") {
                appData[name].privateWinIdList.InsertAt(1, newWinId)
            } else {
                appData[name].nonprivatewinIdList.InsertAt(1, newWinId)
            }
        }

        ; Update the list of all windows
        appData[name].allWinIdList := allWinList

        winList := !isPrivate ? appData[name].nonprivatewinIdList : appData[name].privateWinIdList

        ; No expected window, run it
        if winList.Length == 0 {
            Run !isPrivate ? browser : Format('"{1}" {2}', browser, incognitoFlag)
            ; Get the new window's ahk_id
            list := WinGetList("ahk_exe " . exe)
            for item in list {
                for id in appData[name].allWinIdList {
                    if item != id and A_Index == appData[name].allWinIdList.Length {
                        winId := item
                        break
                    }
                }
            }
            ; Store the window ahk_id
            if !isPrivate {
                appData[name].nonprivatewinIdList := [winId
                ]
            } else {
                appData[name].privateWinIdList := [winId
                ]
            }
            ActivateWindow("ahk_id " . winId)
        }
        ; Only one expected window, toggle it
        else if winList.Length == 1 {
            if WinActive("ahk_id " . winList[1]) {
                MinimizeWindow("ahk_id " . winList[1])
            } else {
                ActivateWindow("ahk_id " . winList[1])
            }
        }
        ; More than one expected window, cycle through them
        else if winList.Length > 1 {
            lastWinId := winList[winList.Length]
            ; the last window in the list will change, so we can cycle through all of them in this way
            if WinActive("ahk_id " . lastWinId) {
                MinimizeWindow("ahk_id " . lastWinId)
            } else {
                ActivateWindow("ahk_id " . lastWinId)
            }
            if !isPrivate {
                appData[name].nonprivatewinIdList.RemoveAt(appData[name].nonprivatewinIdList.Length)
                appData[name].nonprivatewinIdList.InsertAt(1, lastWinId)
            } else {
                appData[name].privateWinIdList.RemoveAt(appData[name].privateWinIdList.Length)
                appData[name].privateWinIdList.InsertAt(1, lastWinId)
            }
        }
        ; Unexpected number of windows
        else if winList.Length < 0 {
            LogError(Error('<0 "' . name . '" browser window has been found while the process exists.'))
        }
    }
    ; If it is not running, run it
    else {
        Run !isPrivate ? browser : Format('"{1}" {2}', browser, incognitoFlag)
        ActivateWindow("ahk_exe " . exe)
        winId := WinGetID("ahk_exe " . exe)
        if winId {
            ; Clear up
            appData[name].allWinIdList := []
            appData[name].nonprivatewinIdList := []
            appData[name].privateWinIdList := []

            ; Store the window ahk_id
            if !isPrivate {
                appData[name].nonprivatewinIdList.Push(winId)
            } else {
                appData[name].privateWinIdList.Push(winId)
            }
            appData[name].allWinIdList.Push(winId)

            appData[name].pid := WinGetPID("ahk_id " . winId)
        }
    }
}

/**
 * Toggle specified Chromium based browser
 * 
 * @param {String} browser - The executable path of the browser (default: chrome)
 * @param {Boolean} isPrivate - Whether to toggle the private window (default: false)
 * @param {String} incognitoFlag - The flag to open the browser in incognito mode (default: "--incognito")
 */
ToggleChromium(browser := chrome, isPrivate := false, incognitoFlag := "--incognito") {
    global appData

    exe := GetPathComponent(browser, "name")
    name := GetPathComponent(browser, "nameNoExt")

    ; Check if this `name` exists in map `appData`, if not, create it
    if (!appData.Has(name)) {
        appData[name] := {}
    }
    ; Check if below props exists for this name in map `appData`, if not, create it
    if (!appData[name].HasProp("allWinIdList")) {
        appData[name].allWinIdList := []
    }
    if (!appData[name].HasProp("nonprivatewinIdList")) {
        appData[name].nonprivatewinIdList := []
    }
    if (!appData[name].HasProp("privateWinIdList")) {
        appData[name].privateWinIdList := []
    }
    if (!appData[name].HasProp("pid")) {
        appData[name].pid := ""
    }

    ; If it is running, toggle the window
    if ProcessExist(exe) {
        ; If pid of the window is different, that means the process has been completely restarted
        if appData[name].pid != WinGetPID("ahk_exe " . exe) {
            ; Clear up
            appData[name].allWinIdList := []
            appData[name].nonprivatewinIdList := []
            appData[name].privateWinIdList := []
            appData[name].pid := WinGetPID("ahk_exe " . exe)
        }

        allWinList := WinGetList("ahk_exe " . exe)

        ; Remove the windows that does not exists anymore (for example, some windows were closed manually)
        if !isPrivate {
            tempList := []
            for winId in appData[name].nonprivatewinIdList {
                for id in allWinList {
                    if winId == id {
                        tempList.Push(id)
                    }
                }
            }
            appData[name].nonprivatewinIdList := tempList
        } else {
            tempList := []
            for privateWinId in appData[name].privateWinIdList {
                for id in allWinList {
                    if privateWinId == id {
                        tempList.Push(id)
                    }
                }
            }
            appData[name].privateWinIdList := tempList
        }

        ; Check for new windows
        newWins := []
        for winId in allWinList {
            isNewWindow := true
            for id in appData[name].allWinIdList {
                if winId == id {
                    isNewWindow := false
                    break
                }
            }
            if isNewWindow {
                newWins.Push(winId)
            }
        }

        ; Handle new windows
        if newWins.Length == 1 {
            newWinId := newWins[1]
            if !isPrivate {
                appData[name].nonprivatewinIdList.InsertAt(1, newWinId)
            } else {
                appData[name].privateWinIdList.InsertAt(1, newWinId)
            }
        }
        ; ATTENTION: Treat all new windows as new non-private windows if new windows are more than one
        else if newWins.Length > 1 {
            for newWinId in newWins {
                appData[name].nonprivatewinIdList.InsertAt(1, newWinId)
            }
        }

        ; Update the list of all windows
        appData[name].allWinIdList := allWinList

        winList := !isPrivate ? appData[name].nonprivatewinIdList : appData[name].privateWinIdList

        ; No expected window, run it
        if winList.Length == 0 {
            Run !isPrivate ? browser : Format('"{1}" {2}', browser, incognitoFlag)
            ; Get the new window's ahk_id
            list := WinGetList("ahk_exe " . exe)
            for item in list {
                for id in appData[name].allWinIdList {
                    if item != id and A_Index == appData[name].allWinIdList.Length {
                        winId := item
                        break
                    }
                }
            }
            ; Store the window ahk_id
            if !isPrivate {
                appData[name].nonprivatewinIdList := [winId
                ]
            } else {
                appData[name].privateWinIdList := [winId
                ]
            }
            if ActivateWindow("ahk_id " . winId) {
                try {
                    SetWindow("ahk_id " . winId, %name%Dim.x, %name%Dim.y, %name%Dim.w, %name%Dim.h)
                } catch {
                    SetWindow("ahk_id " . winId, chromiumDim.x, chromiumDim.y, chromiumDim.w, chromiumDim.h)
                }
            }
        }
        ; Only one expected window, toggle it
        else if winList.Length == 1 {
            if WinActive("ahk_id " . winList[1]) {
                MinimizeWindow("ahk_id " . winList[1])
            } else {
                ActivateWindow("ahk_id " . winList[1])
            }
        }
        ; More than one expected window, cycle through them
        else if winList.Length > 1 {
            lastWinId := winList[winList.Length]
            ; the last window in the list will change, so we can cycle through all of them in this way
            if WinActive("ahk_id " . lastWinId) {
                MinimizeWindow("ahk_id " . lastWinId)
            } else {
                ActivateWindow("ahk_id " . lastWinId)
            }
            if !isPrivate {
                appData[name].nonprivatewinIdList.RemoveAt(appData[name].nonprivatewinIdList.Length)
                appData[name].nonprivatewinIdList.InsertAt(1, lastWinId)
            } else {
                appData[name].privateWinIdList.RemoveAt(appData[name].privateWinIdList.Length)
                appData[name].privateWinIdList.InsertAt(1, lastWinId)
            }
        }
        ; Unexpected number of windows
        else if winList.Length < 0 {
            LogError(Error('<0 "' . name . '" browser window has been found while the process exists.'))
        }
    }
    ; If it is not running, run it
    else {
        Run !isPrivate ? browser : Format('"{1}" {2}', browser, incognitoFlag)
        if ActivateWindow("ahk_exe " . exe) {
            try {
                SetWindow("ahk_exe " . exe, %name%Dim.x, %name%Dim.y, %name%Dim.w, %name%Dim.h)
            } catch {
                SetWindow("ahk_exe " . exe, chromiumDim.x, chromiumDim.y, chromiumDim.w, chromiumDim.h)
            }
        }
        winId := WinGetID("ahk_exe " . exe)
        if winId {
            ; Clear up
            appData[name].allWinIdList := []
            appData[name].nonprivatewinIdList := []
            appData[name].privateWinIdList := []

            ; Store the window ahk_id
            if !isPrivate {
                appData[name].nonprivatewinIdList.Push(winId)
            } else {
                appData[name].privateWinIdList.Push(winId)
            }
            appData[name].allWinIdList.Push(winId)

            appData[name].pid := WinGetPID("ahk_id " . winId)
        }
    }
}

/**
 * Toggle Spotify
 */
ToggleSpotify() {
    ToggleApplication(spotify, spotifyDim, , , true, 2)
}

/**
 * Toggle Telegram
 */
ToggleTelegram() {
    ToggleApplication(telegram, telegramDim, , , true, 2)
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
            CloseWindow("ahk_exe Discord.exe")
        } else if WinExist("ahk_exe Discord.exe") and !WinActive("ahk_exe Discord.exe") {
            if ActivateWindow("ahk_exe Discord.exe") {
                SetWindow("ahk_exe Discord.exe", discordDim.x, discordDim.y, discordDim.w, discordDim.h)
            }
        } else {
            if discord != "" {
                Run discord
                if ActivateWindow("ahk_exe Discord.exe") {
                    SetWindow("ahk_exe Discord.exe", discordDim.x, discordDim.y, discordDim.w, discordDim.h)
                }
            } else {
                discord := GetExePath(EnvGet("LocalAppData") . "\Discord" . "\app-*", "Discord.exe")
                if discord != "" {
                    Run discord
                    if ActivateWindow("ahk_exe Discord.exe") {
                        SetWindow("ahk_exe Discord.exe", discordDim.x, discordDim.y, discordDim.w, discordDim.h)
                    }
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
            if ActivateWindow("ahk_exe Discord.exe") {
                SetWindow("ahk_exe Discord.exe", discordDim.x, discordDim.y, discordDim.w, discordDim.h)
            }
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
            CloseWindow("ahk_exe WeChat.exe ahk_class WeChatMainWndForPC")
        } else if WinExist("ahk_exe WeChat.exe") and !WinActive("ahk_exe WeChat.exe") {
            Run wechat
            if ActivateWindow("ahk_exe WeChat.exe ahk_class WeChatMainWndForPC") {
                SetWindow("ahk_exe WeChat.exe ahk_class WeChatMainWndForPC", wechatDim.x, wechatDim.y, wechatDim.w, wechatDim.h)
            }
        } else {
            Run wechat
            if ActivateWindow("ahk_exe WeChat.exe ahk_class WeChatMainWndForPC") {
                SetWindow("ahk_exe WeChat.exe ahk_class WeChatMainWndForPC", wechatDim.x, wechatDim.y, wechatDim.w, wechatDim.h)
            }
        }
    }
    ; If it is not running, run it
    else {
        Run wechat
        ActivateWindowAndClick("ahk_exe WeChat.exe ahk_class WeChatLoginWndForPC", , , wechatLoginBtnX, wechatLoginBtnY)
        ToolTip "WeChat Login"
        SetTimer () => ToolTip(), -1000, -1

        if WinWait("ahk_exe WeChat.exe ahk_class WeChatMainWndForPC", , 8) {
            if ActivateWindow("ahk_exe WeChat.exe ahk_class WeChatMainWndForPC") {
                SetWindow("ahk_exe WeChat.exe ahk_class WeChatMainWndForPC", wechatDim.x, wechatDim.y, wechatDim.w, wechatDim.h)
            }
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
            CloseWindow("ahk_exe TIM.exe")
        } else {
            Send "{LAlt down}q{LAlt up}"
            if ActivateWindow("ahk_exe TIM.exe") {
                SetWindow("ahk_exe TIM.exe", timDim.x, timDim.y, timDim.w, timDim.h)
            }
        }
    }
    ; If it is not running, run it
    else {
        Run tim
        ; SetWindow("ahk_exe Telegram.exe", telegramDim.x, telegramDim.y, telegramDim.w, telegramDim.h)
        ActivateWindow("ahk_exe TIM.exe")
        loginPageId := WinGetID("ahk_exe TIM.exe")
        maxAttempts := 40
        loop maxAttempts {
            if WinGetID("ahk_exe TIM.exe") != loginPageId {
                if ActivateWindow("ahk_exe TIM.exe") {
                    SetWindow("ahk_exe TIM.exe", timDim.x, timDim.y, timDim.w, timDim.h)
                }
                break
            }
            maxAttempts -= 1
            Sleep 100
        }
        if maxAttempts <= 0 {
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
            CloseWindow("ahk_exe DingTalk.exe")
        } else if WinExist("ahk_exe DingTalk.exe") and !WinActive("ahk_exe DingTalk.exe") {
            Run dingtalk
            if ActivateWindow("ahk_exe DingTalk.exe") {
                SetWindow("ahk_exe DingTalk.exe ahk_class StandardFrame_DingTalk", dingtalkDim.x, dingtalkDim.y, dingtalkDim.w, dingtalkDim.h)
            }
        } else {
            Run dingtalk
            if ActivateWindow("ahk_exe DingTalk.exe") {
                SetWindow("ahk_exe DingTalk.exe ahk_class StandardFrame_DingTalk", dingtalkDim.x, dingtalkDim.y, dingtalkDim.w, dingtalkDim.h)
            }
        }
    }
    ; If it is not running, run it
    else {
        Run dingtalk
        maxAttempts1 := 40
        loop maxAttempts1 {
            ; Login window shows at first
            if WinExist("ahk_exe DingTalk.exe ahk_class Qt51511QWindowIcon") {
                maxAttempts2 := 80
                loop maxAttempts2 {
                    if WinExist("ahk_exe DingTalk.exe ahk_class StandardFrame_DingTalk") {
                        if ActivateWindow("ahk_exe DingTalk.exe ahk_class StandardFrame_DingTalk") {
                            SetWindow("ahk_exe DingTalk.exe ahk_class StandardFrame_DingTalk", dingtalkDim.x, dingtalkDim.y, dingtalkDim.w, dingtalkDim.h)
                        }
                        break
                    }
                    Sleep 50
                }
                break
            }
            maxAttempts1 -= 1
            Sleep 100
        }
        if maxAttempts1 <= 0 {
            MsgBox "ERROR! DingTalk.exe window could not be found!"
        }
    }
}

/**
 * Toggle Eudic
 */
ToggleEudic() {
    ToggleApplication(eudic, eudicDim, , , true, 2)
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
                    if ActivateWindow("ahk_exe 哔哩哔哩.exe ahk_class Chrome_WidgetWin_1") {
                        SetWindow("ahk_exe 哔哩哔哩.exe ahk_class Chrome_WidgetWin_1", bilibiliDim.x, bilibiliDim.y, bilibiliDim.w, bilibiliDim.h)
                    }
                    winId := WinGetID("ahk_exe 哔哩哔哩.exe ahk_class Chrome_WidgetWin_1")
                    if winId {
                        bilibiliWinId := winId
                    }
                }
            case 1:
                ; Only one window, toggle the window
                if WinActive("ahk_id " . winList[1]) {
                    MinimizeWindow("ahk_id " . winList[1])
                } else {
                    if ActivateWindow("ahk_id " . winList[1]) {
                        SetWindow("ahk_exe 哔哩哔哩.exe ahk_class Chrome_WidgetWin_1", bilibiliDim.x, bilibiliDim.y, bilibiliDim.w, bilibiliDim.h)
                    }
                }
                if bilibiliWinId == "" {
                    bilibiliWinId := winList[1]
                }
            case 2:
                if bilibiliWinId == "" {
                    bilibiliWinId := WinGetList("哔哩哔哩 (゜-゜)つロ 干杯~-bilibili ahk_exe 哔哩哔哩.exe ahk_class Chrome_WidgetWin_1")[1]
                }
                ; Two windows (home window & video window), activate the video window
                for win_id in winList {
                    ; Find the video window (bilibiliWinId represents the home window)
                    if win_id != bilibiliWinId {
                        if WinActive("ahk_id " . win_id) {
                            MinimizeWindow("ahk_id " . win_id)
                        } else {
                            if ActivateWindow("ahk_id " . win_id) {
                                SetWindow("ahk_id " . win_id, bilibiliVidDim.x, bilibiliVidDim.y, bilibiliVidDim.w, bilibiliVidDim.h)
                            }
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
        if ActivateWindow("ahk_exe 哔哩哔哩.exe ahk_class Chrome_WidgetWin_1") {
            SetWindow("ahk_exe 哔哩哔哩.exe ahk_class Chrome_WidgetWin_1", bilibiliDim.x, bilibiliDim.y, bilibiliDim.w, bilibiliDim.h)
        }
        winId := WinGetID("ahk_exe 哔哩哔哩.exe ahk_class Chrome_WidgetWin_1")
        if winId {
            bilibiliWinId := winId
        }
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
                    if ActivateWindow("ahk_exe 哔哩哔哩.exe ahk_class Sandbox:MultiAccount:Chrome_WidgetWin_1") {
                        SetWindow("ahk_exe 哔哩哔哩.exe ahk_class Sandbox:MultiAccount:Chrome_WidgetWin_1", bilibiliDim.x, bilibiliDim.y, bilibiliDim.w, bilibiliDim.h)
                    }
                    winId := WinGetID("ahk_exe 哔哩哔哩.exe ahk_class Sandbox:MultiAccount:Chrome_WidgetWin_1")
                    if winId {
                        bilibiliSandboxedWinId := winId
                    }
                }
            case 1:
                ; Only one window, toggle the window
                if WinActive("ahk_id " . winList[1]) {
                    MinimizeWindow("ahk_id " . winList[1])
                } else {
                    if ActivateWindow("ahk_id " . winList[1]) {
                        SetWindow("ahk_id " . winList[1], bilibiliDim.x, bilibiliDim.y, bilibiliDim.w, bilibiliDim.h)
                    }
                }
                if bilibiliSandboxedWinId == "" {
                    bilibiliSandboxedWinId := winList[1]
                }
            case 2:
                if bilibiliSandboxedWinId == "" {
                    bilibiliSandboxedWinId := WinGetList("哔哩哔哩 (゜-゜)つロ 干杯~-bilibili ahk_exe 哔哩哔哩.exe ahk_class Sandbox:MultiAccount:Chrome_WidgetWin_1")[1]
                }
                ; Two windows (home window & video window), activate the video window
                for win_id in winList {
                    ; Find the video window (bilibiliWinId represents the home window)
                    if win_id != bilibiliSandboxedWinId {
                        if WinActive("ahk_id " . win_id) {
                            MinimizeWindow("ahk_id " . win_id)
                        } else {
                            if ActivateWindow("ahk_id " . win_id) {
                                SetWindow("ahk_id " . win_id, bilibiliVidDim.x, bilibiliVidDim.y, bilibiliVidDim.w, bilibiliVidDim.h)
                            }
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
        if ActivateWindow("ahk_exe 哔哩哔哩.exe ahk_class Sandbox:MultiAccount:Chrome_WidgetWin_1") {
            SetWindow("ahk_exe 哔哩哔哩.exe ahk_class Sandbox:MultiAccount:Chrome_WidgetWin_1", bilibiliDim.x, bilibiliDim.y, bilibiliDim.w, bilibiliDim.h)
        }
        winId := WinGetID("ahk_exe 哔哩哔哩.exe ahk_class Sandbox:MultiAccount:Chrome_WidgetWin_1")
        if winId {
            bilibiliSandboxedWinId := winId
        }
    }
}

/**
 * Open YouTube with browser
 */
OpenYouTube() {
    Run '"' . browser . '" "https://www.youtube.com"'
    ActivateWindow("ahk_exe " . GetPathComponent(browser, "name"))
}

/**
 * Open YouTube with browser
 */
OpenYouTube2() {
    ; With the help of browser extension "Open external links in a container"
    ; Extension Repo: https://github.com/honsiorovskyi/open-url-in-container
    Run '"' . browser . '" "ext+container:name=Dintionte&url=https://www.youtube.com"'
    ActivateWindow("ahk_exe " . GetPathComponent(browser, "name"))
}

/**
 * Run Spotify and Lyricify together
 */
RunSpotifyAndLyricify() {
    if !WinActive("ahk_exe Spotify.exe") {
        ToggleSpotify()
    }

    Sleep 1000

    ; Run Lyricify if it's not running
    if !ProcessExist("Lyricify for Spotify.exe") {
        Run lyricify
        CloseWindow("ahk_exe Lyricify for Spotify.exe")
    } else {
        if WinExist("ahk_exe Lyricify for Spotify.exe") {
            CloseWindow("ahk_exe Lyricify for Spotify.exe")
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
        CloseWindow("ahk_exe Docker Desktop.exe")
        Sleep 2000
    }

    isOllamaAlreadyRunning := ProcessExist("ollama.exe")
    ; Start Ollama if it's not running
    if !isOllamaAlreadyRunning {
        Run A_ComSpec . ' /c "' . ollama . '"', , "Hide"
        Sleep 500
    }

    isContainerStarted := IsDockerContainerRunning(openWebuiDockerContainerName)

    if !isContainerStarted {
        ; Start open-webui container
        Run "pwsh.exe -Command " . "docker start " . openWebuiDockerContainerName, , "Hide"
        Sleep 1000
        maxAttempts := 20
        loop maxAttempts {
            if IsDockerContainerRunning(openWebuiDockerContainerName) {
                isContainerStarted := true
                break
            } else if Round(Mod(A_Index, 5)) == 2 {
                Run "pwsh.exe -Command " . "docker start " . openWebuiDockerContainerName, , "Hide"
            }
            Sleep 500
        }
    }

    if isContainerStarted and ProcessExist("Docker Desktop.exe") and ProcessExist("ollama.exe") {
        ToolTip "Docker & Ollama started"
        SetTimer () => ToolTip(), -2000, -1
        if !isDockerAlreadyRunning {
            Sleep 4500
        }
        Run '"' . browser . '" "' . openWebuiUrl . '"'
        if !isDockerAlreadyRunning {
            Sleep 1600
            Send "{F5}"
        }
    } else {
        msg := !ProcessExist("Docker Desktop.exe") ? "Docker Desktop &" : ""
        msg .= !ProcessExist("ollama.exe") ? " Ollama" : ""
        ToolTip "ERROR! " . msg . " not started"
        SetTimer () => ToolTip(), -2000, -1
    }
}

/**
 * Toggle Clash for Windows
 */
ToggleClash() {
    ToggleApplication(clash, clashDim, , , true, 2)
}

/**
 * Toggle the system proxy on/off
 */
ToggleProxyOnOff() {
    if IsSystemProxyEnabled() {
        maxAttempts1 := 3
        loop maxAttempts1 {
            if ProcessExist("Clash for Windows.exe") {
                Sleep 200
                ; Turn off Clash
                Send "{LCtrl down}{LAlt down}{LShift down}pmt{LCtrl up}{LAlt up}{LShift up}"
                Sleep 200
            } else {
                MsgBox "ATTENTION! System Proxy is enabled but Clash for Windows is not running!"
                return
            }
            maxAttempts2 := 6
            loop maxAttempts2 {
                if !IsSystemProxyEnabled() {
                    ToolTip "Proxy Turned Off"
                    SetTimer () => ToolTip(), -2000, -1
                    break
                }
                maxAttempts2 -= 1
                Sleep 500
            }
            if maxAttempts2 <= 0 {
                MsgBox "Attempt " . A_Index . " to turn proxy off failed, trying again...", , "T0.5"
                maxAttempts1 -= 1
            }
            if !IsSystemProxyEnabled() {
                break
            }
        }
        if maxAttempts1 <= 0 {
            MsgBox "Fail to turn proxy off!", , "T0.5"
            return
        }
    } else {
        maxAttempts1 := 3
        loop maxAttempts1 {
            if ProcessExist("Clash for Windows.exe") {
                Sleep 200
                ; Turn off Clash
                Send "{LCtrl down}{LAlt down}{LShift down}pmt{LCtrl up}{LAlt up}{LShift up}"
                Sleep 200
            } else {
                MsgBox "ATTENTION! System Proxy is enabled but Clash for Windows is not running!"
                return
            }
            maxAttempts2 := 6
            loop maxAttempts2 {
                if IsSystemProxyEnabled() {
                    ToolTip "Proxy Turned On"
                    SetTimer () => ToolTip(), -2000, -1
                    break
                }
                maxAttempts2 -= 1
                Sleep 500
            }
            if maxAttempts2 <= 0 {
                MsgBox "Attempt " . A_Index . " to turn proxy off failed, trying again...", , "T0.5"
                maxAttempts1 -= 1
            }
            if IsSystemProxyEnabled() {
                break
            }
        }
        if maxAttempts1 <= 0 {
            MsgBox "Fail to turn proxy on!", , "T0.5"
            return
        }
    }
}

/**
 * Toggle Gaming Network Environment
 */
ToggleGameEnv() {
    RunScriptAsAdmin(adminScript, "ToggleGameEnv")
    maxAttempts := 100
    loop maxAttempts {
        ; Exit AHK script after the game environment has been started
        if FileExist("game_env_started.tmp") {
            FileDelete("game_env_started.tmp")
            ExitApp
        }
        Sleep 200
    }
}

/**
 * Toggle File Explorer
 * 
 * - Not running: Open Windows File Explorer and set windows position and size
 * - Already Running: Toggle Windows File Explorer and set windows position and size
 * 
 * @param {Boolean} newInstance Whether to open a new instance of the application (default: false)
 */
ToggleExplorer(newInstance := false) {
    ToggleApplications(explorer, explorerDim, , "ahk_class CabinetWClass", newInstance)
}

/**
 * Toggle MSI Afterburner
 */
ToggleMSIAfterburner() {
    RunScriptAsAdmin(adminScript, "ToggleMSIAfterburner")
}

/**
 * Toggle HWiNFO64
 */
ToggleHWiNFO() {
    RunScriptAsAdmin(adminScript, "ToggleHWiNFO")
}

/**
 * Close currently active window
 * 
 * Not "Alt + F4", the function only closes the window
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

;;;;;;;;;; UTILITY FUNCTIONS ;;;;;;;;;;

/**
 * Toggle specified application (that can only have one window/instance)
 * 
 * @param {String} app The executable path of the application
 * @param {Array} appDim The position and dimensions of the application window (default: { x: -1, y: -1, w: -1, h: -1 })
 * @param {String} winExeName The application window name (default: ""), in case the executable name is different from the application window name.
 *                            For example, window name "WindowsTerminal.exe" for executable name "wt.exe"
 * @param {String} additionalWinSpecifier Additional window specifier (default: ""), e.g. "ahk_class Chrome_WidgetWin_1"
 * @param {Boolean} setWinAfterEveryActivate Whether to set the position and size every time after activating the existing window (default: false)
 * @param {String} minimizeOrClose Whether to minimize the window to taskbar or close it to minimize to system tray (default: `1`), accepted values: `1` to minimize, `2` to close
 */
ToggleApplication(app := "", appDim := { x: -1, y: -1, w: -1, h: -1
}, winExeName := "", additionalWinSpecifier := "", setWinAfterEveryActivate := false, minimizeOrClose := 1) {
    if app == "" {
        MsgBox "ERROR! No application specified!"
        return
    }

    exe := winExeName == "" ? GetPathComponent(app, "name") : winExeName

    if additionalWinSpecifier != "" {
        additionalWinSpecifier := " " . additionalWinSpecifier
    }
    winSpecifier := "ahk_exe " . exe . additionalWinSpecifier

    ; If it is running, toggle the window
    if ProcessExist(exe) {
        if WinActive("ahk_exe " . exe . additionalWinSpecifier) {
            ; Window is active, minimize or close it
            if minimizeOrClose == 1 {
                MinimizeWindow(winSpecifier)
            } else if minimizeOrClose == 2 {
                CloseWindow(winSpecifier)
            }
        } else if WinExist(winSpecifier) and !WinActive(winSpecifier) {
            if ActivateWindow(winSpecifier) {
                if setWinAfterEveryActivate {
                    SetWindow(winSpecifier, appDim.x, appDim.y, appDim.w, appDim.h)
                }
            }
        } else {
            Run app
            if ActivateWindow(winSpecifier) {
                if setWinAfterEveryActivate {
                    SetWindow(winSpecifier, appDim.x, appDim.y, appDim.w, appDim.h)
                }
            }
        }
    }
    ; If it is not running, run it
    else {
        Run app
        if ActivateWindow(winSpecifier) {
            SetWindow(winSpecifier, appDim.x, appDim.y, appDim.w, appDim.h)
        }
    }
}

/**
 * Toggle specified application (that can have multiple windows/instances)
 * 
 * @param {String} app The executable path of the application
 * @param {Array} appDim The position and dimensions of the application window (default: { x: -1, y: -1, w: -1, h: -1 })
 * @param {String} winExeName The application window name (default: ""), in case the executable name is different from the application window name.
 *                            For example, window name "WindowsTerminal.exe" for executable name "wt.exe"
 * @param {String} additionalWinSpecifier Additional window specifier (default: ""), e.g. "ahk_class Chrome_WidgetWin_1"
 * @param {Boolean} newInstance Whether to open a new instance of the application (default: false)
 * @param {Boolean} setWinAfterEveryActivate Whether to set the position and size every time after activating the existing window (default: false)
 */
ToggleApplications(app := "", appDim := { x: -1, y: -1, w: -1, h: -1
}, winExeName := "", additionalWinSpecifier := "", newInstance := false, setWinAfterEveryActivate := false) {
    global appData

    if app == "" {
        MsgBox "ERROR! No application specified!"
        return
    }

    exe := winExeName == "" ? GetPathComponent(app, "name") : winExeName
    name := GetPathComponent(app, "nameNoExt")

    if additionalWinSpecifier != "" {
        additionalWinSpecifier := " " . additionalWinSpecifier
    }
    winSpecifier := "ahk_exe " . exe . additionalWinSpecifier

    ; Check if this `name` exists in map `appData`, if not, create it
    if (!appData.Has(name)) {
        appData[name] := {}
    }
    ; Check if below props exists for this name in map `appData`, if not, create it
    if (!appData[name].HasProp("allWinIdList")) {
        appData[name].allWinIdList := []
    }

    ; If it is running, toggle the window
    if ProcessExist(exe) {
        winList := WinGetList(winSpecifier)

        tempList := []
        for winId in appData[name].allWinIdList {
            for id in winList {
                if winId == id {
                    tempList.Push(id)
                }
            }
        }
        appData[name].allWinIdList := tempList

        ; Get window id of the new instance
        newWins := []
        for winId in winList {
            isNewWindow := true
            for id in appData[name].allWinIdList {
                if winId == id {
                    isNewWindow := false
                }
            }
            if isNewWindow {
                appData[name].allWinIdList.Push(winId)
            }
        }

        ; If a new instance is requested
        if newInstance {
            oldWinCount := winList.Length

            Run app

            maxAttempts := 500
            loop maxAttempts {
                winList := WinGetList(winSpecifier)
                if winList.Length > oldWinCount {
                    break
                }
                maxAttempts -= 1
                Sleep 20
            }
            if maxAttempts <= 0 {
                MsgBox 'ERROR! New instance window of "' . name . '" could not be found!'
            }

            ; Get window id of the new instance
            newWins := []
            for winId in winList {
                isNewWindow := true
                for id in appData[name].allWinIdList {
                    if winId == id {
                        isNewWindow := false
                    }
                }
                if isNewWindow {
                    appData[name].allWinIdList.Push(winId)
                    if ActivateWindow("ahk_id " . winId) {
                        SetWindow("ahk_id " . winId, appDim.x, appDim.y, appDim.w, appDim.h)
                    }
                    return
                }
            }
        }

        ; No expected window, run it
        if winList.Length == 0 {
            Run app
            if ActivateWindow(winSpecifier) {
                SetWindow(winSpecifier, appDim.x, appDim.y, appDim.w, appDim.h)
            }
            winId := WinGetID(winSpecifier)
            if winId {
                appData[name].allWinIdList := []
                appData[name].allWinIdList.push(winId)
            }
        }
        ; Only one expected window, toggle it
        else if winList.Length == 1 {
            if WinActive("ahk_id " . winList[1]) {
                ; Window is active, minimize it to taskbar
                MinimizeWindow("ahk_id " . winList[1])
            } else {
                if ActivateWindow("ahk_id " . winList[1]) {
                    if setWinAfterEveryActivate {
                        SetWindow("ahk_id " . winList[1], appDim.x, appDim.y, appDim.w, appDim.h)
                    }
                }
            }
        }
        ; More than one expected window, cycle through them
        else if winList.Length >= 1 {
            for winId in winList {
                if winId == winList[winList.Length] {
                    if WinActive("ahk_id " . winId) {
                        MinimizeWindow("ahk_id " . winId)
                    } else {
                        if ActivateWindow("ahk_id " . winId) {
                            if setWinAfterEveryActivate {
                                SetWindow("ahk_id " . winList[1], appDim.x, appDim.y, appDim.w, appDim.h)
                            }
                        }
                    }
                    break
                }
            }
        }
    }
    ; If it is not running, run it
    else {
        Run app
        if ActivateWindow(winSpecifier) {
            SetWindow(winSpecifier, appDim.x, appDim.y, appDim.w, appDim.h)
        }
        winId := WinGetID(winSpecifier)
        if winId {
            appData[name].allWinIdList := []
            appData[name].allWinIdList.Push(winId)
        }
    }
}
