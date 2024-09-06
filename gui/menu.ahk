;; This file contains menu GUI functions.

myMenu := DrawMenu()

/*
Show the menu
*/
OpenMenu() {
    myMenu.Rename("Suspend Script", A_IsSuspended ? "Resume Script" : "Suspend Script")
    myMenu.Show()
}

/*
Draw the menu GUI
*/
DrawMenu() {
    Main := Menu()
    Main.Name := "Main"

    Main.Add("Spotify && Lyricify", MenuHandler)
    Main.Add("Ollama Chat", MenuHandler)
    Main.Add("MSI Afterburner", MenuHandler)
    Main.Add("Game Environment", MenuHandler)
    Main.Add("Suspend Script", MenuHandler)

    Main.Add()  ; Add a separator line.

    Sandboxie := Menu()
    Sandboxie.Name := "Sandboxie"
    for key in sandboxieContainers {
        Sandboxie.Add(key, MenuHandler)
    }
    Sandboxie.Add("Refresh List", MenuHandler)

    Main.Add("Sandboxie", Sandboxie)

    Main.Add()  ; Add a separator line.

    Tool := Menu()
    Tool.Name := "Tool"
    Tool.Add("Notepad++", MenuHandler)
    Tool.Add("Notepad2", MenuHandler)
    Tool.Add("VSCode", MenuHandler)
    Tool.Add("Terminal", MenuHandler)
    Tool.Add("Firefox", MenuHandler)
    Tool.Add("Firefox P", MenuHandler)
    Tool.Add("Eudic", MenuHandler)

    Main.Add("Tool", Tool)

    Main.Add()  ; Add a separator line.

    Chat := Menu()
    Chat.Name := "Chat"
    Chat.Add("Telegram", MenuHandler)
    Chat.Add("Discord", MenuHandler)
    Chat.Add("WeChat", MenuHandler)
    Chat.Add("TIM", MenuHandler)
    Chat.Add("DingTalk", MenuHandler)

    Main.Add("Chat", Chat)

    Main.Add()  ; Add a separator line.

    Media := Menu()
    Media.Name := "Media"
    Media.Add("Spotify", MenuHandler)
    Media.Add("Bilibili", MenuHandler)
    Media.Add("Bilibili S", MenuHandler)
    Media.Add("YouTube", MenuHandler)
    Media.Add("YouTube 2", MenuHandler)

    Main.Add("Media", Media)

    Main.Add()  ; Add a separator line.

    Power := Menu()
    Power.Name := "Power"
    Power.Add("Sleep", MenuHandler)
    Power.Add("Restart", MenuHandler)

    Main.Add("Power", Power)

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
        case 4: RunScriptAsAdmin(toggleGameEnv)
        case 5: SuspendScript()
        default: MsgBox("ERROR! Unknown item: " . itemName . " at position " . itemPos)
    }
}

SandboxieHandler(itemName, itemPos, menuObj) {
    if (itemName == "Refresh List") {
        ; Delete all items
        menuObj.Delete()
        ; Refresh the sandboxie containers list
        updateContainerList()
        ; Add the updated items
        for key in sandboxieContainers {
            menuObj.Add(key, MenuHandler)
        }
        menuObj.Add("Refresh List", MenuHandler)
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
