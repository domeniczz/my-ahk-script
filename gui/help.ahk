;; This file contains help window GUI functions.

helpWindow := DrawHelpGUI()

/*
Toggle the help window
*/
ToggleHelpWindow() {
    window := helpWindow.gui
    lv := helpWindow.lv

    if !WinExist("ahk_id " . window.Hwnd) {
        ; Update colors before showing the window
        SetHelpWindowColors(window, lv)

        ; Show the help window
        window.Show("w" . A_ScreenWidth . " h" . A_ScreenHeight)

        ; Set opacity (200/255)
        WinSetTransparent(200, window)

        ; Hide the window after an interval (4 seconds)
        ; SetTimer () => window.Hide(), -4000, -1
    } else {
        window.Hide()
        ; Cancel the timer if manually hidden
        ; SetTimer () => window.Hide(), 0, -1
    }
}

/*
Draw the GUI of help window (displays all the keybindings)
*/
DrawHelpGUI() {
    helpGui := Gui()
    helpGui.Opt("+AlwaysOnTop -Caption")

    ; Set font style size (pt) and bold
    helpGui.SetFont("s16 bold")

    ; Calculate ListView dimensions and position
    windowWidth := A_ScreenWidth
    windowHeight := A_ScreenHeight
    lvWidth := 1000  ; Adjust this value to change the width of the centered ListView
    lvHeight := 1200
    lvX := (windowWidth - lvWidth) / 2
    lvY := (windowHeight - lvHeight) / 2

    ; Add ListView to display keybindings
    lv := helpGui.Add("ListView", Format("x{} y{} w{} h{} -E0x200 -Hdr -LV0x20 +LV0x4000 +ReadOnly -TabStop", lvX, lvY,
        lvWidth, lvHeight), ["Hotkey", "Feature"
        ])

    for binding in keybindings {
        lv.Add(, binding*)
        lv.Add(, "", "")  ; Add an empty row after each binding
    }

    ; Set column widths and center alignment
    lv.ModifyCol(1, lvWidth * 0.4)  ; 40% of ListView width
    lv.ModifyCol(2, lvWidth * 0.6)  ; 60% of ListView width
    ; lv.ModifyCol(1, "Center")
    ; lv.ModifyCol(2, "Center")

    ; Set initial colors
    SetHelpWindowColors(helpGui, lv)

    ; Add Esc hotkey to close the window
    helpGui.OnEvent("Escape", (*) => helpGui.Hide())

    return { gui: helpGui, lv: lv
    }
}

/*
Set the background colors of the help window based on the Windows color mode
*/
SetHelpWindowColors(helpGui, lv) {
    colorMode := GetWinColorMode()
    if (colorMode == "Dark") {
        color := "4c4a48"
        helpGui.BackColor := color
        ; helpGui.SetFont("c" . "ffffff")
        lv.Opt("+Background" . color)
        lv.SetFont("cWHITE")
    } else {
        ; color := "c6ecff"
        color := "ffffff"
        helpGui.BackColor := color
        ; helpGui.SetFont("c" . "000000")
        lv.Opt("+Background" . color)
        lv.SetFont("cBLACK")
    }
}
