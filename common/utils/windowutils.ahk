;; This file contains utility functions.

;;;;;;;;;; UTILITY FUNCTIONS ;;;;;;;;;;

/*
Activate (focus) app window.
Parameters:
  target: The window identifier (e.g., "ahk_exe Spotify.exe")
  waitDuration: Total seconds to wait before the action (default: 4)
  sleepDuration: Total miliseconds to sleep before activating the window (default: 0)
Displays an error message box if the window is not found after all attempts.
*/
ActivateWindow(target, waitDuration := 4, sleepDuration := 0) {
    if WinWait(target, , waitDuration) {
        if (sleepDuration > 0) {
            Sleep sleepDuration
        }
        WinActivate
    } else {
        MsgBox 'ERROR Activating! The "' . target . '" window could not be found!'
    }
}

/*
Close app window.
Parameters:
  target: The window identifier (e.g., "ahk_exe Spotify.exe")
  waitDuration: Total seconds to wait before the action (default: 4)
  sleepDuration: Total miliseconds to before closing the window (default: 0)
Displays an error message box if the window is not found after all attempts.
*/
CloseWindow(target, waitDuration := 4, sleepDuration := 0) {
    if WinWait(target, , waitDuration) {
        if (sleepDuration > 0) {
            Sleep sleepDuration
        }
        WinClose
    } else {
        MsgBox 'ERROR Closing! The "' . target . '" window could not be found!'
    }
}

/*
Activate (focus) app window and maximize it.
Parameters:
  target: The window identifier (e.g., "ahk_exe Spotify.exe")
  waitDuration: Total seconds to wait before the action (default: 4)
  sleepDuration: Total miliseconds to sleep before activating the window (default: 0)
Displays an error message box if the window is not found after all attempts.
*/
ActivateAndMaximizeWindow(target, waitDuration := 4, sleepDuration := 0) {
    if WinWait(target, , waitDuration) {
        WinActivate
        if (sleepDuration > 0) {
            Sleep sleepDuration
        }
        WinMaximize
    } else {
        MsgBox 'ERROR Activating! The "' . target . '" window could not be found!'
    }
}

/*
Activate (focus) app window and click.
Parameters:
  target: The window identifier (e.g., "ahk_exe Spotify.exe")
  waitDuration: Total seconds to wait (default: 4)
  ClickType: The type of click (default: left click)
  ClickX: The X coordinate of the click (default: 0)
  ClickY: The Y coordinate of the click (default: 0)
  ClickInfo: The tooltip message to display after the click (default: "")
Displays an error message box if the window is not found after all attempts.
*/
ActivateWindowAndClick(target, waitDuration := 4, ClickType := "left", ClickX := 0, ClickY := 0, ClickInfo := "") {
    if WinWait(target, , waitDuration) {
        WinActivate
        MouseClick ClickType, ClickX, ClickY
        ToolTip(ClickInfo)
        SetTimer () => ToolTip(), -1000, -1
    } else {
        MsgBox 'ERROR ' . ClickType . ' Click (' . ClickX . ', ' . ClickY . ')! The "' . target .
            '" window could not be found!'
    }
}

/*
Set app window position and size.
Parameters:
  target: The window identifier (e.g., "ahk_exe Spotify.exe")
  x: The x-coordinate of the window (optional)
  y: The y-coordinate of the window (optional)
  width: The width of the window (optional)
  height: The height of the window (optional)
  waitDuration: Total seconds to wait before the action (default: 4)
  sleepDuration: Total milliseconds to sleep before setting the window position and size (default: 0)
Displays an error message box if the window is not found after all attempts.
*/
SetWindow(target, x := -1, y := -1, width := -1, height := -1, waitDuration := 4, sleepDuration := 0) {
    if WinWait(target, , waitDuration) {
        Sleep sleepDuration

        ; Move and resize the window only if needed
        ; Use provided values or current values if not provided
        if (x != -1 or y != -1 or width != -1 or height != -1) {
            ; Get current window position and size
            WinGetPos &currentX, &currentY, &currentWidth, &currentHeight
            if (x == currentX and y == currentY and width == currentWidth and height == currentHeight) {
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
    } else {
        MsgBox('ERROR Setting Window! The "' . target . '" window could not be found!')
    }
}

/*
Set app window position and size and then activate (focus) app window.
Parameters:
  target: The window identifier (e.g., "ahk_exe Spotify.exe")
  x: The x-coordinate of the window (optional)
  y: The y-coordinate of the window (optional)
  width: The width of the window (optional)
  height: The height of the window (optional)
  waitDuration: Total seconds to wait before the action (default: 4)
  sleepDuration: Total milliseconds to sleep before setting the window position and size (default: 0)
Displays an error message box if the window is not found after all attempts.
*/
SetAndActivateWindow(target, x := -1, y := -1, width := -1, height := -1, waitDuration := 4, sleepDuration := 0) {
    if WinWait(target, , waitDuration) {
        ; Move and resize the window only if needed
        ; Use provided values or current values if not provided
        if (x != -1 or y != -1 or width != -1 or height != -1) {
            ; Get current window position and size
            WinGetPos &currentX, &currentY, &currentWidth, &currentHeight
            if (x == currentX and y == currentY and width == currentWidth and height == currentHeight) {
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
        if (sleepDuration > 0) {
            Sleep sleepDuration
        }
        WinActivate
    } else {
        MsgBox('ERROR Setting Window! The "' . target . '" window could not be found!')
    }
}
