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
        MsgBox "Failed to copy text to clipboard."
        return
    }
    ; Sleep for a while to ensure A_Clipboard works correctly
    sleep 50
    A_Clipboard := RTrim(Trim(A_Clipboard), "`n`r")

    ; Convert the text based on the specified mode
    switch Mode {
        case "L": A_Clipboard := StrLower(A_Clipboard)
        case "U": A_Clipboard := StrUpper(A_Clipboard)
        case "T": A_Clipboard := StrTitle(A_Clipboard)
        default: MsgBox "ERROR! Invalid mode for SwitchTextCase: " Mode
    }

    Send "^v"
    ; Sleep a while in case the paste operation hasn't completed before the clipboard is cleared
    sleep 100
    A_Clipboard := ""
}

/**
 * Get the selected text (if any), the text won't show up in the clipboard history.
 * 
 * @returns {String | Boolean} - The selected text or `false` if no text is selected.
 */
GetSelectedText() {
    ; Copy the text
    Send "^c"
    if !ClipWait(1) {
        MsgBox "Failed to copy text to clipboard."
        return
    }
    ; Sleep for a while to ensure A_Clipboard works correctly
    sleep 50
    selectText := A_Clipboard
    lastChar := SubStr(selectText, -1)
    ; If the last character is a newline, check if the selected text is one whole line, if yes, ignore it
    ; Because in IDEs, we can copy a whole line by just pressing `Ctrl + C` without selecting any text
    if Ord(lastChar) == 10 or Ord(lastChar) == 13 {
        count := 0
        loop parse, selectText {
            ; If the last character is a newline
            ; ASCii 10: Line Feed (LF)
            ; ASCii 13: Carriage Return (CR)
            if (Ord(A_LoopField) == 10 or Ord(A_LoopField) == 13) {
                count++
            }
            if count >= 2 {
                return false
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
 * @returns {Boolean} - `true` if the string contains a newline character, `false` otherwise.
 */
IsTextContainsNewline(str) {
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
        sleep 100
        ; Delete from system clipboard history
        A_Clipboard := ""
        return
    } else if action == "copy" {
        Send "{LCtrl Down}c{LCtrl Up}"
    } else if action == "cut" {
        Send "{LCtrl Down}x{LCtrl Up}"
    }
    if !ClipWait(1) {
        MsgBox "Failed to cut text to clipboard."
        return
    }
    sleep 50
    seperateClipboard := A_Clipboard
    ; Delete from system clipboard history
    A_Clipboard := ""
}

/**
 * Replicate the current line or lines downwards for a specified number of times.
 * 
 * @param {Boolean} userSpecify - Whether to ask the user for the number of lines to copy (default: `false`).
 */
ReplicateDown(userSpecify := false) {
    times := !userSpecify ? 1 : Integer(LetUserInputNumber("How many lines to copy:"))
    if times == 1 {
        if IsTextContainsNewline(GetSelectedText()) {
            Send "{Ctrl Down}c{Ctrl Up}{Right}{Enter}{Ctrl Down}v{Ctrl Up}"
        } else {
            Send "{Up}{End}{Shift Down}{Down}{End}{Shift Up}{Ctrl Down}c{Ctrl Up}{End}{Ctrl Down}v{Ctrl Up}"
        }
    } else if times > 1 {
        if IsTextContainsNewline(GetSelectedText()) {
            loop times {
                if A_Index == 1
                    Send "{Ctrl Down}c{Ctrl Up}{Right}{Enter}{Ctrl Down}v{Ctrl Up}"
                else
                    Send "{Enter}{Ctrl Down}v{Ctrl Up}"
                sleep 50
            }
        } else {
            loop times {
                if A_Index == 1
                    Send "{Up}{End}{Shift Down}{Down}{End}{Shift Up}{Ctrl Down}c{Ctrl Up}{End}{Ctrl Down}v{Ctrl Up}"
                else
                    Send "{Ctrl Down}v{Ctrl Up}"
                sleep 50
            }
        }
    }
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
        if (ExStyle & 0x8) {
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
    if (info) {
        infoText := "Window Title: " . info.title . "`n"
            . "ahk_id: " . info.id . "`n"
            . "ahk_class: " . info.class . "`n"
            . "ahk_exe: " . info.exe
        MsgBox(infoText, "Topmost Window Info")
    } else {
        MsgBox("No suitable window found.", "Topmost Window Info")
    }
}

/**
 * Activate the topmost visible window
 */
ActivateTopmostWindow() {
    info := GetTopmostWindowInfo()
    if (info) {
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
    ;     if (DriveGetType(drivePath) == "Removable") {
    ;         hVolume := DllCall("CreateFile", "Str", "\\.\" . drivePath, "UInt", 0x80000000 | 0x40000000,
    ;             "UInt", 0x1 | 0x2, "Ptr", 0, "UInt", 3, "UInt", 0, "Ptr", 0, "Ptr")

    ;         if (hVolume != -1) {
    ;             result := DllCall("DeviceIoControl", "Ptr", hVolume, "UInt", 0x2D4808,
    ;                 "Ptr", 0, "UInt", 0, "Ptr", 0, "UInt", 0, "Ptr", 0, "Ptr", 0)
    ;             DllCall("CloseHandle", "Ptr", hVolume)

    ;             if (result)
    ;                 MsgBox("Successfully ejected drive " . drivePath)
    ;             else
    ;                 MsgBox("Failed to eject drive " . drivePath, "Error", 16)
    ;         } else {
    ;             MsgBox("Failed to open drive " . drivePath, "Error", 16)
    ;         }
    ;     }
    ; }
}
