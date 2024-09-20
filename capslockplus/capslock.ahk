#Include lib\keyFunctions.ahk
#Include lib\keyActions.ahk
#Include lib\functionsLib.ahk

; Create a GUI to display the CapsLock state
CapsLockGui := Gui()
CapsLockGui.Opt("+AlwaysOnTop -Caption +ToolWindow +E0x20")  ; E0x20 means click-through
CapsLockGui.BackColor := GetWindowsAccentColor()
CapsLockIndicator := CapsLockGui.Add("Text", "Center", "CAPS")
; Margin from the screen edge
margin := 0
xPos := margin
yPos := margin
; Set opacity (*/255), 255 is fully opaque
WinSetTransparent(160, CapsLockGui)
; Show the GUI in the top-left corner
CapsLockGui.Show(Format("x{} y{} NoActivate", xPos, yPos))
; Intially hide the GUI
CapsLockGui.Hide()

; Store the CapsLock activation state (0 = Off, 1 = On)
CapsLockState := 0

; Clipboard separate from the system clipboard
seperateClipboard := ""

; ;; Activation approach 1: Actiavte CapsLock on click and deactivate on second click
; /**
;  * Checks the state of the CapsLock key and updates the GUI accordingly.
;  */
; CheckCapsLockState() {
;     if CapsLockState
;         CapsLockGui.Show("NoActivate")
;     else
;         CapsLockGui.Hide()
; }
; ; Toggle CapsLock state On/Off with CapsLock key press
; *CapsLock::
; {
;     global CapsLockState
;     SetTimer CheckCapsLockState, 100
;     CapsLockState := !CapsLockState ? 1 : 0
;     if CapsLockState {
;         ToolTip("CapsLock ON")
;         SetTimer () => ToolTip(), -600, -1
;     } else {
;         ToolTip("CapsLock OFF")
;         SetTimer () => ToolTip(), -600, -1
;     }
; }

;; Activation approach 2: Actiavte CapsLock on press and deactivate on release
*CapsLock::
{
    global CapsLockState
    CapsLockState := 1
    CapsLockGui.Show("NoActivate")
    KeyWait "CapsLock"
}
*CapsLock Up::
{
    global CapsLockState
    CapsLockState := 0
    CapsLockGui.Hide()
}

#HotIf CapsLockState

;;;;;;;;;; CapsLock + Keys ;;;;;;;;;;

{
    ; A - Z, 0 - 9, F1 - F12
    {
        a::
        b::
        c::
        d::
        e::
        f::
        g::
        h::
        i::
        j::
        k::
        l::
        m::
        n::
        o::
        p::
        q::
        r::
        s::
        t::
        u::
        v::
        w::
        x::
        y::
        z::
        0::
        1::
        2::
        3::
        4::
        5::
        6::
        7::
        8::
        9::
        F1::
        F2::
        F3::
        F4::
        F5::
        F6::
        F7::
        F8::
        F9::
        F10::
        F11::
        F12::
        {
            try {
                RunHotkeyFunction("Capslock_" . A_ThisHotkey)
            } catch as err {
                MsgBox "ERROR while running function Capslock_" . A_ThisHotkey
                ; LogError(err, "Return")
            }
        }
    }
    ; Special keys
    {
        try {
            `:: RunHotkeyFunction("Capslock_Backtick")
            -:: RunHotkeyFunction("Capslock_Minus")
            =:: RunHotkeyFunction("Capslock_Equal")
            [:: RunHotkeyFunction("Capslock_LSquareBracket")
            ]:: RunHotkeyFunction("Capslock_RSquareBracket")
            \:: RunHotkeyFunction("Capslock_Backslash")
            `;:: RunHotkeyFunction("Capslock_Semicolon")
            ':: RunHotkeyFunction("Capslock_Apostrophe")
            ,:: RunHotkeyFunction("Capslock_Comma")
            .:: RunHotkeyFunction("Capslock_Period")
            /:: RunHotkeyFunction("Capslock_Slash")
            Space:: RunHotkeyFunction("Capslock_Space")
            Enter:: RunHotkeyFunction("Capslock_Enter")
            Backspace:: RunHotkeyFunction("Capslock_Backspace")
            Tab:: RunHotkeyFunction("Capslock_Tab")
            Escape:: RunHotkeyFunction("Capslock_Esc")
        } catch as err {
            MsgBox "ERROR while running function Capslock_" . A_ThisHotkey
            ; LogError(err, "Return")
        }
    }
    ; Mouse buttons
    {
        try {
            WheelUp:: RunHotkeyFunction("Capslock_WheelUp")
            WheelDown:: RunHotkeyFunction("Capslock_WheelDown")
            LButton:: RunHotkeyFunction("Capslock_LButton")
            RButton:: RunHotkeyFunction("Capslock_RButton")
            MButton:: RunHotkeyFunction("Capslock_MButton")
        } catch as err {
            MsgBox "ERROR while running function Capslock_" . A_ThisHotkey
            ; LogError(err, "Return")
        }
    }
}

;;;;;;;;;; CapsLock + Shift + Keys ;;;;;;;;;;

{
    ; A - Z, 0 - 9, F1 - F12
    {
        +a::
        +b::
        +c::
        +d::
        +e::
        +f::
        +g::
        +h::
        +i::
        +j::
        +k::
        +l::
        +m::
        +n::
        +o::
        +p::
        +q::
        +r::
        +s::
        +t::
        +u::
        +v::
        +w::
        +x::
        +y::
        +z::
        +0::
        +1::
        +2::
        +3::
        +4::
        +5::
        +6::
        +7::
        +8::
        +9::
        +F1::
        +F2::
        +F3::
        +F4::
        +F5::
        +F6::
        +F7::
        +F8::
        +F9::
        +F10::
        +F11::
        +F12::
        {
            try {
                RunHotkeyFunction("Capslock_Shift_" . SubStr(A_ThisHotkey, 2))
            } catch as err {
                MsgBox "ERROR while running function Capslock_Shift_" . SubStr(A_ThisHotkey, 2)
                ; LogError(err, "Return")
            }
        }
    }
    ; Special keys
    {
        try {
            +`:: RunHotkeyFunction("Capslock_Shift_Backtick")
            +-:: RunHotkeyFunction("Capslock_Shift_Minus")
            +=:: RunHotkeyFunction("Capslock_Shift_Equal")
            +[:: RunHotkeyFunction("Capslock_Shift_LSquareBracket")
            +]:: RunHotkeyFunction("Capslock_Shift_RSquareBracket")
            +\:: RunHotkeyFunction("Capslock_Shift_Backslash")
            +`;:: RunHotkeyFunction("Capslock_Shift_Semicolon")
            +':: RunHotkeyFunction("Capslock_Shift_Apostrophe")
            +,:: RunHotkeyFunction("Capslock_Shift_Comma")
            +.:: RunHotkeyFunction("Capslock_Shift_Period")
            +/:: RunHotkeyFunction("Capslock_Shift_Slash")
            +Space:: RunHotkeyFunction("Capslock_Shift_Space")
            +Enter:: RunHotkeyFunction("Capslock_Shift_Enter")
            +Backspace:: RunHotkeyFunction("Capslock_Shift_Backspace")
            +Tab:: RunHotkeyFunction("Capslock_Shift_Tab")
            +Escape:: RunHotkeyFunction("Capslock_Shift_Esc")
        } catch as err {
            MsgBox "ERROR while running function Capslock_Shift_" . SubStr(A_ThisHotkey, 2)
            ; LogError(err, "Return")
        }
    }
    ; Mouse buttons
    {
        try {
            +WheelUp:: RunHotkeyFunction("Capslock_Shift_WheelUp")
            +WheelDown:: RunHotkeyFunction("Capslock_Shift_WheelDown")
            +LButton:: RunHotkeyFunction("Capslock_Shift_LButton")
            +RButton:: RunHotkeyFunction("Capslock_Shift_RButton")
            +MButton:: RunHotkeyFunction("Capslock_Shift_MButton")
        } catch as err {
            MsgBox "ERROR while running function Capslock_Shift_" . SubStr(A_ThisHotkey, 2)
            ; LogError(err, "Return")
        }
    }
}

;;;;;;;;;; CapsLock + Alt + Keys ;;;;;;;;;;

{
    ; A - Z, 0 - 9, F1 - F12
    {
        !a::
        !b::
        !c::
        !d::
        !e::
        !f::
        !g::
        !h::
        !i::
        !j::
        !k::
        !l::
        !m::
        !n::
        !o::
        !p::
        !q::
        !r::
        !s::
        !t::
        !u::
        !v::
        !w::
        !x::
        !y::
        !z::
        !0::
        !1::
        !2::
        !3::
        !4::
        !5::
        !6::
        !7::
        !8::
        !9::
        !F1::
        !F2::
        !F3::
        !F4::
        !F5::
        !F6::
        !F7::
        !F8::
        !F9::
        !F10::
        !F11::
        !F12::
        {
            try {
                RunHotkeyFunction("Capslock_Alt_" . SubStr(A_ThisHotkey, 2))
            } catch as err {
                MsgBox "ERROR while running function Capslock_Alt_" . SubStr(A_ThisHotkey, 2)
                ; LogError(err, "Return")
            }
        }
    }
    ; Special keys
    {
        try {
            !`:: RunHotkeyFunction("Capslock_Alt_Backtick")
            !-:: RunHotkeyFunction("Capslock_Alt_Minus")
            !=:: RunHotkeyFunction("Capslock_Alt_Equal")
            ![:: RunHotkeyFunction("Capslock_Alt_LSquareBracket")
            !]:: RunHotkeyFunction("Capslock_Alt_RSquareBracket")
            !\:: RunHotkeyFunction("Capslock_Alt_Backslash")
            !`;:: RunHotkeyFunction("Capslock_Alt_Semicolon")
            !':: RunHotkeyFunction("Capslock_Alt_Apostrophe")
            !,:: RunHotkeyFunction("Capslock_Alt_Comma")
            !.:: RunHotkeyFunction("Capslock_Alt_Period")
            !/:: RunHotkeyFunction("Capslock_Alt_Slash")
            !Space:: RunHotkeyFunction("Capslock_Alt_Space")
            !Enter:: RunHotkeyFunction("Capslock_Alt_Enter")
            !Backspace:: RunHotkeyFunction("Capslock_Alt_Backspace")
            !Tab:: RunHotkeyFunction("Capslock_Alt_Tab")
            !Escape:: RunHotkeyFunction("Capslock_Alt_Esc")
        } catch as err {
            MsgBox "ERROR while running function Capslock_Alt_" . SubStr(A_ThisHotkey, 2)
            ; LogError(err, "Return")
        }
    }
    ; Mouse buttons
    {
        try {
            !WheelUp:: RunHotkeyFunction("Capslock_Alt_WheelUp")
            !WheelDown:: RunHotkeyFunction("Capslock_Alt_WheelDown")
            !LButton:: RunHotkeyFunction("Capslock_Alt_LButton")
            !RButton:: RunHotkeyFunction("Capslock_Alt_RButton")
            !MButton:: RunHotkeyFunction("Capslock_Alt_MButton")
        } catch as err {
            MsgBox "ERROR while running function Capslock_Alt_" . SubStr(A_ThisHotkey, 2)
            ; LogError(err, "Return")
        }
    }
}

;;;;;;;;;; CapsLock + Ctrl + Keys ;;;;;;;;;;

{
    ; A - Z, 0 - 9, F1 - F12
    {
        ^a::
        ^b::
        ^c::
        ^d::
        ^e::
        ^f::
        ^g::
        ^h::
        ^i::
        ^j::
        ^k::
        ^l::
        ^m::
        ^n::
        ^o::
        ^p::
        ^q::
        ^r::
        ^s::
        ^t::
        ^u::
        ^v::
        ^w::
        ^x::
        ^y::
        ^z::
        ^0::
        ^1::
        ^2::
        ^3::
        ^4::
        ^5::
        ^6::
        ^7::
        ^8::
        ^9::
        ^F1::
        ^F2::
        ^F3::
        ^F4::
        ^F5::
        ^F6::
        ^F7::
        ^F8::
        ^F9::
        ^F10::
        ^F11::
        ^F12::
        {
            try {
                RunHotkeyFunction("Capslock_Ctrl_" . SubStr(A_ThisHotkey, 2))
            } catch as err {
                MsgBox "ERROR while running function Capslock_Ctrl_" . SubStr(A_ThisHotkey, 2)
                ; LogError(err, "Return")
            }
        }
    }
    ; Special keys
    {
        try {
            ^`:: RunHotkeyFunction("Capslock_Ctrl_Backtick")
            ^-:: RunHotkeyFunction("Capslock_Ctrl_Minus")
            ^=:: RunHotkeyFunction("Capslock_Ctrl_Equal")
            ^[:: RunHotkeyFunction("Capslock_Ctrl_LSquareBracket")
            ^]:: RunHotkeyFunction("Capslock_Ctrl_RSquareBracket")
            ^\:: RunHotkeyFunction("Capslock_Ctrl_Backslash")
            ^`;:: RunHotkeyFunction("Capslock_Ctrl_Semicolon")
            ^':: RunHotkeyFunction("Capslock_Ctrl_Apostrophe")
            ^,:: RunHotkeyFunction("Capslock_Ctrl_Comma")
            ^.:: RunHotkeyFunction("Capslock_Ctrl_Period")
            ^/:: RunHotkeyFunction("Capslock_Ctrl_Slash")
            ^Space:: RunHotkeyFunction("Capslock_Ctrl_Space")
            ^Enter:: RunHotkeyFunction("Capslock_Ctrl_Enter")
            ^Backspace:: RunHotkeyFunction("Capslock_Ctrl_Backspace")
            ^Tab:: RunHotkeyFunction("Capslock_Ctrl_Tab")
            ^Escape:: RunHotkeyFunction("Capslock_Ctrl_Esc")
        } catch as err {
            MsgBox "ERROR while running function Capslock_Ctrl_" . SubStr(A_ThisHotkey, 2)
            ; LogError(err, "Return")
        }
    }
    ; Mouse buttons
    {
        try {
            ^WheelUp:: RunHotkeyFunction("Capslock_Ctrl_WheelUp")
            ^WheelDown:: RunHotkeyFunction("Capslock_Ctrl_WheelDown")
            ^LButton:: RunHotkeyFunction("Capslock_Ctrl_LButton")
            ^RButton:: RunHotkeyFunction("Capslock_Ctrl_RButton")
            ^MButton:: RunHotkeyFunction("Capslock_Ctrl_MButton")
        } catch as err {
            MsgBox "ERROR while running function Capslock_Ctrl_" . SubStr(A_ThisHotkey, 2)
            ; LogError(err, "Return")
        }
    }
}

#HotIf

/**
 * Executes function dynamically based on the provided function name and optional parameters.
 * 
 * @param {string} funcName - A string containing the name of the function to be called, optionally with parameters.
 *                            Examples: "MyFunction", "MyFunction()", "MyFunction(param1)", "MyFunction(param1, param2)"
 * 
 * Handles function calls with or without parameters, and supports up to 3 explicit parameters 
 * or an arbitrary number of parameters using variadic syntax.
 * 
 * Behavior:
 *   1. If funcName doesn't end with ')', it calls the function without parameters.
 *   2. If funcName includes parameters, it parses them and calls the function accordingly:
 *      - No parameters: Calls the function as-is
 *      - 1 to 3 parameters: Calls the function with the specified number of parameters
 *      - More than 3 parameters: Uses variadic syntax to pass all parameters
 * 
 * Note: This function assumes that the target functions exist in the global scope.
 *       Ensure all referenced functions are defined before calling RunHotkeyFunction.
 */
RunHotkeyFunction(funcName) {
    if !RegExMatch(Trim(funcName), "\)$") {
        %funcName%()
        return
    }
    if RegExMatch(funcName, "(\w+)\((.*)\)$", &match) {
        func := match[1]
        if !match[2] {
            %func%()
            return
        }
        params := StrSplit(match[2], ",", " `t")
        switch params.Length {
            case 1: %func%(params[1])
            case 2: %func%(params[1], params[2])
            case 3: %func%(params[1], params[2], params[3])
            default: %func%(params*)
        }
    }
}
