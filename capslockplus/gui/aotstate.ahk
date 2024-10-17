/**
 * Draws the window Always On Top (AOT) state GUI.
 * @returns {Gui} The GUI object.
 */
DrawAOTStateGui() {
    aotStateGui := Gui()

    ; Set GUI options:
    ; +AlwaysOnTop: Keep the GUI on top of other windows
    ; -Caption: Remove the title bar
    ; +ToolWindow: Make it a tool window (thinner border, no taskbar entry)
    ; +E0x20: Make the window click-through
    aotStateGui.Opt("+AlwaysOnTop -Caption +ToolWindow +E0x20")
    ; Set the background color to the Windows accent color
    aotStateGui.BackColor := GetWindowsAccentColor()
    ; Display the aot state
    aotStateGui.Add("Text", "Center vAOTStateText", "AOT ON")
    ; Margin from the screen edge
    margin := 0
    xPos := margin
    yPos := margin
    ; Set opacity (*/255), 255 is fully opaque
    WinSetTransparent(160, aotStateGui)
    ; Show the GUI in the top-Right corner
    aotStateGui.Show(Format("x{} y{} NoActivate", xPos, yPos))
    ; Initially hide the GUI
    aotStateGui.Hide()

    return aotStateGui
}
