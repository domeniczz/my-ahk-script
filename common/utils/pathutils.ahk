/*
Open a folder in Windows Explorer
  path: The path of the folder to open (default: A_MyDocuments)
  explorer: The explorer to program to open the folder (default: "explorer.exe ")
*/
OpenFolder(path := A_MyDocuments, explorer := "explorer.exe ") {
    Run(explorer . path)
}

/*
Get the path of the specified executable file.
Returns the path of file if found, otherwise returns an empty string
Parameters:
  baseDir: The base directory to search in, support wildcard
  exeName: The name of the executable file to search for
*/
GetExePath(baseDir := "", exeName := "") {
    ; Loop through all subdirectories
    loop files, baseDir, "D" {
        ; Check if the executable file exists in current subdirectory
        if FileExist(A_LoopFilePath . "\" . exeName)
            return A_LoopFilePath . "\" . exeName
    }
    return "" ; Return empty string if not found
}

/*
Split a file path into its components and return the specified component.
Returns the requested component of the file path, or the original path string if the component is not recognized.
For example, GetExeName("C:\Windows\explorer.exe") returns "explorer.exe"
Parameters:
  path: The full file path to split
  component: The component of the path to return
    "name": Full filename with extension (default)
    "dir": Directory path
    "ext": File extension (without the dot)
    "nameNoExt": Filename without extension
    "drive": Drive letter or name
*/
GetPathComponent(path, component := "name") {
    SplitPath(path, &name, &dir, &ext, &nameNoExt, &drive)

    switch component {
        case "name": return name
        case "dir": return dir
        case "ext": return ext
        case "nameNoExt": return nameNoExt
        case "drive": return drive
        default: return path
    }
}
