/**
 * Log error to file.
 * 
 * @param {String} err - The error object `Error()`
 * @param {String} mode - The mode of the error (default: "Error")
 */
LogError(err, mode := "Error") {
    if !FileExist(logfile) {
        try {
            FileAppend "", logfile
        } catch as err {
            MsgBox("Failed to create log file: " . err.Message)
            return false
        }
    }
    timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
    logText := Format('{1} - Error in "{2}" on line {3}: {4}`nCallStack: `n{5}`n',
        timestamp,
        err.File,
        err.Line,
        err.Message,
        err.Stack)
    try {
        ; Log with UTF-8 encoding
        FileAppend logText, logfile, "UTF-8"
    } catch as err {
        MsgBox("Failed to log error: " . err.Message)
        return false
    }
    return true
}
