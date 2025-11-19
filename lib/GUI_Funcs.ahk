showSettingsGui() {
    global
    Gui settings:+hWndhMainWnd
    Gui settings:Add, CheckBox, x16 y16 w140 h23, Start with Windows
    Gui settings:Add, CheckBox, x16 y48 w140 h23, Progressive Changes
    Gui settings:Add, CheckBox, x16 y80 w140 h23, Experimental Read Filter
    Gui settings:Add, CheckBox, x16 y112 w140 h23, Look for Updates on boot
    Gui settings:Add, CheckBox, x16 y144 w140 h23, Enable Scheduler
	
    Gui settings:Font, Bold
    Gui settings:Add, Button, hWndhBtnSaveConfig2 x192 y16 w96 h23 +Default, Save Config
    Gui settings:Font
    Gui settings:Add, Button, hWndhBtnClearAllConfig x192 y48 w96 h23, Clear all config
    Gui settings:Add, Button, x192 y80 w96 h23, Cancel
	
	Gui settings:Add, GroupBox, x16 y176 w272 h52, Scheduler
	Gui settings:Add, Text, x32 y192 w59 h23 +0x200, From:
	Gui settings:Add, DateTime, x96 y192 w58 h24 +Disabled +0x9, hh:mm
	Gui settings:Add, Text, x160 y192 w51 h23 +0x200, Until:
	Gui settings:Add, DateTime, x216 y192 w57 h24 +Disabled +0x9, hh:mm
	Gui settings:Add, Text, x16 y240 w70 h23 +0x200, Language
	Gui settings:Add, ComboBox, x88 y240 w200 Choose1, % getLanguagesForDropDown()
	Gui settings:Show, w297 h279, % appName " Settings"
}

appConfiguration(selectedWindowTitle, selectedProcessName) {
    global
	Gui appConfiguration:Add, Text, x16 y16 w101 h23 +0x200, Window title
	Gui appConfiguration:Add, Text, x16 y48 w100 h23 +0x200, Process name
	Gui appConfiguration:Add, Edit, x120 y16 w146 h21, % selectedWindowTitle
	Gui appConfiguration:Add, Edit, x120 y48 w146 h21, % selectedProcessName
	Gui appConfiguration:Add, Text, x16 y128 w134 h23 +0x200, Screen brightness
	Gui appConfiguration:Add, Slider, x152 y128 w120 h32, 50
	Gui appConfiguration:Add, Text, x16 y176 w133 h23 +0x200, Night light intensity
	Gui appConfiguration:Add, Slider, x152 y176 w120 h32, 30
	Gui appConfiguration:Add, Radio, x144 y88 w120 h23, Window title
	Gui appConfiguration:Add, Radio, x16 y88 w120 h23 +Checked, Process name
	Gui appConfiguration:Add, CheckBox, x16 y224 w120 h23 +Checked, Change brightness
	Gui appConfiguration:Add, CheckBox, x152 y224 w120 h23 +Checked, Use night light
	Gui appConfiguration:Add, Button, x192 y264 w80 h23 +Default, Save
	Gui appConfiguration:Add, Button, x104 y264 w80 h23, Cancel
	Gui appConfiguration:Show, w280 h295, % "New " appName " app"
}