/*
Moves the cursor one word to the left
*/
action_moveOneWordLeft() {
    Send "{LCtrl Down}{Left}{LCtrl Up}"
}

/*
Moves the cursor one word to the right
*/
action_moveOneWordRight() {
    Send "{LCtrl Down}{Right}{LCtrl Up}"
}

/*
Moves the cursor one character to the left
*/
action_moveLeft() {
    Send "{Left}"
}

/*
Moves the cursor one character to the right
*/
action_moveRight() {
    Send "{Right}"
}

/*
Moves the cursor up one line
*/
action_moveUp() {
    Send "{Up}"
}

/*
Moves the cursor down one line
*/
action_moveDown() {
    Send "{Down}"
}

/*
Moves the cursor to the beginning of the line
*/
action_home() {
    Send "{Home}"
}

/*
Moves the cursor to the end of the line
*/
action_end() {
    Send "{End}"
}

/*
Select one word to the left
*/
action_selectOneWordLeft() {
    Send "{LShift Down}{LCtrl Down}{Left}{LCtrl Up}{LShift Up}"
}

/*
Select one word to the right
*/
action_selectOneWordRight() {
    Send "{LShift Down}{LCtrl Down}{Right}{LCtrl Up}{LShift Up}"
}

/*
Select one character to the left
*/
action_selectLeft() {
    Send "{LShift Down}{Left}{LShift Up}"
}

/*
Select one character to the right
*/
action_selectRight() {
    Send "{LShift Down}{Right}{LShift Up}"
}

/*
Select up one line
*/
action_selectUp() {
    Send "{LShift Down}{Up}{LShift Up}"
}

/*
Select down one line
*/
action_selectDown() {
    Send "{LShift Down}{Down}{LShift Up}"
}

/*
Select to the beginning of the line
*/
action_selectHome() {
    Send "{LShift Down}{Home}{LShift Up}"
}

/*
Select to the end of the line
*/
action_selectEnd() {
    Send "{LShift Down}{End}{LShift Up}"
}

/*
Deletes the character to the left of the cursor
*/
action_deleteLeft() {
    Send "{BackSpace}"
}

/*
Deletes the character to the right of the cursor
*/
action_deleteRight() {
    Send "{Delete}"
}

/*
Deletes the word to the left of the cursor
*/
action_deleteOneWordLeft() {
    Send "{LCtrl Down}{BackSpace}{LCtrl Up}"
}

/*
Deletes the word to the right of the cursor
*/
action_deleteOneWordRight() {
    Send "{LCtrl Down}{Delete}{LCtrl Up}"
}

/*
Undo the last action
*/
action_undo() {
    Send "{LCtrl Down}z{LCtrl Up}"
}

/*
Redo the last action
*/
action_redo() {
    ; Send "{LCtrl Down}{LShift Down}z{LShift Up}{LCtrl Up}"
    Send "{LCtrl Down}y{LCtrl Up}"
}

/*
Cut the selected text
*/
action_cut() {
    Send "{LCtrl Down}x{LCtrl Up}"
}

/*
Copy the selected text
*/
action_copy() {
    Send "{LCtrl Down}c{LCtrl Up}"
}

/*
Paste the copied text
*/
action_paste() {
    Send "{LCtrl Down}v{LCtrl Up}"
}

/*
Add a blank line above the current line
*/
action_newBlankLineAbove() {
    Send "{Up}{End}{Enter}"
}

/*
Change the selected text to upper case
*/
action_switchSelectedToUpperCase() {
    SwitchTextCase("U")
}

/*
Change the selected text to lower case
*/
action_switchSelectedToLowerCase() {
    SwitchTextCase("L")
}

/*
Change the selected text to title case
*/
action_switchSelectedToTitleCase() {
    SwitchTextCase("T")
}

/*
Scroll up one page
*/
action_pageUp() {
    Send "{PgUp}"
}

/*
Scroll down one page
*/
action_pageDown() {
    Send "{PgDn}"
}

/*
Broswer go back on page in history
*/
action_browserForward() {
    Send "{Browser_Forward}"
}

/*
Broswer go forward on page in history
*/
action_browserBackward() {
    Send "{Browser_Back}"
}

/*
Switch to the tab on the left
*/
action_switchTabLeft() {
    Send "{LCtrl Down}{LShift Down}{Tab}{LShift Up}{LCtrl Up}"
}

/*
Switch to the tab on the right
*/
action_switchTabRight() {
    Send "{LCtrl Down}{Tab}{LCtrl Up}"
}

/*
Turn volume up
*/
action_volumeUp() {
    Send "{Volume_Up}"
}

/*
Turn volume down
*/
action_volumeDown() {
    Send "{Volume_Down}"
}

/*
Mute the volume
*/
action_volumeMute() {
    Send "{Volume_Mute}"
}

/*
Switch to the previous media track
*/
action_previousMedia() {
    Send "{Media_Prev}"
}

/*
Switch to the next media track
*/
action_nextMedia() {
    Send "{Media_Next}"
}

/*
Play or pause the media
*/
action_playOrPauseMedia() {
    Send "{Media_Play_Pause}"
}

/*
Set the window to always be on top
*/
action_setWindowAlwaysOnTop() {
    SetWindowAlwaysOnTop()
}

/*
Display the information of the topmost window
*/
action_displayTopMostWindowInfo() {
    DisplayTopmostWindowInfo()
}

/*
Activate the topmost window
*/
action_activateTopmostWindow() {
    ActivateTopmostWindow()
}

/*
Eject all removable drives
*/
action_ejectAllRemovableDrives() {
    EjectAllRemovableDrives()
}
