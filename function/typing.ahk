;; This file contains the functions related to typing and text input.

;;;;;;;;;; TYPING FUNCTIONS ;;;;;;;;;;

/*
Send predefined text
*/
SendTextLLMGeneralPrompt() {
    SendText("
    (
    You are an expert. Please be reliable, neutral and formal.
    Provide multiple perspectives and solutions if possible. Cite sources with links if there are any.
    Think step by step carefully and logically. Your answer should be correct, clear and easy to understand.
    Thank you in advance.
    )"
    )
}
