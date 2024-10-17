/**
 * Draws the CapsLock activation state GUI.
 * @returns {Gui} The GUI object.
 */
DrawCapsLockStateGui() {
    CapsLockStateGui := Gui()

    ; Set GUI options:
    ; +AlwaysOnTop: Keep the GUI on top of other windows
    ; -Caption: Remove the title bar
    ; +ToolWindow: Make it a tool window (thinner border, no taskbar entry)
    ; +E0x20: Make the window click-through
    CapsLockStateGui.Opt("+AlwaysOnTop -Caption +ToolWindow +E0x20")
    ; Set the background color to the Windows accent color
    CapsLockStateGui.BackColor := GetWindowsAccentColor()
    ; Add a text control to display "CAPS"
    CapsLockStateGui.Add("Text", "Center", "CAPS")
    ; Margin from the screen edge
    margin := 0
    xPos := margin
    yPos := margin
    ; Set opacity (*/255), 255 is fully opaque
    WinSetTransparent(160, CapsLockStateGui)
    ; Show the GUI in the top-left corner
    CapsLockStateGui.Show(Format("x{} y{} NoActivate", xPos, yPos))
    ; Initially hide the GUI
    CapsLockStateGui.Hide()

    return CapsLockStateGui
}
