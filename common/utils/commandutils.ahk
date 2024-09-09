/**
 * Checks if a Docker container is currently running.
 * 
 * @param {String} containerName - The name of the Docker container to check.
 * @returns {Boolean} True if the container is running, false otherwise.
 */
IsDockerContainerRunning(containerName) {
    ; Construct the command
    command := 'docker inspect -f "{{.State.Running}}" ' . containerName . ' | clip'

    ; Run the command using cmd.exe without hiding the console
    RunWait A_ComSpec . " /c " . command

    sleep 50

    ; Trim any whitespace and convert to lowercase
    result := StrLower(RTrim(Trim(A_Clipboard), "`n`r"))

    sleep 50
    A_Clipboard := ""

    ; Return true if the result is "true", false otherwise
    return result == "true"
}
