#Requires AutoHotkey v2.0

#SingleInstance Force


;; This script is ran by Windows Task Scheduler every time the system unlock by any user


RunWait(A_ScriptDir . "\closerawaccel.ahk",, "Hide")
