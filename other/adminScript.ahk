;;;;;;;;;; ! PLEASE RUN THIS SCRIPT AS ADMINISTRATOR ! ;;;;;;;;;;

#Requires AutoHotkey v2.0

#SingleInstance Force

#WinActivateForce

#NoTrayIcon

ProcessSetPriority "High"

A_MaxHotkeysPerInterval := 99999999
A_HotkeyInterval := 99999999

KeyHistory 0
ListLines False

SetKeyDelay -1, -1
SetMouseDelay -1
SetDefaultMouseSpeed 0
SetWinDelay 0
SetControlDelay 0

SendMode "Input"

if not A_IsAdmin {
    try
    {
        if A_IsCompiled
            Run '*RunAs "' A_ScriptFullPath '" /restart'
        else
            Run '*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"'
    } catch {
        MsgBox "Failed to restart " . A_ScriptName . " with admin privileges.", , "T2"
        ExitApp
    }
    ExitApp
}

#Include ..\common\utils\windowutils.ahk
#Include ..\common\utils\systemutils.ahk
#Include ..\common\utils\colorutils.ahk
#Include ..\common\utils\logutils.ahk

OnError LogError

; Persistent

;;;;;;;;;; GLOBAL VARIABLES ;;;;;;;;;;

logfile := A_ScriptDir . "\log\other.log"

steam := EnvGet("ProgramFiles(x86)") . "\Steam\steam.exe"

leishen := EnvGet("ProgramFiles(x86)") . "\LeiGod_Acc\leigod_launcher.exe"

hwinfo := A_ProgramFiles . "\HWiNFO64\HWiNFO64.EXE"

msiafterburner := EnvGet("ProgramFiles(x86)") . "\MSI Afterburner\MSIAfterburner.exe"

hwinfoDim := { w: Round(A_ScreenWidth * 0.41875), h: Round(A_ScreenHeight * 0.466666)
}
hwinfoDim.x := (A_ScreenWidth - hwinfoDim.w) // 2
hwinfoDim.y := (A_ScreenHeight - hwinfoDim.h) // 2

;;;;;;;;;; USER DEFINED FUNCTIONS ;;;;;;;;;;

/**
 * Toggle the gaming network environment
 * - Start gaming: Turn off clash, turn on leigod
 * - Stop gaming: Turn on clash, turn off leigod
 */
ToggleGameEnv() {
    clickX := 1573
    clickY := 100

    ; Lei Shen activation button color
    leishenNonActiveColor := {
        r: { min: 0, max: 59
        },
        g: { min: 215, max: 225
        },
        b: { min: 217, max: 255
        }
    }
    leishenNonActiveColorCursorOnButton := {
        r: { min: 2, max: 48
        },
        g: { min: 173, max: 180
        },
        b: { min: 175, max: 204
        }
    }
    leishenActiveColor := {
        r: { min: 252, max: 255
        },
        g: { min: 109, max: 114
        },
        b: { min: 124, max: 162
        }
    }
    leishenActiveColorCursorOnButton := {
        r: { min: 228, max: 229
        },
        g: { min: 99, max: 104
        },
        b: { min: 113, max: 147
        }
    }

    ; If LeiGod is running, then close it, and turn on Clash
    if ProcessExist("leigod.exe") {
        ; Turn off proxy if it is enabled
        if IsSystemProxyEnabled() {
            maxAttempts1 := 3
            loop maxAttempts1 {
                if ProcessExist("Clash for Windows.exe") {
                    Sleep 200
                    ; Turn off Clash
                    Send "{LCtrl down}{LAlt down}{LShift down}pmt{LCtrl up}{LAlt up}{LShift up}"
                    Sleep 200
                } else {
                    MsgBox "ATTENTION! System Proxy is enabled but Clash for Windows is not running!", , "T2"
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
        }

        if !WinExist("ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1") {
            try {
                Run leishen
            }
        }
        ActivateWindow("ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1", 120)
        Sleep 500

        if IsColorInRange(GetPixelColors(2, clickX, clickY), leishenActiveColor) or
            IsColorInRange(GetPixelColors(2, clickX, clickY), leishenActiveColorCursorOnButton) {
            ActivateWindowAndClick("ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1", , , clickX, clickY, "雷神关闭")
            Sleep 2000

            ; WinClose "ahk_exe leigod.exe"
            if ActivateWindow("ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1") {
                ; Alt + F4 to exit the app
                Send "{LAlt down}{F4}{LAlt up}"
            }
            Sleep 200

            if !IsSystemProxyEnabled() {
                if ProcessExist("Clash for Windows.exe") {
                    ; Turn on Clash
                    Send "{LCtrl down}{LAlt down}{LShift down}pmt{LCtrl up}{LAlt up}{LShift up}"
                    ToolTip "Proxy Turned On"
                    SetTimer () => ToolTip(), -2000, -1
                }
            }

            ; Turn off MSI Afterburner
            if ProcessExist("MSIAfterburner.exe") {
                if WinActive("ahk_exe MSIAfterburner.exe") {
                    Send "{LAlt down}{F4}{LAlt up}"
                } else if WinExist("ahk_exe MSIAfterburner.exe") and !WinActive("ahk_exe MSIAfterburner.exe") {
                    if ActivateWindow("ahk_exe MSIAfterburner.exe") {
                        Send "{LAlt down}{F4}{LAlt up}"
                    }
                } else {
                    try {
                        Run msiafterburner
                        if ActivateWindow("ahk_exe MSIAfterburner.exe") {
                            Send "{LAlt down}{F4}{LAlt up}"
                        }
                    }
                }
            }

            ; Move the cursor to the center
            ; centerX := A_ScreenWidth // 2
            ; centerY := A_ScreenHeight // 2
            ; MouseMove(centerX, centerY)

            Sleep 1500
            ; ToolTip "Remember to un-suspend AHK!"
            ; SetTimer () => ToolTip(), -2000, -1
        } else if IsColorInRange(GetPixelColors(2, clickX, clickY), leishenNonActiveColor) or
            IsColorInRange(GetPixelColors(2, clickX, clickY), leishenNonActiveColorCursorOnButton) {
            if ActivateWindowAndClick("ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1", , , clickX, clickY, "雷神启动") {
                ; Create a file to indicate that the game environment has been started
                FileAppend("", "../game_env_started.tmp")
                Sleep 2000
            }
        }
    }
    ; If LeiGod is not running, then run it, and turn off Clash
    else {
        ; Turn off proxy if it is enabled
        if IsSystemProxyEnabled() {
            maxAttempts1 := 3
            loop maxAttempts1 {
                if ProcessExist("Clash for Windows.exe") {
                    Sleep 200
                    ; Turn off Clash
                    Send "{LCtrl down}{LAlt down}{LShift down}pmt{LCtrl up}{LAlt up}{LShift up}"
                    Sleep 200
                } else {
                    MsgBox "ATTENTION! System Proxy is enabled but Clash for Windows is not running!", , "T2"
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
        }

        try {
            Run leishen
            ; Set the window position and size, then focus on the window
            ActivateWindow("ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1", 120)
            Sleep 1000

            if ActivateWindowAndClick("ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1", , , clickX, clickY, "雷神启动") {
                ; Create a file to indicate that the game environment has been started
                FileAppend("", "../game_env_started.tmp")

                ; Start MSI Afterburner
                if !ProcessExist("MSIAfterburner.exe") {
                    try {
                        Run msiafterburner
                    }
                }

                ; Start Steam
                if !ProcessExist("steam.exe") {
                    try {
                        Run steam
                    }
                    loginWinId := 0
                    loginWinPid := 0
                    steamWinIdentifier := "ahk_exe steamwebhelper.exe ahk_class SDL_app"
                    if WinWait(steamWinIdentifier, , 10) {
                        loginWinId := WinGetID(steamWinIdentifier)
                        loginWinPid := WinGetPID(steamWinIdentifier)
                    }
                    maxAttempts := 400
                    tempCount := 2
                    loop maxAttempts {
                        if WinExist("Steam " . steamWinIdentifier) {
                            mainWinId := WinGetID("Steam " . steamWinIdentifier)
                            if mainWinId != loginWinId and WinGetPID("Steam " . steamWinIdentifier) == loginWinPid {
                                CloseWindow("Steam ahk_id " . mainWinId)
                                tempCount -= 1
                                if tempCount <= 0 {
                                    break
                                }
                            }
                        }
                        maxAttempts -= 1
                        Sleep 500
                    }
                    if maxAttempts <= 0 {
                        MsgBox "Fail to detect Steam main window!", , "T0.5"
                    }
                }
            }
        }

        ; Move the cursor to the center
        ; centerX := A_ScreenWidth // 2
        ; centerY := A_ScreenHeight // 2
        ; MouseMove(centerX, centerY)
        ; ToolTip "Remember to suspend AHK!"
        ; SetTimer () => ToolTip(), -2000, -1
    }
}

/**
 * Toggle HWiNFO64
 */
ToggleHWiNFO() {
    try {
        ; If it is running, toggle the window
        if ProcessExist("HWiNFO64.EXE") {
            if WinActive("ahk_exe HWiNFO64.EXE") {
                WinMinimize
            } else if WinExist("ahk_exe HWiNFO64.EXE") and !WinActive("ahk_exe HWiNFO64.EXE") {
                ActivateWindow("ahk_exe HWiNFO64.EXE")
            } else {
                Run hwinfo
            }
        }
        ; If it is not running, run it
        else {
            Run hwinfo
            if ActivateWindow("ahk_exe HWiNFO64.EXE") {
                startupWinId := WinGetID("ahk_exe HWiNFO64.EXE")
                Send "{Enter}"
                maxAttempts := 600
                loop maxAttempts {
                    id := WinGetID("ahk_exe HWiNFO64.EXE")
                    if id != startupWinId {
                        ActivateWindow("ahk_id " . id)
                    }
                    Sleep 100
                }
            }
        }
    }
}

/**
 * Toggle MSI Afterburner (it will also toggle RivaTuner Statistics Server)
 */
ToggleMSIAfterburner() {
    try {
        ; If it is running, toggle the window
        if ProcessExist("MSIAfterburner.exe") {
            if WinExist("ahk_exe MSIAfterburner.exe") and !WinActive("ahk_exe MSIAfterburner.exe") {
                ActivateWindow("ahk_exe MSIAfterburner.exe")
            } else {
                Run msiafterburner
            }
        }
        ; If it is not running, run it
        else {
            Run msiafterburner
            ToolTip "MSI Afterburner started"
            SetTimer () => ToolTip(), -2500, -1
        }
    }
}

;;;;;;;;;; MAIN FUNCTION ;;;;;;;;;;

if A_Args.Length > 0 {
    functionName := A_Args[1]
    try {
        %functionName%()
    }
}
