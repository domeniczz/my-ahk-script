/**
 * Let user input a number in the GUI.
 * 
 * @param {String} prompt - The prompt message to display in the GUI.
 * @returns {Number} - The inputted number or 0 if no input is provided.
 */
LetUserInputNumber(prompt := "Input a number here:") {
    while true {
        value := LetUserInput(prompt)
        ; If the user cancels the input, return 0
        if value == "" {
            return 0
        }
        ; If the input is a number, return it
        if IsNumber(value) {
            return value
        }
        ; Otherwise, show an error message and continue the loop to ask for input again
        MsgBox "Invalid input. Please input a number.", , "T2"
        continue
    }
}

/**
 * Let user input a string in the GUI.
 * 
 * @param {String} prompt - The prompt message to display in the GUI.
 * @returns {String} - The inputted value or "" if no input is provided.
 */
LetUserInputString(prompt := "Input a string here:") {
    return LetUserInput(prompt)
}

/**
 * Let user input in the GUI.
 * 
 * @param {String} prompt - The prompt message to display in the GUI.
 * @returns {String} - The inputted value or "" if no input is provided.
 */
LetUserInput(prompt := "Input here:") {
    try {
        value := ""

        inputGui := Gui("-Caption +AlwaysOnTop +ToolWindow")
        inputGui.Title := "Input Lines to Copy"
        inputGui.Add("Text", "x10 y10", prompt)
        inputBox := inputGui.Add("Edit", "x10 y30 w200 vUserInput")

        ; Set up a hotkey for `Enter` that only works when the GUI is active
        HotIfWinActive("ahk_id " . inputGui.Hwnd)
        Hotkey("Enter", ProcessInput)

        inputGui.OnEvent("Escape", (*) => CloseGui())
        inputGui.OnEvent("Close", (*) => CloseGui())

        if WinExist("ahk_id " . inputGui.Hwnd) {
            CloseGui()
        } else {
            inputBox.Value := ""
            inputGui.Show()
            inputBox.Focus()
            SetTimer CheckFocus, 100, 100
        }

        WinWaitClose(inputGui)

        return value
    }

    ProcessInput(*) {
        if inputBox.Value != "" {
            value := inputBox.Value
            CloseGui()
        } else {
            CloseGui()
        }
    }

    CheckFocus() {
        if !WinActive("ahk_id " . inputGui.Hwnd) {
            CloseGui()
        }
    }

    CloseGui() {
        HotIfWinActive("ahk_id " . inputGui.Hwnd)
        Hotkey("Enter", "Off")
        inputGui.Hide()
        SetTimer CheckFocus, 0, 100
    }
}
