; Log file path
logDir := A_ScriptDir . "\log\" . FormatTime("", "MM")
; Ensure log directory exists
DirCreate logDir
logfile := logDir . "\" . FormatTime("", "MM-dd") . ".log"
; Ensure the log file exists (creates it if it doesn't)
FileAppend "", logfile

; Log file for scripts in "other" folder
otherLogDir := A_ScriptDir . "\other\log"
DirCreate otherLogDir
otherLogfile := otherLogDir . "\other.log"
FileAppend "", otherLogfile