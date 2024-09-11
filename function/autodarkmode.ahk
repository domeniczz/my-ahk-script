;; This file contains the AutoDarkMode function which checks the current time and changes the Windows color mode accordingly

; Is temparory check interval around sunrise/sunset is applied
tmpAutoDarkModeCheckInterval := false

/**
 * Check the current time and change the Windows color mode if needed
 */
AutoDarkMode() {
    global tmpAutoDarkModeCheckInterval

    currentTime := FormatTime(A_Now, "HHmm")

    ; Calculate the time interval between the current time and the next sunrise/sunset
    diffInterval := Min(CalculateTimeInterval(currentTime, sunrise, "miliseconds"), CalculateTimeInterval(currentTime, sunset, "miliseconds"))
    ; Update the check interval if the next sunrise/sunset is closer than the default check interval
    ; The new check interval will be the time difference between the current time and the next sunrise/sunset, in order to make the color mode change time more accurately
    if !tmpAutoDarkModeCheckInterval and diffInterval < autoDarkModeCheckInterval {
        tmpAutoDarkModeCheckInterval := true
        ; Set a temporary check interval to check the color mode more precisely around sunrise/sunset
        SetTimer AutoDarkMode, diffInterval, -1
        ; FileAppend "Update autodarkmode check timer interval to " . (diffInterval / 60000) . " minutes`n", logfile
    }

    ; If daytime, switch to light mode
    if currentTime >= sunrise and currentTime < sunset {
        if GetWindowsColorMode() != "Light" {
            ; Restore the default check interval
            tmpAutoDarkModeCheckInterval := false
            SetTimer AutoDarkMode, autoDarkModeCheckInterval, -1
            ; Change the Windows color mode
            ToggleWinColorMode()
            ; FileAppend "Changed Windows color mode to Light at " . SubStr(currentTime, 1, 2) . ":" . SubStr(currentTime, 3) . "`n", logfile
            ; FileAppend "Restore autodarkmode check timer interval to " . (autoDarkModeCheckInterval / 6000) . " minutes`n", logfile
        }
    }
    ; If nighttime, switch to dark mode
    else {
        if GetWindowsColorMode() != "Dark" {
            ; Restore the default check interval
            tmpAutoDarkModeCheckInterval := false
            SetTimer AutoDarkMode, autoDarkModeCheckInterval, -1
            ; Change the Windows color mode
            ToggleWinColorMode()
            ; FileAppend "Changed Windows color mode to Dark at " . SubStr(currentTime, 1, 2) . ":" . SubStr(currentTime, 3) . "`n", logfile
            ; FileAppend "Restore autodarkmode check timer interval to " . (autoDarkModeCheckInterval / 6000) . " minutes`n", logfile
        }
    }
    ; FileAppend "Checking Windows color mode at " . SubStr(currentTime, 1, 2) . ":" . SubStr(currentTime, 3) . "`n", logfile
    ; FileAppend "CurrentTime: " . currentTime . ", diffInterval: " . diffInterval . "`n", logfile
}

/**
 * Changes the Windows color mode (theme) between Light and Dark.
 * If no mode is specified, it toggles between the current and the opposite mode.
 * @param {String} - The desired color mode. Accepts "Light", "Dark", or "Toggle".
 * @example
 * ToggleWinColorMode("Light")   ; Switch to light mode
 * ToggleWinColorMode("Dark")    ; Switch to dark mode
 * ToggleWinColorMode("Toggle")  ; Toggle between light and dark mode
 * ToggleWinColorMode()          ; Same as "Toggle"
 */
ToggleWinColorMode(mode := "Toggle") {
    global sunrise, sunset
    try {
        ;; Step 1: Change the Windows color mode
        static HKCU := "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
        if (mode = "Toggle") {
            currentTheme := RegRead(HKCU, "SystemUsesLightTheme")
            mode := (currentTheme = 0) ? "Light" : "Dark"
        }
        themeValue := (mode = "Light") ? 1 : 0
        RegWrite(themeValue, "REG_DWORD", HKCU, "SystemUsesLightTheme")
        RegWrite(themeValue, "REG_DWORD", HKCU, "AppsUseLightTheme")

        ;; Step 2: Refresh to apply the theme changes
        static WM_SETTINGCHANGE := 0x001A
        Run "RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters 2, True", , "Hide"
        DllCall("user32.dll\SendNotifyMessage", "Ptr", 0xFFFF, "Uint", WM_SETTINGCHANGE, "Ptr", 0, "Ptr", 0)
        DllCall("Shell32.dll\SHChangeNotify", "Int", 0x8000000, "UInt", 0, "Ptr", 0, "Ptr", 0)
        ; broadcast system messages
        SendMessage(WM_SETTINGCHANGE, 0, StrPtr("ImmersiveColorSet"), , "ahk_id 0xFFFF")
        SendMessage(WM_SETTINGCHANGE, 0, StrPtr("ThemeChanged"), , "ahk_id 0xFFFF")
        SendMessage(WM_SETTINGCHANGE, 0, StrPtr("ImmersiveColorSet"), , "ahk_class Shell_TrayWnd")
        SendMessage(0x0319, 0, 0x2003, , "ahk_id 0xFFFF")  ; WM_DWMCOLORIZATIONCOLORCHANGED
        SendMessage(0x0319, 0, 0x2007, , "ahk_id 0xFFFF")  ; WM_DWMCOMPOSITIONCHANGED
        SendMessage(0x0096, 0, 0, , "ahk_id 0xFFFF")  ; WM_CHANGEUISTATE
        SendMessage(0x02B1, 0, 0, , "ahk_id 0xFFFF")  ; WM_THEMECHANGED
        SendMessage(0x000F, 0, 0, , "Program Manager")
        try {
            if (DllCall("GetModuleHandle", "Str", "UxTheme.dll", "Ptr")) {
                DllCall("UxTheme.dll\RefreshImmersiveColorPolicyState")
            }
        }
        try DllCall("SetSysColors", "Int", 1, "Int*", 15, "Int*", DllCall("GetSysColor", "Int", 15))

        ; Step 3: Update sunrise and sunset times
        res := CalculateSunriseSunsetTime(currentLatitude, currentLongitude, currentTimezone)
        sunrise := res[1]
        sunset := res[2]
    } catch as err {
        ; MsgBox("An error occurred while changing color mode: " . err.Message)
        LogError(err, "Return")
        return "Error"
    }
}
