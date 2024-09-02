#Requires AutoHotkey v2.0

#SingleInstance Force

;; This script is ran by Windows Task Scheduler every time the system unlock by any user
;; Trigger: At logon of any user
;;          On workstation unlock

RunWait(A_ScriptDir . "\autodarkmode.ahk", , "Hide")