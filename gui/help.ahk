;; This file contains help window GUI functions.

helpWindow := DrawHelpWindow()

/**
 * Toggle the help window
 */
ToggleHelpWindow() {
    window := helpWindow.gui
    lv := helpWindow.lv

    if !WinExist("ahk_id " . window.Hwnd) {
        ; Update colors before showing the window
        SetHelpWindowColors(window, lv)

        ; Show the help window
        window.Show("w" . A_ScreenWidth . " h" . A_ScreenHeight)

        ; Set opacity (*/255), 255 is fully opaque
        WinSetTransparent(210, window)

        ; Hide the window after an interval (4 seconds)
        ; SetTimer () => window.Hide(), -4000, -1
    } else {
        window.Hide()
        ; Cancel the timer if manually hidden
        ; SetTimer () => window.Hide(), 0, -1
    }
}

/**
 * Draw the GUI of help window (displays all the keybindings in two columns)
 */
DrawHelpWindow() {
    helpGui := Gui()
    helpGui.Opt("-Caption +AlwaysOnTop +ToolWindow +E0x20")  ; +E0x20 means enable click-through

    ; Set font style size (pt) and bold
    helpGui.SetFont("s16 bold")

    windowWidth := A_ScreenWidth
    windowHeight := A_ScreenHeight
    ; Calculate ListView dimensions and position
    lvWidth := windowWidth * 0.5
    lvHeight := windowHeight * 0.4
    lvX := (windowWidth - lvWidth) / 2
    lvY := (windowHeight - lvHeight) / 2

    ; Add ListView to display keybindings
    lv := helpGui.Add("ListView", Format("x{} y{} w{} h{} -E0x200 -Hdr -LV0x20 +LV0x4000 +ReadOnly -TabStop", lvX, lvY, lvWidth, lvHeight), ["Content"
    ])

    ; Split keybindings into two columns
    columns := SplitKeybindings(keybindings)

    ; Add items to the ListView
    lLength := columns.left.Length
    rLength := columns.right.Length
    maxRows := Max(lLength, rLength)
    loop maxRows {
        leftItem := A_Index <= lLength ? columns.left[A_Index] : ""
        rightItem := A_Index <= rLength ? columns.right[A_Index] : ""

        leftContent := leftItem ? Format("{:-40s} {}", leftItem[1], leftItem[2]) : ""
        rightContent := rightItem ? Format("{:-40s} {}", rightItem[1], rightItem[2]) : ""

        content := Format("{:-90s}    {}", leftContent, rightContent)
        lv.Add("", content)
        ; Add an empty row after each row
        lv.Add("", "")
    }

    ; Set column width
    lv.ModifyCol(1, lvWidth)

    ; Set initial colors
    SetHelpWindowColors(helpGui, lv)

    ; Add Esc hotkey to close the window
    helpGui.OnEvent("Escape", (*) => helpGui.Hide())

    return { gui: helpGui, lv: lv
    }
}

/**
 * Split keybindings into two balanced columns
 * @param {Array} keybindings - Array of keybinding pairs
 * @returns {Object} - Object with left and right column arrays
 */
SplitKeybindings(keybindings) {
    totalItems := keybindings.Length
    itemsPerColumn := Ceil(totalItems / 2)

    leftColumn := []
    rightColumn := []

    for index, binding in keybindings {
        if index <= itemsPerColumn {
            leftColumn.Push(binding)
        } else {
            rightColumn.Push(binding)
        }
    }

    return { left: leftColumn, right: rightColumn
    }
}

/**
 * Set the background colors of the help window based on the Windows color mode
 * 
 * @param helpGui - help window GUI object
 * @param lv - ListView object
 */
SetHelpWindowColors(helpGui, lv) {
    colorMode := GetWindowsColorMode()
    if colorMode == "Dark" {
        color := "4c4a48"
        helpGui.BackColor := color
        lv.Opt("+Background" . color)
        lv.SetFont("cWHITE")
    } else {
        color := "ffffff"
        helpGui.BackColor := color
        lv.Opt("+Background" . color)
        lv.SetFont("cBLACK")
    }
}
