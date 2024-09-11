currentLatitude := 37.7749
currentLongitude := 120.1551
currentTimezone := 8

; AutoDarkMode parameters (HHmm)
; Sunrise/sunset time will be updated every time after color mode is changed
sunrise := CalculateSunriseSunsetTime(currentLatitude, currentLongitude, currentTimezone)[1]
sunset := CalculateSunriseSunsetTime(currentLatitude, currentLongitude, currentTimezone)[2]
; Check interval (milliseconds)
autoDarkModeCheckInterval := 20 * 60 * 1000