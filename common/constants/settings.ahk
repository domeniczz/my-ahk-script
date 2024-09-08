; Format the current date as MM-dd
CurrentMonth := FormatTime("", "MM")
CurrentDate := FormatTime("", "MM-dd")

; Log file path
logDir := A_ScriptDir . "\log" . "\" . CurrentMonth
; Ensure log directory exists
DirCreate logDir
logfile := logDir . "\" . CurrentDate . ".log"
; Ensure the log file exists (creates it if it doesn't)
FileAppend "", logfile

; Speed of infinite scrolling (* times faster than normal scroll)
; It will increases non-linearly based on the number of consecutive scroll wheel movements in the same direction
baseScrollSpeed := 1.2

; List (Map) of excluded programs
excludedProgramList := Map(
    ; Counter-Strike: Global Offensive
    "cs2.exe", true,
    "csgo_legacy_app.exe", true,
    "csgo.exe", true,
    ; Apex Legends
    "r5apex.exe", true,
    ; Call of Duty
    "cod.exe", true,
    ; Overwatch
    "Overwatch.exe", true,
    ; Dota 2
    "dota2.exe", true,
    ; Red Dead Redemption 2
    "RDR2.exe", true,
    ; Grand Theft Auto V
    "GTA5.exe", true,
    ; Black Myth: Wukong
    "b1.exe", true,
    ; Civilization VI
    "CivilizationVI.exe", true,
    ; Stardew Valley
    "Stardew Valley.exe", true,
    ; Terraria
    "Terraria.exe", true,
    ; 3DMark
    "3DMark.exe", true
)