;; This file contains the functions related to mouse actions and interactions.


;;;;;;;;;; MOUSE FUNCTIONS ;;;;;;;;;;


infiniteScrollActive := false
scrollDirection := 0
rightClickStartTime := 0
scrollAccumulator := 0.0


;; Press and hold right button, then scroll wheel up/down to trigger infinite scrolling
RButtonHandler(*) {
    global rightClickStartTime

    rightClickStartTime := A_TickCount

    ; Start listening for scroll wheel movement
    Hotkey "WheelUp", ScrollHandler, "On"
    Hotkey "WheelDown", ScrollHandler, "On"

    Hotkey "LButton", LeftClickHandler, "On"

    ; Set a timer to check for button release
    SetTimer CheckRButtonRelease, 2
}


;; Handle left-click to stop infinite scrolling
LeftClickHandler(*) {
    global infiniteScrollActive

    if infiniteScrollActive {
        ; Clean up
        SetTimer InfiniteScroll, 0
        SetTimer CheckRButtonRelease, 0
        Hotkey "WheelUp", "Off"
        Hotkey "WheelDown", "Off"
        Hotkey "LButton", "Off"
        infiniteScrollActive := false
        scrollAccumulator := 0.0
        scrollDirection := 0
    }

    ; Perform the original left-click action
    Click "Left"
}


;; Check if the right mouse button is released
;; If released, perform right-click action or stop infinite scrolling if active
CheckRButtonRelease() {
    global infiniteScrollActive, scrollDirection, rightClickStartTime, rightHoldThreshold

    if !GetKeyState("RButton", "P") {
        SetTimer , 0  ; Stop this timer

        ; Clean up
        SetTimer InfiniteScroll, 0

        Hotkey "WheelUp", "Off"
        Hotkey "WheelDown", "Off"
        Hotkey "LButton", "Off"

        ; Perform right-click if no infinite scrolling occurred
        if !infiniteScrollActive {
            Click "Right"
        }

        ; Clean up
        infiniteScrollActive := false
        scrollDirection := 0
    }
}


;; Handle scrolling based on the scroll direction
ScrollHandler(ThisHotkey) {
    global infiniteScrollActive, scrollDirection

    if ThisHotkey == "WheelUp"
        scrollDirection := 1
    else if ThisHotkey == "WheelDown"
        scrollDirection := -1

    if !infiniteScrollActive {
        infiniteScrollActive := true
        ; Start infinite scrolling
        SetTimer InfiniteScroll, 10
    }
}


;; Perform infinite scrolling based on the scroll direction and speed
InfiniteScroll() {
    global scrollDirection, infiniteScrollActive, scrollSpeed, scrollAccumulator

    ; Perform scrolling if and only if the right mouse button is pressed and the left mouse button is not pressed
    if GetKeyState("RButton", "P") and !GetKeyState("LButton", "P") {
        scrollAccumulator += scrollSpeed
        while (scrollAccumulator >= 1) {
            if scrollDirection > 0
                Send "{WheelUp}"
            else if scrollDirection < 0
                Send "{WheelDown}"
            scrollAccumulator -= 1
        }
    }
    else{
        SetTimer , 0  ; Stop the timer if right mouse button is released
        scrollAccumulator := 0.0
    }
}
