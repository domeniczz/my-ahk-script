/**
 * Send given text.
 * 
 * @param {String} text - The text to print
 */
SendText(text) {
    A_Clipboard := text
    Send "^v"

    ; Sleep a while in case the paste operation hasn't completed before the clipboard is cleared
    Sleep 100

    ; Clear the clipboard item (the sent text)
    A_Clipboard := ""
}
