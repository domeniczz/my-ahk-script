/**
 * Get the colors in a grid of specified size around a specified pixel.
 * 
 * @param {Integer} gridSize - The size of the grid (default: 1)
 * - 1 = 1 pixel
 * - 2 = 2 x 2 grid
 * - 3 = 3 x 3 grid
 * - ...
 * @param {Integer} x - The x-coordinate of the center pixel (default: -1)
 * @param {Integer} y - The y-coordinate of the center pixel (default: -1)
 * 
 * @returns {Map} - A map of the colors in the grid, with the `key` being the pixel coordinates and the `value` being the color. (e.g. `Map("1,2", "OxFFFFFF")`)
 */
GetPixelColors(gridSize := 1, x := -1, y := -1) {
    ; Get current mouse position if coordinates are not specified
    if x == -1 and y == -1 {
        MouseGetPos(&x, &y)
    }

    ; Initialize a map to store all colors
    colorData := Map()

    ; Determine the pixelrange
    range := GetPixelRange(gridSize)

    ; Loop through pixels
    for offsetX in range {
        for offsetY in range {
            pixelX := x + offsetX
            pixelY := y + offsetY

            color := PixelGetColor(pixelX, pixelY)
            colorData.Set(pixelX . "," . pixelY, color)
        }
    }

    return colorData

    /**
     * Get the range of pixels based on the grid size.
     * 
     * @param {Integer} gridSize - The size of the grid
     * 
     * @returns {Array} - The range of pixels offset from the center (e.g. [-1, 0, 1] for a 3 x 3 grid)
     */
    GetPixelRange(gridSize) {
        if gridSize == 1 {
            return [0
            ]
        }
        halfSize := Floor((gridSize - 1) / 2)
        range := []
        loop halfSize {
            range.Push(-A_Index)
        }
        range.Push(0)
        loop halfSize {
            range.Push(A_Index)
        }
        return range
    }
}

/**
 * Check if color is within a specified range.
 * 
 * @param {String} color - The color to check. Accepts `String` in hexadecimal format "0xRRGGBB", or a `Map` returned by `GetPixelColors` (e.g. `Map("1,2", "OxFFFFFF")`).
 * @param {Object} range - An object specifying the min and max values for each component. Format: {r: {min: 0, max: 255}, g: {min: 0, max: 255}, b: {min: 0, max: 255}}
 * 
 * @returns {Boolean} - True if the color is within the specified range, false otherwise.
 */
IsColorInRange(color, range) {
    isInRange := false

    if IsObject(color) {
        for key, value in color {
            ; Convert the color string to RGB components
            r := (value >> 16) & 0xFF
            g := (value >> 8) & 0xFF
            b := value & 0xFF

            ; Check if each component is within its specified range
            if (r >= range.r.min and r <= range.r.max) and
                (g >= range.g.min and g <= range.g.max) and
                (b >= range.b.min and b <= range.b.max) {
                isInRange := true
            } else {
                isInRange := false
                break
            }
        }
    } else {
        r := (color >> 16) & 0xFF
        g := (color >> 8) & 0xFF
        b := color & 0xFF

        isInRange := (r >= range.r.min and r <= range.r.max) and
            (g >= range.g.min and g <= range.g.max) and
            (b >= range.b.min and b <= range.b.max)
    }

    return isInRange
}
