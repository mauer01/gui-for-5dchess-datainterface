#include-once
#include <GUIConstantsEx.au3>
#include <..\gui For 5d datainterface.au3>
#include <datainterfaceService.au3>
#include <moreArray.au3>
#include <multiversechess.au3>
#include <pgnRepository.au3>
#include <..\pgn edit form.au3>
#include <..\json edit form.au3>

Func _frontController(ByRef $context, ByRef $mainGui)
	Local $nMsg, $msg, $filepath, $filename, $type

	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case -3
			Return "exit"

		Case $mainGui["json"]["bAddJsonFile"]
			$filepath = GUICtrlRead($mainGui["json"]["iJsonFileNewPath"])
			If $filepath = "" Then
				MsgBox(16, "Error", "No file path provided")
				Return
			EndIf
			$filename = StringSplit($filepath, "\", 3)
			_ArrayReverse($filename)
			$filename = $filename[0]
			If FileExists($filepath) Then
				FileCopy($filepath, $context["data"]["ressourceDir"] & "\" & $filename)
			EndIf
		Case $mainGui["json"]["bAddVariantfromClip"]
			$msg = _controller_addVariant($context["data"], ClipGet())
			If @error Then Return basicError(@error, $msg)
		Case $mainGui["json"]["bAddVariantFromFile"]
			$filepath = FileOpenDialog("Select PGN or JSON File", "", "PGN Files (*.pgn;*.txt)|JSON Files (*.json)")
			If @error Then
				MsgBox(16, "Error", "No file selected")
				Return
			EndIf
			$msg = _controller_addVariant($context["data"], FileRead($filepath), StringTrimRight($filepath, StringMid($filepath, StringInStr($filepath, "\", 0, -1)) + 1))
			If @error Then Return basicError(@error, $msg)
		Case $mainGui["json"]["bRemoteJsonDownload"]
			$msg = _controller_downloadVariants($context["data"], False, GUICtrlRead($mainGui["json"]["cRemoteJsons"]))
		Case $mainGui["json"]["cLocalJsonFiles"]
			_changeActiveJsonFile($context["data"], GUICtrlRead($mainGui["json"]["cLocalJsonFiles"]))
			IniWrite($context.data.ini.path, "Data", "ActiveJsonFile", $context["data"]["activeJsonFile"])
			_updateComboBoxes($context["data"], $mainGui)
		Case $mainGui["json"]["bLocalJsonFileRemove"]
			If UBound($context["data"]["jsonFiles"]) = 1 Then
				MsgBox(16, "Error", "Cannot delete the last JSON file.")
				Return
			EndIf
			If MsgBox(4, "Confirm", "Are you sure you want to delete this JSON file?") = 6 Then
				FileDelete($context["data"]["ressourceDir"] & "\" & GUICtrlRead($mainGui["json"]["cLocalJsonFiles"]) & ".json")
			EndIf
			_updateJsonFiles($context["data"])
			_changeActiveJsonFile($context["data"], $context.data.jsonFiles[0])
			_updateComboBoxes($context["data"], $mainGui)
		Case $mainGui["json"]["bLocalJsonFileCopy"]
			Local $filecopy = StringReplace($context["data"]["activeJsonFilePath"], ".json", "_copy.json")
			If FileExists($filecopy) Then
				MsgBox(16, "Error", "A copy of this file already exists.")
				Return
			EndIf
			FileCopy($context["data"]["activeJsonFilePath"], $filecopy)
			_updateJsonFiles($context["data"])
			$msg = _changeActiveJsonFile($context["data"], StringReplace($filecopy, ".json", ""))
		Case $mainGui["json"]["bLocalJsonFileRename"]
			Local $input = InputBox("Enter new name for JSON file", "", $context["data"]["activeJsonFile"])
			$input = StringReplace($input, ".json", "")
			If _some($context["data"]["jsonFiles"], "_equalityCallback", $input) Then
				MsgBox(16, "Error", "A JSON file with that name already exists.")
				Return
			EndIf
			$msg = FileMove($context["data"]["activeJsonFilePath"], $context["data"]["ressourceDir"] & "\" & $input & ".json")
			_updateJsonFiles($context["data"])
			$msg = _changeActiveJsonFile($context["data"], $input)
		Case $mainGui["json"]["bLocalJsonFileBackup"]
			$msg = DirCopy($context["data"]["ressourceDir"], FileSelectFolder("select a folder to backup your jsons files to", ""), 1)
		Case $mainGui["json"]["bOpenJsonFolder"]
			$msg = ShellExecute("explorer.exe", $context["data"]["ressourceDir"])
		Case $mainGui["json"]["bRunVariant"]
			Local $variantKey = GUICtrlRead($mainGui["json"]["cListOfVariants"])
			Local $variant = $context["data"]["cachedVariantMap"][$variantKey]
			If _countNameOccurrences($context["data"]["jsonFile"]) > 1 Then ; makes sure the jsonVariants file doesnt get overwritten when it still has other variants
				Local $backupname = "jsonVariantsGUIOriginalbackup.json"
				Local $backupcount = 0
				While FileExists($context["data"]["jsonResourceDir"] & "\" & $backupname)
					$backupname = $backupcount & "_" & $backupname
					$backupcount += 1
				WEnd
				FileCopy($context["data"]["jsonFile"], StringReplace($context["data"]["jsonFile"], ".json", "GUIOriginalbackup.json"))
			EndIf
			$msg = _runVariant($context["data"], $variant)
		Case $mainGui["json"]["bVariantRemove"]
			If MsgBox(4, "Confirm", "Are you sure you want to remove this variant?") = 7 Then
				Return
			EndIf
			$msg = _controller_removeVariant($context["data"], GUICtrlRead($mainGui["json"]["cListOfVariants"]))

		Case $mainGui["json"]["bVariantEdit"]
			Local $variantKey = GUICtrlRead($mainGui["json"]["cListOfVariants"])
			Local $variant = $context["data"]["cachedVariantMap"][$variantKey]
			$newJson = jsonEditForm($variant, $mainGui["form"])
			Local $extended = @extended
			If $extended Then
				$msg = _controller_replaceVariant($context["data"], $newJson, $variantKey)
			ElseIf Not $newJson Then
				Return
			Else
				$msg = _controller_addVariant($context["data"], $newJson, False, False, True)
			EndIf
			If @error Then Return basicError(@error, $msg)
		Case $mainGui["json"]["baddVariantsFromJsonFile"]
			$filepath = FileOpenDialog("Select JSON File", $context["data"]["ressourceDir"], "JSON Files (*.json)")
			If @error Then
				MsgBox(16, "Error", "No file selected")
				Return
			EndIf
			$msg = _forEach(_JSON_Parse(FileRead($filepath)), "_controller_addVariantOverload", $context["data"])
		Case $mainGui["settings"]["cClocks"]
			Local $settingmap = _newMap()
			$type = GUICtrlRead($mainGui["settings"]["cClocks"])
			If $type == $context.labels.cClocks Then Return
			Static Local $aklsdfjlkasdjflkasjdfkl
			If Not $aklsdfjlkasdjflkasjdfkl Then
				GUICtrlSetState($mainGui["settings"]["iClockTime"], $GUI_ENABLE)
				GUICtrlSetState($mainGui["settings"]["iClockDelay"], $GUI_ENABLE)
				$aklsdfjlkasdjflkasjdfkl = True
				GUICtrlSetData($mainGui["settings"]["cClocks"], "")
				GUICtrlSetData($mainGui["settings"]["cClocks"], $context.labels.cClocksChoices, $type)
			EndIf
			$keys = MapKeys($context["data"]["settings"])
			$settingmap["S"] = _newMap()
			$settingmap["S"]["timer"] = $keys == True ? $keys[1] : ""
			$settingmap["S"]["increment"] = $keys == True ? $keys[2] : ""
			$settingmap["M"] = _newMap()
			$settingmap["M"]["timer"] = $keys == True ? $keys[3] : ""
			$settingmap["M"]["increment"] = $keys == True ? $keys[4] : ""
			$settingmap["L"] = _newMap()
			$settingmap["L"]["timer"] = $keys == True ? $keys[5] : ""
			$settingmap["L"]["increment"] = $keys == True ? $keys[6] : ""
			GUICtrlSetData($mainGui["settings"]["iClockTime"], $context["data"]["settings"][$settingmap[$mainGui["settings"]["Timers"][$type]]["timer"]])
			$msg = GUICtrlSetData($mainGui["settings"]["iClockDelay"], $context["data"]["settings"][$settingmap[$mainGui["settings"]["Timers"][$type]]["increment"]])
		Case $mainGui["settings"]["bClockSet"]
			Local $time = GUICtrlRead($mainGui["settings"]["iClockTime"])
			Local $delay = GUICtrlRead($mainGui["settings"]["iClockDelay"])
			$type = GUICtrlRead($mainGui["settings"]["cClocks"])
			$keys = MapKeys($mainGui["settings"]["Timers"])
			If Not _some($keys, "stringinstr", $type) Then
				MsgBox(16, "Error", "Choose a valid clock type.")
				Return
			EndIf
			$msg = _controller_changeTimer($context, $mainGui["settings"]["Timers"][$type], $time, $delay)
			If @error Then Return basicError(@error, $msg)
		Case $mainGui["settings"]["bClockReset"]
			$type = GUICtrlRead($mainGui["settings"]["cClocks"])
			$msg = _controller_changeTimer($context, $mainGui["settings"]["Timers"][$type], "reset", "reset")
			If @error = 1 Then MsgBox(16, "Error", "Select a Clock Type to reset.")
		Case $mainGui["settings"]["cbUndoMove"]
			$msg = _controller_undoMoveToggle($context["data"])
		Case $mainGui["settings"]["cbRestartGameOnCrash"]
			If $context["option"]["gameLocation"] = "" Then
				Local $location = _ProcessGetLocation("5dchesswithmultiversetimetravel.exe")
				If @error = 1 Then
					MsgBox(16, "Error", "5D Chess with Multiverse Time Travel is not running. Please start the game first.")
					GUICtrlSetState($mainGui["settings"]["cbRestartGameOnCrash"], $GUI_UNCHECKED)
					Return
				ElseIf @error = 2 Then
					MsgBox(16, "Error", "Unable to get location of 5D Chess with Multiverse Time Travel automatically. Please set the game location in settings first.")
					$location = FileOpenDialog("Select 5D Chess with Multiverse Time Travel Executable", "", "Executable Files (*.exe)|All Files (*.*)")
					If @error Then
						MsgBox(16, "Error", "No file selected. Cannot enable Restart Game on Crash.")
						GUICtrlSetData($mainGui["settings"]["cbRestartGameOnCrash"], $GUI_UNCHECKED)
						Return
					EndIf
				EndIf
				$context["option"]["gameLocation"] = $location
				IniWrite("gui for datainterface.ini", "Data", "gamelocation", $location)
			EndIf
			$context["option"]["keepgameon"] = Not $context["option"]["keepgameon"]
		Case $mainGui["settings"]["rAnimationsAlwaysOn"]
			$msg = _controller_animationSetting($context["data"], "on")
		Case $mainGui["settings"]["rAnimationsAlwaysOff"]
			$msg = _controller_animationSetting($context["data"], "off")
		Case $mainGui["settings"]["rAnimationsIgnore"]
			$msg = _controller_animationSetting($context["data"], "ignore")
		Case $mainGui["settings"]["bInsertCode"]
			$msg = _controller_trigger($context["data"], ClipGet())
		Case $mainGui["settings"]["bResumeGame"]
			$msg = _controller_trigger($context["data"])
		Case $mainGui["pgn"]["bPgnAdd"]
			$filepath = GUICtrlRead($mainGui["pgn"]["iPgnLoaderPath"])
			If Not FileExists($filepath) Then
				MsgBox(16, "Error", "File does not exist.")
				Return
			EndIf
			$msg = _addPgnToMap($context["pgnRepository"], $filepath)
			If @error Then Return basicError(@error, $msg)
			$msg = _savePgnMapinCsv($context["pgnRepository"])
			If @error Then Return basicError(@error, $msg)
		Case $mainGui["pgn"]["bPgnOpenPath"]
			$filepath = FileOpenDialog("Select PGN File", "", "PGN Files (*.pgn;*.txt)|All Files (*.*)")
			If @error Then
				MsgBox(16, "Error", "No file selected.")
				Return
			EndIf
			GUICtrlSetData($mainGui["pgn"]["iPgnLoaderPath"], $filepath)
		Case $mainGui["pgn"]["cPgnList"]

			_updateCgPgnMetaDatagroup($context["pgnRepository"], $mainGui)

		Case $mainGui["pgn"]["bPgnRun"]
			$filename = GUICtrlRead($mainGui["pgn"]["cPgnList"])
			If Not MapExists($context["pgnRepository"]["data"], $filename) Then
				MsgBox(16, "Error", "PGN not found in repository.")
				Return
			EndIf
			$msg = _controller_runPGN($context["data"], $context["pgnRepository"]["data"][$filename], _
					StringSplit(GUICtrlRead($mainGui["pgn"]["cMoveList"]), ".", 2)[0], _
					GUICtrlRead($mainGui["pgn"]["cbBlackIncluded"]) == $GUI_CHECKED)
			If @error Then Return basicError(@error, $msg)
		Case $mainGui["pgn"]["bPgnRemove"]
			$filename = GUICtrlRead($mainGui["pgn"]["cPgnList"])
			$msg = _removePgnFromMap($context["pgnRepository"], $filename)
			If Not $msg Then
				MsgBox(16, "Error", "PGN not found in repository.")
				Return
			EndIf
			$msg = _savePgnMapinCsv($context["pgnRepository"])
			If @error Then Return basicError(@error, $msg)
		Case $mainGui["pgn"]["bPgnEdit"]

			$filename = GUICtrlRead($mainGui["pgn"]["cPgnList"])
			If Not MapExists($context["pgnRepository"]["data"], $filename) Then
				MsgBox(16, "Error", "PGN not found in repository.")
				Return
			EndIf
			$msg = pgneditForm($context["pgnRepository"]["data"][$filename], $mainGui["form"])
			If @error Then Return basicError(@error, $msg)
			$msg = _savePgnMapinCsv($context["pgnRepository"])
			If @error Then Return basicError(@error, $msg)
		Case $mainGui["pgn"]["bPgnAddClipboard"]
			Local $clipdata = ClipGet()
			If Not StringInStr($clipdata, "1.") Then
				MsgBox(16, "Error", "No valid moves found")
				Return
			EndIf
			If Not StringRegExp($clipdata, "(?s).*\[((?:[a-zA-Z\*\d]+\/){7}[a-zA-Z\*\d]+):(\d+):(\d+):([wb])\].*") Then
				MsgBox(16, "Error", "Couldn't find FENS in clipboard data")
				Return
			EndIf
			$msg = _addpgntomap($context["pgnRepository"], $clipdata, InputBox("enter a Name", "enter a name for the pgn"))
			If @error Then basicError(@error, $msg)
			$msg = _savePgnMapinCsv($context["pgnRepository"])
	EndSwitch
	If @error Then Return SetError(@error, 0, "uncaught error" & @CRLF & "Potentially an Errormessage: " & $msg)
	Return
EndFunc   ;==>_frontController

Func _controller_changeTimer(ByRef $context, $type, $time, $delay)
	Local $data = $context["data"]
	Local $except[2] = ["reset", ":"]
	If $type <> "L" And $type <> "M" And $type <> "S" Then
		Return SetError(1, 0, "Type must be L, M, or S")
	EndIf
	_checkString($time, $except)
	If @error Then Return SetError(2, 0, "Time is not in either a : split format or in seconds")
	_checkString($delay, $except)
	If @error Then Return SetError(3, 0, "Delay is not in either a : split format or in seconds")
	Local $map[], $settingmap[]
	$map["L"] = 6
	$map["M"] = 4
	$map["S"] = 2
	$keys = MapKeys($context["data"]["settings"])
	$settingmap["S"] = _newMap()
	$settingmap["S"]["timer"] = $keys == True ? $keys[1] : ""
	$settingmap["S"]["increment"] = $keys == True ? $keys[2] : ""
	$settingmap["M"] = _newMap()
	$settingmap["M"]["timer"] = $keys ? $keys[3] : ""
	$settingmap["M"]["increment"] = $keys == True ? $keys[4] : ""
	$settingmap["L"] = _newMap()
	$settingmap["L"]["timer"] = $keys == True ? $keys[5] : ""
	$settingmap["L"]["increment"] = $keys == True ? $keys[6] : ""
	If StringInStr($time, ":") Then
		$time = _timetoSeconds($time)
		If @error Then Return SetError(4, 0, "Time format invalid")
	EndIf

	If StringInStr($delay, ":") Then
		$delay = _timetoSeconds($delay)
		If @error Then Return SetError(5, 0, "Delay format invalid")
	EndIf
	$keyinc = $settingmap[$type]["increment"]
	$keytimer = $settingmap[$type]["timer"]
	If ($time And $delay) Then
		_settingOptions($data, $map[$type], $time)
		$msg = _waitForResponse($data, "Action executed. Returning to menu")
		If @error Then Return SetError(@error, 0, $msg)
		_settingOptions($data, $map[$type] + 1, $delay)
		$context["data"]["settings"][$keytimer] = $time == "reset" ? "" : $time
		$context["data"]["settings"][$keyinc] = $delay == "reset" ? "" : $delay
	ElseIf $time Then
		_settingOptions($data, $map[$type], $time)
		$context["data"]["settings"][$keytimer] = $time == "reset" ? "" : $time
	ElseIf $delay Then
		_settingOptions($data, $map[$type] + 1, $delay)
		$context["data"]["settings"][$keyinc] = $delay == "reset" ? "" : $delay
	Else
		Return SetError(6, 0, "No time or delay provided")
	EndIf
EndFunc   ;==>_controller_changeTimer

Func _checkString($string, $exceptions)
	If $string = "" Then Return
	If StringIsAlNum($string) Or _some($exceptions, "stringinstroverload", $string) Then
		Return
	EndIf
	Return SetError(1, 0, "string must be numeric or follow a format")
EndFunc   ;==>_checkString
Func stringinstroverload($s, $substr)
	Return StringInStr($substr, $s)
EndFunc   ;==>stringinstroverload


Func _controller_undoMoveToggle(ByRef $data)
	Static $toggled = False
	If $toggled Then
		_optionsOrTriggers($data, 1, 2)
		$toggled = False
	Else
		_optionsOrTriggers($data, 1, 1)
		$toggled = True
	EndIf
EndFunc   ;==>_controller_undoMoveToggle

Func _controller_animationSetting(ByRef $data, $setting)
	Local $map[]
	$map["ignore"] = 1
	$map["on"] = 2
	$map["off"] = 3
	If IsString($setting) Then
		$setting = $map[$setting]
	EndIf
	If $setting < 1 Or $setting > 3 Then
		Return SetError(1, 0, "Setting out of range")
	EndIf
	_settingOptions($data, 1, $setting)
EndFunc   ;==>_controller_animationSetting

Func _controller_removeVariant(ByRef $data, $variant)
	Local $keys = MapKeys($data["cachedVariantMap"]), $variantId
	For $i = 0 To UBound($keys) - 1
		If $keys[$i] = $variant Then
			$variantId = $i + 1
			ExitLoop
		EndIf
	Next
	_removeVariantFromJson($data, $variantId)
	_JSONLoad($data)
EndFunc   ;==>_controller_removeVariant


Func _controller_runPGN(ByRef $data, $pgnMap, $moveNumber = 1, $blackIncluded = True)
	$maxMoves = UBound($pgnMap["moves"]) - 1
	If $moveNumber < UBound($pgnMap["moves"]) Then
		_ArrayDelete($pgnMap["moves"], $moveNumber & "-" & $maxMoves)
		$maxMoves = UBound($pgnMap["moves"]) - 1
	EndIf
	$pgn = StringTrimRight(_fromMapToPGN($pgnMap), 2)
	If ProcessExists("5dchesswithmultiversetimetravel.exe") Then
		Return _runPGN($data, $pgn, $blackIncluded)
	Else
		Return SetError(1, 0, "game not running")
	EndIf
EndFunc   ;==>_controller_runPGN


Func _controller_addVariant(ByRef $data, $fenPgnOrJson, $name = False, $author = False, $overwrite = False)
	If MapExists($fenPgnOrJson, "Name") Then
		$msg = _checkVariant($fenPgnOrJson, True)
		If @error Then
			Return SetError(@error, 0, $msg)
		EndIf
		If Not $overwrite Then
			ensureuniquename($data, $fenPgnOrJson)
			_addVariantToJson($data, _JSON_MYGenerate($fenPgnOrJson))
		EndIf
		$data["cachedVariantMap"][$fenPgnOrJson["Name"] & " by " & $fenPgnOrJson["Author"]] = $fenPgnOrJson
		updateJsonVariants($data)
		Return
	EndIf
	If StringRegExp($fenPgnOrJson, "(?s).*\[((?:[a-zA-Z\*\d]+\/){7}[a-zA-Z\*\d]+):(\d+):(\d+):([wb])\].*") Then
		$multiverse = _multiverse_create("pgn", $fenPgnOrJson)
		$multiverse["Name"] = $name == False ? InputBox("Enter Variant Name", "Variant Name:") : $name
		$multiverse["Author"] = $author == False ? InputBox("Enter Variant Author", "Variant Author:") : $author
		ensureuniquename($data, $multiverse)
		$variant = _JSON_MYGenerate(_multiversetovariant($multiverse, $name, "pgn to variant"))
		_addVariantToJson($data, $variant)
		Return
	EndIf
	If StringInStr($fenPgnOrJson, "{") Then
		$variant = _JSON_Parse($fenPgnOrJson)
		$msg = _checkVariant($variant, True)
		$error = @error
		If $error Then
			Return SetError($error, 0, $msg)
		EndIf
		ensureuniquename($data, $variant)
		_addVariantToJson($data, _JSON_MYGenerate($variant))
		Return
	EndIf
	Return SetError(1, 0, "Input not recognized as valid variant, json, or pgn")
EndFunc   ;==>_controller_addVariant

Func ensureuniquename(ByRef $data, ByRef $fenPgnOrJson)
	Local $i = 2
	While MapExists($data["cachedVariantMap"], $fenPgnOrJson["Name"] & " by " & $fenPgnOrJson["Author"])
		$fenPgnOrJson["Name"] = $fenPgnOrJson["Name"] & "_" & $i
		$i += 1
	WEnd
	Return
EndFunc   ;==>ensureuniquename



Func _controller_addVariantOverload($multiverse, ByRef $data)
	Return _controller_addVariant($data, $multiverse, $multiverse["Name"])
EndFunc   ;==>_controller_addVariantOverload


Func _controller_downloadVariants(ByRef $data, $cacheOnly = False, $variantfiles = "all")
	_cacheJsonUrls($data)
	If $cacheOnly Then
		Return
	EndIf
	If $variantfiles <> "all" Then
		If Not IsArray($variantfiles) Then
			If Not _some($data["remoteJsonUrls"], "StringInStr", $variantfiles) Then
				Return SetError(1, 0, "variant file not found in cached urls")
			EndIf
		ElseIf Not _some($data["remoteJsonUrls"], "_someStringinStringcallback", $variantfiles) Then
			Return SetError(2, 0, "some variant file not found in cached urls")
		EndIf
	EndIf
	If $variantfiles = "all" Then
		$variantfiles = MapKeys($data["remoteJsonUrls"])
	EndIf
	_downloadAndInstallJsonFiles($data, $variantfiles)
EndFunc   ;==>_controller_downloadVariants


Func _controller_replaceVariant(ByRef $data, $input, $variantnumber)
	$check = _checkVariant($input)
	If IsString($check) Then
		Return SetError(1, 0, $check)         ; variant not valid
	EndIf
	MapRemove($data["cachedVariantMap"], $variantnumber)
	$variantnumber = $input["Name"] & " by " & $input["Author"]
	$data["cachedVariantMap"][$variantnumber] = $input

	updateJSONVariants($data)
	Return True
EndFunc   ;==>_controller_replaceVariant


Func _controller_trigger(ByRef $data, $code = False)
	If Not $code Then
		_optionsOrTriggers($data, 3)
		Return
	EndIf
	If Not StringInStr($code, ":") Then
		Return SetError(1, 0, "code format invalid")
	EndIf
	$code = StringReplace($code, "~1", "")
	_optionsOrTriggers($data, 2, $code)
EndFunc   ;==>_controller_trigger



Func _timetoSeconds($time)
	Local $parts = StringSplit($time, ":")
	If $parts[0] = 2 Then
		Return ($parts[1] * 60) + $parts[2]
	ElseIf $parts[0] = 3 Then
		Return ($parts[1] * 3600) + ($parts[2] * 60) + $parts[3]
	Else
		Return SetError(1, 0, "time format invalid")
	EndIf
EndFunc   ;==>_timetoSeconds




Func basicError($errorcode, $msg)
	If $errorcode Then
		MsgBox(16, "Error: " & $errorcode, $msg)
	EndIf
EndFunc   ;==>basicError


Func _countNameOccurrences($filepath)
	If Not FileExists($filepath) Then Return 0

	Local $fileContent = FileRead($filepath)
	If @error Then Return 0

	; Count occurrences of "Name" (case sensitive)
	Local $count = 0
	Local $pos = 1
	While True
		$pos = StringInStr($fileContent, '"Name"', 0, 1, $pos)
		If $pos = 0 Then ExitLoop
		$count += 1
		$pos += 1
	WEnd

	Return $count
EndFunc   ;==>_countNameOccurrences
