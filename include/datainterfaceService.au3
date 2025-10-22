#include-once
#include <AutoitConstants.au3>
#include <Array.au3>
#include <File.au3>
#include <Process.au3>
#include <JSON.au3>
#include <moreArray.au3>
#include <util.au3>

Const $__tempFile = @ScriptDir & "\temp-pgn to variant.txt"
Global $__PIDArray[0] = []
Global $__emptyArray[0] = []

Func _datainterfaceSetup($localPath = False)
	If Not $localPath Then
		_requestDatainterface()
		$localPath = @LocalAppDataDir & "\GuiDataInterface\DataInterface"
	EndIf
	If Not StringInStr($localPath, "\Resources") Then
		If Not StringInStr($localPath & "\..\", "\Resources") Then
			Return SetError(1, 0, "not a valid folder")
		EndIf
		$localPath = StringSplit($localPath, "\", 1)
		$localPath = _ArrayToString($localPath, "\", 1, $localPath[0] - 1)
	EndIf
	$data = _loadDataInterface(StringTrimRight($localPath, 10))
	Return $data
EndFunc   ;==>_datainterfaceSetup
Func _loadDataInterface($filepath)
	Local $data[]
	$data["isRunning"] = False
	$data["wasRunning"] = False
	$data["filePath"] = $filepath & "\DataInterfaceConsole.exe"
	$data["workingDir"] = $filepath
	$data["jsonFile"] = $filepath & "\Resources\jsonVariants.json"
	$data["jsonFileLastChanged"] = ""
	$data["log"] = ""
	$data["crashed"] = False
	$data["pid"] = ""
	$data["configured"] = True
	$data["jsonFiles"] = $__emptyArray
	$data["lastFileList"] = $__emptyArray
	$data["settings"] = _newMap()
	$data["cachedVariantMap"] = _newMap()
	If FileExists($data["workingDir"] & "\settings.json") Then
		$fileContent = FileRead($data["workingDir"] & "\settings.json")
		$data["settings"] = _JSON_Parse($fileContent)
	EndIf


	Return $data
EndFunc   ;==>_loadDataInterface

Func _updateJsonFiles(ByRef $data)
	Local $files = _FileListToArray($data["workingDir"] & "\Resources", "*.json", 1, 1)
	If $files[0] > 1 And Not _arrayCountEquals($files, $data["lastFileList"]) Then
		$data["jsonFiles"] = $__emptyArray
		For $file In $files
			Local $fullpath = StringSplit($file, "\", 1)
			$newFile = $fullpath[UBound($fullpath) - 1]
			If $newFile <> "jsonVariants.json" And StringInStr($newFile, ".json") Then
				_ArrayAdd($data["jsonFiles"], StringReplace($newFile, ".json", ""))
			EndIf
		Next
		$data["lastFileList"] = $files
		Return 1
	EndIf
	Return 0
EndFunc   ;==>_updateJsonFiles

Func _runDataInterface(ByRef $data)
	OnAutoItExitRegister("_CloseAllDatainterfaces")
	$pid = Run($data["filePath"], $data["workingDir"], @SW_HIDE, BitOR($STDOUT_CHILD, $STDIN_CHILD, $STDERR_CHILD))
	$data["pid"] = $pid
	$data["isRunning"] = True
	$data["wasRunning"] = True
	_ArrayAdd($__PIDArray, $data["pid"])
EndFunc   ;==>_runDataInterface
Func _cleanExit(ByRef $data)
	_checkIsRunning($data)
	If $data["isRunning"] Then
		$data["wasRunning"] = False
		$data["isRunning"] = False
		_ProcessClose($data["pid"])
		_ArrayDelete($__PIDArray, _ArraySearch($__PIDArray, $data["pid"]))
	EndIf
EndFunc   ;==>_cleanExit
Func _checkIsRunning(ByRef $data, $justexist = False)
	If $justexist And Not ProcessExists($data["pid"]) Then
		_datainterface_crashed($data)
		Return SetError(1, 0, "Datainterface not running anymore")
	EndIf
	If ProcessExists($data["pid"]) Then
		$new = StdoutRead($data["pid"])
		$err = StderrRead($data["pid"])
		$data["log"] &= "Error:" & $err & @LF & "Out:" & @LF & $new
		ConsoleWrite($new)
		$data["log"] = StringRight($data["log"], 1000)
	Else
		_datainterface_crashed($data)
		Return SetError(1, 0, "Datainterface not running anymore")
	EndIf
EndFunc   ;==>_checkIsRunning
Func _datainterface_crashed(ByRef $data)
	If $data["wasRunning"] = True Then
		$data["wasRunning"] = False
		$data["crashed"] = True
		Return SetError(1, 0, "Datainterface closed unexpectidly Logfile might provide data")
		FileWrite(@ScriptDir & "\" & $data["pid"] & "-log.txt", $data["log"])
	EndIf
EndFunc   ;==>_datainterface_crashed
Func _CloseAllDatainterfaces()
	For $pid In $__PIDArray
		If ProcessExists($pid) Then
			$processname = _ProcessGetName($pid)
			If $processname = "DataInterfaceConsole.exe" Then
				_ProcessClose($pid)
			EndIf
		EndIf
	Next
	_ArrayDelete($__PIDArray, UBound($__PIDArray))
EndFunc   ;==>_CloseAllDatainterfaces


Func _settingOptions(ByRef $data, $setting, $opt, $sleep = 100)
	$run = $data["pid"]
	StdinWrite($run, "4" & @LF)
	Sleep($sleep)
	StdinWrite($run, "" & $setting & @LF)
	Sleep($sleep)
	StdinWrite($run, "" & $opt & @LF)
EndFunc   ;==>_settingOptions

Func _optionsOrTriggers(ByRef $data, $setting, $opt = False, $sleep = 100)
	$run = $data["pid"]
	StdinWrite($run, "5" & @LF)
	Sleep($sleep)
	StdinWrite($run, "" & $setting & @LF)
	Sleep($sleep)
	If $opt Then StdinWrite($run, "" & $opt & @LF)
EndFunc   ;==>_optionsOrTriggers

Func _waitForResponse(ByRef $data, $response)
	$new = StdoutRead($data["pid"])
	While Not StringInStr($new, $response)
		$new = StdoutRead($data["pid"])
		ConsoleWrite($new)
		Sleep(10)
		_checkIsRunning($data, True)
		If @error Then Return SetError(1, 0, "Datainterface not running anymore")
	WEnd
EndFunc   ;==>_waitForResponse
Func _runPGN(ByRef $data, $pgn)
	$run = $data["pid"]
	StdinWrite($run, "3" & @LF)
	_waitForResponse($data, "Discord")
	$pgn = StringSplit($pgn, @LF, 2)
	For $line In $pgn
		StdinWrite($run, $line & @LF)
		Sleep(10)
	Next
	StdinWrite($run, @LF)
EndFunc   ;==>_runPGN

Func _runVariant(ByRef $data, $variant)
	$run = $data["pid"]
	StdinWrite($run, "1" & @LF)
	StdinWrite($run, $variant & @LF)
EndFunc   ;==>_runVariant


Func _loadVariants(ByRef $data, $forceReload = False)
	Local $variantsstring, $variantsarray
	$f_variantloader = $data["jsonFile"]
	$time = _ArrayToString(FileGetTime($f_variantloader))
	If ($time <> $data["jsonFileLastChanged"]) Or $forceReload Then
		$data["jsonFileLastChanged"] = $time
		$variantsstring = _readvariants($data)
		$variantsarray = StringSplit($variantsstring, "|")
		Local $variants[]
		$variants["string"] = $variantsstring
		$variants["array"] = $variantsarray
		$variants["true"] = True
		_syncActiveJsonFile($data)
		Return $variants
	EndIf
	Local $j[]
	$j["true"] = False
	Return $j
EndFunc   ;==>_loadVariants

Func _readvariants(ByRef $data)
	$f_variantloader = $data["jsonFile"]
	$regexp = '\"Name": "[^"]+'
	$regexp2 = '\"Author": "[^"]+'
	$hnd_variantload = FileOpen($f_variantloader)
	$fileContent = FileRead($hnd_variantload)
	FileClose($hnd_variantload)
	$matches = StringRegExp($fileContent, $regexp, 3)
	$matches2 = StringRegExp($fileContent, $regexp2, 3)
	$string = ""

	For $i = 0 To UBound($matches) - 1
		$matches[$i] = StringTrimLeft($matches[$i], 9)
	Next

	For $i = 0 To UBound($matches2) - 1
		$matches2[$i] = StringTrimLeft($matches2[$i], 11)
		$string &= $i + 1 & ".  " & $matches[$i] & " by " & $matches2[$i] & "|"
	Next
	$string = StringTrimRight($string, 1)
	Return $string
EndFunc   ;==>_readvariants


Func updateJSONVariants(ByRef $data, $JSON)

	$h_temp = FileOpen($__tempFile, 2)
	FileWrite($h_temp, _JSON_MYGenerate($JSON))
	FileClose($h_temp)
	FileMove($__tempFile, $data["jsonFile"], 1)
EndFunc   ;==>updateJSONVariants

Func _JSON_MYGenerate($string)
	Return _JSON_Generate($string, "  ", @CRLF, "", " ", "  ", @CRLF)
EndFunc   ;==>_JSON_MYGenerate


Func _addVariantToJson(ByRef $data, $variant, $name)
	Local $h_file
	_FileReadToArray($data["jsonFile"], $h_file)
	$h_temp = FileOpen($__tempFile, 2)
	GUISetState(@SW_DISABLE)
	For $i = 1 To $h_file[0] - 1
		If $i = $h_file[0] - 1 Then
			FileWriteLine($h_temp, $h_file[$i] & ",")
		Else
			FileWriteLine($h_temp, $h_file[$i])
		EndIf
	Next
	$variant = StringTrimRight($variant, 2)
	FileWrite($h_temp, $variant & @LF & "}" & @LF)
	FileWriteLine($h_temp, $h_file[$i])

	FileClose($h_temp)
	FileMove($__tempFile, $data["jsonFile"], 1)

EndFunc   ;==>_addVariantToJson

Func _removeVariantFromJson(ByRef $data, $variant)
	Local $h_file, $skip = 0, $string = ""
	_FileReadToArray($data["activejsonFile"], $h_file)

	$k = 0
	GUISetState(@SW_DISABLE)
	For $i = 1 To $h_file[0] - 1
		If StringInStr($h_file[$i], "Name") > 0 Then
			$k += 1
		EndIf
		If $k = $variant Then
			$skip = 1
		EndIf
		If $k = $variant + 1 Then
			$skip = 0
		EndIf

		If $skip = 0 Then
			$string &= $h_file[$i] & @LF
		EndIf
	Next
	While ($string <> "" And StringRight($string, 1) <> "}")
		$string = StringTrimRight($string, 1)
	WEnd
	$string &= @LF & "]"
	FileWrite($__tempFile, $string)
	FileMove($__tempFile, $data["jsonFile"], 1)
	GUISetState(@SW_ENABLE)
EndFunc   ;==>_removeVariantFromJson

Func _ProcessClose($pid)
	If _ProcessGetName($pid) = "DataInterfaceConsole.exe" Then
		ProcessClose($pid)
	EndIf
EndFunc   ;==>_ProcessClose



Func _createNewJsonFile(ByRef $data, $name = "newVariantFile")

	If $name = "" Then Return SetError(2)
	For $item In $data["jsonFiles"]
		If $item = $name Then
			Return SetError(3)
		EndIf
	Next
	FileCopy($data["jsonFile"], $data["workingDir"] & "\Resources\" & $name & ".json", 1)
	$data["activeJsonFile"] = $name
EndFunc   ;==>_createNewJsonFile

Func _changeActiveJsonFile(ByRef $data, $name)

	$activeFile = _find($data["jsonFiles"], "_stringinstringcallback", "ACTIVE")
	FileMove($data["workingDir"] & "\Resources\" & $activeFile & ".json", $data["workingDir"] & "\Resources\" & StringReplace($activeFile, "", "") & ".json", 1)
	FileMove($data["workingDir"] & "\Resources\" & $name & ".json", $data["workingDir"] & "\Resources\" & $name & ".json", 1)
	FileCopy($data["workingDir"] & "\Resources\" & $name & ".json", $data["jsonFile"], 1)
	$data["activeJsonFile"] = StringReplace($name, ".json", "")
EndFunc   ;==>_changeActiveJsonFile

Func _changeNameOfJsonFile(ByRef $data, $oldName, $newName)

	If $oldName = $newName Then Return SetError(1)
	If _some($data["jsonFiles"], "stringinstr", $newName) Then
		Return SetError(2)
	EndIf
	FileMove($data["workingDir"] & "\Resources\" & $oldName & ".json", $data["workingDir"] & "\Resources\" & $newName & ".json", 1)
	$data["activeJsonFile"] = $newName

EndFunc   ;==>_changeNameOfJsonFile


Func _backUpJsonFile(ByRef $data, $target, $entireFolder = False)
	If $entireFolder Then
		DirCopy($data["workingDir"] & "\Resources", $target)
	Else
		FileCopy($data["jsonFile"], $target, 1)
	EndIf
EndFunc   ;==>_backUpJsonFile

Func _downloadAndInstallJsonFiles(ByRef $data, $key)
	If Not MapExists($data, "remoteJsonUrls") Then
		_cacheJsonUrls($data)
		If @error Then Return SetError(1)
	EndIf
	If IsArray($key) Then
		_forEach($key, "_downloadAndInstallJsonFilescb", $data)
		If @error Then Return SetError(@error)
		Return
	EndIf
	If Not MapExists($data["remoteJsonUrls"], $key) Then Return SetError(2)
	If _some($data["jsonFiles"], "_stringinstringcallback", $key) Then Return SetError(3)
	Local $url = $data["remoteJsonUrls"][$key]
	InetGet($url, $data["workingDir"] & "\Resources\" & $key & ".json", 1, 0)
EndFunc   ;==>_downloadAndInstallJsonFiles
Func _downloadAndInstallJsonFilescb($item, $data)
	_downloadAndInstallJsonFiles($data, $item)
	If @error Then Return SetError(@error)
EndFunc   ;==>_downloadAndInstallJsonFilescb
Func _cacheJsonUrls(ByRef $data)
	$data2 = InetRead("https://raw.githubusercontent.com/mauer01/gui-for-5dchess-datainterface/refs/heads/main/variantFiles/variantFilesWithPath.json")
	If @error Then
		Return SetError(@error, 0, "Couldnt fetch variant file list from github")
	EndIf
	$data2 = BinaryToString($data2)
	$data["remoteJsonUrls"] = _JSON_Parse($data2)
EndFunc   ;==>_cacheJsonUrls

Func _requestDatainterface()
	Local $JSON, $file, $data
	$file = InetRead("https://api.github.com/repos/GHXX/FiveDChessDataInterface/releases/latest", 1)
	If @error Then
		Return SetError(1, 0, "Couldnt fetch latest release info from github")
	EndIf
	$file = BinaryToString($file)
	$JSON = _JSON_parse($file)
	$asset = _find($JSON["assets"], "_someStringinStringcallback", "standalone")
	If Not IsMap($asset) Then
		Return SetError(1, 0, "Couldnt find a standalone release asset")
	EndIf
	Local $folderDataInterface = @LocalAppDataDir & "\GuiDataInterface\DataInterface"
	DirCreate($folderDataInterface)
	InetGet($asset["browser_download_url"], @ScriptDir & "\data.zip")
	_unZip(@ScriptDir & "\data.zip", $folderDataInterface)
	If @error Then
		Return SetError(1, 0, "Couldnt unzip the downloaded file")
	EndIf
	FileDelete(@ScriptDir & "\data.zip")
	Return $folderDataInterface
EndFunc   ;==>_requestDatainterface


Func _JSONLoad(ByRef $data)
	$fileContent = FileRead($data["activeJsonFile"])
	$temp = _JSON_Parse($fileContent)
	$data["cachedVariantArray"] = $temp
EndFunc   ;==>_JSONLoad
