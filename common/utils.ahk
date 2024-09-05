;; This file contains utility functions.

;;;;;;;;;; UTILITY FUNCTIONS ;;;;;;;;;;

;; Activate (focus) app window.
;; Parameters:
;;   target: The window identifier (e.g., "ahk_exe Spotify.exe")
;;   waitDuration: Total seconds to wait before the action (default: 4)
;;   sleepDuration: Total miliseconds to sleep before activating the window (default: 0)
;; Displays an error message box if the window is not found after all attempts.
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

;; Close app window.
;; Parameters:
;;   target: The window identifier (e.g., "ahk_exe Spotify.exe")
;;   waitDuration: Total seconds to wait before the action (default: 4)
;;   sleepDuration: Total miliseconds to before closing the window (default: 0)
;; Displays an error message box if the window is not found after all attempts.
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

;; Activate (focus) app window and maximize it.
;; Parameters:
;;   target: The window identifier (e.g., "ahk_exe Spotify.exe")
;;   waitDuration: Total seconds to wait before the action (default: 4)
;;   sleepDuration: Total miliseconds to sleep before activating the window (default: 0)
;; Displays an error message box if the window is not found after all attempts.
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

;; Activate (focus) app window and click.
;; Parameters:
;;   target: The window identifier (e.g., "ahk_exe Spotify.exe")
;;   waitDuration: Total seconds to wait (default: 4)
;;   ClickType: The type of click (default: left click)
;;   ClickX: The X coordinate of the click (default: 0)
;;   ClickY: The Y coordinate of the click (default: 0)
;;   ClickInfo: The tooltip message to display after the click (default: "")
;; Displays an error message box if the window is not found after all attempts.
ActivateWindowAndClick(target, waitDuration := 4, ClickType := "left", ClickX := 0, ClickY := 0, ClickInfo := "") {
    if WinWait(target, , waitDuration) {
        WinActivate
        MouseClick ClickType, ClickX, ClickY
        ToolTip(ClickInfo)
        SetTimer () => ToolTip(), -1000
    } else {
        MsgBox 'ERROR ' . ClickType . ' Click (' . ClickX . ', ' . ClickY . ')! The "' . target .
            '" window could not be found!'
    }
}

;; Set app window position and size.
;; Parameters:
;;   target: The window identifier (e.g., "ahk_exe Spotify.exe")
;;   x: The x-coordinate of the window (optional)
;;   y: The y-coordinate of the window (optional)
;;   width: The width of the window (optional)
;;   height: The height of the window (optional)
;;   waitDuration: Total seconds to wait before the action (default: 4)
;;   sleepDuration: Total milliseconds to sleep before setting the window position and size (default: 0)
;; Displays an error message box if the window is not found after all attempts.
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

;; Set app window position and size and then activate (focus) app window.
;; Parameters:
;;   target: The window identifier (e.g., "ahk_exe Spotify.exe")
;;   x: The x-coordinate of the window (optional)
;;   y: The y-coordinate of the window (optional)
;;   width: The width of the window (optional)
;;   height: The height of the window (optional)
;;   waitDuration: Total seconds to wait before the action (default: 4)
;;   sleepDuration: Total milliseconds to sleep before setting the window position and size (default: 0)
;; Displays an error message box if the window is not found after all attempts.
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

;; Get the path of the specified executable file.
;; Returns the path of file if found, otherwise returns an empty string
;; Parameters:
;;   baseDir: The base directory to search in, support wildcard
;;   exeName: The name of the executable file to search for
GetExePath(baseDir := "", exeName := "") {
    ; Loop through all subdirectories
    loop files, baseDir, "D" {
        ; Check if the executable file exists in current subdirectory
        if FileExist(A_LoopFilePath . "\" . exeName)
            return A_LoopFilePath . "\" . exeName
    }
    return "" ; Return empty string if not found
}

;; Run specified script with administrator privileges
;; Parameters:
;;   ScriptPath: The path of the script to run
RunScriptAsAdmin(ScriptPath) {
    try {
        Run '*RunAs "' A_AhkPath '" "' ScriptPath '"'
    } catch as e {
        MsgBox "Error attempting to run admin script: " . e.Message
    }
}

;; Get the color mode of Windows (Light or Dark)
GetWinColorMode() {
    regKey := "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    regValue := "AppsUseLightTheme"
    colorMode := RegRead(regKey, regValue)
    return (colorMode == 0) ? "Dark" : "Light"
}

;; Send given text
SendText(text) {
    A_Clipboard := text
    Send "^v"

    ; Wait a bit to ensure the paste operation is complete
    Sleep 50

    ; Clear the clipboard item (the sent text)
    A_Clipboard := ""
}

;; Split a file path into its components and return the specified component.
;; Returns the requested component of the file path, or the original path string if the component is not recognized.
;; For example, GetExeName("C:\Windows\explorer.exe") returns "explorer.exe"
;; Parameters:
;;   path: The full file path to split
;;   component: The component of the path to return
;;     "name": Full filename with extension (default)
;;     "dir": Directory path
;;     "ext": File extension (without the dot)
;;     "nameNoExt": Filename without extension
;;     "drive": Drive letter or name
GetPathComponent(path, component := "name") {
    SplitPath(path, &name, &dir, &ext, &nameNoExt, &drive)

    switch component {
        case "name":
            return name
        case "dir":
            return dir
        case "ext":
            return ext
        case "nameNoExt":
            return nameNoExt
        case "drive":
            return drive
        default:
            return path
    }
}

;; Check if the current program is in the exclude list
;; Returns: true if the program is excluded, false otherwise
IsExcludedProgram() {
    program := ""
    try {
        program := WinGetProcessName("A")
        ; Check if the current program is in the exclude list
        ; If `WinGetProcessName` fails to get the process name and returns an empty string, return true
        return program != "" ? excludedProgramList.Has(program) : true
    } catch as err {
        ; ToolTip("ERROR checking excluded program: " . (program != "" ? program : "Unknown"))
        ; SetTimer () => ToolTip(), -5000
        return false
    }
}

; Log error to file
LogError(exception, mode) {
    timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
    FileAppend Format("{1} - Error in {2} on line {3}: {4}`n",
        timestamp,
        exception.What,
        exception.Line,
        exception.Message),
        logfile
    return true
}
