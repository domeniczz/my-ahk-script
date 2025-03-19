/**
 * Create an array with a given size, all elements are `unset`.
 * 
 * @param {Integer} size - The size of the array
 * 
 * @returns {Array} - The created array
 */
CreateArray(size) {
    arr := []
    loop size {
        arr.Push(unset)
    }
    return arr
}

/**
 * Print the array in a human readable format with MsgBox.
 * 
 * @param {Array} arr - The array to print
 */
PrintArray(arr) {
    arrStr := ""
    for index, val in arr {
        arrStr .= index . ": " . val . "`n"
    }
    MsgBox arrStr
}

/**
 * Check if the value exists in the list.
 * 
 * @param {Object} list - The list to search in
 * @param {String} value - The value to search for
 * 
 * @returns {Integer} - The index of the value in the list, `0` if the value is not in the list
 * 
 * @throws {Error} - If `list` is not an valid object
 */
HasVal(list, value) {
    if !IsObject(list) {
        throw Error("Invalid list")
    }
    for index, val in list {
        if val == value {
            return index
        }
    }
    return 0
}

/**
 * Reverse the array, without mutating the original array, return a new array.
 * 
 * @param {Array} arr - The array to reverse
 * 
 * @returns {Array} - The reversed array
 */
ReverseArray(arr) {
    reversed := []
    for item in arr {
        reversed.InsertAt(1, item)
    }
    return reversed
}

/**
 * Reverse the array in place, mutating the original array.
 * 
 * @param {Array} arr - The array to reverse
 */
ReverseArrayInPlace(arr) {
    left := 1
    right := arr.Length
    while left < right {
        tmp := arr[left]
        arr[left] := arr[right]
        arr[right] := tmp
        left++
        right--
    }
}
