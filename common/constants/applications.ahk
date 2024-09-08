; Path to the default browser executable
browser := A_ProgramFiles . "\Mozilla Firefox\firefox.exe"

; URL for the open-webui website
openWebuiUrl := "http://localhost:3333"
dockerContainerName := "open-webui"

; Wechat login button X Y coordinates
wechatLoginBtnX := 220
wechatLoginBtnY := 450

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