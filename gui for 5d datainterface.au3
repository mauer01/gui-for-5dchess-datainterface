#include-once
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <include\controller.au3>
Func _LoadMainGui(ByRef $context)
	Local $keys
	#Region ### START Koda GUI section ### Form=.\kodaForms\main.kxf
	Local $main = GUICreate($context.labels.main, 604, 210, 1140, 268)
	Local $tab = GUICtrlCreateTab(0, 0, 601, 209)
	GUICtrlCreateTabItem($context.labels.tJsonLoader)
	GUIStartGroup()
	Local $cgNewJson = GUICtrlCreateLabel("", 8, 34, 0, 0)
	Local $iJsonFileNewPath = GUICtrlCreateInput("", 8, 34, 225, 21)
	Local $bAddJsonFile = GUICtrlCreateButton($context.labels.bAddJsonFile, 240, 32)
	GUIStartGroup()
	GUIStartGroup()
	Local $cgRemoteJson = GUICtrlCreateLabel("", 8, 66, 0, 0)
	Local $cRemoteJsons = GUICtrlCreateCombo("No Connection", 8, 66, 225, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	If MapExists($context.data, "remoteJsonUrls") Then
		$keys = MapKeys($context.data.remoteJsonUrls)
		GUICtrlSetData($cRemoteJsons, "")
		GUICtrlSetData($cRemoteJsons, _ArrayToString($keys), $keys[0])
	EndIf
	Local $bRemoteJsonDownload = GUICtrlCreateButton($context.labels.bRemoteJsonDownload, 240, 64)
	GUIStartGroup()
	GUIStartGroup()
	Local $cgLocalJson = GUICtrlCreateLabel("", 8, 98, 0, 0)
	Local $cLocalJsonFiles = GUICtrlCreateCombo("", 8, 98, 225, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	If MapExists($context.data, "jsonFiles") Then
		GUICtrlSetData($cLocalJsonFiles, "")
		GUICtrlSetData($cLocalJsonFiles, _ArrayToString($context.data.jsonFiles), $context.data.activeJsonFile)
	EndIf
	Local $bLocalJsonFileRemove = GUICtrlCreateButton($context.labels.bLocalJsonFileRemove, 240, 96)
	$newPos = myControlGetPos($main, $bLocalJsonFileRemove)
	Local $bLocalJsonFileCopy = GUICtrlCreateButton($context.labels.bLocalJsonFileCopy, $newPos["x"] + 5, $newPos["y"])
	$newPos = myControlGetPos($main, $bLocalJsonFileCopy)
	Local $bLocalJsonFileRename = GUICtrlCreateButton($context.labels.bLocalJsonFileRename, $newPos["x"] + 5, $newPos["y"])
	$newPos = myControlGetPos($main, $bLocalJsonFileRename)
	Local $bLocalJsonFileBackup = GUICtrlCreateButton($context.labels.bLocalJsonFileBackup, $newPos["x"] + 5, $newPos["y"])
	$newPos = myControlGetPos($main, $bLocalJsonFileBackup)
	Local $bOpenJsonFolder = GUICtrlCreateButton($context.labels.bOpenJsonFolder, $newPos["x"] + 5, $newPos["y"])
	GUIStartGroup()
	GUIStartGroup()
	Local $cgVariants = GUICtrlCreateLabel("", 8, 130, 0, 0)
	Local $cListOfVariants = GUICtrlCreateCombo("", 8, 130, 225, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	$mapKeys = MapKeys($context.data.cachedVariantMap)
	GUICtrlSetData($cListOfVariants, _ArrayToString($mapKeys))

	$newPos = myControlGetPos($main, $cListOfVariants)
	Local $bRunVariant = GUICtrlCreateButton($context.labels.bRunVariant, $newPos["x"] + 5, $newPos["y"])
	$newPos = myControlGetPos($main, $bRunVariant)
	Local $bVariantRemove = GUICtrlCreateButton($context.labels.bVariantRemove, $newPos["x"] + 5, $newPos["y"])
	$newPos = myControlGetPos($main, $bVariantRemove)
	Local $bVariantEdit = GUICtrlCreateButton($context.labels.bVariantEdit, $newPos["x"] + 5, $newPos["y"])
	GUIStartGroup()
	GUIStartGroup()
	$lAddSpecifier = GUICtrlCreateLabel($context.labels.laddSpecifier, 16, 170)
	$newPos = myControlGetPos($main, $lAddSpecifier)
	Local $cgAddvariants = GUICtrlCreateLabel("", $newPos["x"], $newPos["y"] - 5, 0, 0)
	Local $bAddVariantfromClip = GUICtrlCreateButton($context.labels.bAddVariantfromClip, $newPos["x"], $newPos["y"] - 5)
	$newPos = myControlGetPos($main, $bAddVariantfromClip)
	Local $bAddVariantFromFile = GUICtrlCreateButton($context.labels.bAddVariantFromFile, $newPos["x"] + 5, $newPos["y"])
	$newPos = myControlGetPos($main, $bAddVariantFromFile)
	Local $baddVariantsFromJsonFile = GUICtrlCreateButton($context.labels.baddVariantsFromJsonFile, $newPos["x"] + 5, $newPos["y"])
	GUIStartGroup()
	GUICtrlCreateTabItem($context.labels.tSettings)
	GUIStartGroup()
	Local $cgClocks = GUICtrlCreateLabel("", 8, 32, 0, 0)
	Local $cClocks = GUICtrlCreateCombo($context.labels.cClocks, 8, 32, 145, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $context.labels.cClocksChoices)
	Local $iClockTime = GUICtrlCreateInput($context.labels.iClockTime, 8, 56, 65, 21)
	GUICtrlSetState(-1, $GUI_DISABLE)
	Local $iClockDelay = GUICtrlCreateInput($context.labels.iClockDelay, 88, 56, 65, 21)
	GUICtrlSetState(-1, $GUI_DISABLE)
	Local $bClockSet = GUICtrlCreateButton($context.labels.bClockSet, 160, 56)
	Local $bClockReset = GUICtrlCreateButton($context.labels.bClockReset, 160, 32)
	GUICtrlCreateLabel($context.labels.Label1, 76, 58)
	GUIStartGroup()
	GUIStartGroup()
	Local $cgEphemeral = GUICtrlCreateLabel("", 8, 96, 0, 0)
	Local $cbUndoMove = GUICtrlCreateCheckbox($context.labels.cbUndoMove, 8, 96, 89, 17)
	$newPos = myControlGetPos($main, $cbUndoMove, "y")
	Local $cbRestartGameOnCrash = GUICtrlCreateCheckbox($context.labels.cbRestartGameOnCrash, $newPos["x"], $newPos["y"] + 5, 129, 17)
	GUIStartGroup()
	GUIStartGroup()
	Local $cgSettings = GUICtrlCreateLabel("", 264, 96, 0, 0)
	GUICtrlCreateLabel($context.labels.lTravelAnimations, 264, 96)
	$newPos = myControlGetPos($main, $cgSettings, "y")
	Local $rAnimationsAlwaysOn = GUICtrlCreateRadio($context.labels.rAnimationsAlwaysOn, 280, $newPos["y"] + 20)
	$newPos = myControlGetPos($main, $rAnimationsAlwaysOn, "y")
	Local $rAnimationsAlwaysOff = GUICtrlCreateRadio($context.labels.rAnimationsAlwaysOff, 280, $newPos["y"] + 5)
	$newPos = myControlGetPos($main, $rAnimationsAlwaysOff, "y")
	Local $rAnimationsIgnore = GUICtrlCreateRadio($context.labels.rAnimationsIgnore, 280, $newPos["y"] + 5)
	GUIStartGroup()
	GUIStartGroup()
	Local $cgTriggers = GUICtrlCreateLabel("", 144, 96, 0, 0)
	Local $bInsertCode = GUICtrlCreateButton($context.labels.bInsertCode, 144, 96, 107, 25)
	Local $bResumeGame = GUICtrlCreateButton($context.labels.bResumeGame, 144, 120, 107, 25)
	GUIStartGroup()
	GUICtrlCreateTabItem($context.labels.tPgnLoader)
	GUICtrlSetState(-1, $GUI_SHOW)
	GUIStartGroup()
	Local $cgNewPgn = GUICtrlCreateLabel("", 8, 32, 0, 0)
	Local $iPgnLoaderPath = GUICtrlCreateInput("", 8, 32, 217, 21)
	Local $bPgnAdd = GUICtrlCreateButton($context.labels.bPgnAdd, 232, 32)
	$newPos = myControlGetPos($main, $bPgnAdd)
	Local $bPgnOpenPath = GUICtrlCreateButton($context.labels.bPgnOpenPath, $newPos["x"] + 5, $newPos["y"])
	GUIStartGroup()
	GUIStartGroup()
	Local $cgPgnText = GUICtrlCreateLabel("", 8, 64, 0, 0)
	Local $bPgnAddClipboard = GUICtrlCreateButton($context.labels.bPgnAddClipboard, 8, 64)
	GUIStartGroup()
	GUIStartGroup()
	Local $cgListPgns = GUICtrlCreateLabel("", 8, 96, 0, 0)
	Local $cPgnList = GUICtrlCreateCombo("", 8, 96, 217, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	$pgnKeys = MapKeys($context.pgnRepository["data"])
	If Not $pgnKeys Then
		GUICtrlSetData(-1, "No PGNs saved", "No PGNs saved")
	Else
		GUICtrlSetData(-1, _ArrayToString($pgnKeys), $pgnKeys[0])
	EndIf
	Local $bPgnRun = GUICtrlCreateButton($context.labels.bPgnRun, 232, 96)
	$newPos = myControlGetPos($main, $bPgnRun)
	Local $bPgnRemove = GUICtrlCreateButton($context.labels.bPgnRemove, $newPos["x"] + 5, $newPos["y"])
	$newPos = myControlGetPos($main, $bPgnRemove)
	Local $bPgnEdit = GUICtrlCreateButton($context.labels.bPgnEdit, $newPos["x"] + 5, $newPos["y"])
	GUIStartGroup()
	GUIStartGroup()
	$cMoveList = GUICtrlCreateCombo("", 8, 128, 217, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
	$cbBlackIncluded = GUICtrlCreateCheckbox($context.labels.cbBlackIncluded, 232, 128)
	GUIStartGroup()
	GUICtrlCreateTabItem("")

	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###
	Local $formMap[]
	$formMap["main"] = $main
	$formMap["tab"] = $tab
	#cs
		  "ForceTimetravelAnimationValue": "always_off",
	 "Clock1BaseTime": null,
	 "Clock1Increment": null,
	 "Clock2BaseTime": null,
	 "Clock2Increment": null,
	 "Clock3BaseTime": null,
	 "Clock3Increment": null
	#ce
	If MapExists($context.data, "settings") Then
		If (MapExists($context.data.settings, "ForceTimetravelAnimationValue")) Then
			Switch $context.data.settings.ForceTimetravelAnimationValue
				Case "always_on"
					GUICtrlSetState($rAnimationsAlwaysOn, $GUI_CHECKED)
				Case "always_off"
					GUICtrlSetState($rAnimationsAlwaysOff, $GUI_CHECKED)
				Case "ignore"
					GUICtrlSetState($rAnimationsIgnore, $GUI_CHECKED)
			EndSwitch
		EndIf
	EndIf
	Local $jsonMap[]
	$jsonMap["cgNewJson"] = $cgNewJson
	$jsonMap["iJsonFileNewPath"] = $iJsonFileNewPath
	$jsonMap["bAddJsonFile"] = $bAddJsonFile
	$jsonMap["cgRemoteJson"] = $cgRemoteJson
	$jsonMap["cRemoteJsons"] = $cRemoteJsons
	$jsonMap["bRemoteJsonDownload"] = $bRemoteJsonDownload
	$jsonMap["cgLocalJson"] = $cgLocalJson
	$jsonMap["cLocalJsonFiles"] = $cLocalJsonFiles
	$jsonMap["bLocalJsonFileRemove"] = $bLocalJsonFileRemove
	$jsonMap["bLocalJsonFileCopy"] = $bLocalJsonFileCopy
	$jsonMap["bLocalJsonFileRename"] = $bLocalJsonFileRename
	$jsonMap["bLocalJsonFileBackup"] = $bLocalJsonFileBackup
	$jsonMap["bOpenJsonFolder"] = $bOpenJsonFolder
	$jsonMap["cgVariants"] = $cgVariants
	$jsonMap["cListOfVariants"] = $cListOfVariants
	$jsonMap["bRunVariant"] = $bRunVariant
	$jsonMap["bVariantRemove"] = $bVariantRemove
	$jsonMap["bVariantEdit"] = $bVariantEdit
	$jsonMap["lAddSpecifier"] = $lAddSpecifier
	$jsonMap["cgAddvariants"] = $cgAddvariants
	$jsonMap["bAddVariantfromClip"] = $bAddVariantfromClip
	$jsonMap["bAddVariantFromFile"] = $bAddVariantFromFile
	$jsonMap["baddVariantsFromJsonFile"] = $baddVariantsFromJsonFile

	Local $settingsMap[]
	$settingsMap["cgClocks"] = $cgClocks
	$settingsMap["cClocks"] = $cClocks
	$settingsMap["iClockTime"] = $iClockTime
	$settingsMap["iClockDelay"] = $iClockDelay
	$settingsMap["Timers"] = _newMap()
	$keys = StringSplit($context.labels.cClocksChoices, "|", 3)
	$settingsMap["Timers"][$keys[0]] = "L"
	$settingsMap["Timers"][$keys[1]] = "M"
	$settingsMap["Timers"][$keys[2]] = "S"
	$settingsMap["bClockSet"] = $bClockSet
	$settingsMap["bClockReset"] = $bClockReset
	$settingsMap["cgEphemeral"] = $cgEphemeral
	$settingsMap["cbUndoMove"] = $cbUndoMove
	$settingsMap["cbRestartGameOnCrash"] = $cbRestartGameOnCrash
	$settingsMap["cgSettings"] = $cgSettings
	$settingsMap["rAnimationsAlwaysOn"] = $rAnimationsAlwaysOn
	$settingsMap["rAnimationsAlwaysOff"] = $rAnimationsAlwaysOff
	$settingsMap["rAnimationsIgnore"] = $rAnimationsIgnore
	$settingsMap["cgTriggers"] = $cgTriggers
	$settingsMap["bInsertCode"] = $bInsertCode
	$settingsMap["bResumeGame"] = $bResumeGame

	Local $pgnMap[]
	$pgnMap["cgNewPgn"] = $cgNewPgn
	$pgnMap["iPgnLoaderPath"] = $iPgnLoaderPath
	$pgnMap["bPgnAdd"] = $bPgnAdd
	$pgnMap["bPgnOpenPath"] = $bPgnOpenPath
	$pgnMap["cgPgnText"] = $cgPgnText
	$pgnMap["bPgnAddClipboard"] = $bPgnAddClipboard
	$pgnMap["cgListPgns"] = $cgListPgns
	$pgnMap["cPgnList"] = $cPgnList
	$pgnMap["bPgnRun"] = $bPgnRun
	$pgnMap["bPgnRemove"] = $bPgnRemove
	$pgnMap["bPgnEdit"] = $bPgnEdit
	$pgnMap["cMoveList"] = $cMoveList
	$pgnMap["cbBlackIncluded"] = $cbBlackIncluded

	Local $ctrlMap[]
	$ctrlMap["form"] = $formMap
	$ctrlMap["json"] = $jsonMap
	$ctrlMap["settings"] = $settingsMap
	$ctrlMap["pgn"] = $pgnMap

	; return the assembled control map
	Return $ctrlMap
EndFunc   ;==>_LoadMainGui





Func myControlGetPos($form_id, $control_id, $axis = "x")
	WinGetTitle($form_id)
	Local $pos[]
	Local $coords = ControlGetPos($form_id, "", $control_id)
	$pos["x"] = $coords[0] + $coords[2] * ($axis == "x")
	$pos["y"] = $coords[1] + $coords[3] * ($axis == "y")

	Return $pos
EndFunc   ;==>myControlGetPos
Func _updateComboBoxes(ByRef $data, ByRef $main)
	Local $keys = MapKeys($data["remoteJsonUrls"])
	Static Local $oldkeys[0]
	Static Local $oldjson[0]
	Static Local $oldvariants[0]
	If MapExists($data, "remoteJsonUrls") And Not _arrayCountEquals($keys, $oldkeys) Then
		GUICtrlSetData($main["json"]["cRemoteJsons"], "")
		GUICtrlSetData($main["json"]["cRemoteJsons"], _ArrayToString($keys), $keys[0])
		$oldkeys = $keys
	EndIf
	If MapExists($data, "jsonFiles") And Not _arrayCountEquals($data.jsonFiles, $oldjson) Then
		GUICtrlSetData($main["json"]["cLocalJsonFiles"], "")
		GUICtrlSetData($main["json"]["cLocalJsonFiles"], _ArrayToString($data.jsonFiles), $data.activeJsonFile)
		$oldjson = $data["jsonFiles"]
	EndIf
	If Not _arrayCountEquals(MapKeys($data["cachedVariantMap"]), $oldvariants) Then
		$mapKeys = MapKeys($data["cachedVariantMap"])
		GUICtrlSetData($main["json"]["cListOfVariants"], "")
		GUICtrlSetData($main["json"]["cListOfVariants"], _ArrayToString($mapKeys), $mapKeys[0])
		$oldvariants = $mapKeys
	EndIf

EndFunc   ;==>_updateComboBoxes

Func updatePgnCombo(ByRef $pgnRepository, $main)
	Static Local $oldPgns[0]
	Static Local $oldPgnSelection = ""
	Local $pgnKeys = MapKeys($pgnRepository["data"])
	If Not _arrayCountEquals($pgnKeys, $oldPgns) Then
		GUICtrlSetData($main["pgn"]["cPgnList"], "")
		GUICtrlSetData($main["pgn"]["cPgnList"], _ArrayToString($pgnKeys), $oldPgnSelection)
		$oldPgns = $pgnKeys
	EndIf

EndFunc   ;==>updatePgnCombo

