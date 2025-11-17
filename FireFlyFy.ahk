;@Ahk2Exe-SetName FireFlyFy
;@Ahk2Exe-SetDescription Changes monitor brightness based on active window.
;@Ahk2Exe-SetVersion 0.0.1
;@Ahk2Exe-SetCopyright Copyright (c) 2025`, elModo7 - VictorDevLog
;@Ahk2Exe-SetOrigFilename FireFlyFy.exe
#NoEnv
#SingleInstance Force
#Persistent
DetectHiddenWindows, On
SetBatchLines -1
#Include <Screen>
#Include <cJSON>
#Include <aboutScreen>
#Include <WindowsNightLight>
global version := "0.1"
global appName := "FireFlyFy"
global appPrev, globalSettings, apps

gosub, configureTray
gosub, createOrReadConfig
createNightFilter()

SetTimer, checkCurrentApp, 500
;WinShow, nightFilter
NightLight_Toggle()
Sleep, 2000
NightLight_Toggle()
return

checkCurrentApp:
	;WinGetActiveTitle, activeTitle
	;WinGet, activeProcess, ProcessName
	if (appCur != appPrev) {
		; setMonitorBrightnessProgressive(0)
	}
	appPrev := appCur
return

configureTray:
	Menu, Tray, NoStandard
	Menu, Tray, Tip, % appName "v" version
	Menu, Tray, Add,
	Menu, tray, add, % appName " Info", showAboutScreen
	;Menu tray, Icon, % appName " Info", % A_Temp "\" appName "\info.ico"
	Menu, Tray, Add, Exit, ExitSub
	;Menu tray, Icon, Exit, % A_Temp "\" appName "\close3.ico"
return

createOrReadConfig:
	if (!FileExist("config/global.json")) {
		createConfig()
	} else {
		FileRead, globalSettings, config/global.json
		globalSettings := JSON.Load(globalSettings)
	}
return

createConfig() {
	globalSettings := {}
	globalSettings.language := "en-US"
	globalSettings.startWithWindows := 0
	FileAppend, % JSON.Dump(globalSettings), config/global.json
}

createNightFilter() {
	global
	Gui, nightFilter:+AlwaysOnTop +ToolWindow -Caption -DPIScale +E0x20
	Gui, nightFilter:Color, 0xFFFFEB
	Gui, nightFilter:Show, x0 y0 w1920 h1080 NoActivate Hide, nightFilter
	WinWait, nightFilter
	WinSet, Transparent, 35, nightFilter
}

showAboutScreen:
	showAboutScreen(appName " v" version, "Changes your monitor brightness automatically based on the currently active window.")
return

aboutGuiEscape:
aboutGuiClose:
	AboutGuiClose()
return

ExitSub:
	ExitApp

/*
toggleable hotkey
trayMenu
title or processName
brightnessValue 0-100
progressive change yes/no
add about
*/