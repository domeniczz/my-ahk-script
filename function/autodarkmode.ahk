;; This file contains the AutoDarkMode function which checks the current time and changes the Windows color mode accordingly


;; Check the current time and change the Windows color mode if needed
AutoDarkMode() {
    currentTime := FormatTime(A_Now, "HHmm")
    if (currentTime >= morning and currentTime < evening) {
        if GetWinColorMode() != "Light" {
            ToggleWinColorMode()
            FileAppend "Changed Windows color mode to Light at " . SubStr(currentTime, 1, 2) . ":" . SubStr(currentTime, 3) . "`n", logfile
        }
    } else {
        if GetWinColorMode() != "Dark" {
            ToggleWinColorMode()
            FileAppend "Changed Windows color mode to Dark at " . SubStr(currentTime, 1, 2) . ":" . SubStr(currentTime, 3) . "`n", logfile
        }
    }
    ; FileAppend "Checking Windows color mode at " . SubStr(currentTime, 1, 2) . ":" . SubStr(currentTime, 3) . "`n", logfile
}


;; Changes the Windows color mode (theme) between Light and Dark.
;; If no mode is specified, it toggles between the current and the opposite mode.
;; Parameters:
;;   mode: The desired color mode. Accepts "Light", "Dark", or "Toggle" (default).
;;         Any other value or omitting the parameter will result in a toggle.
;; Usage:
;;   ToggleWinColorMode("Light")   ; Switch to light mode
;;   ToggleWinColorMode("Dark")    ; Switch to dark mode
;;   ToggleWinColorMode("Toggle")  ; Toggle between light and dark mode
;;   ToggleWinColorMode()          ; Same as "Toggle"
; ToggleWinColorMode(mode := "Toggle") {
;     try {
;         ;; Change the Windows color mode

;         static HKCU := "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
;         if (mode = "Toggle") {
;             currentTheme := RegRead(HKCU, "SystemUsesLightTheme")
;             mode := (currentTheme = 0) ? "Light" : "Dark"
;         }
;         themeValue := (mode = "Light") ? 1 : 0
;         RegWrite(themeValue, "REG_DWORD", HKCU, "SystemUsesLightTheme")
;         RegWrite(themeValue, "REG_DWORD", HKCU, "AppsUseLightTheme")

;         ;; Refresh to apply the theme changes

;         Run "RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters", , "Hide"

;         SendMessage(WM_SETTINGCHANGE := 0x001A, 0, StrPtr("ImmersiveColorSet"), , "ahk_id 0xFFFF")

;         DllCall("user32.dll\SendNotifyMessage", "Ptr", 0xFFFF, "Uint", 0x001A, "Ptr", 0, "Ptr", 0)

;         DllCall("Shell32.dll\SHChangeNotify", "Int", 0x8000000, "UInt", 0, "Ptr", 0, "Ptr", 0)

;         PostMessage(0x0111, 0x0000f200, 0, , "ahk_class Shell_TrayWnd")  ; WM_COMMAND, TB_ENDTRACK
;         SendMessage(0x001A, 0, StrPtr("ThemeChanged"), , "ahk_id 0xFFFF")

;         static WM_SETTINGCHANGE := 0x001A
;         SendMessage(WM_SETTINGCHANGE, 0, StrPtr("ImmersiveColorSet"), , "ahk_class Shell_TrayWnd")

;         try {
;             if (DllCall("GetModuleHandle", "Str", "UxTheme.dll", "Ptr")) {
;                 DllCall("UxTheme.dll\RefreshImmersiveColorPolicyState")
;             }
;         }

;         try DllCall("SetSysColors", "Int", 1, "Int*", 15, "Int*", DllCall("GetSysColor", "Int", 15))

;         SendMessage(0x000F, 0, 0, , "Program Manager")
;     } catch as err {
;         MsgBox("An error occurred while changing color mode: " . err.Message)
;         return "Error"
;     }
; }

ToggleWinColorMode(mode := "Toggle") {
    try {
        ; Run "ms-settings:"
        ; WinMinimize "ahk_exe ApplicationFrameHost.exe"
        ;; Change the Windows color mode
        static HKCU := "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
        if (mode = "Toggle") {
            currentTheme := RegRead(HKCU, "SystemUsesLightTheme")
            mode := (currentTheme = 0) ? "Light" : "Dark"
        }
        themeValue := (mode = "Light") ? 1 : 0
        RegWrite(themeValue, "REG_DWORD", HKCU, "SystemUsesLightTheme")
        RegWrite(themeValue, "REG_DWORD", HKCU, "AppsUseLightTheme")
        ; WinClose "ahk_exe ApplicationFrameHost.exe"

        ;; Refresh to apply the theme changes

        Run "RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters 2, True", , "Hide"

        ; broadcast system messages
        static WM_SETTINGCHANGE := 0x001A
        SendMessage(WM_SETTINGCHANGE, 0, StrPtr("ImmersiveColorSet"), , "ahk_id 0xFFFF")
        SendMessage(WM_SETTINGCHANGE, 0, StrPtr("ThemeChanged"), , "ahk_id 0xFFFF")
        SendMessage(WM_SETTINGCHANGE, 0, StrPtr("ImmersiveColorSet"), , "ahk_class Shell_TrayWnd")
        DllCall("user32.dll\SendNotifyMessage", "Ptr", 0xFFFF, "Uint", WM_SETTINGCHANGE, "Ptr", 0, "Ptr", 0)
        DllCall("Shell32.dll\SHChangeNotify", "Int", 0x8000000, "UInt", 0, "Ptr", 0, "Ptr", 0)
        ; Broadcast additional messages
        SendMessage(0x0319, 0, 0x2003, , "ahk_id 0xFFFF")  ; WM_DWMCOLORIZATIONCOLORCHANGED
        SendMessage(0x0319, 0, 0x2007, , "ahk_id 0xFFFF")  ; WM_DWMCOMPOSITIONCHANGED
        SendMessage(0x0096, 0, 0, , "ahk_id 0xFFFF")  ; WM_CHANGEUISTATE
        SendMessage(0x02B1, 0, 0, , "ahk_id 0xFFFF")  ; WM_THEMECHANGED
        try {
            if (DllCall("GetModuleHandle", "Str", "UxTheme.dll", "Ptr")) {
                DllCall("UxTheme.dll\RefreshImmersiveColorPolicyState")
            }
        }
        try DllCall("SetSysColors", "Int", 1, "Int*", 15, "Int*", DllCall("GetSysColor", "Int", 15))
        SendMessage(0x000F, 0, 0, , "Program Manager")
    } catch as err {
        MsgBox("An error occurred while changing color mode: " . err.Message)
        return "Error"
    }
}

BroadcastSystemMessages() {
    static WM_SETTINGCHANGE := 0x001A

    ; Broadcast to all windows
    SendMessage(WM_SETTINGCHANGE, 0, StrPtr("ImmersiveColorSet"), , "ahk_id 0xFFFF")
    DllCall("user32.dll\SendNotifyMessage", "Ptr", 0xFFFF, "Uint", WM_SETTINGCHANGE, "Ptr", 0, "Ptr", 0)

    ; Notify Shell about the change
    DllCall("Shell32.dll\SHChangeNotify", "Int", 0x8000000, "UInt", 0, "Ptr", 0, "Ptr", 0)

    ; Additional broadcasts
    PostMessage(0x0111, 0x0000f200, 0, , "ahk_class Shell_TrayWnd")  ; WM_COMMAND, TB_ENDTRACK
    SendMessage(WM_SETTINGCHANGE, 0, StrPtr("ThemeChanged"), , "ahk_id 0xFFFF")
    SendMessage(WM_SETTINGCHANGE, 0, StrPtr("ImmersiveColorSet"), , "ahk_class Shell_TrayWnd")
}
