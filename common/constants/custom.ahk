; System drive letter (e.g. C:)
C_SystemDriveLetter := SubStr(A_WinDir, 1, 2)

; Local app data path (e.g. C:\Users\<username>\AppData\Local)
C_LocalAppData := EnvGet("LocalAppData")

; Program Files x86 path (e.g. C:\Program Files (x86))
C_ProgramFilesx86 := EnvGet("ProgramFiles(x86)")

/**
 * Map of keyboard layouts (IME input languages) and their corresponding IDs
 */
C_IMEInputLanguage := Map(
    "en_us", 0x4090409,
    "zh_cn", 0x8040804
)