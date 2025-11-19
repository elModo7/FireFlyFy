#Include <Updater>
#Include <DownloadToFile>
#Include <Chalk>
#Include <FireFlyFy>
#Include <GUI_Funcs>
#Include <Gdip_All>

installResources(overWrite := 0) {
	global
	FileCreateDir, % A_Temp "\" appName
	FileInstall, res/ico/FireFlyFy.ico, % A_Temp "\" appName "\FireFlyFy.ico", % overWrite
	FileInstall, res/ico/download.ico, % A_Temp "\" appName "\download.ico", % overWrite
	FileInstall, res/ico/info.ico, % A_Temp "\" appName "\info.ico", % overWrite
	FileInstall, res/ico/close.ico, % A_Temp "\" appName "\close.ico", % overWrite
	FileInstall, res/ico/cogs.ico, % A_Temp "\" appName "\cogs.ico", % overWrite
	FileInstall, res/ico/enabled.ico, % A_Temp "\" appName "\enabled.ico", % overWrite
	FileInstall, res/ico/disabled.ico, % A_Temp "\" appName "\disabled.ico", % overWrite
	FileInstall, res/ico/appicon.ico, % A_Temp "\" appName "\appicon.ico", % overWrite
	FileInstall, res/img/FireFlyFy_FireFly.png, % A_Temp "\" appName "\FireFlyFy_FireFly.png", % overWrite
	FileInstall, res/img/FireFlyFy.png, % A_Temp "\" appName "\FireFlyFy.png", % overWrite
}

configureTray() {
	global
	Menu, Tray, NoStandard
	Menu, Tray, Icon, % A_Temp "\" appName "\FireFlyFy.ico"
	Menu, Tray, Tip, % getCustomToolTipByDate()
	Menu, Tray, Add, % "New " appName, addNewFireFlyFyWindow
	Menu, Tray, Icon, % "New " appName, % A_Temp "\" appName "\FireFlyFy.ico"
	Menu, Tray, Default, % "New " appName
	Menu, Tray, Add, % "Disable " appName, toggleFireFlyFy
	Menu, Tray, Icon, % "Disable " appName, % A_Temp "\" appName "\disabled.ico"
	Menu, Tray, Add, % "Manage app list", showAboutScreen ; TODO GUI
	Menu, Tray, Icon, % "Manage app list", % A_Temp "\" appName "\appicon.ico"
	Menu, Tray, Add,
	Menu, Tray, add, % "Settings", showSettingsGui
	Menu, Tray, Icon, % "Settings", % A_Temp "\" appName "\cogs.ico"
	Menu, Tray, Add, Look for Updates, lookForUpdates
	Menu, Tray, Icon, Look for Updates, % A_Temp "\" appName "\download.ico"
	Menu, Tray, add, % "About", showAboutScreen
	Menu, Tray, Icon, % "About", % A_Temp "\" appName "\info.ico"
	Menu, Tray, Add, Exit, ExitSub
	Menu, Tray, Icon, Exit, % A_Temp "\" appName "\close.ico"
	contextcolor(2) ;0=Default ;1=AllowDark ;2=ForceDark ;3=ForceLight ;4=Max
}

createOrReadConfig() {
	global
	if (!FileExist("config/global.json")) {
		createGlobalConfig()
	} else {
		FileRead, globalConfig, config/global.json
		globalConfig := JSON.Load(globalConfig)
	}
	if (!FileExist("config/apps.json")) {
		createAppsConfig()
	} else {
		FileRead, appsConfig, config/apps.json
		appsConfig := JSON.Load(appsConfig)
	}
}

createGlobalConfig() {
	global globalConfig, JSON
	globalConfig := {}
	globalConfig.language := "en-US"
	globalConfig.startWithWindows := 0
	globalConfig.progressive := 1
	globalConfig.experimentalReadFilter := 0
	globalConfig.lookForUpdates := 1
	FileAppend, % JSON.Dump(globalConfig, 1), config/global.json
}

createAppsConfig() {
	global appsConfig, JSON
	appsConfig := {}
	appsConfig.apps := []
	app := {}
	app.activeBy := "process"
	app.brightness := 30
	app.changeBrightness := 1
	app.name := "Notepad"
	app.process := "Notepad.exe"
	app.readMode := 1
	app.title := "New text document"
	app.nightLightStrength := 50
	appsConfig.apps.push(app)
	FileAppend, % JSON.Dump(appsConfig, 1), config/apps.json
}

; Unused
toggleVisibility() {
	global
	if isVisible
	{
		WinHide, % appName
		if(!nogui)
			Menu, tray, Rename, % "Hide " appName, % "Show " appName
		isVisible = 0
	}
	else
	{
		WinShow, % appName
		WinActivate, % appName
		if(!nogui)
			Menu, tray, Rename, % "Show " appName, % "Hide " appName
		isVisible = 1
	}
}

urlDownloadToVar(url,raw:=0,userAgent:="",headers:=""){
	if (!regExMatch(url,"i)https?://"))
		url:="https://" url
	try {
		hObject:=comObjCreate("WinHttp.WinHttpRequest.5.1")
		hObject.open("GET",url)
		if (userAgent)
			hObject.setRequestHeader("User-Agent",userAgent)
		if (isObject(headers)) {
			for i,a in headers {
				hObject.setRequestHeader(i,a)
			}
		}
		hObject.send()
		return raw?hObject.responseBody:hObject.responseText
	} catch e
		return % e.message
}

URLToVar(URL)
{
    ComObjError(0)
    WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    WebRequest.Open("GET", URL)
    WebRequest.Send()
    Return WebRequest.ResponseText()
}

showError(msg, isFatal := false) {
	if (isFatal) {
		MsgBox 0x10, Error, % msg "`n`n The app will now close."
		ExitApp
	} else {
		MsgBox 0x10, Error, % msg
	}
}

contextcolor(color:=2) ; change the number here from the list above if you want light mode
{
	static uxtheme := DllCall("GetModuleHandle", "str", "uxtheme", "ptr")
	static SetPreferredAppMode := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 135, "ptr")
	static FlushMenuThemes := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 136, "ptr")
	DllCall(SetPreferredAppMode, "int", color)
	DllCall(FlushMenuThemes)
}

trayEventsCapture(wParam, lParam) {
	if (lParam == 0x201) {
		; TODO new FireFlyFy window entry
	} else if (lParam == 0x205) {
		Menu, Tray, Show
	}
	return 0
}

getCustomToolTipByDate() {
	global appName
	customToolTipText := ""
	if (A_MM == 2 && A_DD == 14) {
		customToolTipText := "❤"
	} else if (A_MM == 10 || (A_MM == 11 && A_DD <= 5)) {
		customToolTipText := "🎃"
	} else if (A_MM == 12 && A_DD == 25) {
		customToolTipText := "🎄"
	} else if ((A_MM == 12 && A_DD == 31) || (A_MM == 1 && A_DD == 1)) {
		customToolTipText := "🎇"
	} else {
		customToolTipText := "🕯"
	}
	return % customToolTipText " " appName
}

; Deprecated, too overloaded
getCustomToolTipByDateAndSeason() {
	global appName
	customToolTipText := ""
	if (A_MM == 1 && A_DD > 7) {
		customToolTipText := "⛄"
	} else if (A_MM == 2 && A_DD == 14) {
		customToolTipText := "❤"
	} else if (A_MM > 3 && A_MM < 6) {
		customToolTipText := "🌿"
	} else if (A_MM > 5 && A_MM < 9) {
		customToolTipText := "🏖"
	} else if (A_MM == 10 || (A_MM == 11 && A_DD <= 5)) {
		customToolTipText := "🎃"
	} else if (A_MM == 11) {
		customToolTipText := "🍂"
	} else if ((A_MM == 12 && A_DD == 31) || (A_MM == 1 && A_DD == 1)) {
		customToolTipText := "🎇"
	} else if (A_MM == 12 || (A_MM == 1 && A_DD <= 7)) {
		customToolTipText := "🎄"
	}
	return % "🕯 " appName " " customToolTipText
}

; New Window FireFlyFy detection flow
addNewFireFlyFyWindow() {
	global
	MsgBox,,Select Window, % "1) Activate a window you want " appName " to detect.`n2) Press Enter to configure it`n`nEsc: Cancel"
	HotKey, Enter, detectOpenProgram, On
	HotKey, Esc, detectOpenProgramCancel, On
	SetTimer, fireFlyFollowMouse, 10
}

detectOpenProgram() {
	global
	WinGetActiveTitle, selectedWindowTitle
	WinGet, selectedProcessName, ProcessName, A
	Hotkey, Enter, DetectOpenProgram, Off
	removeMouseFollower()
	appConfiguration(selectedWindowTitle, selectedProcessName)
}

detectOpenProgramCancel() {
	global
	HotKey, Enter, detectOpenProgram, Off
	HotKey, Esc, detectOpenProgramCancel, Off
	removeMouseFollower()
}

; Translations
getLanguages() {
	global JSON
	FileRead, languages, res\translations\list.json
	return JSON.load(languages).languages
}

getLanguagesForDropDown() {
	languages := getLanguages()
	langOutput := ""
	for langK, langV in languages
	{
		langOutput .= langV.language (langK < languages.length() ? "|" : "")
	}
	return langOutput
}

loadTranslations(curLang) {
	global
	; TODO
	;~ FileRead, translations, res\translations\list.json
}