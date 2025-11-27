; ************************************************************
; SETTINGS
; ************************************************************
showSettingsGui() {
    global
    Gui settings:+hWndhMainWnd
    Gui settings:Add, CheckBox, x16 y16 w140 h30 vstartWithWindows, % i18n.t("start_with_windows")
	GuiControl, settings:, startWithWindows, % globalConfig.startWithWindows
    Gui settings:Add, CheckBox, x16 y48 w140 h30 vprogressiveChanges, % i18n.t("progressive_changes")
	GuiControl, settings:, progressiveChanges, % globalConfig.progressive
    Gui settings:Add, CheckBox, x16 y80 w140 h30 +Disabled vexperimentalReadFilter, % i18n.t("experimental_read_filter")
	GuiControl, settings:, experimentalReadFilter, % globalConfig.experimentalReadFilter
    Gui settings:Add, CheckBox, x16 y112 w140 h30 vlookForUpdates, % i18n.t("look_for_updates_on_boot")
	GuiControl, settings:, lookForUpdates, % globalConfig.lookForUpdates
    Gui settings:Add, CheckBox, x16 y144 w140 h30 +Disabled vscheduler gtoggleScheduler, % i18n.t("enable_scheduler")
	GuiControl, settings:, scheduler , % globalConfig.scheduler
		
	Gui settings:Add, GroupBox, x16 y176 w272 h52, % i18n.t("scheduler")
	Gui settings:Add, Text, x32 y192 w59 h23 +0x200 vfrom, % i18n.t("from") ":"
	Gui settings:Add, DateTime, x96 y192 w58 h24 +Disabled +0x9 vschedulerFrom, hh:mm
	GuiControl, settings:, schedulerFrom, % globalConfig.schedulerFrom
	Gui settings:Add, Text, x160 y192 w51 h23 +0x200 vuntil, % i18n.t("until") ":"
	Gui settings:Add, DateTime, x216 y192 w58 h24 +Disabled +0x9 vschedulerUntil, hh:mm
	GuiControl, settings:, schedulerUntil, % globalConfig.schedulerFrom
	
	if (globalConfig.scheduler) {
		GuiControl, settings:Enable, schedulerFrom
		GuiControl, settings:Enable, schedulerUntil
	}
	
	Gui settings:Add, Text, x16 y240 w70 h23 +0x200 vlangTxt, % i18n.t("language")
	langKeyChoosed := getLanguageToChooseDropDown()
	Gui settings:Add, ComboBox, x88 y240 w200 Choose%langKeyChoosed% vlanguage gchangeTempLanguage, % getLanguagesForDropDown()
	
	Gui settings:Font, Bold
    Gui settings:Add, Button, hWndhBtnSaveConfig2 x192 y16 w96 h30 +Default vsaveConfig gsaveConfig, % i18n.t("save_config")
    Gui settings:Font
    Gui settings:Add, Button, hWndhBtnClearAllConfig x192 y48 w96 h30 vclearAllConfig gcreateGlobalConfig, % i18n.t("clear_all_config")
    Gui settings:Add, Button, x192 y80 w96 h30 vcancel gsettingsGuiClose, % i18n.t("cancel")
	
	Gui settings:Show, w297 h279, % appName " " i18n.t("settings")
}

toggleScheduler() {
	global
	GuiControlGet, scheduler, settings:, scheduler
	if (scheduler) {
		GuiControl, settings:Enable, schedulerFrom
		GuiControl, settings:Enable, schedulerUntil
	} else {
		GuiControl, settings:Disable, schedulerFrom
		GuiControl, settings:Disable, schedulerUntil
	}
}

saveConfig() {
	global
	Gui, settings:Submit, NoHide
	globalConfig.language := getLanguageFromDropDown(language).langCode
	i18n.SetLocale(globalConfig.language)
	configureTray()
	globalConfig.startWithWindows := startWithWindows
	globalConfig.progressive := progressiveChanges
	globalConfig.experimentalReadFilter := experimentalReadFilter
	globalConfig.lookForUpdates := lookForUpdates
	globalConfig.scheduler := scheduler
	globalConfig.schedulerFrom := schedulerFrom
	globalConfig.schedulerUntil := schedulerUntil
	
	if(startWithWindows){
		FileCreateShortcut, % A_ScriptFullPath, %A_AppData%\Microsoft\Windows\Start Menu\Programs\Startup\FireFlyFy.lnk
	} else {
		FileDelete, %A_AppData%\Microsoft\Windows\Start Menu\Programs\Startup\FireFlyFy.lnk
	}
	FileDelete, config/global.json
	FileAppend, % JSON.Dump(globalConfig, 1), config/global.json
	Gui, settings:Destroy
}

changeTempLanguage(fromGui := false) {
	global
	GuiControlGet, language, settings:, language
	i18n.SetLocale(!fromGui ? globalConfig.language : getLanguageFromDropDown(language).langCode)
	updateSettingsGui()
	configureTray()
}

updateSettingsGui() {
	GuiControl, settings:, startWithWindows, % i18n.t("start_with_windows")
	GuiControl, settings:, progressiveChanges, % i18n.t("progressive_changes")
	GuiControl, settings:, experimentalReadFilter, % i18n.t("experimental_read_filter")
	GuiControl, settings:, lookForUpdates, % i18n.t("look_for_updates_on_boot")
	GuiControl, settings:, scheduler, % i18n.t("enable_scheduler")
	GuiControl, settings:, from, % i18n.t("from") ":"
	GuiControl, settings:, until, % i18n.t("until") ":"
	GuiControl, settings:, langTxt, % i18n.t("language")
	GuiControl, settings:, saveConfig, % i18n.t("save_config")
	GuiControl, settings:, clearAllConfig, % i18n.t("clear_all_config")
	GuiControl, settings:, cancel, % i18n.t("cancel")
	Gui settings:Show, w297 h279, % appName " " i18n.t("settings")
}

; ************************************************************
; APP CONFIGURATION
; ************************************************************
appConfiguration(selectedWindowTitleLocal, selectedProcessNameLocal) {
    global
	selectedAppConfig := {}
	for appK, appV in appsConfig.apps
	{
		if (selectedWindowTitleLocal == appV.title || (selectedProcessNameLocal == appV.process && appV.activeBy == "process")) {
			selectedAppConfig := appV ; replace
		}
	}
	
	Gui appConfiguration:Add, Text, x16 y16 w101 h23 +0x200, % i18n.t("window_title")
	Gui appConfiguration:Add, Text, x16 y48 w100 h23 +0x200, % i18n.t("process_name")
	Gui appConfiguration:Add, Edit, x120 y16 w146 h21 vselectedWindowTitle, % selectedWindowTitleLocal
	Gui appConfiguration:Add, Edit, x120 y48 w146 h21 vselectedProcessName, % selectedProcessNameLocal
	Gui appConfiguration:Add, Text, x16 y128 w134 h23 +0x200, % i18n.t("screen_brightness")
	Gui appConfiguration:Add, Slider, x152 y128 w120 h32 vscreenBrightness, % selectedAppConfig.brightness ? selectedAppConfig.brightness : 50
	Gui appConfiguration:Add, Text, x16 y176 w133 h23 +0x200, % i18n.t("night_light_intensity")
	Gui appConfiguration:Add, Slider, x152 y176 w120 h32 vnightLightIntensity, % selectedAppConfig.nightLightStrength ? selectedAppConfig.nightLightStrength : 30
	
	procesRadioChecked := selectedAppConfig.activeBy != "title" ? "+Checked" : ""
	titleRadioChecked := procesRadioChecked == "+Checked" ? "" : "+Checked"
	Gui appConfiguration:Add, Radio, x144 y88 w120 h23 %titleRadioChecked% vbyTitle, % i18n.t("window_title")
	Gui appConfiguration:Add, Radio, x16 y88 w120 h23 %procesRadioChecked% vbyProcessName, % i18n.t("process_name")
	
	changeBrightnessChecked := selectedAppConfig.changeBrightness ? "+Checked" : ""
	readModeChecked := selectedAppConfig.readMode ? "+Checked" : ""
	changeBrightnessChecked := (changeBrightnessChecked == "" && readModeChecked == "") ? "+Checked" : changeBrightnessChecked
	Gui appConfiguration:Add, CheckBox, x16 y224 w120 h23 %changeBrightnessChecked% vchangeBrightness, % i18n.t("change_brightness")
	Gui appConfiguration:Add, CheckBox, x152 y224 w120 h23 %readModeChecked% vuseNightLight, % i18n.t("use_night_light")
	
	Gui appConfiguration:Add, Button, x192 y264 w80 h23 +Default gappConfigurationSave, % i18n.t("save")
	Gui appConfiguration:Add, Button, x104 y264 w80 h23 gappConfigurationGuiClose, % i18n.t("cancel")
	Gui appConfiguration:Show, w280 h295, % i18n.t("new") " " appName " " i18n.t("app")
}

appConfigurationSave() {
	global
	Gui, appConfiguration:Submit, NoHide
	app := {}
	app.activeBy := byProcessName ? "process" : "title"
	app.brightness := screenBrightness
	app.changeBrightness := changeBrightness
	app.name := StrReplace(selectedProcessName, ".exe")
	app.process := selectedProcessName
	app.readMode := useNightLight
	app.title := selectedWindowTitle
	app.nightLightStrength := nightLightIntensity
	Gui appConfiguration:Destroy
	
	existed := false
	for appK, appV in appsConfig.apps
	{
		if (app.activeBy == "title" && app.title == appV.title) {
			appsConfig.apps[appK] := app ; replace
			existed := true
		} else if ((app.process == appV.process && app.activeBy == "process") || (app.title == appV.title && app.activeBy == "title")) {
			appsConfig.apps.RemoveAt(appK) ; remove all by process or title, will add it at the end (treated as new)
		}
	}
	
	if (!existed) {
		appsConfig.apps.push(app) ; Insert new app config
	}
	
	FileDelete, config/apps.json
	FileAppend, % JSON.Dump(appsConfig, 1), config/apps.json
	reloadListView()
}

deleteApp(selectedWindowTitleLocal, selectedProcessNameLocal) {
    global
	for appK, appV in appsConfig.apps
	{	
		if ((selectedWindowTitleLocal == appV.title && appV.activeBy == "title") || (selectedProcessNameLocal == appV.process && appV.activeBy == "process")) {
			appsConfig.apps.RemoveAt(appK)
		}
	}
	FileDelete, config/apps.json
	FileAppend, % JSON.Dump(appsConfig, 1), config/apps.json
	reloadListView()
}

clearApps() {
	global
	MsgBox 0x34, Confirmation, Are you sure you want to remove the config for all apps?`n`nThis action is not reversible!
	IfMsgBox Yes, {
		appsConfig.apps := []
		FileDelete, config/apps.json
		FileAppend, % JSON.Dump(appsConfig, 1), config/apps.json
		reloadListView()
	}
}

; ************************************************************
; APPS MANAGEMENT CONFIGURATION
; ************************************************************
appManagementConfigurationGui() {
	global
	Gui configuredApps:Add, Button, x528 y16 w80 h23 gaddNewFireFlyFyWindow, % i18n.t("add_new")
	Gui configuredApps:Add, Button, x528 y48 w80 h23 geditAppConfig, % i18n.t("edit")
	Gui configuredApps:Add, Button, x528 y80 w80 h23 gdeleteAppConfig, % i18n.t("remove")
	Gui configuredApps:Add, Button, x528 y112 w80 h23 gclearApps, % i18n.t("clear_all")
	Gui configuredApps:Add, Button, x528 y144 w80 h23 gconfiguredAppsGuiEscape, % i18n.t("close")
	Gui configuredApps:Add, ListView, x8 y8 w515 h342 +LV0x4000 -Multi vLVApps, % i18n.t("listview_header") ; Name|Active by|Title

	reloadListView()

	Gui configuredApps:Show, w616 h366, % i18n.t("app_configured_applications", {app: appName})
}

editAppConfig() {
	global
	Gui, configuredApps:Default
	Gui, configuredApps:ListView, LVApps
	RowNumber := LV_GetNext(0, F)
	LV_GetText(selectedProcessName, RowNumber)
	LV_GetText(selectedWindowTitle, RowNumber, 3)
	appConfiguration(selectedWindowTitle, selectedProcessName ".exe")
}

deleteAppConfig() {
	global
	Gui, configuredApps:Default
	Gui, configuredApps:ListView, LVApps
	RowNumber := LV_GetNext(0, F)
	LV_GetText(selectedProcessName, RowNumber)
	LV_GetText(selectedWindowTitle, RowNumber, 3)
	deleteApp(selectedWindowTitle, selectedProcessName ".exe")
}

reloadListView() {
	global
	Gui, configuredApps:Default
	Gui, configuredApps:ListView, LVApps
	
	LV_Delete()
	
	for appK, appV in appsConfig.apps
	{
		LV_Add("", appV.name, appV.activeBy, appV.title)
	}

	LV_ModifyCol(1, 100)
	LV_ModifyCol(2, 90)
	LV_ModifyCol(3, 300)
}