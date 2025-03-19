capsKeyboardHelpImages := [
    "capslockplus\assets\keyboard_caps.png",
    "capslockplus\assets\keyboard_caps_shift.png",
    "capslockplus\assets\keyboard_caps_alt.png",
    "capslockplus\assets\keyboard_caps_ctrl.png"
]
currentImageIndex := 1
imgNum := capsKeyboardHelpImages.Length
capsHelpGuiVisible := false

capsHelpGui := DrawCapsHelpGui()

#HotIf capsHelpGuiVisible
WheelUp:: SwitchImage(1)
WheelDown:: SwitchImage(-1)
Esc:: ToggleCapsHelpGui()
#HotIf

; Toggle GUI visibility
ToggleCapsHelpGui() {
    global capsHelpGuiVisible, capsHelpGui
    if WinExist("ahk_id " . capsHelpGui.Hwnd) {
        capsHelpGui.Hide()
        capsHelpGuiVisible := false
    } else {
        if !capsHelpGui.HasProp("Hwnd") {
            capsHelpGui := DrawCapsHelpGui()
        }
        capsHelpGui.Show("NoActivate")
        capsHelpGuiVisible := true
    }
}

; Draw the CapsLock help GUI
DrawCapsHelpGui() {
    capsHelpGui := Gui("+E0x02000000 +E0x00080000")
    capsHelpGui.Opt("+AlwaysOnTop -Caption +ToolWindow +E0x20")  ; +E0x20 means enable click-through
    capsHelpGui.BackColor := "EEAA99"  ; Choose a color that won't appear in your capsKeyboardHelpImages
    capsHelpGui.Add("Picture", GetImgSizeOptions() . "vKeyboardImage", capsKeyboardHelpImages[currentImageIndex])
    capsHelpGui.Show("Hide")
    WinSetTransColor("EEAA99", capsHelpGui)
    return capsHelpGui
}

; Switch between keyboard help images
SwitchImage(direction) {
    global currentImageIndex, capsHelpGui
    if direction < 0 {
        currentImageIndex := Mod(currentImageIndex, imgNum) + 1
    } else {
        currentImageIndex := Mod(currentImageIndex - 2 + imgNum, imgNum) + 1
    }
    if capsHelpGui.HasProp("Hwnd") {
        capsHelpGui["KeyboardImage"].Value := capsKeyboardHelpImages[currentImageIndex]
    }
}

; Get the image display size options string
GetImgSizeOptions() {
    imgSize := CalculateImageSize()
    imgSizeOption := ""
    if imgSize.w {
        imgSizeOption .= "w" . imgSize.w
    }
    if imgSize.h {
        imgSizeOption .= imgSizeOption == "" ? "h" . imgSize.h : " h" . imgSize.h
    }
    if imgSizeOption != "" {
        imgSizeOption .= " "
    }
    return imgSizeOption
}

; Calculate the image display size
CalculateImageSize() {
    imgFileWidth := 0
    imgFileHeight := 0
    for imgPath in capsKeyboardHelpImages {
        size := GetImageSize(imgPath)
        width := size.w
        height := size.h
        imgFileWidth := width > imgFileWidth ? width : imgFileWidth
        imgFileHeight := height > imgFileHeight ? height : imgFileHeight
    }
    imgDisplayWidth := 0
    imgDisplayHeight := 0
    imgRatio := imgFileWidth / imgFileHeight
    if imgFileWidth > A_ScreenWidth and imgFileHeight < A_ScreenHeight {
        imgDisplayWidth := Round(A_ScreenWidth * 0.65)
        imgDispayHeight := Round(imgFileHeight / imgRatio)
    } else if imgFileWidth < A_ScreenWidth and imgFileHeight > A_ScreenHeight {
        imgDisplayWidth := Round(imgFileWidth * imgRatio)
        imgDisplayHeight := Round(A_ScreenHeight * 0.65)
    }
    return { w: imgDisplayWidth, h: imgDisplayHeight
    }
}

; Get the image original size
GetImageSize(imgPath) {
    GDIPToken := Gdip_Startup()
    pBM := Gdip_CreateBitmapFromFile(imgPath)
    width := Gdip_GetImageWidth(pBM)
    height := Gdip_GetImageHeight(pBM)
    Gdip_DisposeImage(pBM)
    Gdip_Shutdown(GDIPToken)
    return { w: width, h: height
    }
}
