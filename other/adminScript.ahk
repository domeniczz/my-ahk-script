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
        MsgBox "Failed to restart " . A_ScriptName . " with admin privileges."
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

explorer := A_WinDir . "\explorer.exe"

steam := EnvGet("ProgramFiles(x86)") . "\Steam\steam.exe"

leishen := EnvGet("ProgramFiles(x86)") . "\LeiGod_Acc\leigod_launcher.exe"

hwinfo := A_ProgramFiles . "\HWiNFO64\HWiNFO64.EXE"

msiafterburner := EnvGet("ProgramFiles(x86)") . "\MSI Afterburner\MSIAfterburner.exe"

explorerDim := { w: Round(A_ScreenWidth * 0.520833), h: Round(A_ScreenHeight * 0.648148)
}
explorerDim.x := (A_ScreenWidth - explorerDim.w) // 2
explorerDim.y := (A_ScreenHeight - explorerDim.h) // 2

leishenDim := { w: Round(A_ScreenWidth * 0.41875), h: Round(A_ScreenHeight * 0.466666)
}
leishenDim.x := (A_ScreenWidth - leishenDim.w) // 2
leishenDim.y := (A_ScreenHeight - leishenDim.h) // 2

hwinfoDim := { w: Round(A_ScreenWidth * 0.41875), h: Round(A_ScreenHeight * 0.466666)
}
hwinfoDim.x := (A_ScreenWidth - hwinfoDim.w) // 2
hwinfoDim.y := (A_ScreenHeight - hwinfoDim.h) // 2

;;;;;;;;;; USER DEFINED FUNCTIONS ;;;;;;;;;;

/**
 * Toggle Windows File Explorer
 * - Not running: Open Windows File Explorer and set windows position and size
 * - Already Running: Toggle Windows File Explorer and set windows position and size
 */
ToggleFileExplorer() {
    ; If it is running, toggle the window
    if WinExist("ahk_exe explorer.exe ahk_class CabinetWClass") {
        if WinActive("ahk_exe explorer.exe ahk_class CabinetWClass") {
            ; Window is active, minimize it to taskbar
            WinMinimize
        } else {
            ActivateWindow("ahk_exe explorer.exe ahk_class CabinetWClass")
            SetWindow("ahk_exe explorer.exe ahk_class CabinetWClass", explorerDim.x, explorerDim.y, explorerDim.w, explorerDim.h)
        }
    }
    ; If it is not running, run it
    else {
        Run explorer
        ActivateWindow("ahk_exe explorer.exe ahk_class CabinetWClass")
        SetWindow("ahk_exe explorer.exe ahk_class CabinetWClass", explorerDim.x, explorerDim.y, explorerDim.w, explorerDim.h)
    }
}

/**
 * Toggle the gaming network environment
 * - Start gaming: Turn off clash, turn on leigod
 * - Stop gaming: Turn on clash, turn off leigod
 */
ToggleGameEnv() {
    clickX := leishenDim.w * 0.97823383
    clickY := leishenDim.h * 0.099206

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
        if IsSystemProxyEnabled() {
            if ProcessExist("Clash for Windows.exe") {
                ; Turn off Clash
                Send "{LCtrl down}{LAlt down}{LShift down}pmt{LCtrl up}{LAlt up}{LShift up}"
                ToolTip "Clash Turned Off"
                SetTimer () => ToolTip(), -2000, -1
                Sleep 200
            } else {
                MsgBox "ATTENTION! System Proxy is enabled but Clash for Windows is not running!"
            }
        }

        if !WinExist("ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1") {
            run leishen
        }
        ActivateWindow("ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1")
        SetWindow("ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1", leishenDim.x, leishenDim.y, leishenDim.w, leishenDim.h)
        Sleep 500

        if IsColorInRange(GetPixelColors(2, clickX, clickY), leishenActiveColor) or
            IsColorInRange(GetPixelColors(2, clickX, clickY), leishenActiveColorCursorOnButton) {
            ActivateWindowAndClick("ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1", , , clickX, clickY, "雷神关闭")
            Sleep 2000

            if WinExist("ahk_exe leigod.exe") {
                ; WinClose "ahk_exe leigod.exe"
                ActivateWindow("ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1")
                ; Alt + F4 to exit the app
                Send "{LAlt down}{F4}{LAlt up}"
            }

            Sleep 200

            if !IsSystemProxyEnabled() and ProcessExist("Clash for Windows.exe") {
                ; Turn on Clash
                Send "{LCtrl down}{LAlt down}{LShift down}pmt{LCtrl up}{LAlt up}{LShift up}"
                ToolTip "Clash Turned On"
                SetTimer () => ToolTip(), -2000, -1
            }

            ; Move the cursor to the center
            ; centerX := A_ScreenWidth // 2
            ; centerY := A_ScreenHeight // 2
            ; MouseMove(centerX, centerY)

            Sleep 1500
            ToolTip "Remember to un-suspend AHK!"
            SetTimer () => ToolTip(), -2000, -1

            ; Turn off MSI Afterburner
            if ProcessExist("MSIAfterburner.exe") {
                if WinActive("ahk_exe MSIAfterburner.exe") {
                    WinClose
                } else if WinExist("ahk_exe MSIAfterburner.exe") and !WinActive("ahk_exe MSIAfterburner.exe") {
                    ActivateWindow("ahk_exe MSIAfterburner.exe")
                    Sleep 100
                    WinClose
                }
            }
        } else if IsColorInRange(GetPixelColors(2, clickX, clickY), leishenNonActiveColor) or
            IsColorInRange(GetPixelColors(2, clickX, clickY), leishenNonActiveColorCursorOnButton) {
            ActivateWindowAndClick("ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1", , , clickX, clickY, "雷神启动")
            ; Create a file to indicate that the game environment has been started
            FileAppend("", "../game_env_started.tmp")
            Sleep 2000
        }
    }
    ; If LeiGod is not running, then run it, and turn off Clash
    else {
        if IsSystemProxyEnabled() {
            if ProcessExist("Clash for Windows.exe") {
                ; Turn off Clash
                Send "{LCtrl down}{LAlt down}{LShift down}pmt{LCtrl up}{LAlt up}{LShift up}"
                ToolTip "Clash Turned Off"
                SetTimer () => ToolTip(), -2000, -1
                Sleep 200
            } else {
                MsgBox "ATTENTION! System Proxy is enabled but Clash for Windows is not running!"
            }
        }

        Run leishen
        ; Set the window position and size, then focus on the window
        ActivateWindow("ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1", 90)
        SetWindow("ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1", leishenDim.x, leishenDim.y, leishenDim.w, leishenDim.h)
        Sleep 1000

        ActivateWindowAndClick("ahk_exe leigod.exe ahk_class Chrome_WidgetWin_1", , , clickX, clickY, "雷神启动")

        ; Start Steam
        if !ProcessExist("steam.exe") {
            Run steam
        }

        ; Move the cursor to the center
        ; centerX := A_ScreenWidth // 2
        ; centerY := A_ScreenHeight // 2
        ; MouseMove(centerX, centerY)
        ToolTip "Remember to suspend AHK!"
        SetTimer () => ToolTip(), -2000, -1

        ; Start MSI Afterburner
        if !ProcessExist("MSIAfterburner.exe") {
            Run msiafterburner
        }

        ; Create a file to indicate that the game environment has been started
        FileAppend("", "../game_env_started.tmp")
        Sleep 2000
    }
}

/**
 * Toggle HWiNFO64
 */
ToggleHWiNFO() {
    if ProcessExist("HWiNFO64.EXE") {
        if WinActive("ahk_exe HWiNFO64.EXE") {
            WinMinimize
        } else if WinExist("ahk_exe HWiNFO64.EXE") and !WinActive("ahk_exe HWiNFO64.EXE") {
            ActivateWindow("ahk_exe HWiNFO64.EXE")
        } else {
            Run hwinfo
        }
    } else {
        Run hwinfo
        ActivateWindow("ahk_exe HWiNFO64.EXE")
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

/**
 * Toggle MSI Afterburner (it will also toggle RivaTuner Statistics Server)
 */
ToggleMSIAfterburner() {
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

;;;;;;;;;; MAIN FUNCTION ;;;;;;;;;;

if A_Args.Length > 0 {
    functionName := A_Args[1]
    try {
        %functionName%()
    } catch MethodError as e {
        MsgBox 'Function "' . functionName . '" not found or failed to execute. Error: ' . e.Message
    } catch as e {
        MsgBox 'An error occurred while executing "' . functionName . '". Error: ' . e.Message
    }
}
