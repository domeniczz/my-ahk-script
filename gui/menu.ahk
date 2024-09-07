;; This file contains menu GUI functions.

myMenu := DrawMenu()

/*
Show the menu
*/
OpenMenu() {
    ; RefreshItems()
    myMenu.Show()
}

/*
Draw the menu GUI
*/
DrawMenu() {
    Main := Menu()
    Main.Name := "Main"

    Main.Add "Spotify && Lyricify", MenuHandler
    Main.SetIcon "Spotify && Lyricify", "imageres.dll", 104
    Main.Add "Ollama Chat", MenuHandler
    Main.SetIcon "Ollama Chat", "imageres.dll", 244
    Main.Add "MSI Afterburner", MenuHandler
    Main.SetIcon "MSI Afterburner", "DDORes.dll", 35
    Main.Add "Gaming Environment", MenuHandler
    Main.SetIcon "Gaming Environment", "DDORes.dll", 30
    Main.Add "Suspend Script", MenuHandler
    Main.SetIcon "Suspend Script", "imageres.dll", 229

    Main.Add()  ; Add a separator line.

    Sandboxie := Menu()
    Sandboxie.Name := "Sandboxie"
    for key in sandboxieContainers {
        Sandboxie.Add key, MenuHandler
        Sandboxie.SetIcon key, "imageres.dll", 4
    }
    Sandboxie.Add "Refresh List", MenuHandler
    Sandboxie.SetIcon "Refresh List", "imageres.dll", 230

    Main.Add "Sandboxie", Sandboxie
    Main.SetIcon "Sandboxie", "imageres.dll", 166

    Main.Add  ; Add a separator line.

    Tool := Menu()
    Tool.Name := "Tool"
    Tool.Add "Notepad++", MenuHandler
    Tool.SetIcon "Notepad++", "imageres.dll", 248
    Tool.Add "Notepad2", MenuHandler
    Tool.SetIcon "Notepad2", "imageres.dll", 248
    Tool.Add "VSCode", MenuHandler
    Tool.SetIcon "VSCode", "imageres.dll", 291
    Tool.Add "Terminal", MenuHandler
    Tool.SetIcon "Terminal", "imageres.dll", 313
    Tool.Add "Firefox", MenuHandler
    Tool.SetIcon "Firefox", "imageres.dll", 222
    Tool.Add "Firefox P", MenuHandler
    Tool.SetIcon "Firefox P", "imageres.dll", 233
    Tool.Add "Eudic", MenuHandler
    Tool.SetIcon "Eudic", "shell32.dll", 219

    Main.Add "Tool", Tool
    Main.SetIcon "Tool", "imageres.dll", 188

    Main.Add  ; Add a separator line.

    Chat := Menu()
    Chat.Name := "Chat"
    Chat.Add "Telegram", MenuHandler
    Chat.SetIcon "Telegram", "imageres.dll", 210
    Chat.Add "Discord", MenuHandler
    Chat.SetIcon "Discord", "imageres.dll", 210
    Chat.Add "WeChat", MenuHandler
    Chat.SetIcon "WeChat", "imageres.dll", 210
    Chat.Add "TIM", MenuHandler
    Chat.SetIcon "TIM", "imageres.dll", 210
    Chat.Add "DingTalk", MenuHandler
    Chat.SetIcon "DingTalk", "imageres.dll", 210

    Main.Add "Chat", Chat
    Main.SetIcon "Chat", "imageres.dll", 75

    Main.Add  ; Add a separator line.

    Media := Menu()
    Media.Name := "Media"
    Media.Add "Spotify", MenuHandler
    Media.SetIcon "Spotify", "imageres.dll", 192
    Media.Add "Bilibili", MenuHandler
    Media.SetIcon "Bilibili", "imageres.dll", 193
    Media.Add "Bilibili S", MenuHandler
    Media.SetIcon "Bilibili S", "imageres.dll", 193
    Media.Add "YouTube", MenuHandler
    Media.SetIcon "YouTube", "imageres.dll", 193
    Media.Add "YouTube 2", MenuHandler
    Media.SetIcon "YouTube 2", "imageres.dll", 193

    Main.Add "Media", Media
    Main.SetIcon "Media", "shell32.dll", 131

    Main.Add  ; Add a separator line.

    Power := Menu()
    Power.Name := "Power"
    Power.Add "Sleep", MenuHandler
    Power.SetIcon "Sleep", "imageres.dll", 97
    Power.Add "Restart", MenuHandler
    Power.SetIcon "Restart", "imageres.dll", 270

    Main.Add "Power", Power
    Main.SetIcon "Power", "imageres.dll", 103

    return Main
}

/*
Handle menu item selection
*/
MenuHandler(itemName, itemPos, menuObj) {
    switch menuObj.Name {
        case "Main": MainHandler(itemName, itemPos, menuObj)
        case "Sandboxie": SandboxieHandler(itemName, itemPos, menuObj)
        case "Tool": ToolHandler(itemName, itemPos, menuObj)
        case "Chat": ChatHandler(itemName, itemPos, menuObj)
        case "Media": MediaHandler(itemName, itemPos, menuObj)
        case "Power": PowerHandler(itemName, itemPos, menuObj)
    }
}

MainHandler(itemName, itemPos, menuObj) {
    switch itemPos {
        case 1: RunSpotifyAndLyricify()
        case 2: StartOllamaAndDockerWebUI()
        case 3: ToggleMSIAfterburner()
        case 4:
            RunScriptAsAdmin(toggleGameEnv)
        case 5:
            SuspendScript()
            ; Refresh the menu item
            myMenu.Rename(A_IsSuspended ? "Suspend Script" : "Resume Script", A_IsSuspended ? "Resume Script" : "Suspend Script")
            myMenu.SetIcon(A_IsSuspended ? "Resume Script" : "Suspend Script", "imageres.dll", A_IsSuspended ? 231 : 229)
        default: MsgBox("ERROR! Unknown item: " . itemName . " at position " . itemPos)
    }
}

SandboxieHandler(itemName, itemPos, menuObj) {
    if (itemName == "Refresh List") {
        ; Delete all items
        menuObj.Delete
        ; Refresh the sandboxie containers list
        updateContainerList()
        ; Add the updated items
        for key in sandboxieContainers {
            menuObj.Add key, MenuHandler
        }
        menuObj.Add "Refresh List", MenuHandler
        return
    }
    OpenFolder(sandboxieContainers[itemName])
}

ToolHandler(itemName, itemPos, menuObj) {
    switch itemPos {
        case 1: ToggleNotepadPP()
        case 2: ToggleNotepad2()
        case 3: ToggleVSCode()
        case 4: ToggleWindowsTerminal()
        case 5: ToggleFirefox()
        case 6: ToggleFirefox(true)
        case 7: ToggleEudic()
        default: MsgBox("ERROR! Unknown item: " . itemName . " at position " . itemPos)
    }
}

ChatHandler(itemName, itemPos, menuObj) {
    switch itemPos {
        case 1: ToggleTelegram()
        case 2: ToggleDiscord()
        case 3: ToggleWeChat()
        case 4: ToggleTencentTIM()
        case 5: ToggleDingTalk()
        default: MsgBox("ERROR! Unknown item: " . itemName . " at position " . itemPos)
    }
}

MediaHandler(itemName, itemPos, menuObj) {
    switch itemPos {
        case 1: ToggleSpotify()
        case 2: ToggleBilibili()
        case 3: ToggleSandboxedBilibili()
        case 4: OpenYouTube()
        case 5: OpenYouTube2()
        default: MsgBox("ERROR! Unknown item: " . itemName . " at position " . itemPos)
    }
}

PowerHandler(itemName, itemPos, menuObj) {
    switch itemPos {
        case 1: PutComputerToSleep()
        case 2: PutComputerToRestart()
        default: MsgBox("ERROR! Unknown item: " . itemName . " at position " . itemPos)
    }
}
