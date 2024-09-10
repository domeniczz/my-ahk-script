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
        ; If `WinGetProcessName` fails to get the process name and returns an empty string, return true
        return program != "" ? excludedProgramList.Has(program) : true
    } catch as err {
        ; ToolTip("ERROR checking excluded program: " . (program != "" ? program : "Unknown"))
        ; SetTimer () => ToolTip(), -5000, -1
        return false
    }
}

/**
 * Run specified script with administrator privileges.
 * 
 * @param {String} ScriptPath - The path of the script to run
 */
RunScriptAsAdmin(ScriptPath) {
    try {
        Run '*RunAs "' A_AhkPath '" "' ScriptPath '"'
    } catch as e {
        MsgBox "Error attempting to run admin script: " . e.Message
    }
}

/**
 * Suspend/Resume the script.
 */
SuspendScript() {
    ; Toggle "Suspend Hotkeys" On/Off
    Suspend -1
    ToolTip(A_IsSuspended ? "Script suspended" : "Script activated")
    SetTimer () => ToolTip(), -3000, -1
}
