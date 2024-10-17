/**
 * Loop to execute a given callback function repeatedly until it returns `true` or the maximum number of attempts is reached. Default loop interval is 50 * 200ms = 10s.
 * 
 * The callback function should return `true` if the condition is met and want to break the loop, `false` otherwise.
 * 
 * @param {Function} callbackFunc - The function to be called on each iteration.
 * @param {Integer} maxAttempts - The maximum number of times to call the callback function (default: 50)
 * @param {Integer} sleepDuration - The time in milliseconds to wait between attempts (default: 200)
 * 
 * @returns {Boolean} - Returns `true` if the callback function succeeds within given attempts, `false` otherwise.
 * 
 * @throws {Error} - If `callbackFunc` is not a function
 */
LoopLogic(callbackFunc, maxAttempts := 50, sleepDuration := 200) {
    if !(callbackFunc is Func) {
        throw Error("Invalid callback function")
    }
    maxAttempts := Max(1, maxAttempts)
    loop maxAttempts {
        res := callbackFunc()
        if res {
            return res
        }
        maxAttempts--
        if sleepDuration > 0 {
            Sleep sleepDuration
        }
    }
    return false
}
