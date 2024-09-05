;; This file contains all the constants and global variables.

;;;;;;;;;; GLOBAL VARIABLES ;;;;;;;;;;

; Format the current date as MM-dd
CurrentMonth := FormatTime("", "MM")
CurrentDate := FormatTime("", "MM-dd")

; Log file path
logDir := A_ScriptDir . "\log" . "\" . CurrentMonth
; Ensure log directory exists
DirCreate logDir
logfile := logDir . "\" . CurrentDate . ".log"
; Ensure the log file exists (creates it if it doesn't)
FileAppend "", logfile

; Path to the default browser executable
browser := A_ProgramFiles . "\Mozilla Firefox\firefox.exe"

; URL for the open-webui website
openWebuiUrl := "http://localhost:3333"
dockerContainerName := "open-webui"

; Speed of infinite scrolling (* times faster than normal scroll)
; It will increases non-linearly based on the number of consecutive scroll wheel movements in the same direction
baseScrollSpeed := 1.5

; Wechat login button X Y coordinates
wechatLoginBtnX := 220
wechatLoginBtnY := 450

; AutoDarkMode parameters
morning := 0700
evening := 1830
; Check interval (seconds)
autoDarkModeCheckInterval := 15 * 60 * 1000

; List (Map) of excluded programs
excludedProgramList := Map(
    ; Counter-Strike: Global Offensive
    "cs2.exe", true,
    "csgo_legacy_app.exe", true,
    "csgo.exe", true,
    ; Apex Legends
    "r5apex.exe", true,
    ; Call of Duty
    "cod.exe", true,
    ; Overwatch
    "Overwatch.exe", true,
    ; Dota 2
    "dota2.exe", true,
    ; Red Dead Redemption 2
    "RDR2.exe", true,
    ; Grand Theft Auto V
    "GTA5.exe", true,
    ; Black Myth: Wukong
    "b1.exe", true,
    ; Civilization VI
    "CivilizationVI.exe", true,
    ; Stardew Valley
    "Stardew Valley.exe", true,
    ; Terraria
    "Terraria.exe", true,
    ; 3DMark
    "3DMark.exe", true
)

; All custom hotkey bindings
keybindings := [
    ["LAlt + 1", "Toggle Notepad++"
    ],
    ["LAlt + 2", "Toggle Notepad2"
    ],
    ["LAlt + 3", "Toggle Visual Studio Code"
    ],
    ["LAlt + 4", "Toggle Windows Terminal"
    ],
    ["LWin (+ LShift) + 1", "Toggle Firefox (Private)"
    ],
    ["RAlt + P", "Toggle Spotify"
    ],
    ["LAlt + R", "Toggle Telegram"
    ],
    ["LAlt + T", "Toggle Discord"
    ],
    ["LAlt + W", "Toggle WeChat"
    ],
    ["LAlt + Q", "Toggle TIM"
    ],
    ["LAlt + E", "Toggle DingTalk"
    ],
    ["RAlt + L", "Toggle Eudic"
    ],
    ["RAlt + =", "Toggle Bilibili"
    ],
    ["RAlt + -", "Toggle Bilibili (Sandboxed)"
    ],
    ["RAlt + 0", "Open YouTube"
    ],
    ["RAlt + 9", "Open YouTube (Firefox Container)"
    ],
    ["RAlt + RShift + P", "Run Spotify & Lyricify"
    ],
    ["RAlt + K", "Toggle Gaming Network Environment"
    ],
    ["RAlt + C", "Start Ollama & Docker container for LLM"
    ],
    ["RAlt + O", "Open MSI Afterburner"
    ],
    ["LAlt + ``", "Close current window"
    ],
    ["RAlt + F12", "Computer Sleep"
    ],
    ["LCtrl + LShift + RAlt + F12", "Computer Restart"
    ],
    ["RAlt + \", "Send LLM General Prompt"
    ]
]

;;;;;;;;;; SCRIPT PATHS ;;;;;;;;;;

; script to toggle gaming network environment
toggleGameEnv := A_ScriptDir . "\other\toggleGameEnv.ahk"

; script to toggle windows color mode
toggleAutoDarkMode := A_ScriptDir . "\function\autodarkmode.ahk"

;;;;;;;;;; APPLICATION PATHS ;;;;;;;;;;

notepadpp := A_ProgramFiles . "\Notepad++\notepad++.exe"

notepad2 := A_ProgramFiles . "\Notepad2\Notepad2.exe"

vscode := EnvGet("LocalAppData") . "\Programs\Microsoft VS Code\Code.exe"

terminal := EnvGet("LocalAppData") . "\Microsoft\WindowsApps\wt.exe"

firefox := A_ProgramFiles . "\Mozilla Firefox\firefox.exe"

firefoxPrivate := A_ProgramFiles . "\Mozilla Firefox\private_browsing.exe"

spotify := A_AppData . "\Spotify\Spotify.exe"

lyricify := EnvGet("LocalAppData") . "\Lyricify 4\Lyricify for Spotify.exe"

telegram := A_AppData . "\Telegram Desktop\Telegram.exe"

wechat := A_ProgramFiles . "\Tencent\WeChat\WeChat.exe"

tim := "C:\Programs\Tencent\TIM\Bin\TIM.exe"

dingtalk := EnvGet("ProgramFiles(x86)") . "\DingDing\DingtalkLauncher.exe"

bilibili := A_ProgramFiles . "\bilibili\哔哩哔哩.exe"

bilibiliSandboxed := "C:\Sandbox\" . A_UserName . "\MultiAccount\drive\C\Program Files\bilibili\哔哩哔哩.exe"

eudic := A_ProgramFiles . "\eudic\eudic.exe"

docker := A_ProgramFiles . "\Docker\Docker\Docker Desktop.exe"

ollama := EnvGet("LocalAppData") . "\Programs\Ollama\ollama app.exe"

steam := EnvGet("ProgramFiles(x86)") . "\Steam\steam.exe"

leishen := EnvGet("ProgramFiles(x86)") . "\LeiGod_Acc\leigod_launcher.exe"

rawaccel := "C:\Programs\RawAccel\rawaccel.exe"

msiafterburner := EnvGet("ProgramFiles(x86)") . "\MSI Afterburner\MSIAfterburner.exe"

; Real executable path will be set in the toggle function
; Because the path might change after the app is updated
discord := ""

;;;;;;;;;; APPLICATION WINDOW DIMENSIONS ;;;;;;;;;;

notepadppDim := { x: 871, y: 240, w: 2097, h: 1689
}

; notepad2Dim := { x: 250, y: 40, w: 3340, h: 2080 }

vscodeDim := { x: 250, y: 40, w: 3340, h: 2080
}

spotifyDim := { x: 450, y: 100, w: 2940, h: 1960
}

telegramDim := { x: 620, y: 130, w: 2600, h: 1900
}

discordDim := { x: 600, y: 100, w: 2640, h: 1960
}

wechatDim := { x: 800, y: 180, w: 2240, h: 1800
}

timDim := { x: 720, y: 180, w: 2400, h: 1800
}

dingtalkDim := { x: 670, y: 130, w: 2500, h: 1900
}

bilibiliDim := { x: 520, y: 120, w: 2800, h: 1920
}

bilibiliVidDim := { x: 360, y: 65, w: 3120, h: 2030
}

eudicDim := { x: 850, y: 210, w: 2140, h: 1740
}

leishenDim := { x: 1116, y: 576, w: 1608, h: 1008
}