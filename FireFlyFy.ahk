;@Ahk2Exe-SetName FireFlyFy
;@Ahk2Exe-SetDescription Changes monitor brightness based on active window.
;@Ahk2Exe-SetVersion 1.0.0
;@Ahk2Exe-SetCopyright Copyright (c) 2025`, elModo7 - VictorDevLog
;@Ahk2Exe-SetOrigFilename FireFlyFy.exe
#NoEnv
#SingleInstance Force
#Persistent
SetTitleMatchMode, 3
DetectHiddenWindows, On
SetBatchLines -1
CoordMode, Mouse, Screen
global version := "0.1.3"
global appName := "FireFlyFy"

; Libs
#Include <Screen>
#Include <cJSON>
#Include <Utils>
#Include <AboutScreen>
#Include <WindowsNightLight>

; Globals
global initialBrightness, appPrev, processPrev, globalConfig, appsConfig, isVisible := 1, fireFlyFyEnabled := 1

; Init
createOrReadConfig()
loadTranslations(globalConfig.language)
installResources()
setInitialBrigthness()
configureTray()
createNightFilter()

Gui +LastFound 
hWnd := WinExist()
DllCall("RegisterShellHookWindow", UInt, hWnd)
registerWindowMessageId := DllCall("RegisterWindowMessage", Str, "SHELLHOOK")
OnMessage(0x404, "trayEventsCapture")

enableFireFlyFy()
gosub, initMouseFollower
return

detectWindowChanged(wParam, lParam)
{
	; https://learn.microsoft.com/en-us/previous-versions/windows/desktop/legacy/ms644991(v=vs.85)
	if ((wParam > 0 && wParam < 5) || wParam == 6 || wParam == 32772) {
		Settimer, checkCurrentApp, 100
	}
}

checkCurrentApp:
	Settimer, checkCurrentApp, Off
	WinGetActiveTitle, appCur
	WinGet, processCur, ProcessName, A
	if (appCur != appPrev || processCur != processPrev) {
		appPrev := appCur
		processPrev := processCur
		for appK, appV in appsConfig.apps
		{
			if (appV.activeBy == "process") {
				if (processCur == appV.process) {
					applyFireFlyFy(appV)
					return
				}
			} else {
				if (appCur == appV.title) {
					applyFireFlyFy(appV)
					return
				}
			}
		}
		removeFireFlyFy()
	}
return

#Include <LabelUtils>

^Esc::Reload

/* TODO:
Add window / process -> FireFly follows mouse when choosing, enter chooses, escape cancels
title or processName (default by process)
brightnessValue 0-100 (default 50)
nightLightStrength 0-100 (default 50)
Block that if you have by title of the same process, you can not add a rule by process unless you remove the ones by title before, maybe prompt of those that match and offer removing?


application list

Start with windows (default no)
Scheduler (default no)
progressive change yes/no (default yes)
multilingual
Clear config

Update, autoreplace running executable
Add CLI
*/