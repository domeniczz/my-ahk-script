/**
 * Calculate the time interval between two times in "HHmm" format and return the result in the specified format.
 * If the endTime is earlier than the startTime, it is assumed to be the next day.
 * 
 * @param {Number} startTime - The start time in "HHmm" format
 * @param {Number} endTime - The end time in "HHmm" format
 * @param {String} result - The format in which to return the time interval (default: "minutes"). Accepts "hours", "minutes", "seconds", or "miliseconds".
 * 
 * @returns {Number} - The time interval between the two times in the specified format
 * 
 * @throws {ValueError} - If `startTime` or `endTime` is not in "HHmm" format
 * @throws {ValueError} - If `result` is not a valid format
 */
CalculateTimeInterval(startTime, endTime, result := "minutes") {
    ; Convert HHmm to minutes since midnight
    if StrLen(startTime) == 4 {
        startMinutes := (SubStr(startTime, 1, 2) * 60) + SubStr(startTime, 3)
    } else if StrLen(startTime) == 3 {
        startMinutes := (SubStr(startTime, 1, 1) * 60) + SubStr(startTime, 2)
    } else {
        throw ValueError("Invalid startTime format")
    }

    if StrLen(endTime) == 4
        endMinutes := (SubStr(endTime, 1, 2) * 60) + SubStr(endTime, 3)
    else if StrLen(endTime) == 3
        endMinutes := (SubStr(endTime, 1, 1) * 60) + SubStr(endTime, 2)
    else
        throw ValueError("Invalid endTime format")

    ; Calculate the difference
    diffMinutes := endMinutes - startMinutes

    ; Handle crossing midnight
    if diffMinutes < 0
        diffMinutes += 1440  ; Add minutes in a day (24 * 60)

    ; Convert back to HHmm format
    hours := Floor(diffMinutes / 60)
    minutes := Mod(diffMinutes, 60)

    switch result {
        case "hours": return hours + minutes / 60
        case "minutes": return hours * 60 + minutes
        case "seconds": return hours * 3600 + minutes * 60
        case "miliseconds": return (hours * 3600 + minutes * 60) * 1000
        default: throw ValueError("Invalid result format")
    }
}

/**
 * Calculates sunrise and sunset times for a given location and date.
 * 
 * @param {Number} latitude - Latitude of the location (-90 to 90)
 * @param {Number} longitude - Longitude of the location (-180 to 180)
 * @param {Number} timezone - Timezone offset from UTC (-12 to 14)
 * 
 * @returns {Array} - An array containing [sunrise, sunset] times in "HHmm" format
 */
CalculateSunriseSunsetTime(latitude, longitude, timezone) {
    ; Constants
    rad := 0.017453292519943295 ; PI/180
    zenith := 90.83333333333333 ; Solar zenith for sunrise/sunset

    ; Get current date
    date := A_Now
    year := FormatTime(date, "yyyy")
    month := FormatTime(date, "M")
    day := FormatTime(date, "d")

    ; Calculate day of year
    n1 := Floor((275 * month) / 9)
    n2 := Floor((month + 9) / 12)
    n3 := (1 + Floor((year - 4 * Floor(year / 4) + 2) / 3))
    n := n1 - (n2 * n3) + day - 30

    ; Calculate solar noon
    lngHour := longitude / 15
    t := n + ((6 - lngHour) / 24)
    m := (0.9856 * t) - 3.289

    ; Calculate sun's true longitude
    l := m + (1.916 * Sin(rad * m)) + (0.020 * Sin(2 * rad * m)) + 282.634
    l := Mod(l + 360, 360)

    ; Calculate sun's right ascension
    y := 0.91764 * Sin(rad * l)
    x := Cos(rad * l)
    ra := ATan(y / x) / rad
    if x < 0
        ra += 180
    else if y < 0
        ra += 360
    ra := Mod(ra + 360, 360)

    ; Adjust right ascension to same quadrant as L
    lQuadrant := Floor(l / 90) * 90
    raQuadrant := Floor(ra / 90) * 90
    ra := ra + (lQuadrant - raQuadrant)

    ; Convert RA to hours
    ra /= 15

    ; Calculate sun's declination
    sinDec := 0.39782 * Sin(rad * l)
    cosDec := Cos(ASin(sinDec))

    ; Calculate sun's local hour angle
    cosH := (Cos(rad * zenith) - (sinDec * Sin(rad * latitude))) / (cosDec * Cos(rad * latitude))

    ; Calculate sunrise and sunset times
    h := ACos(cosH) / rad
    sunrise := ((360 - h) / 15) + ra - (0.06571 * t) - 6.622 - lngHour + timezone
    sunset := (h / 15) + ra - (0.06571 * t) - 6.622 - lngHour + timezone

    ; Adjust for 24-hour time
    sunrise := Mod(sunrise + 24, 24)
    sunset := Mod(sunset + 24, 24)

    ; Convert to HHmm format
    sunriseTime := DecimalToHHmm(sunrise)
    sunsetTime := DecimalToHHmm(sunset)

    DecimalToHHmm(decimalTime) {
        hours := Floor(decimalTime)
        minutes := Round((decimalTime - hours) * 60)
        if minutes == 60 {
            hours += 1
            minutes := 0
        }
        return Format("{:02}{:02}", Mod(hours, 24), minutes)
    }

    return [sunriseTime, sunsetTime
    ]
}
