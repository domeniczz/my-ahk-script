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

#Include ..\common\constants\custom.ahk
#Include ..\common\constants\settings.ahk
#Include ..\common\utils\datautils.ahk
#Include ..\common\utils\controlutils.ahk
#Include ..\common\utils\windowutils.ahk
#Include ..\common\utils\systemutils.ahk
#Include ..\common\utils\colorutils.ahk
#Include ..\common\utils\logutils.ahk
#Include ..\common\utils\applications.ahk
#Include ..\common\utils\fileutils.ahk

OnError LogError

; Persistent

;;;;;;;;;; GLOBAL VARIABLES ;;;;;;;;;;

logfile := A_ScriptDir . "\log\other.log"

leishen := C_ProgramFilesx86 . "\LeiGod_Acc\leigod_launcher.exe"
ValidateAndUpdatePath(&leishen)

steam := C_ProgramFilesx86 . "\Steam\steam.exe"
ValidateAndUpdatePath(&steam)

msiafterburner := C_ProgramFilesx86 . "\MSI Afterburner\MSIAfterburner.exe"
ValidateAndUpdatePath(&msiafterburner)

hwinfo := A_ProgramFiles . "\HWiNFO64\HWiNFO64.EXE"
ValidateAndUpdatePath(&hwinfo)

;;;;;;;;;; USER DEFINED FUNCTIONS ;;;;;;;;;;

/**
 * Toggle the gaming network environment
 * - Start gaming: Turn off clash, turn on leigod
 * - Stop gaming: Turn on clash, turn off leigod
 */
ToggleGameEnvAdmin() {
    leigodWinIdentifier := "ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1"
    steamWinIdentifier := "ahk_exe steamwebhelper.exe ahk_class SDL_app"

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

    IsProxyOn() {
        return IsSystemProxyEnabled()
    }
    IsProxyOff() {
        return !IsSystemProxyEnabled()
    }
    TurnOnProxy() {
        toggleClashProxyShortcut := "{LCtrl down}{LAlt down}{LShift down}pmt{LCtrl up}{LAlt up}{LShift up}"
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
    TurnOffProxy() {
        toggleClashProxyShortcut := "{LCtrl down}{LAlt down}{LShift down}pmt{LCtrl up}{LAlt up}{LShift up}"
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
    }

    ; If LeiGod is running, then close it, and turn on Clash
    if ProcessExist("leigod.exe") {
        ; Turn off proxy if it is enabled
        if IsSystemProxyEnabled() {
            if !LoopLogic(TurnOffProxy, 3, 0) {
                MsgBox "Fail to turn proxy off!", , "T2"
            }
        }

        if !WinExist(leigodWinIdentifier) {
            try {
                Run leishen
            }
        }
        ActivateWindow(leigodWinIdentifier, 120)
        Sleep 500

        if IsColorInRange(GetPixelColors(2, clickX, clickY), leishenActiveColor) or
        IsColorInRange(GetPixelColors(2, clickX, clickY), leishenActiveColorCursorOnButton) {
            ActivateWindowAndClick(leigodWinIdentifier, , , clickX, clickY, "雷神关闭")
            Sleep 2000

            ; WinClose "ahk_exe leigod.exe"
            if ActivateWindow(leigodWinIdentifier) {
                ; Alt + F4 to exit the app
                Send "{LAlt down}{F4}{LAlt up}"
            }
            SwitchKeyboardLayoutAdmin(C_KeyboardLayout["zh_cn"])
            Sleep 200

            ; Turn on proxy
            if !IsSystemProxyEnabled() {
                if !LoopLogic(TurnOnProxy, 3, 0) {
                    MsgBox "Fail to turn proxy on!", , "T2"
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
            if ActivateWindowAndClick(leigodWinIdentifier, , , clickX, clickY, "雷神启动") {
                ; Create a file to indicate that the game environment has been started
                FileAppend("", "../game_env_started.tmp")
                SwitchKeyboardLayoutAdmin(C_KeyboardLayout["en_us"])
                Sleep 2000
            }
        }
    }
    ; If LeiGod is not running, then run it, and turn off Clash
    else {
        ; Turn off proxy if it is enabled
        if IsSystemProxyEnabled() {
            if !LoopLogic(TurnOffProxy, 3, 0) {
                MsgBox "Fail to turn proxy off!", , "T2"
            }
        }

        try {
            if !ProcessExist("steam.exe") {
                try {
                    Run steam
                }
            }

            Run leishen
            IsLeigodStarted() {
                if !WinExist("ahk_exe leigod_launcher.exe") and !WinExist("ahk_exe updater.exe") and WinExist(leigodWinIdentifier) {
                    ; Set the window position and size, then focus on the window
                    ActivateWindow(leigodWinIdentifier)
                    return true
                }
            }
            LoopLogic(IsLeigodStarted, 900)
            Sleep 1000

            if ActivateWindowAndClick(leigodWinIdentifier, , , clickX, clickY, "雷神启动") {
                ; Create a file to indicate that the game environment has been started
                FileAppend("", "../game_env_started.tmp")

                SwitchKeyboardLayoutAdmin(C_KeyboardLayout["en_us"])

                ; Start MSI Afterburner
                if !ProcessExist("MSIAfterburner.exe") {
                    try {
                        Run msiafterburner
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
ToggleHWiNFOAdmin() {
    winIdentifier := "ahk_exe HWiNFO64.EXE"

    try {
        ; If it is running, toggle the window
        if ProcessExist("HWiNFO64.EXE") {
            if WinExist(winIdentifier) and !WinActive(winIdentifier) {
                ActivateWindow(winIdentifier)
            } else {
                Run hwinfo
            }
        }
        ; If it is not running, run it
        else {
            Run hwinfo
            if ActivateWindow(winIdentifier) {
                startupWinId := WinGetID(winIdentifier)
                Send "{Enter}"
                WaitAndActivateWin() {
                    id := WinGetID(winIdentifier)
                    if id != startupWinId {
                        return ActivateWindow("ahk_id " . id)
                    }
                }
                LoopLogic(WaitAndActivateWin, 600)
            }
        }
    }
}

/**
 * Toggle MSI Afterburner (it will also toggle RivaTuner Statistics Server)
 */
ToggleMSIAfterburnerAdmin() {
    winIdentifier := "ahk_exe MSIAfterburner.exe"

    try {
        ; If it is running, toggle the window
        if ProcessExist("MSIAfterburner.exe") {
            if WinExist(winIdentifier) and !WinActive(winIdentifier) {
                ActivateWindow(winIdentifier)
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

/**
 * Switch the IME input language.
 * 
 * @param {Integer} targetLayout - The target language keyboard ID
 */
SwitchKeyboardLayoutAdmin(targetLayout) {
    winId := WinGetID("A")
    if winId {
        threadId := DllCall("GetWindowThreadProcessId", "Ptr", winId, "Ptr", 0)
        currentLayout := DllCall("GetKeyboardLayout", "UInt", threadId, "Ptr")

        if currentLayout != targetLayout {
            SendMessage(0x50, , targetLayout, , "A")
        }
    }
}

;;;;;;;;;; MAIN FUNCTION ;;;;;;;;;;

if A_Args.Length > 0 {
    functionName := A_Args[1]
    try {
        %functionName%Admin()
    }
}
