;; This file contains all the constants and global variables.


;;;;;;;;;; GLOBAL VARIABLE ;;;;;;;;;;


; Script log file path
logfile := A_MyDocuments . "\AHK\log\main.log"

; Path to the default browser executable
browser := A_ProgramFiles . "\Mozilla Firefox\firefox.exe"

; URL for the open-webui website
openWebuiUrl := "http://localhost:3333"
dockerContainerName := "open-webui"

; Speed of infinite scrolling (* times faster than normal scroll)
; It will increases non-linearly based on the number of consecutive scroll wheel movements in the same direction
baseScrollSpeed := 1.2

; Wechat login button X Y coordinates
wechatLoginBtnX := 220
wechatLoginBtnY := 450

; AutoDarkMode parameters
morning := 0700
evening := 1830
autoDarkModeCheckInterval := 15 * 60 * 1000

; All custom key bindings
keybindings := [
    ["LAlt + 1", "Toggle Notepad++"],
    ["LAlt + 2", "Toggle Notepad2"],
    ["LAlt + 3", "Toggle Visual Studio Code"],
    ["LAlt + 4", "Toggle Windows Terminal"],
    ["RAlt + P", "Toggle Spotify"],
    ["LAlt + R", "Toggle Telegram"],
    ["LAlt + D", "Toggle Discord"],
    ["LAlt + W", "Toggle WeChat"],
    ["RAlt + L", "Toggle Eudic"],
    ["RAlt + =", "Toggle Bilibili"],
    ["RAlt + -", "Toggle Bilibili (Sandboxed)"],
    ["RAlt + 0", "Open YouTube"],
    ["RAlt + 9", "Open YouTube (Firefox Container)"],
    ["RAlt + RShift + P", "Run Spotify & Lyricify"],
    ["RAlt + K", "Toggle Gaming Network Environment"],
    ["RAlt + C", "Start Ollama & Docker container for LLM"],
    ["LAlt + ``", "Close current window"],
    ["RAlt + F12", "Computer Sleep"],
    ["LCtrl + LShift + RAlt + F12", "Computer Restart"],
    ["RAlt + \", "Send LLM General Prompt"]
]


;;;;;;;;;; APPLICATION PATH ;;;;;;;;;;


notepadpp := A_ProgramFiles . "\Notepad++\notepad++.exe"

notepad2 := A_ProgramFiles . "\Notepad2\Notepad2.exe"

vscode := EnvGet("LocalAppData") . "\Programs\Microsoft VS Code\Code.exe"

terminal := EnvGet("LocalAppData") . "\Microsoft\WindowsApps\wt.exe"

spotify := A_AppData . "\Spotify\Spotify.exe"

lyricify := EnvGet("LocalAppData") . "\Lyricify 4\Lyricify for Spotify.exe"

telegram := A_AppData . "\Telegram Desktop\Telegram.exe"

wechat := A_ProgramFiles . "\Tencent\WeChat\WeChat.exe"

bilibili := A_ProgramFiles . "\bilibili\哔哩哔哩.exe"

bilibiliSandboxed := "C:\Sandbox\" . A_UserName . "\MultiAccount\drive\C\Program Files\bilibili\哔哩哔哩.exe"

eudic := A_ProgramFiles . "\eudic\eudic.exe"

docker := A_ProgramFiles . "\Docker\Docker\Docker Desktop.exe"

ollama := EnvGet("LocalAppData") . "\Programs\Ollama\ollama app.exe"

leishen := EnvGet("ProgramFiles(x86)") . "\LeiGod_Acc\leigod_launcher.exe"


; Real executable path will be set in the toggle function
; Because the path might change after the app is updated
discord := ""

; script to toggle gaming network environment
toggleGameEnv := A_ScriptDir . "\other\toggleGameEnv.ahk"


;;;;;;;;;; APPLICATION WINDOW DIMENSIONS ;;;;;;;;;;


notepadppDim := { x: 871, y: 240, w: 2097, h: 1689 }

; notepad2Dim := { x: 250, y: 40, w: 3340, h: 2080 }

vscodeDim := { x: 250, y: 40, w: 3340, h: 2080 }

spotifyDim := { x: 450, y: 100, w: 2940, h: 1960 }

telegramDim := { x: 711, y: 130, w: 2418, h: 1909 }

discordDim := { x: 600, y: 100, w: 2640, h: 1960 }

wechatDim := { x: 800, y: 180, w: 2240, h: 1800 }

bilibiliDim := { x: 520, y: 120, w: 2800, h: 1920 }

bilibiliVidDim := { x: 360, y: 65, w: 3120, h: 2030 }

eudicDim := { x: 850, y: 210, w: 2140, h: 1740 }

leishenDim := { x:1116 , y: 576, w: 1608, h: 1008 }


;;;;;;;;;; OTHER APPLICATION PARAMETERS ;;;;;;;;;;


; ahk_id of bilibili home page window
bilibiliWinId := ""

; ahk_id of bilibili (sandboxed) home page window
bilibiliSandboxedWinId := ""