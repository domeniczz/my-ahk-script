; Speed of infinite scrolling (* times faster than normal scroll)
; It will increases non-linearly based on the number of consecutive scroll wheel movements in the same direction
baseScrollSpeed := 1.4

/**
 * List (Map) of programs to exclude for AHK usage
 * 
 * Key:
 * 
 * - application executable name (String)
 * 
 * Value:
 * 
 * - `true` if the application should be excluded, `false` otherwise
 */
excludedProgramList := [
    ; Counter-Strike: Global Offensive
    "cs2.exe",
    "csgo_legacy_app.exe",
    "csgo.exe",
    ; Apex Legends
    "r5apex.exe",
    ; Call of Duty
    "cod.exe",
    ; Overwatch
    "Overwatch.exe",
    ; PUBG
    "ExecPubg.exe",
    ; Dota 2
    "dota2.exe",
    ; Red Dead Redemption 2
    "RDR2.exe",
    ; Grand Theft Auto V
    "GTA5.exe",
    ; Black Myth: Wukong
    "b1.exe",
    ; Forza Horizon 4
    "ForzaHorizon4.exe",
    ; Forza Horizon 5
    "ForzaHorizon5.exe",
    ; Civilization VI
    "CivilizationVI.exe",
    ; Stardew Valley
    "Stardew Valley.exe",
    ; Terraria
    "Terraria.exe",
    ; Real Pool 3D - Poolians
    "Poolians.exe",
    ; 3DMark
    "3DMark.exe"
]

/**
 * List (Map) of applications to exclude when searching topmost window
 * 
 * Key:
 * 
 * - application executable name (String)
 * 
 * Value:
 * 
 * - `true` if the application should be excluded, `false` otherwise
 */
excludedWindowList := [
    "StartMenuExperienceHost.exe",
    "Lyricify for Spotify.exe",
    "AutoHotkey64.exe"
]