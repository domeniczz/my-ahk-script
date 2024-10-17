/**
 * Send given text.
 * 
 * @param {String} text - The text to print
 */
SendText(text) {
    A_Clipboard := text
    Send "^v"

    ; Clear the most recent clipboard item (the sent text) after paste operation is complete
    if PasteWait() {
        A_Clipboard := ""
    }
}

/**
 * Wait for the paste operation to complete.
 * 
 * @param {Integer} timeout - The maximum time to wait (default: 1000ms)
 * @returns {Integer} - `true` if the paste operation is complete, `false` otherwise.
 */
PasteWait(timeout := 1000) {
    startTime := A_TickCount
    while A_TickCount - startTime < timeout {
        ; use GetOpenClipboardWindow to check if any window currently has the clipboard open
        if !DllCall("GetOpenClipboardWindow", "Ptr") {
            Sleep 200
            return true
        }
        Sleep 10
    }
    return false
}
