#Requires AutoHotkey v2.0

#SingleInstance Force

#Include ..\common\constants.ahk
#Include ..\common\utils.ahk
#Include ..\function\autodarkmode.ahk

;;;;;;;;;;  This script is ran by Windows Task Scheduler every time the system unlock  ;;;;;;;;;;
;;;;;;;;;;  Function `AutoDarkMode` is called to change the color mode based on time   ;;;;;;;;;;

AutoDarkMode()

ExitApp