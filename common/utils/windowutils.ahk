;; This file contains utility functions.

;;;;;;;;;; UTILITY FUNCTIONS ;;;;;;;;;;

/**
 * Activate (focus) app window.
 * Displays an error message box if the window is not found after all attempts.
 * 
 * @param target - The window identifier (e.g., "ahk_exe explorer.exe")
 * @param {Integer} waitDuration - Total seconds to wait for finding the target window (default: 10)
 * @param {Integer} sleepDuration - Total miliseconds to sleep before activating the window (default: 0)
 * 
 * @returns {Boolean} - True if the window is found and activated, false otherwise
 * 
 * @throws {Error} - If encounter errors when activating the window
 */
ActivateWindow(target, waitDuration := 10, sleepDuration := 0) {
    try {
        if WinWait(target, , waitDuration) {
            if sleepDuration > 0 {
                Sleep sleepDuration
            }
            WinActivate
            return true
        } else {
            throw Error('The "' . target . '" window could not be found !')
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
 * 
 * @returns {Boolean} - True if the window is found and closed, false otherwise
 * 
 * @throws {Error} - If encounter errors when closing the window
 */
CloseWindow(target, waitDuration := 10, sleepDuration := 0) {
    try {
        if WinWait(target, , waitDuration) {
            if sleepDuration > 0 {
                Sleep sleepDuration
            }
            WinClose
            return true
        } else {
            throw Error('The "' . target . '" window could not be found !')
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
 * 
 * @returns {Boolean} - True if the window is found and maximized, false otherwise
 * 
 * @throws {Error} - If encounter errors when maximizing the window
 */
MaximizeWindow(target, waitDuration := 10, sleepDuration := 0) {
    try {
        if WinWait(target, , waitDuration) {
            if sleepDuration > 0 {
                Sleep sleepDuration
            }
            WinMaximize
            return true
        } else {
            throw Error('The "' . target . '" window could not be found !')
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
 * 
 * @returns {Boolean} - True if the window is found and minimized, false otherwise
 * 
 * @throws {Error} - If encounter errors when minimizing the window
 */
MinimizeWindow(target, waitDuration := 10, sleepDuration := 0) {
    try {
        if WinWait(target, , waitDuration) {
            if sleepDuration > 0 {
                Sleep sleepDuration
            }
            WinMinimize
            return true
        } else {
            throw Error('The "' . target . '" window could not be found !')
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
 * 
 * @returns {Boolean} - True if the window is found and maximized, false otherwise
 * 
 * @throws {Error} - If encounter errors when activating and maximizing the window
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
        } else {
            throw Error('The "' . target . '" window could not be found !')
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
 * 
 * @returns {Boolean} - True if the window is found and clicked, false otherwise
 * 
 * @throws {Error} - If encounter errors when activating and clicking the window
 */
ActivateWindowAndClick(target, waitDuration := 10, ClickType := "left", ClickX := 0, ClickY := 0, ClickInfo := "") {
    try {
        if WinWait(target, , waitDuration) {
            WinActivate
            MouseClick ClickType, ClickX, ClickY
            if ClickInfo != "" {
                ToolTip ClickInfo
                SetTimer () => ToolTip(), -1000, -1
            }
            return true
        } else {
            throw Error('The "' . target . '" window could not be found !')
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
 * 
 * @returns {Boolean} - True if the window is found and its position and size are set, false otherwise
 * 
 * @throws {Error} - If encounter errors when setting the window position and size
 */
SetWindow(target, x := -1, y := -1, width := -1, height := -1, waitDuration := 10, sleepDuration := 0) {
    try {
        if WinWait(target, , waitDuration) {
            if sleepDuration > 0 {
                Sleep sleepDuration
            }
            ; Move and resize the window only if needed
            ; Use provided values or current values if not provided
            ; Get current window position and size
            WinGetPos &currentX, &currentY, &currentWidth, &currentHeight
            if x == currentX and y == currentY and width == currentWidth and height == currentHeight {
                return  ; No need to change the window position and size
            }
            params := CreateArray(5)
            params[5] := target
            if x != -1 and x != currentX
                params[1] := x
            if y != -1 and y != currentY
                params[2] := y
            if width != -1 and width != currentWidth
                params[3] := width
            if height != -1 and height != currentHeight
                params[4] := height
            WinMove(params*)
            return true
        } else {
            throw Error('The "' . target . '" window could not be found !')
        }
    } catch as err {
        MsgBox 'ERROR Setting Window! The "' . target . '" window could not be found!', , "T2"
        throw
    }
}
