/**
 * Changes the case of selected text.
 * 
 * @param {String} Mode - The type of case conversion to perform.
 * 
 * - `L`: Convert to lowercase
 * - `U`: Convert to uppercase
 * - `T`: Convert to titlecase (capitalize the first letter of each word)
 */
SwitchTextCase(Mode) {
    ; Copy the text
    Send "^c"
    if !ClipWait(1) {
        MsgBox "Failed to copy text to clipboard.", , "T2"
        return
    }
    ; Sleep for a while to ensure A_Clipboard works correctly
    Sleep 50
    A_Clipboard := RTrim(Trim(A_Clipboard), "`r`n")

    ; Convert the text based on the specified mode
    switch Mode {
        case "L": A_Clipboard := StrLower(A_Clipboard)
        case "U": A_Clipboard := StrUpper(A_Clipboard)
        case "T": A_Clipboard := StrTitle(A_Clipboard)
        default: MsgBox "ERROR! Invalid mode for SwitchTextCase: " . Mode, , "T2"
    }

    Send "^v"
    ; Sleep a while in case the paste operation hasn't completed before the clipboard is cleared
    Sleep 100
    A_Clipboard := ""
}

/**
 * Get the selected text (if any), the text won't show up in the clipboard history.
 * 
 * @param {Boolean} retainText - Whether to retain the selected text in the clipboard history (default: `false`).
 * 
 * @returns {String | Boolean} - The selected text or empty ("") if no text is selected.
 */
GetSelectedText(retainText := false) {
    A_Clipboard := ""
    ; Copy the text
    Send "{LCtrl Down}c{LCtrl Up}"
    ; Sleep for a while to ensure A_Clipboard works correctly
    Sleep 50
    selectText := A_Clipboard
    ; Delete from system clipboard history
    if !retainText {
        A_Clipboard := ""
    }
    if selectText == "" {
        return ""
    }
    lastChar := SubStr(selectText, -1)
    ; If the last character is a newline, check if the selected text is one whole line, if yes, ignore it
    ; Because in IDEs, we can copy a whole line by just pressing `Ctrl + C` without selecting any text
    if Ord(lastChar) == 10 or Ord(lastChar) == 13 {
        count := 0
        loop parse, selectText {
            ; If the last character is a newline
            ; ASCii 10: Line Feed (LF)
            ; ASCii 13: Carriage Return (CR)
            if Ord(A_LoopField) == 10 or Ord(A_LoopField) == 13 {
                count++
            }
            if count >= 2 {
                return ""
            }
            ; Limit the loop times in case the selected text is too long
            if A_Index > 400 {
                break
            }
        }
    }
    return selectText
}

/**
 * Check if a string contains a line ending character.
 * 
 * @param {String} str - The string to check.
 * @param {Boolean} omitLeadingNewline - Whether to ignore leading line ending characters.
 * @param {Boolean} omitTrailingNewline - Whether to ignore trailing line ending characters.
 * 
 * @returns {Boolean} - `true` if the string contains a line ending character, `false` otherwise.
 */
IsTextContainsNewline(str := "", omitLeadingNewline := false, omitTrailingNewline := false) {
    if str == "" {
        return false
    }
    if omitLeadingNewline {
        str := RegExReplace(str, "^\R+")
    }
    if omitTrailingNewline {
        str := RegExReplace(str, "\R+$")
    }
    return InStr(str, "`n") > 0 or InStr(str, "`r") > 0
}

/**
 * Check if a string is a web link.
 * 
 * @param {String} str - The string to check.
 * @returns {Boolean} - `true` if the string is a web link, `false` otherwise.
 */
IsWebLink(str) {
    ; Regular expression pattern for matching URLs
    pattern := "^(?:(?:[A-Za-z]{3,9}\:(?:\/\/)?)?(?:[\-\;\&\=\+\w]+(?:\.[A-Za-z0-9.-]{2,})|(?:[\-\;\&\=\+\w]+\:\b\d{1,5}\b))(?:(?:\/[\+\~\%\/\.\w\-\_]*)?\??.*?)?)(?<!\.)$"
    return RegExMatch(str, pattern)
}

/**
 * Action on a separate clipboard that doesn't interfere with the system clipboard.
 * 
 * @param {String} action - Clipboard action
 * 
 * - `copy`: Copy the selected text
 * - `cut`: Cut the selected text
 * - `paste`: Paste the copied text
 */
SeparateClipboard(action := "copy") {
    global SeperateClipboard

    if action == "paste" {
        A_Clipboard := SeperateClipboard
        Send "{LCtrl Down}v{LCtrl Up}"
        Sleep 100
        ; Delete from system clipboard history
        A_Clipboard := ""
        return
    } else if action == "copy" {
        Send "{LCtrl Down}c{LCtrl Up}"
    } else if action == "cut" {
        Send "{LCtrl Down}x{LCtrl Up}"
    }
    if !ClipWait(1) {
        MsgBox "Failed to cut text to clipboard.", , "T2"
        return
    }
    Sleep 50
    SeperateClipboard := A_Clipboard
    ; Delete from system clipboard history
    A_Clipboard := ""
}

lastReplicateDownActionTime := 0
lastreplicateDownMode := 0

/**
 * Replicate the current line or lines downwards for a specified number of times.
 * 
 * If the last replicate down action is within 2 seconds, simply paste the copied text, no need to execute the complete logic again; otherwise, execute the complete logic.
 * 
 * @param {Boolean} userSpecify - Whether to ask the user for the number of lines to copy (default: `false`).
 */
ReplicateDown(userSpecify := false) {
    global lastReplicateDownActionTime, lastreplicateDownMode

    ; If the last replicate down action is within 2 seconds, simply paste the copied text, no need to execute the complete logic again
    if A_TickCount - lastReplicateDownActionTime < 2000 {
        switch lastreplicateDownMode {
            case 1: Send "{Enter}{Ctrl Down}v{Ctrl Up}"
            case 2: Send "{Ctrl Down}v{Ctrl Up}"
            case 3: Send "{Enter}{Ctrl Down}v{Ctrl Up}"
        }
    }
    ; If the last replicate down action is not within 2 seconds, execute the complete logic
    else {
        times := !userSpecify ? 1 : Integer(LetUserInputNumber("How many lines to copy:"))
        selectedText := GetSelectedText()
        if times == 1 {
            if IsTextContainsNewline(selectedText) {
                Send "{Ctrl Down}c{Ctrl Up}{Right}{Enter}{Ctrl Down}v{Ctrl Up}"
                lastreplicateDownMode := 1
            } else {
                if selectedText == "" {
                    Send "{Up}{End}{Shift Down}{Down}{End}{Shift Up}{Ctrl Down}c{Ctrl Up}{Right}{Ctrl Down}v{Ctrl Up}"
                    lastreplicateDownMode := 2
                }
                else {
                    Send "{Ctrl Down}c{Ctrl Up}{Right}{Enter}{Ctrl Down}v{Ctrl Up}"
                    lastreplicateDownMode := 3
                }
            }
        } else if times > 1 {
            if IsTextContainsNewline(selectedText) {
                loop times {
                    if A_Index == 1 {
                        Send "{Ctrl Down}c{Ctrl Up}{Right}{Enter}{Ctrl Down}v{Ctrl Up}"
                    } else {
                        Send "{Enter}{Ctrl Down}v{Ctrl Up}"
                    }
                    Sleep 50
                }
                lastreplicateDownMode := 1
            } else {
                if selectedText == "" {
                    loop times {
                        if A_Index == 1 {
                            Send "{Up}{End}{Shift Down}{Down}{End}{Shift Up}{Ctrl Down}c{Ctrl Up}{Right}{Ctrl Down}v{Ctrl Up}"
                        } else {
                            Send "{Ctrl Down}v{Ctrl Up}"
                        }
                        Sleep 50
                    }
                    lastreplicateDownMode := 2
                } else {
                    loop times {
                        if A_Index == 1 {
                            Send "{Ctrl Down}c{Ctrl Up}{Right}{Enter}{Ctrl Down}v{Ctrl Up}"
                        } else {
                            Send "{Enter}{Ctrl Down}v{Ctrl Up}"
                        }
                        Sleep 50
                    }
                    lastreplicateDownMode := 3
                }
            }
        } else if times < 0 {
            MsgBox "ERROR! Invalid number of times to replicate: " . times, , "T2"
            lastreplicateDownMode := 0
        }
    }

    ; Update the last replicate down action time
    lastReplicateDownActionTime := A_TickCount
}

/**
 * Searches selected text or opens the selected link, if no selection, use the most recent clipboard item.
 * 
 * @param {Boolean} isPrivate - Whether to open browser in private mode (default: `false`).
 */
SearchOrOpenSelected(isPrivate := false) {
    clipboardBackup := Trim(A_Clipboard, "`s`t`r`n")

    ; Get the selected text or most recent clipboard item
    text := GetSelectedText()

    if text == "" {
        if clipboardBackup == "" {
            MsgBox "Nothing in the clipboard.", , "T2"
            return
        }
        text := clipboardBackup
    }

    A_Clipboard := text

    browserToUse := browser
    incognitoFlag := browserIncognitoFlag

    ; If the topmost window is a mainstream browser, use this browser instead of the default one
    currentProgram := GetTopmostWindowInfo(false).exe
    if HasVal(chromiumBrowserList, currentProgram) {
        ; Assume the name of global variable for browser path is the same as the browser executable name without the .exe extension
        browserToUse := %StrSplit(currentProgram, ".", , 2)[1]%
        incognitoFlag := "--incognito"
    } else if HasVal(geckoBrowserList, currentProgram) {
        browserToUse := %StrSplit(currentProgram, ".", , 2)[1]%
        incognitoFlag := "--private-window"
    }

    try {
        ; Check if the text is a web link
        if IsWebLink(text) {
            Run '"' . browserToUse . '"' . (isPrivate ? " " . incognitoFlag : "") . ' "' . TrimLinkParams(text) . '"'
        } else {
            Run '"' . browserToUse . '"' . (isPrivate ? " " . incognitoFlag : "") . ' "https://kagi.com/search?q=' . text . (kagiSearchToken == "" ? "" : "&token=" . kagiSearchToken) . '"'
        }
    }
}

aotStateGui := DrawAOTStateGui()

/**
 * Toggle the Always On Top for the currently active window.
 */
SetWindowAlwaysOnTop() {
    ; Uses AlwaysOnTop from Powertoys
    if ProcessExist("PowerToys.AlwaysOnTop.exe") {
        Send "{LCtrl Down}{LWin Down}t{LCtrl Up}{LWin Up}"
    }
    ; Use the custom method if Powertoys is not available
    else {
        ; change title "! " as required
        Title_When_On_Top := "! "
        winTitle := WinGetTitle("A")
        ExStyle := WinGetExStyle(winTitle)
        ; 0x8 is WS_EX_TOPMOST
        if ExStyle & 0x8 {
            ; Turn off aot and remove Title_When_On_Top
            WinSetAlwaysOnTop 0, winTitle
            WinSetTitle RegExReplace(winTitle, Title_When_On_Top), winTitle
            aotStateGui.Hide()
            aotStateGui["AOTStateText"].Value := "AOT ON"
        } else {
            ; Turn on aot and add Title_When_On_Top
            WinSetAlwaysOnTop 1, winTitle
            WinSetTitle Title_When_On_Top winTitle, winTitle
            ; Display the aot window's process name (without file extension)
            aotStateGui["AOTStateText"].Value := GetPathComponent(WinGetProcessName("A"), "nameNoExt")
            aotStateGui.Show("NoActivate")
        }
    }
}

/**
 * Display the information of the topmost visible window: title, ahk_id, ahk_class, ahk_exe
 */
DisplayTopmostWindowInfo() {
    info := GetTopmostWindowInfo()
    if info {
        infoText := "Window Title: " . info.title . "`n"
            . "ahk_id: " . info.id . "`n"
            . "ahk_class: " . info.class . "`n"
            . "ahk_exe: " . info.exe
        MsgBox infoText, "Topmost Window Info", "T2"
    } else {
        MsgBox "No suitable window found.", "Topmost Window Info", "T2"
    }
}

/**
 * Activate the topmost visible window.
 */
ActivateTopmostWindow() {
    info := GetTopmostWindowInfo()
    if info {
        ActivateWindow(info.id)
    }
}

/**
 * Toggle the window between maximized and restored state.
 */
ToggleWindowMaximize() {
    winId := GetTopmostWindowInfo().id
    if winId {
        if WinGetMinMax(winId) == 1 {
            WinRestore(winId)
        } else {
            WinMaximize(winId)
        }
    }
}

/**
 * Eject all removable drives.
 */
EjectAllRemovableDrives() {
    loop parse DriveGetList("REMOVABLE") {
        DriveEject(A_LoopField)
    }
    ; driveList := DriveGetList()

    ; for drive in StrSplit(driveList) {
    ;     drivePath := drive . ":"
    ;     if DriveGetType(drivePath) == "Removable" {
    ;         hVolume := DllCall("CreateFile", "Str", "\\.\" . drivePath, "UInt", 0x80000000 | 0x40000000,
    ;             "UInt", 0x1 | 0x2, "Ptr", 0, "UInt", 3, "UInt", 0, "Ptr", 0, "Ptr")

    ;         if hVolume != -1 {
    ;             result := DllCall("DeviceIoControl", "Ptr", hVolume, "UInt", 0x2D4808,
    ;                 "Ptr", 0, "UInt", 0, "Ptr", 0, "UInt", 0, "Ptr", 0, "Ptr", 0)
    ;             DllCall("CloseHandle", "Ptr", hVolume)

    ;             if result
    ;                 MsgBox "Successfully ejected drive " . drivePath, , "T2"
    ;             else
    ;                 MsgBox "Failed to eject drive " . drivePath, "Error", "T2 16"
    ;         } else {
    ;             MsgBox "Failed to open drive " . drivePath, "Error", "T2 16"
    ;         }
    ;     }
    ; }
}

/**
 * Reload the script with admin privileges.
 */
ReloadScriptWithAdminPrivilege() {
    try {
        if A_IsCompiled {
            Run '*RunAs "' A_ScriptFullPath '" /restart'
        } else {
            Run '*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"'
        }
    }
    ExitApp
}

/**
 * Retrieves information of the topmost visible window: title, ahk_id, ahk_class, ahk_exe
 * Returns false if no suitable window is found.
 * 
 * @param {Boolean} withAhkPrefixs - Whether to include ahk_ prefix (e.g. ahk_id) (default: `true`).
 * @param {Boolean} excludeWindows - Whether to exclude defined windows (default: `true`).
 * 
 * @returns {Object | Boolean} - The information of the topmost visible window or false if no suitable window is found
 * 
 * @throws {Error} - If encounter errors when getting the topmost window info
 * 
 * @example
 * {
 *     title: "Mozilla Firefox",
 *     id: "ahk_id 394026",
 *     class: "ahk_class MozillaWindowClass",
 *     exe: "ahk_exe firefox.exe"
 * }
 */
GetTopmostWindowInfo(withAhkPrefixs := true, excludeWindows := true) {
    try {
        windowList := WinGetList()

        ; Iterate through all windows
        for window in windowList {
            ; Skip if window doesn't exist
            if !WinExist(window)
                continue

            winExe := WinGetProcessName(window)
            winClass := WinGetClass(window)

            if excludeWindows {
                ; Skip explorer.exe windows except File Explorer
                if winExe = "explorer.exe" && winClass != "CabinetWClass" {
                    continue
                }
                ; Skip excluded windows in the list
                if HasVal(excludedWindowList, winExe) {
                    continue
                }
            }

            winTitle := WinGetTitle(window)
            winId := WinGetID(window)

            ; Check if the window is minimized
            minMax := WinGetMinMax(window)
            if minMax == -1  ; -1 means minimized
                continue

            ; Return the information
            return {
                title: winTitle,
                id: Format(withAhkPrefixs ? "ahk_id {}" : "{}", winId),
                class: Format(withAhkPrefixs ? "ahk_class {}" : "{}", winClass),
                exe: Format(withAhkPrefixs ? "ahk_exe {}" : "{}", winExe)
            }
        }

        ; No suitable window found
        return false
    } catch as err {
        MsgBox "ERROR when get topmost window info: " . err.Message, , "T2"
        throw
    }
}

/**
 * Switch the Keyboard input language.
 */
SwitchKeyboardInputLanguage() {
    currentLanguage := GetCurrentIMEInputLanguage()
    if currentLanguage == C_IMEInputLanguage["zh_cn"] {
        SwitchIMEInputLanguage(C_IMEInputLanguage["en_us"])
        ToolTip "IME: English"
        SetTimer () => ToolTip(), -1000, -1
    } else if currentLanguage == C_IMEInputLanguage["en_us"] {
        SwitchIMEInputLanguage(C_IMEInputLanguage["zh_cn"])
        ToolTip "IME: Chinese"
        SetTimer () => ToolTip(), -1000, -1
    }
}

/**
 * Clean up the unnecessary parameters from the provided URL link
 * 
 * @param {String} url - The URL to trim
 * @returns {String} - The URL with the parameters trimmed
 */
TrimLinkParams(url) {
    parts := StrSplit(url, "#", , 2)
    anchor := parts.Length > 1 ? "#" . parts[2] : ""

    parts := StrSplit(parts[1], "?", , 2)
    if parts.Length < 2 {
        return url
    }

    base := parts[1]
    query := parts[2]

    ; If there are no query parameters, return the base URL
    if !query {
        return base
    }

    cleanedParams := ParamsCleanup()

    ; Rebuild the query string if there are valid parameters
    resQuery := ""
    if cleanedParams.Length > 0 {
        for i, param in cleanedParams {
            resQuery .= (i = 1 ? "?" : "&") . param
        }
    }

    return base . resQuery . anchor

    ParamsCleanup() {
        local params := StrSplit(query, "&")
        for removalRule in paramsRemovalRules {
            rule := ParseRule(removalRule)
            if rule.urlPattern != "" and !CheckUrlPatternMatch([GetDomain(), base], rule.urlPattern) {
                continue
            }
            for i, param in params {
                if !param {
                    continue
                }
                key := StrSplit(param, "=", , 2)[1]
                if RegExMatch(key, rule.pattern) {
                    params.RemoveAt(i)
                }
                if params.Length == 0 {
                    return params
                }
            }
        }
        return params
    }

    /**
     * Parse the rule string to get the url pattern and parameter match pattern
     */
    ParseRule(ruleString) {
        if SubStr(ruleString, 1, 2) == "||" {
            atPosition := InStr(ruleString, "@")
            if atPosition > 2 {
                local urlPattern := SubStr(ruleString, 3, atPosition - 3)
                local pattern := SubStr(ruleString, atPosition + 1)
                return { urlPattern: urlPattern, pattern: pattern
                }
            }
        }
        return { urlPattern: "", pattern: ruleString
        }
    }

    /**
     * Check if the rule domain matches the URL domain
     */
    CheckUrlPatternMatch(urls, rulePattern) {
        ; Check for regex pattern
        if SubStr(rulePattern, 1, 1) == "/" and SubStr(rulePattern, -1) == "/" {
            ; Remove the slashes and treat as regex
            pattern := SubStr(rulePattern, 2, StrLen(rulePattern) - 2)
            return RegExMatch(urls[1], pattern) or RegExMatch(urls[2], pattern)
        }
        ; Check for wildcard pattern
        if InStr(rulePattern, "*") {
            pattern := StrReplace(rulePattern, ".", "\.")
            pattern := StrReplace(pattern, "*", ".*")
            return RegExMatch(urls[1], "^" . pattern . "$") or RegExMatch(urls[2], "^" . pattern . "$")
        }
        ; Check for exact match
        if urls[1] == rulePattern or urls[2] == rulePattern {
            return true
        }
        ; Check for partial match
        ; Example:
        ; - "example.com" matches "www.example.com"
        ; - "www.example" matches "www.example.com.hk"
        ; - "example" matches "www.example.com"
        for url in urls {
            urlParts := StrSplit(url, ".")
            rulePatternParts := StrSplit(rulePattern, ".")
            if rulePatternParts.Length > urlParts.Length {
                return false
            }
            ruleMatchIndex := 1
            for i, part in urlParts {
                if part == rulePatternParts[ruleMatchIndex] {
                    ruleMatchIndex++
                }
                if ruleMatchIndex > rulePatternParts.Length {
                    return true
                }
            }
        }

        return false
    }

    /**
     * Get the domain of the base URL
     */
    GetDomain() {
        domain := ""
        if RegExMatch(base, "^[\w\.]+://.*") {
            domain := StrSplit(RegExReplace(base, "^[\w\.]+://"), "/", , 2)[1]
        } else {
            domain := StrSplit(base, "/", , 2)[1]
        }
        return domain
    }
}
