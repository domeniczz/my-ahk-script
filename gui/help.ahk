;; This file contains help window GUI functions.

helpWindow := DrawHelpWindow()

helpGuiVisible := false

#HotIf helpGuiVisible
Esc:: ToggleHelpWindow()
#HotIf

/**
 * Toggle the help window
 */
ToggleHelpWindow() {
    global helpGuiVisible

    window := helpWindow.gui
    lv := helpWindow.lv

    if !WinExist("ahk_id " . window.Hwnd) {
        ; Update colors before showing the window
        SetHelpWindowColors(window, lv)

        ; Show the help window
        window.Show("w" . A_ScreenWidth . " h" . A_ScreenHeight . " NoActivate")

        ; Set opacity (*/255), 255 is fully opaque
        WinSetTransparent(210, window)

        ; Hide the window after an interval (4 seconds)
        ; SetTimer () => window.Hide(), -4000, -1
        helpGuiVisible := true
    } else {
        window.Hide()
        ; Cancel the timer if manually hidden
        ; SetTimer () => window.Hide(), 0, -1
        helpGuiVisible := false
    }
}

/**
 * Draw the GUI of help window (displays all the keybindings in two columns)
 */
DrawHelpWindow() {
    helpGui := Gui()
    helpGui.Opt("-Caption +AlwaysOnTop +ToolWindow +E0x20")  ; +E0x20 means enable click-through

    ; Split keybindings into two columns
    columns := SplitKeybindings(keybindings)
    lLength := columns.left.Length
    rLength := columns.right.Length
    maxRows := Max(lLength, rLength)

    maxKeyValLength := 0
    for k, v in keybindings {
        if StrLen(v[1]) + StrLen(v[2]) > maxKeyValLength {
            maxKeyValLength := StrLen(v[1]) + StrLen(v[2])
        }
    }

    ; Calculate ListView dimensions and position
    lvWidth := Min(maxKeyValLength * 20 * 2, A_ScreenWidth * 0.5)
    lvHeight := Min(maxRows * 50, A_ScreenHeight * 0.6)
    lvX := (A_ScreenWidth - lvWidth) / 2
    lvY := (A_ScreenHeight - lvHeight) / 2

    ; Set font style size (pt) and bold
    fontSize := 16 - (3840 * 2160) / (A_ScreenWidth * A_ScreenHeight)
    helpGui.SetFont("s" . fontSize . " bold")

    ; Add ListView to display keybindings
    lv := helpGui.Add("ListView", Format("x{} y{} w{} h{} -E0x200 -Hdr -LV0x20 +LV0x4000 +ReadOnly -TabStop", lvX, lvY, lvWidth, lvHeight), ["Content"
    ])

    ; Add items to the ListView
    loop maxRows {
        leftItem := A_Index <= lLength ? columns.left[A_Index] : ""
        rightItem := A_Index <= rLength ? columns.right[A_Index] : ""

        leftContent := leftItem ? Format("{:-30s} {}", leftItem[1], leftItem[2]) : ""
        rightContent := rightItem ? Format("{:-30s} {}", rightItem[1], rightItem[2]) : ""

        content := Format("{:-80s}    {}", leftContent, rightContent)
        lv.Add("", content)
        ; Add an empty row after each row
        lv.Add("", "")
    }

    ; Set column width
    lv.ModifyCol(1, lvWidth)

    ; Set initial colors
    SetHelpWindowColors(helpGui, lv)

    return { gui: helpGui, lv: lv
    }
}

/**
 * Split keybindings into two balanced columns
 * 
 * @param {Array} keybindings - Array of keybinding pairs
 * 
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
        color := "ececec"
        helpGui.BackColor := color
        lv.Opt("+Background" . color)
        lv.SetFont("cBLACK")
    }
}
