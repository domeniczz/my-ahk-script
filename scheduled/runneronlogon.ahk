#Requires AutoHotkey v2.0

#SingleInstance Force

; #WinActivateForce

ProcessSetPriority "High"

A_MaxHotkeysPerInterval := 99999999
A_HotkeyInterval := 99999999

KeyHistory 0
ListLines False

SetKeyDelay -1, -1
SetMouseDelay -1
SetDefaultMouseSpeed 0
SetWinDelay 0
SetControlDelay 0

SendMode "Input"

OnError LogError

logfile := A_ScriptDir . "\logs\scheduled.log"

#Include ..\common\utils\logutils.ahk

;; This script is ran by Windows Task Scheduler every time the system logon
;; Trigger: At logon of any user

RunWait(A_ScriptDir . "\applyrawaccel.ahk", , "Hide")