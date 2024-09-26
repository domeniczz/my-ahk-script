/**
 * Check if the current program is in the exclude list.
 * 
 * @returns {Boolean} - `true` if the program is excluded, `false` otherwise
 */
IsExcludedProgram() {
    program := ""
    try {
        program := WinGetProcessName("A")
        ; Check if the current program is in the exclude list
        ; If `WinGetProcessName` fails to get the process name and returns an empty string, return false
        return program != "" ? excludedProgramList.HasValue(program) : false
    } catch as err {
        ; ToolTip "ERROR checking excluded program: " . (program != "" ? program : "Unknown")
        ; SetTimer () => ToolTip(), -5000, -1
        return false
    }
}

/**
 * Run specified script with administrator privileges.
 * 
 * @param {String} script - The path of the script to run
 * @param {String} fucntionName - The name of the function to run in the script
 */
RunScriptAsAdmin(script, fucntionName := "") {
    try {
        Run '*RunAs "' . A_AhkPath . '" "' . script . '" "' . fucntionName . '"'
    } catch as err {
        MsgBox "Error attempting to run admin script: " . err.Message
    }
}

/**
 * Suspend/Resume the script.
 */
SuspendScript() {
    ; Toggle "Suspend Hotkeys" On/Off
    Suspend -1
    ToolTip A_IsSuspended ? "Script suspended" : "Script activated"
    SetTimer () => ToolTip(), -3000, -1
}
