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
 * - `lastActivatedWinId`: the last activated window's ahk_id (String)
 */
appData := Map(
    "explorer", {
        allWinIdList: [],
        lastActivatedWinId: ""
    }, "firefox", {
        allWinIdList: [],
        nonprivatewinIdList: [],
        privateWinIdList: [],
        pid: "",
        lastActivatedWinId: ""
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
 * Toggle Heynote
 */
ToggleHeynote() {
    ToggleApplication(heynote, heynoteDim)
}

/**
 * Toggle Typora
 * 
 * @param {Boolean} newInstance - Whether to open a new instance (default: false)
 */
ToggleTypora(newInstance := false) {
    ToggleApplications(typora, typoraDim, , , newInstance)
}

/**
 * Toggle Obsidian
 */
ToggleObsidian() {
    ToggleApplication(obsidian, obsidianDim)
}

/**
 * Toggle Windows Terminal
 * 
 * @param {Boolean} newInstance - Whether to open a new instance (default: false)
 */
ToggleWindowsTerminal(newInstance := false) {
    if newInstance {
        try {
            Run terminal
        }
        if ActivateWindow("ahk_exe WindowsTerminal.exe") {
            SetWindow("ahk_exe WindowsTerminal.exe", terminalDim.x, terminalDim.y, terminalDim.w, terminalDim.h)
        }
        return
    }
    ToggleApplication(terminal, terminalDim, "WindowsTerminal.exe", "ahk_class CASCADIA_HOSTING_WINDOW_CLASS")
}

/**
 * Toggle Thunderbird Email Client
 */
ToggleThunderbird() {
    ToggleApplication(thunderbird, thunderbirdDim, , "ahk_class MozillaWindowClass", true)
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

    if browser == "" {
        MsgBox "ERROR while toggling! No gecko browser specified!", , "T2"
        return
    }

    exe := GetPathComponent(browser, "name")
    name := GetPathComponent(browser, "nameNoExt")

    ; Check if this `name` exists in map `appData`, if not, create it
    if !appData.Has(name) {
        appData[name] := {}
    }
    ; Check if below props exists for this name in map `appData`, if not, create it
    if !appData[name].HasProp("allWinIdList") {
        appData[name].allWinIdList := []
    }
    if !appData[name].HasProp("nonprivatewinIdList") {
        appData[name].nonprivatewinIdList := []
    }
    if !appData[name].HasProp("privateWinIdList") {
        appData[name].privateWinIdList := []
    }
    if !appData[name].HasProp("pid") {
        appData[name].pid := ""
    }
    if !appData[name].HasProp("lastActivatedWinId") {
        appData[name].lastActivatedWinId := ""
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
                ; Ignore the picture-in-picture window
                if winId == id or WinGetTitle("ahk_id " . winId) == "Picture-in-Picture" {
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
                if newWins.Length == allWinList.Length {
                    appData[name].privateWinIdList.Push(newWinId)
                } else {
                    appData[name].privateWinIdList.InsertAt(1, newWinId)
                }
            } else {
                if newWins.Length == allWinList.Length {
                    appData[name].nonprivatewinIdList.Push(newWinId)
                } else {
                    appData[name].nonprivatewinIdList.InsertAt(1, newWinId)
                }
            }
        }

        ; Update the list of all windows
        appData[name].allWinIdList := allWinList

        winList := !isPrivate ? appData[name].nonprivatewinIdList : appData[name].privateWinIdList

        ; No expected window, run it
        if winList.Length == 0 {
            try {
                Run !isPrivate ? browser : Format('"{1}" {2}', browser, incognitoFlag)
            }
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
            appData[name].lastActivatedWinId := winId
        }
        ; Only one expected window, toggle it
        else if winList.Length == 1 {
            if WinActive("ahk_id " . winList[1]) {
                MinimizeWindow("ahk_id " . winList[1])
            } else {
                ActivateWindow("ahk_id " . winList[1])
                appData[name].lastActivatedWinId := winList[1]
            }
        }
        ; More than one expected window, cycle through them
        else if winList.Length > 1 {
            oldestWinId := winList[winList.Length]
            ; The last window in the list will change, so we can cycle through all of them in this way
            if WinActive("ahk_exe " . exe) {
                ActivateWindow("ahk_id " . oldestWinId)
                appData[name].lastActivatedWinId := oldestWinId
                if !isPrivate {
                    appData[name].nonprivatewinIdList.RemoveAt(appData[name].nonprivatewinIdList.Length)
                    appData[name].nonprivatewinIdList.InsertAt(1, oldestWinId)
                } else {
                    appData[name].privateWinIdList.RemoveAt(appData[name].privateWinIdList.Length)
                    appData[name].privateWinIdList.InsertAt(1, oldestWinId)
                }
            } else {
                if appData[name].lastActivatedWinId == "" and allWinList.Length > 0 {
                    appData[name].lastActivatedWinId := allWinList[1]
                }
                ActivateWindow("ahk_id " . appData[name].lastActivatedWinId)
            }
        }
        ; Unexpected number of windows
        else if winList.Length < 0 {
            LogError(Error('<0 "' . name . '" browser window has been found while the process exists.'))
        }
    }
    ; If it is not running, run it
    else {
        try {
            Run !isPrivate ? browser : Format('"{1}" {2}', browser, incognitoFlag)
        }
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

    if browser == "" {
        MsgBox "ERROR while toggling! No chromium browser specified!", , "T2"
        return
    }

    exe := GetPathComponent(browser, "name")
    name := GetPathComponent(browser, "nameNoExt")

    ; Check if this `name` exists in map `appData`, if not, create it
    if !appData.Has(name) {
        appData[name] := {}
    }
    ; Check if below props exists for this name in map `appData`, if not, create it
    if !appData[name].HasProp("allWinIdList") {
        appData[name].allWinIdList := []
    }
    if !appData[name].HasProp("nonprivatewinIdList") {
        appData[name].nonprivatewinIdList := []
    }
    if !appData[name].HasProp("privateWinIdList") {
        appData[name].privateWinIdList := []
    }
    if !appData[name].HasProp("pid") {
        appData[name].pid := ""
    }
    if !appData[name].HasProp("lastActivatedWinId") {
        appData[name].lastActivatedWinId := ""
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
                ; Ignore the picture-in-picture window
                if winId == id or WinGetTitle("ahk_id " . winId) == "Picture in picture" {
                    isNewWindow := false
                    break
                }
            }
            if isNewWindow {
                newWins.Push(winId)
            }
        }

        ; ATTENTION: Treat all new windows not started by AHK as new non-private windows
        for newWinId in newWins {
            if newWins.Length == allWinList.Length {
                appData[name].nonprivatewinIdList.Push(newWinId)
            } else {
                appData[name].nonprivatewinIdList.InsertAt(1, newWinId)
            }
        }

        ; Update the list of all windows
        appData[name].allWinIdList := allWinList

        winList := !isPrivate ? appData[name].nonprivatewinIdList : appData[name].privateWinIdList

        ; No expected window, run it
        if winList.Length == 0 {
            try {
                Run !isPrivate ? browser : Format('"{1}" {2}', browser, incognitoFlag)
            }
            winId := 0
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
                appData[name].lastActivatedWinId := winId
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
                appData[name].lastActivatedWinId := winId
            }
        }
        ; More than one expected window, cycle through them
        else if winList.Length > 1 {
            oldestWinId := winList[winList.Length]
            ; The last window in the list will change, so we can cycle through all of them in this way
            if WinActive("ahk_exe " . exe) {
                ActivateWindow("ahk_id " . oldestWinId)
                appData[name].lastActivatedWinId := oldestWinId
                if !isPrivate {
                    appData[name].nonprivatewinIdList.RemoveAt(appData[name].nonprivatewinIdList.Length)
                    appData[name].nonprivatewinIdList.InsertAt(1, oldestWinId)
                } else {
                    appData[name].privateWinIdList.RemoveAt(appData[name].privateWinIdList.Length)
                    appData[name].privateWinIdList.InsertAt(1, oldestWinId)
                }
            } else {
                if appData[name].lastActivatedWinId == "" and allWinList.Length > 0 {
                    appData[name].lastActivatedWinId := allWinList[1]
                }
                ActivateWindow("ahk_id " . appData[name].lastActivatedWinId)
            }
        }
        ; Unexpected number of windows
        else if winList.Length < 0 {
            LogError(Error('<0 "' . name . '" browser window has been found while the process exists.'))
        }
    }
    ; If it is not running, run it
    else {
        try {
            Run !isPrivate ? browser : Format('"{1}" {2}', browser, incognitoFlag)
        }
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
 * Toggle Follow
 */
ToggleFollow() {
    ToggleApplication(follow, followDim, , , true)
}

/**
 * Toggle Telegram
 */
ToggleTelegram() {
    ToggleApplication(telegram, telegramDim, , "ahk_class Qt51515QWindowIcon", true, 2)
}

/**
 * Toggle Discord
 */
ToggleDiscord() {
    global discord

    winIdentifier := "ahk_exe Discord.exe"

    ; If it is running, toggle the window
    if ProcessExist("Discord.exe") {
        if WinActive(winIdentifier) {
            ; Window is active, close to minimize it to the system tray
            CloseWindow(winIdentifier)
        } else if WinExist(winIdentifier) and !WinActive(winIdentifier) {
            if ActivateWindow(winIdentifier) {
                SetWindow(winIdentifier, discordDim.x, discordDim.y, discordDim.w, discordDim.h)
            }
        } else {
            if discord != "" {
                RunAndActivateDiscord()
            } else {
                if !FileExist(discord) {
                    discord := GetFilePath(C_LocalAppData . "\Discord", "Discord.exe")
                }
                if discord != "" {
                    RunAndActivateDiscord()
                } else {
                    MsgBox "ERROR! Discord.exe not found in the expected directory `"" . discord . "`".", , "T2"
                }
            }
        }
    }
    ; If it is not running, run it
    else {
        if !FileExist(discord) {
            discord := GetFilePath(C_LocalAppData . "\Discord", "Discord.exe")
        }
        if discord != "" {
            RunAndActivateDiscord()
        } else {
            MsgBox "ERROR! Discord.exe not found in the expected directory `"" . discord . "`".", , "T2"
        }
    }

    RunAndActivateDiscord() {
        try {
            Run discord
        }
        isDiscordUpdateFinished() {
            if !WinExist(winIdentifier) {
                return false
            }
            winTitle := WinGetTitle(winIdentifier)
            if winTitle == "Discord Updater" {
                return false
            }
            if RegExMatch(winTitle, "i)\s-\sDiscord$") {
                return true
            }
            return true
        }
        LoopLogic(isDiscordUpdateFinished, 600)
        if ActivateWindow(winIdentifier) {
            SetWindow(winIdentifier, discordDim.x, discordDim.y, discordDim.w, discordDim.h)
        }
    }
}

/**
 * Toggle WeChat
 */
ToggleWeChat() {
    winIdentifier := "ahk_exe WeChat.exe"
    mainWinIdentifier := winIdentifier . " ahk_class WeChatMainWndForPC"
    loginWinIdentifier := winIdentifier . " ahk_class WeChatLoginWndForPC"

    ; If it is running, toggle the window
    if ProcessExist("WeChat.exe") {
        if WinActive(mainWinIdentifier) {
            ; Window is active, close to minimize it to the system tray
            CloseWindow(mainWinIdentifier)
        } else if WinExist(winIdentifier) and !WinActive(winIdentifier) {
            try {
                Run wechat
            }
            if ActivateWindow(mainWinIdentifier) {
                SetWindow(mainWinIdentifier, wechatDim.x, wechatDim.y, wechatDim.w, wechatDim.h)
            }
        } else {
            try {
                Run wechat
            }
            if ActivateWindow(mainWinIdentifier) {
                SetWindow(mainWinIdentifier, wechatDim.x, wechatDim.y, wechatDim.w, wechatDim.h)
            }
        }
    }
    ; If it is not running, run it
    else {
        try {
            Run wechat
        }
        ActivateWindowAndClick(loginWinIdentifier, , , wechatLoginBtnX, wechatLoginBtnY)
        ToolTip "WeChat Login"
        SetTimer () => ToolTip(), -1000, -1

        if WinWait(mainWinIdentifier, , 8) {
            if ActivateWindow(mainWinIdentifier) {
                SetWindow(mainWinIdentifier, wechatDim.x, wechatDim.y, wechatDim.w, wechatDim.h)
            }
        } else {
            MsgBox "ERROR! WeChat.exe window could not be found!", , "T2"
        }
    }
}

/**
 * Toggle Tencent TIM
 */
ToggleTencentTIM() {
    winIdentifier := "ahk_exe TIM.exe"

    ; If it is running, toggle the window
    if ProcessExist("TIM.exe") {
        if WinActive(winIdentifier) {
            ; Window is active, close to minimize it to the system tray
            CloseWindow(winIdentifier)
        } else {
            Send "{LAlt down}q{LAlt up}"
            if ActivateWindow(winIdentifier) {
                SetWindow(winIdentifier, timDim.x, timDim.y, timDim.w, timDim.h)
            }
        }
    }
    ; If it is not running, run it
    else {
        try {
            Run tim
        }
        ActivateWindow(winIdentifier)
        loginPageId := WinGetID(winIdentifier)

        TIMWinActivate() {
            if WinGetID(winIdentifier) != loginPageId {
                if ActivateWindow(winIdentifier) {
                    SetWindow(winIdentifier, timDim.x, timDim.y, timDim.w, timDim.h)
                }
                return true
            }
            return false
        }
        if !LoopLogic(TIMWinActivate, 40, 100) {
            MsgBox "ERROR! TIM.exe main window could not be found!", , "T2"
        }
    }
}

/**
 * Toggle DingTalk
 */
ToggleDingTalk() {
    winIdentifier := "ahk_exe DingTalk.exe"
    mainWinIdentifier := winIdentifier . " ahk_class StandardFrame_DingTalk"
    loginWinIdentifier := winIdentifier . " ahk_class Qt51511QWindowIcon"

    ; If it is running, toggle the window
    if ProcessExist("DingTalk.exe") {
        if WinActive(mainWinIdentifier) {
            ; Window is active, close to minimize it to the system tray
            CloseWindow(mainWinIdentifier)
        } else if WinExist(mainWinIdentifier) and !WinActive(mainWinIdentifier) {
            try {
                Run dingtalk
            }
            if ActivateWindow(mainWinIdentifier) {
                SetWindow(mainWinIdentifier, dingtalkDim.x, dingtalkDim.y, dingtalkDim.w, dingtalkDim.h)
            }
        } else {
            try {
                Run dingtalk
            }
            if ActivateWindow(mainWinIdentifier) {
                SetWindow(mainWinIdentifier, dingtalkDim.x, dingtalkDim.y, dingtalkDim.w, dingtalkDim.h)
            }
        }
    }
    ; If it is not running, run it
    else {
        try {
            Run dingtalk
        }
        DingtalkMainWinActivate() {
            if WinExist(mainWinIdentifier) {
                if ActivateWindow(mainWinIdentifier) {
                    SetWindow(mainWinIdentifier, dingtalkDim.x, dingtalkDim.y, dingtalkDim.w, dingtalkDim.h)
                    return true
                }
            }
            return false
        }
        DingtalkStartup() {
            if WinExist(loginWinIdentifier) {
                if ActivateWindow(loginWinIdentifier) {
                    return false
                }
                if LoopLogic(DingtalkMainWinActivate, 500) {
                    return true
                }
            }
            if WinExist(mainWinIdentifier) {
                if ActivateWindow(mainWinIdentifier) {
                    SetWindow(mainWinIdentifier, dingtalkDim.x, dingtalkDim.y, dingtalkDim.w, dingtalkDim.h)
                    return true
                }
            }
            return false
        }
        if !LoopLogic(DingtalkStartup) {
            MsgBox "ERROR! DingTalk.exe login window could not be found!", , "T2"
        }
    }
}

/**
 * Toggle Eudic
 */
ToggleEudic() {
    ToggleApplication(eudic, eudicDim, , , true, 2)
}

/**
 * Toggle 1Password
 */
Toggle1Password() {
    ToggleApplication(onepassword, onepasswordDim, , , true, 2)
}

; ahk_id of bilibili home page window
bilibiliWinId := ""

/**
 * Toggle Bilibili
 * When there are two windows, home window and video window, then toggle the video window
 */
ToggleBilibili() {
    global bilibiliWinId

    winIdentifier := "ahk_exe 哔哩哔哩.exe ahk_class Chrome_WidgetWin_1"
    winTitle := "哔哩哔哩 (゜-゜)つロ 干杯~-bilibili"

    ; If it is running, toggle the window
    if ProcessExist("哔哩哔哩.exe") {
        winList := WinGetList(winIdentifier)

        switch winList.Length {
            case 0:
                ; No window, run it
                try {
                    Run bilibili
                }
                if bilibiliWinId == "" and WinWait(winIdentifier, , 10) {
                    if ActivateWindow(winIdentifier) {
                        SetWindow(winIdentifier, bilibiliDim.x, bilibiliDim.y, bilibiliDim.w, bilibiliDim.h)
                    }
                    winId := WinGetID(winIdentifier)
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
                        SetWindow(winIdentifier, bilibiliDim.x, bilibiliDim.y, bilibiliDim.w, bilibiliDim.h)
                    }
                }
                if bilibiliWinId == "" {
                    bilibiliWinId := winList[1]
                }
            case 2:
                if bilibiliWinId == "" {
                    bilibiliWinId := WinGetID(winTitle . " " . winIdentifier)
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
                MsgBox "ERROR! Unexpected number of bilibili windows: " . winList.Length, , "T2"
        }
    }
    ; If it is not running, run it
    else {
        try {
            Run bilibili
        }
        if ActivateWindow(winIdentifier) {
            SetWindow(winIdentifier, bilibiliDim.x, bilibiliDim.y, bilibiliDim.w, bilibiliDim.h)
        }
        winId := WinGetID(winIdentifier)
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

    winIdentifier := "ahk_exe 哔哩哔哩.exe ahk_class Sandbox:MultiAccount:Chrome_WidgetWin_1"
    winTitle := "哔哩哔哩 (゜-゜)つロ 干杯~-bilibili"

    ; If it is running, toggle the window
    if ProcessExist("哔哩哔哩.exe") {
        winList := WinGetList(winIdentifier)

        switch winList.Length {
            case 0:
                ; No window, run it
                try {
                    Run bilibiliSandboxed
                }
                if bilibiliSandboxedWinId == "" and WinWait(winIdentifier, , 10) {
                    if ActivateWindow(winIdentifier) {
                        SetWindow(winIdentifier, bilibiliDim.x, bilibiliDim.y, bilibiliDim.w, bilibiliDim.h)
                    }
                    winId := WinGetID(winIdentifier)
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
                    bilibiliSandboxedWinId := WinGetID(winTitle . " " . winIdentifier)
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
                MsgBox "ERROR! Unexpected number of bilibili (sandboxed) windows: " . winList.Length, , "T2"
        }
    }
    ; If it is not running, run it
    else {
        try {
            Run bilibiliSandboxed
        }
        if ActivateWindow(winIdentifier) {
            SetWindow(winIdentifier, bilibiliDim.x, bilibiliDim.y, bilibiliDim.w, bilibiliDim.h)
        }
        winId := WinGetID(winIdentifier)
        if winId {
            bilibiliSandboxedWinId := winId
        }
    }
}

/**
 * Open Bilibili with browser
 */
OpenBilibiliWeb() {
    try {
        Run '"' . browser . '" "https://www.bilibili.com"'
    }
    ActivateWindow("ahk_exe " . GetPathComponent(browser, "name"))
}

/**
 * Open Bilibili with browser
 */
OpenBilibiliWeb2() {
    ; With the help of browser extension "Open external links in a container"
    ; Extension Repo: https://github.com/honsiorovskyi/open-url-in-container
    try {
        Run '"' . brave . '" "https://www.bilibili.com"'
    }
    ActivateWindow("ahk_exe " . GetPathComponent(brave, "name"))
}

/**
 * Open YouTube with browser
 */
OpenYouTubeWeb() {
    try {
        Run '"' . browser . '" "https://www.youtube.com"'
    }
    ActivateWindow("ahk_exe " . GetPathComponent(browser, "name"))
}

/**
 * Open YouTube with browser
 */
OpenYouTubeWeb2() {
    ; With the help of browser extension "Open external links in a container"
    ; Extension Repo: https://github.com/honsiorovskyi/open-url-in-container
    try {
        Run '"' . brave . '" "https://www.youtube.com"'
    }
    ActivateWindow("ahk_exe " . GetPathComponent(brave, "name"))
}

/**
 * Run Spotify and Lyricify together
 */
RunSpotifyAndLyricify() {
    spotifyWinIdentifier := "ahk_exe Spotify.exe"
    lyricifyWinIdentifier := "ahk_exe Lyricify for Spotify.exe"

    if !WinActive(spotifyWinIdentifier) {
        ToggleSpotify()
    }

    ; Run Lyricify if it's not running
    if !ProcessExist(lyricifyWinIdentifier) {
        Run lyricify
        CloseWindow(lyricifyWinIdentifier)
    } else {
        if WinExist(lyricifyWinIdentifier) {
            CloseWindow(lyricifyWinIdentifier)
        }
    }
}

/**
 * Start Ollama and Docker container for chat webui
 */
StartOllamaAndWebUI() {
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
        startDockerContainer() {
            if IsDockerContainerRunning(openWebuiDockerContainerName) {
                return true
            } else if Round(Mod(A_Index, 5)) == 2 {
                Run "pwsh.exe -Command " . "docker start " . openWebuiDockerContainerName, , "Hide"
            }
            return false
        }
        isContainerStarted := LoopLogic(startDockerContainer, 20, 500)
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
    winSpecifier := "ahk_exe Clash for Windows.exe"
    if ProcessExist("Clash for Windows.exe") {
        if WinActive(winSpecifier) {
            CloseWindow(winSpecifier)
        } else if WinExist(winSpecifier) and !WinActive(winSpecifier) {
            if ActivateWindow(winSpecifier) {
                SetWindow(winSpecifier, clashDim.x, clashDim.y, clashDim.w, clashDim.h)
            }
        } else {
            Run clash
            if ActivateWindow(winSpecifier) {
                SetWindow(winSpecifier, clashDim.x, clashDim.y, clashDim.w, clashDim.h)
            }
        }
    }
    ; If it is not running, run it
    else {
        try {
            Run clash
        }
        if WinExist(winSpecifier) {
            if ActivateWindow(winSpecifier) {
                SetWindow(winSpecifier, clashDim.x, clashDim.y, clashDim.w, clashDim.h)
            }
            return
        } else if ProcessWait("Clash for Windows.exe", 10) {
            Run clash
            if ActivateWindow(winSpecifier) {
                SetWindow(winSpecifier, clashDim.x, clashDim.y, clashDim.w, clashDim.h)
            }
        }
    }
}

/**
 * Toggle the system proxy on/off
 */
ToggleProxyOnOff() {
    ToggleProxy() {
        toggleClashProxyShortcut := "{LCtrl down}{LAlt down}{LShift down}pmt{LCtrl up}{LAlt up}{LShift up}"
        if IsSystemProxyEnabled() {
            if ProcessExist("Clash for Windows.exe") {
                Sleep 200
                ; Turn off Clash
                Send toggleClashProxyShortcut
                Sleep 200
            } else {
                MsgBox "ATTENTION! System Proxy is enabled but Clash for Windows is not running!", , "T2"
                return false
            }
            if LoopLogic(IsProxyOff, 6, 500) {
                ToolTip "Proxy Turned Off"
                SetTimer () => ToolTip(), -2000, -1
                return true
            }
            MsgBox "Fail to turn proxy off, trying again...", , "T2"
            return false
        } else {
            if ProcessExist("Clash for Windows.exe") {
                Sleep 200
                ; Turn on Clash
                Send toggleClashProxyShortcut
                Sleep 200
            } else {
                MsgBox "ATTENTION! System Proxy is disabled but Clash for Windows is not running!", , "T2"
                return false
            }
            if LoopLogic(IsProxyOn, 6, 500) {
                ToolTip "Proxy Turned On"
                SetTimer () => ToolTip(), -2000, -1
                return true
            }
            MsgBox "Fail to turn proxy on, trying again...", , "T2"
            return false
        }
    }
    IsProxyOn() {
        return IsSystemProxyEnabled()
    }
    IsProxyOff() {
        return !IsSystemProxyEnabled()
    }
    if !LoopLogic(ToggleProxy, 3, 0) {
        MsgBox "Fail to turn proxy " . (IsSystemProxyEnabled() ? "off" : "on") . "!", , "T2"
    }
}

/**
 * Toggle Gaming Network Environment
 */
ToggleGameEnv() {
    RunScriptAsAdmin(adminScript, "ToggleGameEnv")
    IsGameEnvStarted() {
        if FileExist("game_env_started.tmp") {
            FileDelete("game_env_started.tmp")
            ExitApp
        }
    }
    ; Exit AHK script after the game environment has been started
    LoopLogic(IsGameEnvStarted, 100)
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
    try {
        DllCall("PowrProf.dll\SetSuspendState", "Int", 0, "Int", 0, "Int", 0)
    }
}

/**
 * Restart the computer (* seconds countdown)
 */
PutComputerToRestart() {
    countDownSeconds := 5
    try {
        Run('pwsh.exe -Command "for ($i = ' . countDownSeconds . '; $i -gt 0; $i--) { Write-Host \"Restarting in $i seconds...\"; Start-Sleep -Seconds 1 }; Restart-Computer"')
    }
}

;;;;;;;;;; UTILITY FUNCTIONS ;;;;;;;;;;

/**
 * Toggle specified application (that can only have one window/instance)
 * 
 * @param {String} app The executable path of the application
 * @param {Array} appDim The position and dimensions of the application window (default: { x: -1, y: -1, w: -1, h: -1 })
 * @param {String} winExeName The application window name (default: ""), in case the executable name is different from the application window name. For example, window name "WindowsTerminal.exe" for executable name "wt.exe"
 * @param {String} additionalWinSpecifier Additional window specifier (default: ""), e.g. "ahk_class Chrome_WidgetWin_1"
 * @param {Boolean} setWinAfterEveryActivation Whether to set the position and size every time after activating the existing window (default: false)
 * @param {String} minimizeOrClose Whether to minimize the window to taskbar or close it to minimize to system tray (default: `1`), accepted values: `1` to minimize, `2` to close
 */
ToggleApplication(app := "", appDim := { x: -1, y: -1, w: -1, h: -1
}, winExeName := "", additionalWinSpecifier := "", setWinAfterEveryActivation := false, minimizeOrClose := 1) {
    if app == "" {
        MsgBox "ERROR while toggling! No application specified!", , "T2"
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
                if setWinAfterEveryActivation {
                    SetWindow(winSpecifier, appDim.x, appDim.y, appDim.w, appDim.h)
                }
            }
        } else {
            Run app
            if ActivateWindow(winSpecifier) {
                if setWinAfterEveryActivation {
                    SetWindow(winSpecifier, appDim.x, appDim.y, appDim.w, appDim.h)
                }
            }
        }
    }
    ; If it is not running, run it
    else {
        try {
            Run app
        }
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
 * @param {String} winExeName The application window name (default: ""), in case the executable name is different from the application window name. For example, window name "WindowsTerminal.exe" for executable name "wt.exe"
 * @param {String} additionalWinSpecifier Additional window specifier (default: ""), e.g. "ahk_class Chrome_WidgetWin_1"
 * @param {Boolean} newInstance Whether to open a new instance of the application (default: false)
 * @param {Boolean} setWinAfterEveryActivation Whether to set the position and size every time after activating the existing window (default: false)
 */
ToggleApplications(app := "", appDim := { x: -1, y: -1, w: -1, h: -1
}, winExeName := "", additionalWinSpecifier := "", newInstance := false, setWinAfterEveryActivation := false) {
    global appData

    if app == "" {
        MsgBox "ERROR while toggling! No application specified!", , "T2"
        return
    }

    exe := winExeName == "" ? GetPathComponent(app, "name") : winExeName
    name := GetPathComponent(app, "nameNoExt")

    if additionalWinSpecifier != "" {
        additionalWinSpecifier := " " . additionalWinSpecifier
    }
    winSpecifier := "ahk_exe " . exe . additionalWinSpecifier

    ; Check if this `name` exists in map `appData`, if not, create it
    if !appData.Has(name) {
        appData[name] := {}
    }
    ; Check if below props exists for this name in map `appData`, if not, create it
    if !appData[name].HasProp("allWinIdList") {
        appData[name].allWinIdList := []
    }
    if !appData[name].HasProp("lastActivatedWinId") {
        appData[name].lastActivatedWinId := ""
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

            try {
                Run app
            }

            IsNewInstanceStarted() {
                winList := WinGetList(winSpecifier)
                if winList.Length > oldWinCount {
                    return winList
                }
                return false
            }
            winList := LoopLogic(IsNewInstanceStarted, 100, 200)

            if !winList {
                MsgBox 'ERROR! New instance window of "' . name . '" could not be found!', , "T2"
                return
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
                        appData[name].lastActivatedWinId := winId
                        SetWindow("ahk_id " . winId, appDim.x, appDim.y, appDim.w, appDim.h)
                    }
                    return
                }
            }
        }

        ; No expected window, run it
        if winList.Length == 0 {
            try {
                Run app
            }
            if ActivateWindow(winSpecifier) {
                SetWindow(winSpecifier, appDim.x, appDim.y, appDim.w, appDim.h)
            }
            winId := WinGetID(winSpecifier)
            appData[name].lastActivatedWinId := winId
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
                    appData[name].lastActivatedWinId := winList[1]
                    if setWinAfterEveryActivation {
                        SetWindow("ahk_id " . winList[1], appDim.x, appDim.y, appDim.w, appDim.h)
                    }
                }
            }
        }
        ; More than one expected window, cycle through them
        else if winList.Length >= 1 {
            oldestWinId := winList[winList.Length]
            if WinActive("ahk_exe " . exe) {
                ActivateWindow("ahk_id " . oldestWinId)
                appData[name].lastActivatedWinId := oldestWinId
                appData[name].allWinIdList.RemoveAt(appData[name].allWinIdList.Length)
                appData[name].allWinIdList.InsertAt(1, oldestWinId)
            } else {
                if appData[name].lastActivatedWinId == "" and winList.Length > 0 {
                    appData[name].lastActivatedWinId := winList[1]
                }
                ActivateWindow("ahk_id " . appData[name].lastActivatedWinId)
            }
        }
        ; Unexpected number of windows
        else if winList.Length < 0 {
            LogError(Error('<0 "' . name . '" window has been found while the process exists.'))
        }
    }
    ; If it is not running, run it
    else {
        try {
            Run app
        }
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
