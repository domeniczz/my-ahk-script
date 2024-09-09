;; This file contains the AutoDarkMode function which checks the current time and changes the Windows color mode accordingly

/**
 * Check the current time and change the Windows color mode if needed
 */
AutoDarkMode() {
    currentTime := FormatTime(A_Now, "HHmm")
    if (currentTime >= sunrise and currentTime < sunset) {
        if GetWindowsColorMode() != "Light" {
            ToggleWinColorMode()
            ; FileAppend "Changed Windows color mode to Light at " . SubStr(currentTime, 1, 2) . ":" . SubStr(currentTime, 3) . "`n", logfile
        }
    } else {
        if GetWindowsColorMode() != "Dark" {
            ToggleWinColorMode()
            ; FileAppend "Changed Windows color mode to Dark at " . SubStr(currentTime, 1, 2) . ":" . SubStr(currentTime, 3) . "`n", logfile
        }
    }
    ; FileAppend "Checking Windows color mode at " . SubStr(currentTime, 1, 2) . ":" . SubStr(currentTime, 3) . "`n", logfile
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
        res := GetSunriseSunsetTimes(currentLatitude, currentLongitude, currentTimezone)
        sunrise := res[1] + 10
        sunset := res[2] + 10
    } catch as err {
        ; MsgBox("An error occurred while changing color mode: " . err.Message)
        LogError(err, "Return")
        return "Error"
    }
}

/**
 * Calculates sunrise and sunset times for a given location and date.
 * @param {Number} latitude - Latitude of the location (-90 to 90)
 * @param {Number} longitude - Longitude of the location (-180 to 180)
 * @param {Number} timezone - Timezone offset from UTC (-12 to 14)
 * @returns {Array} An array containing [sunrise, sunset] times in "HHmm" format
 */
GetSunriseSunsetTimes(latitude, longitude, timezone) {
    ; Constants
    rad := 0.017453292519943295 ; PI/180
    zenith := 90.83333333333333 ; Solar zenith for sunrise/sunset

    ; Get current date
    date := A_Now
    year := FormatTime(date, "yyyy")
    month := FormatTime(date, "M")
    day := FormatTime(date, "d")

    ; Calculate day of year
    n1 := Floor((275 * month) / 9)
    n2 := Floor((month + 9) / 12)
    n3 := (1 + Floor((year - 4 * Floor(year / 4) + 2) / 3))
    n := n1 - (n2 * n3) + day - 30

    ; Calculate solar noon
    lngHour := longitude / 15
    t := n + ((6 - lngHour) / 24)
    m := (0.9856 * t) - 3.289

    ; Calculate sun's true longitude
    l := m + (1.916 * Sin(rad * m)) + (0.020 * Sin(2 * rad * m)) + 282.634
    l := Mod(l + 360, 360)

    ; Calculate sun's right ascension
    y := 0.91764 * Sin(rad * l)
    x := Cos(rad * l)
    ra := ATan(y / x) / rad
    if (x < 0)
        ra += 180
    else if (y < 0)
        ra += 360
    ra := Mod(ra + 360, 360)

    ; Adjust right ascension to same quadrant as L
    lQuadrant := Floor(l / 90) * 90
    raQuadrant := Floor(ra / 90) * 90
    ra := ra + (lQuadrant - raQuadrant)

    ; Convert RA to hours
    ra /= 15

    ; Calculate sun's declination
    sinDec := 0.39782 * Sin(rad * l)
    cosDec := Cos(ASin(sinDec))

    ; Calculate sun's local hour angle
    cosH := (Cos(rad * zenith) - (sinDec * Sin(rad * latitude))) / (cosDec * Cos(rad * latitude))

    ; Calculate sunrise and sunset times
    h := ACos(cosH) / rad
    sunrise := ((360 - h) / 15) + ra - (0.06571 * t) - 6.622 - lngHour + timezone
    sunset := (h / 15) + ra - (0.06571 * t) - 6.622 - lngHour + timezone

    ; Adjust for 24-hour time
    sunrise := Mod(sunrise + 24, 24)
    sunset := Mod(sunset + 24, 24)

    ; Convert to HHmm format
    sunriseTime := DecimalToHHmm(sunrise)
    sunsetTime := DecimalToHHmm(sunset)

    DecimalToHHmm(decimalTime) {
        hours := Floor(decimalTime)
        minutes := Round((decimalTime - hours) * 60)
        if (minutes = 60) {
            hours += 1
            minutes := 0
        }
        return Format("{:02}{:02}", Mod(hours, 24), minutes)
    }

    return [sunriseTime, sunsetTime
    ]
}
