/**
 * Validate and update application paths, if the application path is not found, search in common app installation paths
 * 
 * @param {VarRef} appPath The path to the application
 * 
 * @returns {String} - The path to the application
 */
ValidateAndUpdatePath(&appPath) {
    if appPath == "" {
        LogError(Error("Empty application path!"))
        return ""
    }
    exeName := GetPathComponent(appPath, "name")
    if !FileExist(appPath) {
        startTime := A_TickCount
        for path in commonInstallationPaths {
            if A_TickCount - startTime > 1000 {
                LogError(Error('ValidateAndUpdatePath: Search "' . exeName . '" timeout after 1 second'))
                break
            }
            if !DirExist(path) {
                continue
            }
            appPath := GetFilePath(path, exeName)
            if appPath != "" {
                return appPath
            }
        }
    }
    return appPath
}

/**
 * Adjust the width coefficient of the application window to fit the current screen size
 * 
 * @param widthCoeff The original width coefficient of the application window
 * 
 * @returns {Float | Integer} - The adjusted width coefficient
 */
AdjustWidthCoeff(widthCoeff) {
    baseScreenWidth := 3840
    ratio := A_ScreenWidth / baseScreenWidth

    ; For screens of the same size as the base one
    if ratio == 1 {
        return widthCoeff
    }
    ; For smaller screens
    else if ratio < 1 {
        adjustment := 1 + (1 - ratio) * 2.4 * (1 - widthCoeff)
        return Min(widthCoeff * adjustment, 0.99)
    }
    ; For larger screens
    else if ratio > 1 {
        adjustment := 1 + (ratio - 1) * 0.5 * (1 - widthCoeff)
        return Min(widthCoeff * adjustment, 0.88)
    }
}

/**
 * Adjust the height coefficient of the application window to fit the current screen size
 * 
 * @param heightCoeff The original height coefficient of the application window
 * 
 * @returns {Float | Integer} - The adjusted height coefficient
 */
AdjustHeightCoeff(heightCoeff) {
    baseScreenHeight := 2160
    ratio := A_ScreenHeight / baseScreenHeight

    ; For screens of the same size as the base one
    if ratio == 1 {
        return heightCoeff
    }
    ; For smaller screens
    else if ratio < 1 {
        adjustment := 1 + (1 - ratio) * 2 * (1 - heightCoeff)
        return Min(heightCoeff * adjustment, 0.97)
    }
    ; For larger screens
    else if ratio > 1 {
        adjustment := 1 + (ratio - 1) * 0.8 * (1 - heightCoeff)
        return Min(heightCoeff * adjustment, 0.97)
    }
}
