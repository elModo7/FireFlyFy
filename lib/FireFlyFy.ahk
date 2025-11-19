applyFireFlyFy(targetApp) {
	global
	if (targetApp.changeBrightness && targetApp.brightness != "") {
		if (globalConfig.progressive) {
			setMonitorBrightnessProgressive(targetApp.brightness)
		} else {
			setMonitorBrightness(targetApp.brightness)
		}
	} else {
		if (getMonitorBrightness() != initialBrightness) {
			if (globalConfig.progressive) {
				setMonitorBrightnessProgressive(initialBrightness)
			} else {
				setMonitorBrightness(initialBrightness)
			}
		}
	}
	
	if (targetApp.readMode) {
		if (experimentalReadFilter) {
			showReadFilter(1)
			if (NightLight_IsEnabled()) {
				NightLight_Disable()
			}
		} else {
			showReadFilter(0)
			if (globalConfig.progressive) {
				if (NightLight_IsEnabled()) {
					NightLight_SetStrengthProgressive(targetApp.nightLightStrength)
				} else {
					NightLight_SetStrengthProgressive(0, 1, 1)
					NightLight_Enable()
					NightLight_SetStrengthProgressive(targetApp.nightLightStrength, 0)
				}
			} else {
				NightLight_SetStrength(targetApp.nightLightStrength)
				if (!NightLight_IsEnabled()) {
					NightLight_Enable()
				}
			}
		}
	} else {
		if (experimentalReadFilter)
			showReadFilter(0)
		else {
			if (NightLight_IsEnabled()) {
				if (globalConfig.progressive) {
					NightLight_SetStrengthProgressive(0)
				}
				NightLight_Disable()
			}
		}
	}
}

removeFireFlyFy() {
	global
	if (experimentalReadFilter)
		showReadFilter(0)
	else {
		if (NightLight_IsEnabled()) {
			if (globalConfig.progressive) {
				NightLight_SetStrengthProgressive(0)
			}
			NightLight_Disable()
		}
	}
	if (globalConfig.progressive) {
			setMonitorBrightnessProgressive(initialBrightness)
	} else {
		setMonitorBrightness(initialBrightness)
	}
}

setInitialBrigthness() {
	global initialBrightness
	initialBrightness := getMonitorBrightness()
}

enableFireFlyFy() {
	global
	if (!fireFlyFyEnabled) {
		Menu, Tray, Rename, % "Enable " appName, % "Disable " appName
		Menu tray, Icon, % "Disable " appName, % A_Temp "\" appName "\disabled.ico"
	}
	fireFlyFyEnabled := 1
	OnMessage(registerWindowMessageId, "detectWindowChanged")
}

disableFireFlyFy() {
	global
	if (fireFlyFyEnabled) {
		Menu, Tray, Rename, % "Disable " appName, % "Enable " appName
		Menu tray, Icon, % "Enable " appName, % A_Temp "\" appName "\enabled.ico"
	}
	fireFlyFyEnabled := 0
	OnMessage(registerWindowMessageId, "")
}

toggleFireFlyFy() {
	global fireFlyFyEnabled
	if (fireFlyFyEnabled)
		disableFireFlyFy()
	else
		enableFireFlyFy()
}

showReadFilter(status) {
	if (status)
		WinShow, nightFilter
	else
		WinHide, nightFilter
}

createNightFilter() {
	global nightFilter
	Gui, nightFilter:+AlwaysOnTop +ToolWindow -Caption -DPIScale +E0x20
	Gui, nightFilter:Color, 0xFFFFEB
	Gui, nightFilter:Show, x0 y0 w1920 h1080 NoActivate Hide, nightFilter
	WinWait, nightFilter
	WinSet, Transparent, 35, nightFilter
}

removeMouseFollower() {
	global
	SetTimer, fireFlyFollowMouse, Off
	Gdip_GraphicsClear(G1)
	UpdateLayeredWindow(hwnd1, hdc1, OutputVarX-100, OutputVarY-50, 145, 100)
}

fireFlyFollowMouse() {
	global
	MouseGetPos, OutputVarX, OutputVarY
	Gdip_GraphicsClear(G1)
	Gdip_DrawImage(G1, pBitmap1, 0, 0, 50, 50, 0, 0, Width1, Height1)
	UpdateLayeredWindow(hwnd1, hdc1, OutputVarX+10, OutputVarY-50, 50, 50)
}