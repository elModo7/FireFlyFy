#Include <Updater>
#Include <DownloadToFile>
#Include <Chalk>
#Include <ConsoleMessages>
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
	Menu, Tray, DeleteAll
	Menu, Tray, Icon, % A_Temp "\" appName "\FireFlyFy.ico"
	Menu, Tray, Tip, % getCustomToolTipByDate()
	Menu, Tray, Add, % i18n.t("tray_new_app", {app: appName}), addNewFireFlyFyWindow
	Menu, Tray, Icon, % i18n.t("tray_new_app", {app: appName}), % A_Temp "\" appName "\FireFlyFy.ico"
	Menu, Tray, Default, % i18n.t("tray_new_app", {app: appName})
	if (fireFlyFyEnabled) {
		Menu, Tray, Add, % i18n.t("tray_disable_app", {app: appName}), toggleFireFlyFy
		Menu, Tray, Icon, % i18n.t("tray_disable_app", {app: appName}), % A_Temp "\" appName "\disabled.ico"
	} else {
		Menu, Tray, Add, % i18n.t("tray_enable_app", {app: appName}), toggleFireFlyFy
		Menu, Tray, Icon, % i18n.t("tray_enable_app", {app: appName}), % A_Temp "\" appName "\enabled.ico"
	}
	Menu, Tray, Add, % i18n.t("tray_manage_app_list"), appManagementConfigurationGui
	Menu, Tray, Icon, % i18n.t("tray_manage_app_list"), % A_Temp "\" appName "\appicon.ico"
	Menu, Tray, Add
	Menu, Tray, Add, % i18n.t("tray_settings"), showSettingsGui
	Menu, Tray, Icon, % i18n.t("tray_settings"), % A_Temp "\" appName "\cogs.ico"
	Menu, Tray, Add, % i18n.t("tray_look_for_updates"), lookForUpdates
	Menu, Tray, Icon, % i18n.t("tray_look_for_updates"), % A_Temp "\" appName "\download.ico"
	Menu, Tray, Add, % i18n.t("tray_about"), showAboutScreen
	Menu, Tray, Icon, % i18n.t("tray_about"), % A_Temp "\" appName "\info.ico"
	Menu, Tray, Add, % i18n.t("tray_exit"), ExitSub
	Menu, Tray, Icon, % i18n.t("tray_exit"), % A_Temp "\" appName "\close.ico"
	contextcolor(2) ;0=Default ;1=AllowDark ;2=ForceDark ;3=ForceLight ;4=Max
}

createOrReadConfig() {
	global
	if (!FileExist("config/global.json")) {
		createGlobalConfig()
		getCurrentLanguage()
	} else {
		FileRead, globalConfig, config/global.json
		globalConfig := JSON.Load(globalConfig)
		getCurrentLanguage()
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
	Gui, settings:Destroy
	FileDelete, config/global.json
	globalConfig := {}
	globalConfig.language := "en_US"
	globalConfig.startWithWindows := 0
	globalConfig.progressive := 1
	globalConfig.experimentalReadFilter := 0
	globalConfig.lookForUpdates := 1
	globalConfig.scheduler := 0
	globalConfig.schedulerFrom := ""
	globalConfig.schedulerUntil := ""
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
		MsgBox 0x10, Error, % msg "`n`n " i18n.t("the_app_will_now_close")
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
		addNewFireFlyFyWindow()
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
	MsgBox, 0x40, % i18n.t("select_window"), % i18n.t("activate_a_window_you_want_firefly_to_detect", {app: appName})
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
	global JSON, languages
	languages := []
	Loop, Files, res\translations\*.json
	{
		newLang := {}
		FileRead, langJson, % A_LoopFileFullPath
		lang := JSON.Load(langJson)
		newLang.langName := lang.language_name
		newLang.langCode := lang.language_code
		languages.push(newLang)
	}
}

getLanguagesForDropDown() {
	global languages
	langOutput := ""
	for langK, langV in languages
	{
		langOutput .= langV.langName (langK < languages.length() ? "|" : "")
	}
	return langOutput
}

getCurrentLanguage() {
	global
	curLang := {}
	for langK, lang in languages
	{
		if (lang.langCode == globalConfig.language) {
			curLang := lang
		}
	}
	if (curLang.langCode == "") {
		curLang.langCode := "en_US"
		curLang.langName := "English"
	}
	i18n.SetLocale(globalConfig.language)
}

getLanguageFromDropDown(langName) {
	global
	selectedLang := {}
	for langK, lang in languages
	{
		if (lang.langName == langName) {
			selectedLang := lang
		}
	}
	if (selectedLang.langCode == "") {
		selectedLang.langCode := "en_US"
		selectedLang.langName := "English"
	}
	return selectedLang
}

getLanguageToChooseDropDown() {
	global
	selectedLanguageKey := 1
	for langK, lang in languages
	{
		if (lang.langCode == globalConfig.language) {
			selectedLanguageKey := langK
		}
	}
	return selectedLanguageKey
}

loadTranslations() {
	global
	Loop, Files, res\translations\*.json
	{
		i18n.LoadFile(A_LoopFileFullPath)
	}
}