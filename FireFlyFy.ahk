;@Ahk2Exe-SetName FireFlyFy
;@Ahk2Exe-SetDescription Changes monitor brightness based on active window.
;@Ahk2Exe-SetVersion 1.0.0
;@Ahk2Exe-SetCopyright 2025 elModo7 - VictorDevLog
;@Ahk2Exe-SetOrigFilename FireFlyFy.exe
;~ ;@Ahk2Exe-ConsoleApp ; Only for CLI Mode (maybe for a future revision as I will already be releasing a standalone CLI binary)
#NoEnv
#SingleInstance Force
#Persistent
SetTitleMatchMode, 3
DetectHiddenWindows, On
SetBatchLines -1
CoordMode, Mouse, Screen
FileEncoding, UTF-8
global version := "1.0.0"
global appName := "FireFlyFy"

; Libs
#Include <Screen>
#Include <cJSON>
#Include <i18n>
#Include <Utils>
#Include <AboutScreen>
#Include <WindowsNightLight>

; Globals
global initialBrightness, appPrev, processPrev, globalConfig, appsConfig, isVisible := 1, fireFlyFyEnabled := 1
global curLang := {}, langC, languages

; Languages
getLanguages()
i18n := new i18n("", "en_US", ["en_US"])
loadTranslations()

; Init
initCLIMessages()
createOrReadConfig()
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
OnExit, ExitSub
globalConfig.lookForUpdates ? lookForUpdates(1) : ""
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
			if (appV.activeBy == "title") {
				if (appCur == appV.title) {
					applyFireFlyFy(appV)
					return
				}
			} else {
				if (processCur == appV.process) {
					applyFireFlyFy(appV)
					return
				}
			}
		}
		removeFireFlyFy()
	}
return

#Include <LabelUtils>

/* TODO:
Scheduler (default no)
Update, autoreplace running executable
Add CLI
*/