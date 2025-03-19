/**
 * The function address stored in ImmGetDefaultIMEWnd will remain constant as long as the `imm32.dll` library stays loaded.
 * 
 * The only scenario where the value might change would be if the `imm32.dll` library was unloaded and reloaded, but this is extremely unlikely to happen during normal operation.
 */
ImmGetDefaultIMEWnd := DllCall("GetProcAddress", "Ptr", DllCall("LoadLibrary", "Str", "imm32", "Ptr"), "AStr", "ImmGetDefaultIMEWnd", "Ptr")

/**
 * Get the active window's IME window ID
 * 
 * @returns {String} - The IME window ID
 */
GetIMEWinId() {
    return DllCall(ImmGetDefaultIMEWnd, "Ptr", WinGetID("A"), "Ptr")
}

/**
 * Get the current IME input language.
 * 
 * @returns {Integer} - The current IME input language ID or `0` if failed
 */
GetCurrentKeyboardLayout() {
    winId := GetIMEWinId()
    if winId {
        threadId := DllCall("GetWindowThreadProcessId", "Ptr", winId, "Ptr", 0)
        currentLayout := DllCall("GetKeyboardLayout", "UInt", threadId, "Ptr")
        return currentLayout
    }
    return 0
}

/**
 * Switch the IME input language.
 * 
 * @param {Integer} targetLayout - The target language keyboard ID
 */
SwitchKeyboardLayout(targetLayout) {
    currentLayout := GetCurrentKeyboardLayout()
    if currentLayout {
        if currentLayout != targetLayout {
            SendMessage(0x50, , targetLayout, , "A")
        }
    }
}

/**
 * Get the current language mode of the Chinese IME keyboard layout (English or Chinese input mode)
 * 
 * @param {String} winId - Optional. The IME window ID
 * 
 * @returns {Number} - The IME language mode (0: English, 1: Chinese)
 */
GetCurrentIMEMode(winId := 0) {
    if !winId {
        winId := GetIMEWinId()
    }
    result := SendMessage(0x283, 0x005, 0, , winId)
    if result == 1 {
        result := SendMessage(0x283, 0x001, 0, , winId)
        return result & 1
    }
    return result
}

/**
 * Set the IME language mode for the Chinese IME keyboard layout
 * 
 * @param {Number} mode - The desired IME mode (0: English, 1: Chinese)
 * 
 * @param {String} winId - Optional. The IME window ID
 */
SetIMEMode(mode, winId := 0) {
    if !winId {
        winId := GetIMEWinId()
    }
    ; Set the conversion mode
    SendMessage(0x283, 0x002, mode, , winId)
    ; Set the sentence mode
    SendMessage(0x283, 0x006, mode, , winId)
}

/**
 * Toggle between English and Chinese input modes for the Chinese IME keyboard layout
 */
ToggleIMEMode() {
    if GetCurrentKeyboardLayout() != C_KeyboardLayout["zh_cn"] {
        return
    }
    winId := GetIMEWinId()
    currentMode := GetCurrentIMEMode(winId)
    newMode := currentMode == 0 ? 1 : 0
    SetIMEMode(newMode, winId)
    ToolTip("IME Mode: " . (newMode == 0 ? "English" : "Chinese"))
    SetTimer () => ToolTip(), -1000
}

/**
 * Switch the IME language mode for the Chinese IME keyboard layout to target mode
 * 
 * @param {Number} mode - The desired IME mode, accept integer or string (0: English, 1: Chinese)
 */
SwitchIMEMode(mode) {
    if GetCurrentKeyboardLayout() != C_KeyboardLayout["zh_cn"] {
        return
    }
    if Type(mode) == "String" {
        if mode == "English" {
            mode := 0
        } else if mode == "Chinese" {
            mode := 1
        }
    }
    if mode != 0 and mode != 1 {
        throw Error("Invalid IME mode: " . mode)
    }
    winId := GetIMEWinId()
    SetIMEMode(mode, winId)
}
