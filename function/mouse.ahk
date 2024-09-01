;; This file contains the functions related to mouse actions and interactions.


;;;;;;;;;; MOUSE FUNCTIONS ;;;;;;;;;;


infiniteScrollActive := false
scrollDirection := 0
rightClickStartTime := 0
scrollAccumulator := 0.0
consecutiveScrollCount := 0
lastScrollDirection := 0


;; Check if the current program is in the exclude list for infinite scrolling
;; Returns: true if the program is excluded, false otherwise
IsExcludedProgram() {
    return infiniScrollExcludedPrograms.Has(WinGetProcessName("A"))
}


;; Press and hold right button, then scroll wheel up/down to trigger infinite scrolling
InfiniScrollHandler(*) {
    if (IsExcludedProgram()) {
        Click "Right"
        return
    }

    global rightClickStartTime

    BeforeCleanUp()

    rightClickStartTime := A_TickCount

    ; Start listening for scroll wheel movement
    Hotkey "WheelUp", ScrollWheelHandler, "On"
    Hotkey "WheelDown", ScrollWheelHandler, "On"
    ; Start listening for left button click
    Hotkey "LButton", LButtonClickHandler, "On"

    ; Set a timer to check for right button release
    SetTimer CheckRButtonRelease, 1
}


;; Handle left-click to stop infinite scrolling
LButtonClickHandler(*) {
    global infiniteScrollActive

    AfterCleanUp()
    infiniteScrollActive := false

    ; Perform the original left-click action
    Click "Left"
}


;; Check if the right mouse button is released
;; If released, perform right-click action or stop infinite scrolling if active
CheckRButtonRelease() {
    global infiniteScrollActive

    ; `GetKeyState` returns 1 (true) if the key is down or 0 (false) if it is up
    if !GetKeyState("RButton", "P") {
        if !infiniteScrollActive {
            ; Perform right-click if no infinite scrolling occurred
            Click "Right"
        }
        AfterCleanUp()
        infiniteScrollActive := false
    }
}


;; Handle scrolling based on the scroll direction
ScrollWheelHandler(ThisHotkey) {
    global infiniteScrollActive, scrollDirection, consecutiveScrollCount, lastScrollDirection

    ; Get scroll direction
    if ThisHotkey == "WheelUp"
        direction := 1
    else if ThisHotkey == "WheelDown"
        direction := -1

    ; If the scroll direction has changed, reset the consecutive scroll count
    if direction != lastScrollDirection {
        consecutiveScrollCount := 1
        lastScrollDirection := direction
        scrollDirection := direction
    }
    ; Otherwise, increment the consecutive scroll count
    else {
        ; Limit the count in case of accidental continuous increase
        if consecutiveScrollCount < 25
            consecutiveScrollCount++
    }

    ; Start infinite scrolling if not already
    if !infiniteScrollActive {
        infiniteScrollActive := true
        ; Start infinite scrolling
        SetTimer InfiniteScroll, 10
    }
}


; Calculate speed multiplier based on consecutive scroll count
; The speed multiplier increases non-linearly based on the number of consecutive scroll wheel movements in the same direction
CalculateSpeedMultiplier(count) {
    ; 1 + (count * 0.12) ^ 3
    return 1 + (count * 0.14) ** 3
}


;; Perform infinite scrolling based on the scroll direction and speed
InfiniteScroll() {
    global scrollAccumulator

    if GetKeyState("RButton", "P") and !GetKeyState("LButton", "P") {
        finalScrollSpeed := baseScrollSpeed * CalculateSpeedMultiplier(consecutiveScrollCount)
        scrollAccumulator += finalScrollSpeed
        while (scrollAccumulator >= 1) {
            if scrollDirection > 0
                Send "{WheelUp}"
            else if scrollDirection < 0
                Send "{WheelDown}"
            scrollAccumulator -= 1
        }
    } else {
        AfterCleanUp()
    }
}


BeforeCleanUp() {
    global infiniteScrollActive, scrollDirection, scrollAccumulator, consecutiveScrollCount, lastScrollDirection

    SetTimer InfiniteScroll, 0
    infiniteScrollActive := false
    scrollAccumulator := 0.0
    scrollDirection := 0
    consecutiveScrollCount := 0
    lastScrollDirection := 0
}


;; Clean up after infinite scrolling
AfterCleanUp() {
    global scrollDirection, scrollAccumulator, consecutiveScrollCount, lastScrollDirection

    SetTimer InfiniteScroll, 0
    SetTimer CheckRButtonRelease, 0
    Hotkey "WheelUp", ScrollWheelHandler, "Off"
    Hotkey "WheelDown", ScrollWheelHandler, "Off"
    Hotkey "LButton", LButtonClickHandler, "Off"
    scrollAccumulator := 0.0
    scrollDirection := 0
    consecutiveScrollCount := 0
    lastScrollDirection := 0
}