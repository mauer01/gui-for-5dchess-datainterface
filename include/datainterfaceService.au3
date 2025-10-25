#include-once
#include <AutoitConstants.au3>
#include <Array.au3>
#include <File.au3>
#include <Process.au3>
#include <JSON.au3>
#include <moreArray.au3>
#include <util.au3>

Const $__tempFile = @ScriptDir & "\temp-pgn to variant.txt"
Global $__PIDArray = _newArray()


Func _datainterfaceSetup($ini, $localPath = False)
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
	$data = _loadDataInterface(StringTrimRight($localPath, 10), $ini.data.activeJsonFile)
	Return $data
EndFunc   ;==>_datainterfaceSetup
Func _loadDataInterface($filepath, $activeFile)
	Local $data[]
	$data["isRunning"] = False
	$data["wasRunning"] = False
	$data["filePath"] = $filepath & "\DataInterfaceConsole.exe"
	$data["workingDir"] = $filepath
	$data["jsonFile"] = $filepath & "\Resources\jsonVariants.json"
	$data["ressourceDir"] = $filepath & "\Resources"
	$data["activeJsonFile"] = $activeFile
	$data["activeJsonFilePath"] = $data["ressourceDir"] & "\" & $activeFile & ".json"
	$data["jsonFileLastChanged"] = ""
	$data["log"] = ""
	$data["crashed"] = False
	$data["pid"] = ""
	$data["configured"] = True
	$data["jsonFiles"] = _newArray()
	$data["lastFileList"] = _newArray()
	$data["settings"] = _newMap()
	$data["cachedVariantMap"] = _newMap()
	If FileExists($data["workingDir"] & "\settings.json") Then
		$fileContent = FileRead($data["workingDir"] & "\settings.json")
		$data["settings"] = _JSON_Parse($fileContent)
	EndIf
	$msg = _updateJsonFiles($data)
	If @error = 1 Then
		FileCopy($data["jsonFile"], $data["workingDir"] & "\Resources\guiJsonVariants.json", 1)
		_changeActiveJsonFile($data, "guiJsonVariants.json")
		_updateJsonFiles($data)
	ElseIf @error Then
		Return SetError(@error, 0, $msg)
	EndIf
	If Not _some($data["jsonFiles"], "stringinstr", $activeFile) Then
		$data["activeJsonFile"] = $data.jsonFiles[0]
	EndIf
	_JSONLoad($data)
	Return $data
EndFunc   ;==>_loadDataInterface

Func _updateJsonFiles(ByRef $data)
	Local $files = _FileListToArray($data["workingDir"] & "\Resources", "*.json", 1, 1)
	If $files[0] = 1 And StringInStr($files[1], "jsonVariants.json") Then
		Return SetError(1, 0, "Only normal jsonVariants.json file found, no variant files present")
	EndIf
	If $files[0] > 1 And Not _arrayCountEquals($files, $data["lastFileList"]) Then
		$data["jsonFiles"] = _newArray()
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
	ElseIf $justexist Then
		Return
	EndIf

	If ProcessExists($data["pid"]) Then
		$new = StdoutRead($data["pid"])
		$err = StderrRead($data["pid"])
		$data["log"] &= "Error:" & $err & @LF & "Out:" & @LF & $new
		ConsoleWrite($new)
		$data["log"] = StringRight($data["log"], 1000)
	Else
		Return _datainterface_crashed($data)
	EndIf
EndFunc   ;==>_checkIsRunning
Func _datainterface_crashed(ByRef $data)
	If $data["wasRunning"] = True Then
		$data["wasRunning"] = False
		$data["crashed"] = True
		FileWrite(@ScriptDir & "\" & $data["pid"] & "-log.txt", $data["log"])
		Return SetError(1, 0, "Datainterface closed unexpectidly Logfile might provide data")
	EndIf
	Return SetError(1, 0, "Datainterface is not running")
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
		$new = StdoutRead($data["pid"], True)
		ConsoleWrite($new)
		Sleep(10)
		_checkIsRunning($data, True)
		If @error Then Return SetError(1, 0, "Datainterface not running anymore")
	WEnd
EndFunc   ;==>_waitForResponse
Func _runPGN(ByRef $data, $pgn, $blackincluded)
	$run = $data["pid"]
	StdinWrite($run, "3" & @LF)
	_waitForResponse($data, "Discord")
	$pgn = StringSplit($pgn, @LF, 2)
	For $line In $pgn
		If _isLastOne($line, $pgn) And Not $blackincluded Then
			StdinWrite($run, StringSplit($line, "/", 2)[0] & @LF)
		Else
			StdinWrite($run, $line & @LF)
		EndIf
		Sleep(10)
	Next
	StdinWrite($run, @LF)
EndFunc   ;==>_runPGN

Func _runVariant(ByRef $data, $variant)
	Local $runnablevariant[1] = [$variant]
	FileWrite(@ScriptDir & "\variant.json", _JSON_generate($runnablevariant))
	FileMove(@ScriptDir & "\variant.json", $data["jsonFile"], 1)
	FileDelete(@ScriptDir & "\variant.json")
	$run = $data["pid"]
	StdinWrite($run, "1" & @LF)
	StdinWrite($run, "1" & @LF)
EndFunc   ;==>_runVariant




Func updateJSONVariants(ByRef $data, $JSON)

	$h_temp = FileOpen($__tempFile, 2)
	FileWrite($h_temp, _JSON_MYGenerate($JSON))
	FileClose($h_temp)
	FileMove($__tempFile, $data["activeJsonFilePath"], 1)

EndFunc   ;==>updateJSONVariants

Func _JSON_MYGenerate($string)
	Return _JSON_Generate($string, "  ", @CRLF, "", " ", "  ", @CRLF)
EndFunc   ;==>_JSON_MYGenerate


Func _addVariantToJson(ByRef $data, $variant)
	Local $h_file
	_FileReadToArray($data["activeJsonFilePath"], $h_file)
	$h_temp = FileOpen($__tempFile, 2)
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
	FileMove($__tempFile, $data["activeJsonFilePath"], 1)
	_JSONLoad($data)
EndFunc   ;==>_addVariantToJson

Func _removeVariantFromJson(ByRef $data, $variant)
	Local $h_file, $skip = 0, $string = ""
	_FileReadToArray($data["activeJsonFilePath"], $h_file)
	$k = 0
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
	FileMove($__tempFile, $data["activeJsonFilePath"], 1)
	GUISetState(@SW_ENABLE)
EndFunc   ;==>_removeVariantFromJson
Func _ProcessClose($pid)
	If _ProcessGetName($pid) = "DataInterfaceConsole.exe" Then
		ProcessClose($pid)
	EndIf
EndFunc   ;==>_ProcessClose



Func _createNewJsonFile(ByRef $data, $name)

	If $name = "" Then Return SetError(2)
	For $item In $data["jsonFiles"]
		If $item = $name Then
			Return SetError(3)
		EndIf
	Next
	FileCopy($data["jsonFile"], $data["workingDir"] & "\Resources\" & $name & ".json", 1)
	_changeActiveJsonFile($data, $name)
EndFunc   ;==>_createNewJsonFile

Func _changeActiveJsonFile(ByRef $data, $name)
	If Not _some($data["jsonFiles"], "stringinstr", $name) Then
		Return SetError(1, 0, "Json file not found")
	EndIf
	$data["activeJsonFile"] = StringReplace($name, ".json", "")
	$data["activeJsonFilePath"] = $data["ressourceDir"] & "\" & $data["activeJsonFile"] & ".json"
	IniWrite(@ScriptDir & "\gui for datainterface.ini", "Data", "activeJsonFile", $data["activeJsonFile"])
	_JSONLoad($data)
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
	Local $JSON, $file
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
	$data["cachedVariantMap"] = _newMap()
	Local $path = $data["activeJsonFilePath"]
	Local $fileContent = FileRead($path)
	Local $temp = _JSON_Parse($fileContent)
	Local $keys = _map($temp, "variantNameAuthorCallback", "")
	For $i = 0 To UBound($keys) - 1
		$key = $keys[$i]
		While MapExists($data["cachedVariantMap"], $key)
			$key &= "--duplicate"
		WEnd
		$data["cachedVariantMap"][$keys[$i]] = $temp[$i]
	Next
EndFunc   ;==>_JSONLoad


Func variantNameAuthorCallback($e, $string)
	Local $fullstring = $e.Name & " by " & $e.Author & $string
	Return $fullstring
EndFunc   ;==>variantNameAuthorCallback
