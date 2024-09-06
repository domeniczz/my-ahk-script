sandboxieContainers := GetSandboxieContainerList()

/*
Get all the sandboxie containers for the current user
Returns a map of container names and their paths
*/
GetSandboxieContainerList() {
    baseDir := "C:\Sandbox\" . A_UserName . "\"
    containers := Map()

    loop files, baseDir "*", "D" {
        containers[A_LoopFileName] := baseDir A_LoopFileName "\drive"
    }

    return containers
}

/*
Update the container list
*/
updateContainerList() {
    sandboxieContainers := GetSandboxieContainerList()
}
