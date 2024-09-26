/**
 * Log error to file.
 * 
 * @param {String} err - The error object `Error()`
 * @param {String} mode - The mode of the error (default: "Error")
 */
LogError(err, mode := "Error") {
    timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
    logText := Format('{1} - Error in "{2}" on line {3}: {4}`nCallStack: `n{5}`n',
        timestamp,
        err.File,
        err.Line,
        err.Message,
        err.Stack)
    ; Log with UTF-8 encoding
    FileAppend logText, logfile, "UTF-8"
    return true
}
