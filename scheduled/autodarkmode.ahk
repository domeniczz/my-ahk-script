#Requires AutoHotkey v2.0

#SingleInstance Force

#WinActivateForce

A_MaxHotkeysPerInterval := 99999999
A_HotkeyInterval := 99999999

KeyHistory 0
ListLines False

SetKeyDelay -1, -1
SetMouseDelay -1
SetDefaultMouseSpeed 0
SetWinDelay 0
SetControlDelay 0

SendMode "InputThenPlay"

OnError LogError

logfile := A_ScriptDir . "\logs\scheduled.log"

#Include ..\common\constants\autodarkmode.ahk
#Include ..\common\utils\systemutils.ahk
#Include ..\function\autodarkmode.ahk
#Include ..\common\utils\logutils.ahk

;;;;;;;;;;  This script is ran by Windows Task Scheduler every time the system unlock  ;;;;;;;;;;
;;;;;;;;;;  Function `AutoDarkMode` is called to change the color mode based on time   ;;;;;;;;;;

AutoDarkMode()

ExitApp