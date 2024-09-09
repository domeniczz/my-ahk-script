;; This file contains the functions related to typing and text input.

;;;;;;;;;; TYPING FUNCTIONS ;;;;;;;;;;

/**
 * Send predefined LLM prompt for general questions.
 */
SendTextLLMGeneralPrompt() {
    SendText("
    (
    You are an expert. Be reliable, neutral and formal.
    Provide multiple perspectives and solutions if possible. Cite sources with links if there are any.
    Peruse all the info and context the user provided and make sure you have understood them all.
    Think step-by-step carefully and logically. Derive a step-by-step plan to solve the problem first and then handle the task based on the plan.
    Your answer must be correct, clear and easy to understand. Use a professional tone. Use concise, precise and simple wording.
    Thank you in advance.
    )"
    )
}
