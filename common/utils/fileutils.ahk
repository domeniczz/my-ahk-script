/**
 * Opens a folder in Windows Explorer.
 * 
 * @param {String} path - The path of the folder to open
 * @param {String} explorer - The explorer program to open the folder
 */
OpenFolder(path := A_MyDocuments, explorer := "explorer.exe ") {
    try {
        Run(explorer . path)
    }
}

/**
 * Gets the path of the specified file.
 * 
 * @param {String} baseDir - The base directory to search in, supports wildcard (default: "C:\")
 * @param {String} fileName - The name of the file (with file extension) to search for (default: "")
 * 
 * @returns {String} - The path of the file if found, otherwise an empty string "".
 * 
 * @throws {Error} - If baseDir or fileName is not a string
 */
GetFilePath(baseDir := C_SystemDriveLetter . "\", fileName := "") {
    if Type(baseDir) != "String" or Type(fileName) != "String" {
        throw ValueError("baseDir and fileName must be strings")
    }
    if fileName == "" {
        return ""
    }
    try {
        loop files, baseDir . "\" . fileName, "FR" {
            if GetPathComponent(A_LoopFilePath, "name") == fileName {
                return A_LoopFilePath
            }
        }
    }
    return ""
}

/**
 * Splits a file path into its components and returns the specified component.
 * 
 * @param {String} path - The full file path to split
 * @param {String} component - The component of the path to return
 * 
 * - "name": Full filename with extension (default)
 * - "dir": Directory path
 * - "ext": File extension (without the dot)
 * - "nameNoExt": Filename without extension
 * - "drive": Drive letter or name
 * 
 * @returns {String} - The requested component of the file path, or the original path string if the component is not recognized
 * 
 * @example GetPathComponent("C:\Windows\explorer.exe", "name") returns "explorer.exe"
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
