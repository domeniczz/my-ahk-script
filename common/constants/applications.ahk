; Path to the default browser executable
browser := A_ProgramFiles . "\Mozilla Firefox\firefox.exe"
ValidateAndUpdatePath(&browser)
; Incognito flag for the defaultbrowser
browserIncognitoFlag := "--private-window"

; URL for the open-webui website
openWebuiUrl := "http://localhost:3333"
openWebuiDockerContainerName := "open-webui"

; Wechat login button X Y coordinates
wechatLoginBtnX := 220
wechatLoginBtnY := 450

;;;;;;;;;; APPLICATION PATHS ;;;;;;;;;;

explorer := A_WinDir . "\explorer.exe"
ValidateAndUpdatePath(&explorer)

notepadpp := A_ProgramFiles . "\Notepad++\notepad++.exe"
ValidateAndUpdatePath(&notepadpp)

notepad2 := A_ProgramFiles . "\Notepad2\Notepad2.exe"
ValidateAndUpdatePath(&notepad2)

vscode := C_LocalAppData . "\Programs\Microsoft VS Code\Code.exe"
ValidateAndUpdatePath(&vscode)

cursor := C_LocalAppData . "\Programs\cursor\Cursor.exe"
ValidateAndUpdatePath(&cursor)

heynote := A_ProgramFiles . "\Heynote\Heynote.exe"
ValidateAndUpdatePath(&heynote)

typora := A_ProgramFiles . "\Typora\Typora.exe"
ValidateAndUpdatePath(&typora)

obsidian := A_ProgramFiles . "\Obsidian\Obsidian.exe"
ValidateAndUpdatePath(&obsidian)

terminal := C_LocalAppData . "\Microsoft\WindowsApps\wt.exe"
ValidateAndUpdatePath(&terminal)

thunderbird := A_ProgramFiles . "\Mozilla Thunderbird\thunderbird.exe"
ValidateAndUpdatePath(&thunderbird)

firefox := A_ProgramFiles . "\Mozilla Firefox\firefox.exe"
ValidateAndUpdatePath(&firefox)

brave := A_ProgramFiles . "\BraveSoftware\Brave-Browser\Application\brave.exe"
ValidateAndUpdatePath(&brave)

chrome := A_ProgramFiles . "\Google\Chrome\Application\chrome.exe"
ValidateAndUpdatePath(&chrome)

msedge := C_ProgramFilesx86 . "\Microsoft\Edge\Application\msedge.exe"
ValidateAndUpdatePath(&msedge)

spotify := A_AppData . "\Spotify\Spotify.exe"
ValidateAndUpdatePath(&spotify)

lyricify := C_LocalAppData . "\Lyricify 4\Lyricify for Spotify.exe"
ValidateAndUpdatePath(&lyricify)

follow := C_LocalAppData . "\Follow\Follow.exe"
ValidateAndUpdatePath(&follow)

telegram := A_AppData . "\Telegram Desktop\Telegram.exe"
ValidateAndUpdatePath(&telegram)

discord := GetFilePath(C_LocalAppData . "\Discord", "Discord.exe")
ValidateAndUpdatePath(&discord)

wechat := A_ProgramFiles . "\Tencent\WeChat\WeChat.exe"
ValidateAndUpdatePath(&wechat)

tim := C_SystemDriveLetter . "\Programs\Tencent\TIM\Bin\TIM.exe"
ValidateAndUpdatePath(&tim)

dingtalk := C_ProgramFilesx86 . "\DingDing\DingtalkLauncher.exe"
ValidateAndUpdatePath(&dingtalk)

bilibili := A_ProgramFiles . "\bilibili\哔哩哔哩.exe"
ValidateAndUpdatePath(&bilibili)

bilibiliSandboxed := C_SystemDriveLetter . "\Sandbox\" . A_UserName . "\MultiAccount\drive\C\Program Files\bilibili\哔哩哔哩.exe"
ValidateAndUpdatePath(&bilibiliSandboxed)

eudic := A_ProgramFiles . "\eudic\eudic.exe"
ValidateAndUpdatePath(&eudic)

docker := A_ProgramFiles . "\Docker\Docker\Docker Desktop.exe"
ValidateAndUpdatePath(&docker)

ollama := C_LocalAppData . "\Programs\Ollama\ollama app.exe"
ValidateAndUpdatePath(&ollama)

steam := C_ProgramFilesx86 . "\Steam\steam.exe"
ValidateAndUpdatePath(&steam)

clash := A_ProgramFiles . "\Clash for Windows\Clash for Windows.exe"
ValidateAndUpdatePath(&clash)

onepassword := C_LocalAppData . "\1Password\app\8\1Password.exe"
ValidateAndUpdatePath(&onepassword)

leishen := C_ProgramFilesx86 . "\LeiGod_Acc\leigod_launcher.exe"
ValidateAndUpdatePath(&leishen)

rawaccel := C_SystemDriveLetter . "\Programs\RawAccel\rawaccel.exe"
ValidateAndUpdatePath(&rawaccel)

msiafterburner := C_ProgramFilesx86 . "\MSI Afterburner\MSIAfterburner.exe"
ValidateAndUpdatePath(&msiafterburner)

hwinfo := A_ProgramFiles . "\HWiNFO64\HWiNFO64.EXE"
ValidateAndUpdatePath(&hwinfo)

;;;;;;;;;; APPLICATION WINDOW DIMENSIONS ;;;;;;;;;;

explorerDim := { w: Round(A_ScreenWidth * AdjustWidthCoeff(0.5536458)), h: Round(A_ScreenHeight * AdjustHeightCoeff(0.7148148))
}
explorerDim.x := (A_ScreenWidth - explorerDim.w) // 2
explorerDim.y := (A_ScreenHeight - explorerDim.h) // 2

notepadppDim := { w: Round(A_ScreenWidth * AdjustWidthCoeff(0.546)), h: Round(A_ScreenHeight * AdjustHeightCoeff(0.7819))
}
notepadppDim.x := (A_ScreenWidth - notepadppDim.w) // 2
notepadppDim.y := (A_ScreenHeight - notepadppDim.h) // 2

vscodeDim := { w: Round(A_ScreenWidth * AdjustWidthCoeff(0.86979166)), h: Round(A_ScreenHeight * AdjustHeightCoeff(0.962962))
}
vscodeDim.x := (A_ScreenWidth - vscodeDim.w) // 2
vscodeDim.y := (A_ScreenHeight - vscodeDim.h) // 2

cursorDim := { w: Round(A_ScreenWidth * AdjustWidthCoeff(0.86979166)), h: Round(A_ScreenHeight * AdjustHeightCoeff(0.962962))
}
cursorDim.x := (A_ScreenWidth - cursorDim.w) // 2
cursorDim.y := (A_ScreenHeight - cursorDim.h) // 2

heynoteDim := { w: Round(A_ScreenWidth * AdjustWidthCoeff(0.53385416)), h: Round(A_ScreenHeight * AdjustHeightCoeff(0.787037))
}
heynoteDim.x := (A_ScreenWidth - heynoteDim.w) // 2
heynoteDim.y := (A_ScreenHeight - heynoteDim.h) // 2

typoraDim := { w: Round(A_ScreenWidth * AdjustWidthCoeff(0.86979166)), h: Round(A_ScreenHeight * AdjustHeightCoeff(0.962962))
}
typoraDim.x := (A_ScreenWidth - typoraDim.w) // 2
typoraDim.y := (A_ScreenHeight - typoraDim.h) // 2

obsidianDim := { w: Round(A_ScreenWidth * AdjustWidthCoeff(0.86979166)), h: Round(A_ScreenHeight * AdjustHeightCoeff(0.962962))
}
obsidianDim.x := (A_ScreenWidth - obsidianDim.w) // 2
obsidianDim.y := (A_ScreenHeight - obsidianDim.h) // 2

terminalDim := { w: Round(A_ScreenWidth * AdjustWidthCoeff(0.55989583)), h: Round(A_ScreenHeight * AdjustHeightCoeff(0.7060185))
}
terminalDim.x := (A_ScreenWidth - terminalDim.w) // 2
terminalDim.y := (A_ScreenHeight - terminalDim.h) // 2

thunderbirdDim := { w: Round(A_ScreenWidth * AdjustWidthCoeff(0.6875)), h: Round(A_ScreenHeight * AdjustHeightCoeff(0.91111111))
}
thunderbirdDim.x := (A_ScreenWidth - thunderbirdDim.w) // 2
thunderbirdDim.y := (A_ScreenHeight - thunderbirdDim.h) // 2

geckoDim := { w: Round(A_ScreenWidth * AdjustWidthCoeff(0.86979166)), h: Round(A_ScreenHeight * AdjustHeightCoeff(0.962962))
}
geckoDim.x := (A_ScreenWidth - geckoDim.w) // 2
geckoDim.y := (A_ScreenHeight - geckoDim.h) // 2

firefoxDim := { w: Round(A_ScreenWidth * AdjustWidthCoeff(0.86979166)), h: Round(A_ScreenHeight * AdjustHeightCoeff(0.962962))
}
firefoxDim.x := (A_ScreenWidth - firefoxDim.w) // 2
firefoxDim.y := (A_ScreenHeight - firefoxDim.h) // 2

chromiumDim := { w: Round(A_ScreenWidth * AdjustWidthCoeff(0.875)), h: Round(A_ScreenHeight * AdjustHeightCoeff(0.96759))
}
chromiumDim.x := (A_ScreenWidth - chromiumDim.w) // 2
chromiumDim.y := (A_ScreenHeight - chromiumDim.h) // 2 + 5

braveDim := { w: Round(A_ScreenWidth * AdjustWidthCoeff(0.875)), h: Round(A_ScreenHeight * AdjustHeightCoeff(0.96759))
}
braveDim.x := (A_ScreenWidth - braveDim.w) // 2
braveDim.y := (A_ScreenHeight - braveDim.h) // 2 + 5

spotifyDim := { w: Round(A_ScreenWidth * AdjustWidthCoeff(0.765625)), h: Round(A_ScreenHeight * AdjustHeightCoeff(0.9074074))
}
spotifyDim.x := (A_ScreenWidth - spotifyDim.w) // 2
spotifyDim.y := (A_ScreenHeight - spotifyDim.h) // 2

followDim := { w: Round(A_ScreenWidth * AdjustWidthCoeff(0.765625)), h: Round(A_ScreenHeight * AdjustHeightCoeff(0.9074074))
}
followDim.x := (A_ScreenWidth - followDim.w) // 2
followDim.y := (A_ScreenHeight - followDim.h) // 2

telegramDim := { w: Round(A_ScreenWidth * AdjustWidthCoeff(0.6770833)), h: Round(A_ScreenHeight * AdjustHeightCoeff(0.87962962))
}
telegramDim.x := (A_ScreenWidth - telegramDim.w) // 2
telegramDim.y := (A_ScreenHeight - telegramDim.h) // 2

discordDim := { w: Round(A_ScreenWidth * AdjustWidthCoeff(0.6875)), h: Round(A_ScreenHeight * AdjustHeightCoeff(0.9074074))
}
discordDim.x := (A_ScreenWidth - discordDim.w) // 2
discordDim.y := (A_ScreenHeight - discordDim.h) // 2

wechatDim := { w: Round(A_ScreenWidth * AdjustWidthCoeff(0.583333)), h: Round(A_ScreenHeight * AdjustHeightCoeff(0.833333))
}
wechatDim.x := (A_ScreenWidth - wechatDim.w) // 2
wechatDim.y := (A_ScreenHeight - wechatDim.h) // 2

timDim := { w: Round(A_ScreenWidth * AdjustWidthCoeff(0.625)), h: Round(A_ScreenHeight * AdjustHeightCoeff(0.833333))
}
timDim.x := (A_ScreenWidth - timDim.w) // 2
timDim.y := (A_ScreenHeight - timDim.h) // 2

dingtalkDim := { w: Round(A_ScreenWidth * AdjustWidthCoeff(0.65104167)), h: Round(A_ScreenHeight * AdjustHeightCoeff(0.87962962))
}
dingtalkDim.x := (A_ScreenWidth - dingtalkDim.w) // 2
dingtalkDim.y := (A_ScreenHeight - dingtalkDim.h) // 2

bilibiliDim := { w: Round(A_ScreenWidth * AdjustWidthCoeff(0.7291666)), h: Round(A_ScreenHeight * AdjustHeightCoeff(0.888888))
}
bilibiliDim.x := (A_ScreenWidth - bilibiliDim.w) // 2
bilibiliDim.y := (A_ScreenHeight - bilibiliDim.h) // 2

bilibiliVidDim := { w: Round(A_ScreenWidth * AdjustWidthCoeff(0.8125)), h: Round(A_ScreenHeight * AdjustHeightCoeff(0.9398148))
}
bilibiliVidDim.x := (A_ScreenWidth - bilibiliVidDim.w) // 2
bilibiliVidDim.y := (A_ScreenHeight - bilibiliVidDim.h) // 2

eudicDim := { w: Round(A_ScreenWidth * AdjustWidthCoeff(0.55729166)), h: Round(A_ScreenHeight * AdjustHeightCoeff(0.8055555))
}
eudicDim.x := (A_ScreenWidth - eudicDim.w) // 2
eudicDim.y := (A_ScreenHeight - eudicDim.h) // 2

onepasswordDim := { w: Round(A_ScreenWidth * AdjustWidthCoeff(0.53125)), h: Round(A_ScreenHeight * AdjustHeightCoeff(0.8055555))
}
onepasswordDim.x := (A_ScreenWidth - onepasswordDim.w) // 2
onepasswordDim.y := (A_ScreenHeight - onepasswordDim.h) // 2

clashDim := { w: Round(A_ScreenWidth * AdjustWidthCoeff(0.5)), h: Round(A_ScreenHeight * AdjustHeightCoeff(0.6944444))
}
clashDim.x := (A_ScreenWidth - clashDim.w) // 2
clashDim.y := (A_ScreenHeight - clashDim.h) // 2