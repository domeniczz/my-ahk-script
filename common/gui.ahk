;; This file contains gui functions.

;;;;;;;;;; GUI WINDOW ;;;;;;;;;;

helpWindow := DrawHelpGUI()

;;;;;;;;;; GUI FUNCTIONS ;;;;;;;;;;

; Draw the GUI of help window (displays all the keybindings)
DrawHelpGUI() {
    helpGui := Gui()
    helpGui.Opt("+AlwaysOnTop -Caption")

    ; Set font style (17pt, bold)
    helpGui.SetFont("s17 bold")

    ; Calculate ListView dimensions and position
    windowWidth := A_ScreenWidth
    windowHeight := A_ScreenHeight
    lvWidth := 1000  ; Adjust this value to change the width of the centered ListView
    lvHeight := 1100
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

;; Set the colors of the help window based on the Windows color mode
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
