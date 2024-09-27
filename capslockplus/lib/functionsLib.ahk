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
    A_Clipboard := RTrim(Trim(A_Clipboard), "`n`r")

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
 * @returns {String | Boolean} - The selected text or empty ("") if no text is selected.
 */
GetSelectedText() {
    A_Clipboard := ""
    ; Copy the text
    Send "{LCtrl Down}c{LCtrl Up}"
    ; Sleep for a while to ensure A_Clipboard works correctly
    Sleep 50
    selectText := A_Clipboard
    if selectText == ""
        return ""
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
    ; Delete from system clipboard history
    A_Clipboard := ""
    return selectText
}

/**
 * Check if a string contains a newline character.
 * 
 * @param {String} str - The string to check.
 * @param {Boolean} omitLeadingNewline - Whether to ignore leading newline characters.
 * @param {Boolean} omitTrailingNewline - Whether to ignore trailing newline characters.
 * @returns {Boolean} - `true` if the string contains a newline character, `false` otherwise.
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
 * Action on a separate clipboard that doesn't interfere with the system clipboard.
 * 
 * @param {String} action - Clipboard action
 * 
 * - `copy`: Copy the selected text
 * - `cut`: Cut the selected text
 * - `paste`: Paste the copied text
 */
SeparateClipboard(action := "copy") {
    global seperateClipboard

    if action == "paste" {
        A_Clipboard := seperateClipboard
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
    seperateClipboard := A_Clipboard
    ; Delete from system clipboard history
    A_Clipboard := ""
}

lastReplicateDownActionTime := 0

/**
 * Replicate the current line or lines downwards for a specified number of times.
 * 
 * If the last replicate down action is within 2 seconds, simply paste the copied text, no need to execute the complete logic again; otherwise, execute the complete logic.
 * 
 * @param {Boolean} userSpecify - Whether to ask the user for the number of lines to copy (default: `false`).
 */
ReplicateDown(userSpecify := false) {
    global lastReplicateDownActionTime

    ; If the last replicate down action is within 2 seconds, simply paste the copied text, no need to execute the complete logic again
    if A_TickCount - lastReplicateDownActionTime < 2000 {
        if IsTextContainsNewline(A_Clipboard, true) {
            Send "{Enter}{Ctrl Down}v{Ctrl Up}"
        } else {
            Send "{Ctrl Down}v{Ctrl Up}"
        }
    }
    ; If the last replicate down action is not within 2 seconds, execute the complete logic
    else {
        times := !userSpecify ? 1 : Integer(LetUserInputNumber("How many lines to copy:"))
        selectedText := GetSelectedText()
        if times == 1 {
            if IsTextContainsNewline(selectedText) {
                Send "{Ctrl Down}c{Ctrl Up}{Right}{Enter}{Ctrl Down}v{Ctrl Up}"
            } else {
                if selectedText == ""
                    Send "{Up}{End}{Shift Down}{Down}{End}{Shift Up}{Ctrl Down}c{Ctrl Up}{Right}{Ctrl Down}v{Ctrl Up}"
                else
                    Send "{Ctrl Down}c{Ctrl Up}{Right}{Enter}{Ctrl Down}v{Ctrl Up}"
            }
        } else if times > 1 {
            if IsTextContainsNewline(selectedText) {
                loop times {
                    if A_Index == 1
                        Send "{Ctrl Down}c{Ctrl Up}{Right}{Enter}{Ctrl Down}v{Ctrl Up}"
                    else
                        Send "{Enter}{Ctrl Down}v{Ctrl Up}"
                    Sleep 50
                }
            } else {
                if selectedText == "" {
                    loop times {
                        if A_Index == 1
                            Send "{Up}{End}{Shift Down}{Down}{End}{Shift Up}{Ctrl Down}c{Ctrl Up}{Right}{Ctrl Down}v{Ctrl Up}"
                        else
                            Send "{Ctrl Down}v{Ctrl Up}"
                        Sleep 50
                    }
                } else {
                    loop times {
                        if A_Index == 1
                            Send "{Ctrl Down}c{Ctrl Up}{Right}{Enter}{Ctrl Down}v{Ctrl Up}"
                        else
                            Send "{Enter}{Ctrl Down}v{Ctrl Up}"
                        Sleep 50
                    }
                }
            }
        } else if times < 0 {
            MsgBox "ERROR! Invalid number of times to replicate: " . times, , "T2"
        }
    }

    ; Update the last replicate down action time
    lastReplicateDownActionTime := A_TickCount
}

/**
 * Toggle the Always On Top for the currently active window
 */
SetWindowAlwaysOnTop() {
    if ProcessExist("PowerToys.AlwaysOnTop.exe") {
        ; Uses AlwaysOnTop in Powertoys
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
            ; Turn OFF and remove Title_When_On_Top
            WinSetAlwaysOnTop 0, winTitle
            WinSetTitle (RegExReplace(winTitle, Title_When_On_Top)), winTitle
        } else {
            ; Turn ON and add Title_When_On_Top
            WinSetAlwaysOnTop 1, winTitle
            WinSetTitle Title_When_On_Top winTitle, winTitle
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
 * Activate the topmost visible window
 */
ActivateTopmostWindow() {
    info := GetTopmostWindowInfo()
    if info {
        ActivateWindow(info.id)
    }
}

/**
 * Eject all removable drives
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
 * Reload the script with admin privileges
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
 * @returns {Object | Boolean} - The information of the topmost visible window or false if no suitable window is found
 * @example
 * {
 *     title: "Mozilla Firefox",
 *     id: "ahk_id 394026",
 *     class: "ahk_class MozillaWindowClass",
 *     exe: "ahk_exe firefox.exe"
 * }
 */
GetTopmostWindowInfo() {
    try {
        windowList := WinGetList()

        ; Iterate through all windows
        for window in windowList {
            ; Skip if window doesn't exist
            if !WinExist(window)
                continue

            winExe := WinGetProcessName(window)
            winClass := WinGetClass(window)

            ; Skip explorer.exe windows except File Explorer
            if winExe = "explorer.exe" && winClass != "CabinetWClass" {
                continue
            }
            ; Skip excluded windows in the list
            if HasVal(excludedWindowList, winExe) {
                continue
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
                id: Format("ahk_id {}", winId),
                class: Format("ahk_class {}", winClass),
                exe: Format("ahk_exe {}", winExe)
            }
        }

        ; No suitable window found
        return false
    } catch as err {
        MsgBox "ERROR when get topmost window info: " . err.Message, , "T2"
        throw
    }
}
