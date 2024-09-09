/**
 * Changes the case of selected text.
 * 
 * @param {String} Mode - The type of case conversion to perform.
 * 
 * - "L": Convert to lowercase
 * - "U": Convert to uppercase
 * - "T": Convert to titlecase (capitalize the first letter of each word)
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
        case "L":
            A_Clipboard := StrLower(A_Clipboard)
        case "U":
            A_Clipboard := StrUpper(A_Clipboard)
        case "T":
            A_Clipboard := StrTitle(A_Clipboard)
        default:
            MsgBox "ERROR! Invalid mode for SwitchTextCase: " Mode
    }

    ; Paste the coverted text, and clear the clipboard
    Send "^v"
    sleep 50
    A_Clipboard := ""
}

/**
 * Toggle the Always On Top for the currently active window
 */
SetWindowAlwaysOnTop() {
    ; Uses AlwaysOnTop in Powertoys
    Send "{LCtrl Down}{LWin Down}t{LCtrl Up}{LWin Up}"

    ;; Below is the custom method

    ; ; change title "! " as required
    ; Title_When_On_Top := "! "
    ; winTitle := WinGetTitle("A")
    ; ExStyle := WinGetExStyle(winTitle)
    ; ; 0x8 is WS_EX_TOPMOST
    ; if (ExStyle & 0x8) {
    ;     ; Turn OFF and remove Title_When_On_Top
    ;     WinSetAlwaysOnTop 0, winTitle
    ;     WinSetTitle (RegExReplace(winTitle, Title_When_On_Top)), winTitle
    ; } else {
    ;     ; Turn ON and add Title_When_On_Top
    ;     WinSetAlwaysOnTop 1, winTitle
    ;     WinSetTitle Title_When_On_Top winTitle, winTitle
    ; }
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
