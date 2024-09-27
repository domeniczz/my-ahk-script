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
    try {
        if WinWait(target, , waitDuration) {
            if sleepDuration > 0 {
                Sleep sleepDuration
            }
            WinActivate
            return true
        }
    } catch as err {
        MsgBox 'ERROR Activating! The "' . target . '" window could not be found!', , "T2"
        throw
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
    try {
        if WinWait(target, , waitDuration) {
            if sleepDuration > 0 {
                Sleep sleepDuration
            }
            WinClose
            return true
        }
    } catch as err {
        MsgBox 'ERROR Closing! The "' . target . '" window could not be found!', , "T2"
        throw
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
    try {
        if WinWait(target, , waitDuration) {
            if sleepDuration > 0 {
                Sleep sleepDuration
            }
            WinMaximize
            return true
        }
    } catch as err {
        MsgBox 'ERROR Maximizing! The "' . target . '" window could not be found!', , "T2"
        throw
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
    try {
        if WinWait(target, , waitDuration) {
            if sleepDuration > 0 {
                Sleep sleepDuration
            }
            WinMinimize
            return true
        }
    } catch as err {
        MsgBox 'ERROR Minimizing! The "' . target . '" window could not be found!', , "T2"
        throw
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
    try {
        if WinWait(target, , waitDuration) {
            WinActivate
            if sleepDuration > 0 {
                Sleep sleepDuration
            }
            WinMaximize
            return true
        }
    } catch as err {
        MsgBox 'ERROR Activating and Maximizing! The "' . target . '" window could not be found!', , "T2"
        throw
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
    try {
        if WinWait(target, , waitDuration) {
            WinActivate
            MouseClick ClickType, ClickX, ClickY
            ToolTip ClickInfo
            SetTimer () => ToolTip(), -1000, -1
            return true
        }
    } catch as err {
        MsgBox 'ERROR ' . ClickType . ' Click (' . ClickX . ', ' . ClickY . ')! The "' . target . '" window could not be found!', , "T2"
        throw
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
    try {
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
        }
    } catch as err {
        MsgBox 'ERROR Setting Window! The "' . target . '" window could not be found!', , "T2"
        throw
    }
}
