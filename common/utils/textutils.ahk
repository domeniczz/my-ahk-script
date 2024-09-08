/*
Send given text
*/
SendText(text) {
    A_Clipboard := text
    Send "^v"

    ; Wait a bit to ensure the paste operation is complete
    Sleep 50

    ; Clear the clipboard item (the sent text)
    A_Clipboard := ""
}
