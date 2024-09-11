/**
 * Get the color mode of Windows (Light or Dark)
 * 
 * @returns {String} - The color mode of Windows (`Light` or `Dark`)
 */
GetWindowsColorMode() {
    regKey := "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    regValue := "AppsUseLightTheme"
    colorMode := RegRead(regKey, regValue)
    return (colorMode == 0) ? "Dark" : "Light"
}

/**
 * Get the accent color of Windows.
 * 
 * @param {Integer} offset - The offset to get different colors (default: 1)
 */
GetWindowsAccentColor(offset := 1) {
    ; Read the AccentPalette from the Registry
    accentPalette := RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent", "AccentPalette")
    ; Extract the color of the first accent color (change the offset to get different colors)
    r := SubStr(accentPalette, offset * 8 + 1, 2)
    g := SubStr(accentPalette, offset * 8 + 3, 2)
    b := SubStr(accentPalette, offset * 8 + 5, 2)
    ; Combine into a hex color code
    hexColor := r . g . b
    return hexColor
}
