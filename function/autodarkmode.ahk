;; This file contains the AutoDarkMode function which checks the current time and changes the Windows color mode accordingly


;; Check the current time and change the Windows color mode if needed
AutoDarkMode() {
    currentTime := FormatTime(A_Now, "HHmm")
    if (currentTime >= morning and currentTime < evening) {
        if GetWinColorMode() != "Light" {
            ToggleWinColorMode()
            FileAppend "Changed Windows color mode to Light at " . SubStr(currentTime, 1, 2) . ":" . SubStr(currentTime, 3) . "`n", logfile
        }
    } else {
        if GetWinColorMode() != "Dark" {
            ToggleWinColorMode()
            FileAppend "Changed Windows color mode to Dark at " . SubStr(currentTime, 1, 2) . ":" . SubStr(currentTime, 3) . "`n", logfile
        }
    }
    ; FileAppend "Checking Windows color mode at " . SubStr(currentTime, 1, 2) . ":" . SubStr(currentTime, 3) . "`n", logfile
}
