#NoEnv
#SingleInstance Force

; --- REGISTRY PATHS (HKCU) ---
; :contentReference[oaicite:1]{index=1}
stateSubKey    := "Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount\Current\default$windows.data.bluelightreduction.bluelightreductionstate\windows.data.bluelightreduction.bluelightreductionstate"
settingsSubKey := "Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount\Current\default$windows.data.bluelightreduction.settings\windows.data.bluelightreduction.settings"

; Temp Constants
MIN_KELVIN := 1200   ; 100% warmth
MAX_KELVIN := 6500   ; 0% warmth

; ============================
;   HOTKEYS
; ============================

/*
; F9 -> Toggle Night Light
F9::
    NightLight_Toggle()
return

; F10 -> Forzar ON
F10::
    NightLight_Enable()
return

; F11 -> Forzar OFF
F11::
    NightLight_Disable()
return

; F12 -> Mostrar fuerza actual (0–100%)
F12::
    strength := NightLight_GetStrength()
    MsgBox, 64, Night Light, Intensidad actual: %strength%`%
return
*/

; ============================
;   API PRINCIPAL
; ============================

NightLight_Supported() {
    global stateSubKey, settingsSubKey
    RegRead, dummy, HKCU, %stateSubKey%, Data
    if (ErrorLevel)
        return 0
    RegRead, dummy, HKCU, %settingsSubKey%, Data
    return ErrorLevel ? 0 : 1
}

NightLight_ReadStateBytes() {
    global stateSubKey
    if (!NightLight_Supported())
        return ""
    RegRead, dataHex, HKCU, %stateSubKey%, Data
    if (ErrorLevel || dataHex = "")
        return ""
    return NightLight_HexToBytes(dataHex)
}

NightLight_IsEnabled() {
    bytes := NightLight_ReadStateBytes()
    if (!IsObject(bytes))
        return 0
    if (!bytes.HasKey(18))  ; index 18 (0x12) -> 0x15 = ON, 0x13 = OFF
        return 0
    return (bytes[18] = 0x15) ? 1 : 0
}

NightLight_Enable() {
    if (!NightLight_IsEnabled())
        return NightLight_Toggle()
    return 1
}

NightLight_Disable() {
    if (NightLight_IsEnabled())
        return NightLight_Toggle()
    return 1
}

NightLight_Toggle() {
    global stateSubKey

    if (!NightLight_Supported()) {
        MsgBox, 16, Night Light, Night Light not supported in this system.
        return 0
    }

    bytes := NightLight_ReadStateBytes()
    if (!IsObject(bytes)) {
        MsgBox, 16, Night Light, Night Light data cannot be read.
        return 0
    }

    enabled := NightLight_IsEnabled()
    len := bytes.Count()

    if (enabled) {
        ; ---- SHUTDOWN ----
        newLen := 41
        new := NightLight_MakeZeroArray(newLen)

        ; Copy data[0..21] -> new[0..21]
        copyLen := (len < 22) ? len : 22
        Loop, %copyLen% {
            idx := A_Index - 1
            new[idx] := bytes[idx]
        }

        ; Copy data[25..] -> new[23..]
        if (len > 25) {
            copyLen2 := len - 25
            if (copyLen2 > 18)
                copyLen2 := 18
            Loop, %copyLen2% {
                off := A_Index - 1
                new[23 + off] := bytes[25 + off]
            }
        }

        ; Shutdown Flag
        new[18] := 0x13
    } else {
        ; ---- TURN ON ----
        newLen := 43
        new := NightLight_MakeZeroArray(newLen)

        ; Copy data[0..21] -> new[0..21]
        copyLen := (len < 22) ? len : 22
        Loop, %copyLen% {
            idx := A_Index - 1
            new[idx] := bytes[idx]
        }

        ; Copy data[23..] -> new[25..]
        if (len > 23) {
            copyLen2 := len - 23
            if (copyLen2 > 18)
                copyLen2 := 18
            Loop, %copyLen2% {
                off := A_Index - 1
                new[25 + off] := bytes[23 + off]
            }
        }

        ; Turn on Flag + bytes 0x10 0x00
        new[18] := 0x15
        new[23] := 0x10
        new[24] := 0x00
    }

    ; Increment first byte between 10 y 14 and not being 0xFF (timestamp/version)
    Loop, 5 {
        i := 10 + (A_Index - 1)
        if (new.HasKey(i) && new[i] != 0xFF) {
            new[i] := (new[i] + 1) & 0xFF
            break
        }
    }

    hexNew := NightLight_BytesToHex(new)
    RegWrite, REG_BINARY, HKCU, %stateSubKey%, Data, %hexNew%
    if (ErrorLevel) {
        MsgBox, 16, Night Light, Error writing to registry.
        return 0
    }
    return 1
}

; --- Intensity (0–100%) ---

NightLight_GetStrength() {
    global settingsSubKey, MIN_KELVIN, MAX_KELVIN

    if (!NightLight_Supported())
        return 0

    RegRead, dataHex, HKCU, %settingsSubKey%, Data
    if (ErrorLevel || dataHex = "")
        return 0

    bytes := NightLight_HexToBytes(dataHex)
    if (!IsObject(bytes) || !bytes.HasKey(0x23) || !bytes.HasKey(0x24))
        return 0

    tempLo := bytes[0x23]
    tempHi := bytes[0x24]

    kelvin := tempHi * 64 + ((tempLo - 128) / 2.0)
    perc := NightLight_ConvertFromKelvin(kelvin)

    if (perc < 0)
        perc := 0
    if (perc > 100)
        perc := 100

    return Round(perc)
}

NightLight_SetStrength(percentage) {
    global settingsSubKey, MIN_KELVIN, MAX_KELVIN

    if (percentage < 0)
        percentage := 0
    if (percentage > 100)
        percentage := 100

    if (!NightLight_Supported())
        return 0

    RegRead, dataHex, HKCU, %settingsSubKey%, Data
    if (ErrorLevel || dataHex = "")
        return 0

    bytes := NightLight_HexToBytes(dataHex)
    if (!IsObject(bytes))
        return 0

    kelvin := NightLight_ConvertToKelvin(percentage)

    tempHi := Floor(kelvin / 64)
    tempLo := ((kelvin - (tempHi * 64)) * 2) + 128

    bytes[0x23] := Floor(tempLo) & 0xFF
    bytes[0x24] := Floor(tempHi) & 0xFF

    ; Update timestamp bytes 10-14
    Loop, 5 {
        i := 10 + (A_Index - 1)
        if (bytes.HasKey(i) && bytes[i] != 0xFF) {
            bytes[i] := (bytes[i] + 1) & 0xFF
            break
        }
    }

    hexNew := NightLight_BytesToHex(bytes)
    RegWrite, REG_BINARY, HKCU, %settingsSubKey%, Data, %hexNew%

    if (ErrorLevel) {
        MsgBox, 16, Night Light, Error al escribir en el registro (intensidad).
        return 0
    }
    return 1
}


; ============================
;   AUX FUNCTIONS
; ============================

NightLight_ConvertFromKelvin(kelvin) {
    global MIN_KELVIN, MAX_KELVIN
    return 100 - ((kelvin - MIN_KELVIN) / (MAX_KELVIN - MIN_KELVIN)) * 100
}

NightLight_ConvertToKelvin(percentage) {
    global MIN_KELVIN, MAX_KELVIN
    return MAX_KELVIN - (percentage / 100.0) * (MAX_KELVIN - MIN_KELVIN)
}

NightLight_MakeZeroArray(len) {
    arr := []
    Loop, %len% {
        idx := A_Index - 1
        arr[idx] := 0
    }
    return arr
}

NightLight_HexToBytes(hex) {
    hex := RegExReplace(hex, "\s")  ; remove spaces just in case
    arr := []
    strLen := StrLen(hex)
    if (strLen < 2)
        return arr

    idx := 0
    Loop, % (strLen // 2) {
        pos := (A_Index - 1) * 2 + 1
        byteHex := SubStr(hex, pos, 2)
        b := "0x" byteHex
        arr[idx] := b + 0
        idx++
    }
    return arr
}

NightLight_BytesToHex(arr) {
    hex := ""
    for idx, b in arr
        hex .= Format("{:02X}", b & 0xFF)
    return hex
}
