/**
 * Check if the value is in the array.
 * 
 * @param {Object} array - The array to search in
 * @param {String} value - The value to search for
 * @returns {Integer} - The index of the value in the array, `0` if the value is not in the array
 */
HasVal(array, value) {
    if !(IsObject(array))
        throw
    for index, val in array {
        if (val = value) {
            return index
        }
    }
    return 0
}
