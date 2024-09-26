;; This file contains utility functions.

;;;;;;;;;; UTILITY FUNCTIONS ;;;;;;;;;;

/**
 * Activate (focus) app window.
 * Displays an error message box if the window is not found after all attempts.
 * 
 * @param target - The window identifier (e.g., "ahk_exe explorer.exe")
 * @param {Integer} waitDuration - Total seconds to wait for finding the target window (default: 10)
 * @param {Integer} sleepDuration - Total miliseconds to sleep before activating the window (default: 0)
 * @returns {Boolean} - True if the window is found and activated, false otherwise
 */
ActivateWindow(target, waitDuration := 10, sleepDuration := 0) {
    if WinWait(target, , waitDuration) {
        if sleepDuration > 0 {
            Sleep sleepDuration
        }
        WinActivate
        return true
    } else {
        MsgBox 'ERROR Activating! The "' . target . '" window could not be found!'
        return false
    }
}

/**
 * Close app window.
 * Displays an error message box if the window is not found after all attempts.
 * 
 * @param target - The window identifier (e.g., "ahk_exe explorer.exe")
 * @param {Integer} waitDuration - Total seconds to wait for finding the target window (default: 10)
 * @param {Integer} sleepDuration - Total miliseconds to before closing the window (default: 0)
 * @returns {Boolean} - True if the window is found and closed, false otherwise
 */
CloseWindow(target, waitDuration := 10, sleepDuration := 0) {
    if WinWait(target, , waitDuration) {
        if sleepDuration > 0 {
            Sleep sleepDuration
        }
        WinClose
        return true
    } else {
        MsgBox 'ERROR Closing! The "' . target . '" window could not be found!'
        return false
    }
}

/**
 * Maximize (focus) app window.
 * Displays an error message box if the window is not found after all attempts.
 * 
 * @param target - The window identifier (e.g., "ahk_exe explorer.exe")
 * @param {Integer} waitDuration - Total seconds to wait for finding the target window (default: 10)
 * @param {Integer} sleepDuration - Total miliseconds to sleep before maximizing the window (default: 0)
 * @returns {Boolean} - True if the window is found and maximized, false otherwise
 */
MaximizeWindow(target, waitDuration := 10, sleepDuration := 0) {
    if WinWait(target, , waitDuration) {
        if sleepDuration > 0 {
            Sleep sleepDuration
        }
        WinMaximize
        return true
    } else {
        MsgBox 'ERROR Maximizing! The "' . target . '" window could not be found!'
        return false
    }
}

/**
 * Minimize (hide) app window.
 * Displays an error message box if the window is not found after all attempts.
 * 
 * @param target - The window identifier (e.g., "ahk_exe explorer.exe")
 * @param {Integer} waitDuration - Total seconds to wait for finding the target window (default: 10)
 * @param {Integer} sleepDuration - Total miliseconds to sleep before minimizing the window (default: 0)
 * @returns {Boolean} - True if the window is found and minimized, false otherwise
 */
MinimizeWindow(target, waitDuration := 10, sleepDuration := 0) {
    if WinWait(target, , waitDuration) {
        if sleepDuration > 0 {
            Sleep sleepDuration
        }
        WinMinimize
        return true
    } else {
        MsgBox 'ERROR Minimizing! The "' . target . '" window could not be found!'
        return false
    }
}

/**
 * Activate (focus) app window and maximize it.
 * Displays an error message box if the window is not found after all attempts.
 * 
 * @param target - The window identifier (e.g., "ahk_exe explorer.exe")
 * @param {Integer} waitDuration - Total seconds to wait for finding the target window (default: 10)
 * @param {Integer} sleepDuration - Total miliseconds to sleep before activating the window (default: 0)
 * @returns {Boolean} - True if the window is found and maximized, false otherwise
 */
ActivateAndMaximizeWindow(target, waitDuration := 10, sleepDuration := 0) {
    if WinWait(target, , waitDuration) {
        WinActivate
        if sleepDuration > 0 {
            Sleep sleepDuration
        }
        WinMaximize
        return true
    } else {
        MsgBox 'ERROR Activating! The "' . target . '" window could not be found!'
        return false
    }
}

/**
 * Activate (focus) app window and click.
 * Displays an error message box if the window is not found after all attempts.
 * 
 * @param target - The window identifier (e.g., "ahk_exe explorer.exe")
 * @param {Integer} waitDuration - Total seconds to wait (default: 10)
 * @param {String} ClickType - The type of click (default: left click)
 * @param {Integer} ClickX - The X coordinate of the click (default: 0)
 * @param {Integer} ClickY - The Y coordinate of the click (default: 0)
 * @param {String} ClickInfo - The tooltip message to display after the click (default: "")
 * @returns {Boolean} - True if the window is found and clicked, false otherwise
 */
ActivateWindowAndClick(target, waitDuration := 10, ClickType := "left", ClickX := 0, ClickY := 0, ClickInfo := "") {
    if WinWait(target, , waitDuration) {
        WinActivate
        MouseClick ClickType, ClickX, ClickY
        ToolTip ClickInfo
        SetTimer () => ToolTip(), -1000, -1
        return true
    } else {
        MsgBox 'ERROR ' . ClickType . ' Click (' . ClickX . ', ' . ClickY . ')! The "' . target .
            '" window could not be found!'
        return false
    }
}

/**
 * Set app window position and size.
 * Displays an error message box if the window is not found after all attempts.
 * 
 * @param target - The window identifier (e.g., "ahk_exe explorer.exe")
 * @param {Number} x - The x-coordinate of the window (optional)
 * @param {Number} y - The y-coordinate of the window (optional)
 * @param {Number} width - The width of the window (optional)
 * @param {Number} height - The height of the window (optional)
 * @param {Integer} waitDuration - Total seconds to wait for finding the target window (default: 10)
 * @param {Integer} sleepDuration - Total milliseconds to sleep before setting the window position and size (default: 0)
 * @returns {Boolean} - True if the window is found and its position and size are set, false otherwise
 */
SetWindow(target, x := -1, y := -1, width := -1, height := -1, waitDuration := 10, sleepDuration := 0) {
    if WinWait(target, , waitDuration) {
        if sleepDuration > 0 {
            Sleep sleepDuration
        }
        ; Move and resize the window only if needed
        ; Use provided values or current values if not provided
        if x != -1 or y != -1 or width != -1 or height != -1 {
            ; Get current window position and size
            WinGetPos &currentX, &currentY, &currentWidth, &currentHeight
            if x == currentX and y == currentY and width == currentWidth and height == currentHeight {
                return  ; No need to change the window position and size
            }
            WinMove(
                x != -1 ? x : currentX,
                y != -1 ? y : currentY,
                width != -1 ? width : currentWidth,
                height != -1 ? height : currentHeight,
                target
            )
        }
        return true
    } else {
        MsgBox('ERROR Setting Window! The "' . target . '" window could not be found!')
        return false
    }
}

/**
 * List (Map) of applications to exclude when searching topmost window
 * 
 * Key:
 * 
 * - application executable name (String)
 * 
 * Value:
 * 
 * - `true` if the application should be excluded, `false` otherwise
 */
excludedWindowList := [
    "StartMenuExperienceHost.exe",
    "Lyricify for Spotify.exe",
    "AutoHotkey64.exe"
]

/**
 * Retrieves information of the topmost visible window: title, ahk_id, ahk_class, ahk_exe
 * Returns false if no suitable window is found.
 * 
 * @returns {Object | Boolean} - The information of the topmost visible window or false if no suitable window is found
 * @example
 * {
 *     title: "Mozilla Firefox",
 *     id: "ahk_id 394026",
 *     class: "ahk_class MozillaWindowClass",
 *     exe: "ahk_exe firefox.exe"
 * }
 */
GetTopmostWindowInfo() {
    try {
        windowList := WinGetList()

        ; Iterate through all windows
        for window in windowList {
            ; Skip if window doesn't exist
            if !WinExist(window)
                continue

            winExe := WinGetProcessName(window)
            winClass := WinGetClass(window)

            ; Skip explorer.exe windows except File Explorer
            if winExe = "explorer.exe" && winClass != "CabinetWClass" {
                continue
            }
            ; Skip excluded windows in the list
            if excludedWindowList.HasValue(winExe) {
                continue
            }

            winTitle := WinGetTitle(window)
            winId := WinGetID(window)

            ; Check if the window is minimized
            minMax := WinGetMinMax(window)
            if minMax == -1  ; -1 means minimized
                continue

            ; Return the information
            return {
                title: winTitle,
                id: Format("ahk_id {}", winId),
                class: Format("ahk_class {}", winClass),
                exe: Format("ahk_exe {}", winExe)
            }
        }

        ; No suitable window found
        return false
    } catch as err {
        MsgBox("ERROR when get topmost window info: " . err.Message)
        return false
    }
}
