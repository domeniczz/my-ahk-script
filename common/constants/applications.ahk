; Path to the default browser executable
browser := A_ProgramFiles . "\Mozilla Firefox\firefox.exe"

; URL for the open-webui website
openWebuiUrl := "http://localhost:3333"
openWebuiDockerContainerName := "open-webui"

; Wechat login button X Y coordinates
wechatLoginBtnX := 220
wechatLoginBtnY := 450

;;;;;;;;;; APPLICATION PATHS ;;;;;;;;;;

explorer := A_WinDir . "\explorer.exe"

notepadpp := A_ProgramFiles . "\Notepad++\notepad++.exe"

notepad2 := A_ProgramFiles . "\Notepad2\Notepad2.exe"

vscode := EnvGet("LocalAppData") . "\Programs\Microsoft VS Code\Code.exe"

cursor := EnvGet("LocalAppData") . "\Programs\cursor\Cursor.exe"

heynote := A_ProgramFiles . "\Heynote\Heynote.exe"

typora := A_ProgramFiles . "\Typora\Typora.exe"

terminal := EnvGet("LocalAppData") . "\Microsoft\WindowsApps\wt.exe"

firefox := A_ProgramFiles . "\Mozilla Firefox\firefox.exe"

brave := A_ProgramFiles . "\BraveSoftware\Brave-Browser\Application\brave.exe"

chrome := A_ProgramFiles . "\Google\Chrome\Application\chrome.exe"

msedge := EnvGet("ProgramFiles(x86)") . "\Microsoft\Edge\Application\msedge.exe"

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

hwinfo := A_ProgramFiles . "\HWiNFO64\HWiNFO64.EXE"

clash := A_ProgramFiles . "\Clash for Windows\Clash for Windows.exe"

; Real executable path will be set in the toggle function
; Because the path might change after the app is updated
discord := ""

;;;;;;;;;; APPLICATION WINDOW DIMENSIONS ;;;;;;;;;;

explorerDim := { w: Round(A_ScreenWidth * AdjustWidthCoeff(0.520833)), h: Round(A_ScreenHeight * AdjustHeightCoeff(0.648148))
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

terminalDim := { w: Round(A_ScreenWidth * AdjustWidthCoeff(0.55989583)), h: Round(A_ScreenHeight * AdjustHeightCoeff(0.7060185))
}
terminalDim.x := (A_ScreenWidth - terminalDim.w) // 2
terminalDim.y := (A_ScreenHeight - terminalDim.h) // 2

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

clashDim := { w: Round(A_ScreenWidth * AdjustWidthCoeff(0.5)), h: Round(A_ScreenHeight * AdjustHeightCoeff(0.6944444))
}
clashDim.x := (A_ScreenWidth - clashDim.w) // 2
clashDim.y := (A_ScreenHeight - clashDim.h) // 2

/**
 * Adjust the width coefficient of the application window to fit the current screen size
 * 
 * @param widthCoeff The original width coefficient of the application window
 * @returns {Float | Integer} The adjusted width coefficient
 */
AdjustWidthCoeff(widthCoeff) {
    baseScreenWidth := 3840
    ratio := A_ScreenWidth / baseScreenWidth

    ; For screens of the same size as the base one
    if ratio == 1 {
        return widthCoeff
    }
    ; For smaller screens
    else if ratio < 1 {
        adjustment := 1 + (1 - ratio) * 2.4 * (1 - widthCoeff)
        return Min(widthCoeff * adjustment, 0.99)
    }
    ; For larger screens
    else if ratio > 1 {
        adjustment := 1 + (ratio - 1) * 0.5 * (1 - widthCoeff)
        return Min(widthCoeff * adjustment, 0.88)
    }
}

/**
 * Adjust the height coefficient of the application window to fit the current screen size
 * 
 * @param heightCoeff The original height coefficient of the application window
 * @returns {Float | Integer} The adjusted height coefficient
 */
AdjustHeightCoeff(heightCoeff) {
    baseScreenHeight := 2160
    ratio := A_ScreenHeight / baseScreenHeight

    ; For screens of the same size as the base one
    if ratio == 1 {
        return heightCoeff
    }
    ; For smaller screens
    else if ratio < 1 {
        adjustment := 1 + (1 - ratio) * 2 * (1 - heightCoeff)
        return Min(heightCoeff * adjustment, 0.97)
    }
    ; For larger screens
    else if ratio > 1 {
        adjustment := 1 + (ratio - 1) * 0.8 * (1 - heightCoeff)
        return Min(heightCoeff * adjustment, 0.97)
    }
}
