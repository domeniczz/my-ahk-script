/*
Log error to file
Parameters:
  err: The error object
  mode: The mode of the error (default: "Error")
*/
LogError(err, mode) {
    timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
    FileAppend Format('{1} - Error in "{2}" on line {3}: {4}`nCallStack: `n{5}`n',
        timestamp,
        err.File,
        err.Line,
        err.Message,
        err.Stack),
        logfile
    return true
}
