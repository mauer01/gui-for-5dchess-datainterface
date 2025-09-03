#include-once
#include <AutoitConstants.au3>
#include <Array.au3>
#include <File.au3>
#include <Process.au3>
#include <JSON.au3>

Const $__tempFile = @ScriptDir & "\temp-pgn to variant.txt"
Global $__PIDArray[0] = []
Func _loadDataInterface($filepath)
    local $data[]
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
    If Not FileExists($data["filePath"]) or Not FileExists($data["jsonFile"]) Then SetError(1)
    return $data
EndFunc
Func _runDataInterface(ByRef $data)
    $pid = Run($data["filePath"], $data["workingDir"], @SW_HIDE, BitOR($STDOUT_CHILD, $STDIN_CHILD, $STDERR_CHILD))
    $data["pid"] = $pid
    $data["isRunning"] = True
    $data["wasRunning"] = True
    _ArrayAdd($__PIDArray,$data["pid"])
EndFunc
Func _cleanExit(ByRef $data)
    _checkIsRunning($data)
    If $data["isRunning"] Then
        $data["wasRunning"] = False
        $data["isRunning"] = False
        _ProcessClose($data["pid"])
    EndIf
EndFunc
Func _checkIsRunning(ByRef $data)
    if ProcessExists($data["pid"]) Then
        $new = StdoutRead($data["pid"])
        $err = StderrRead($data["pid"])
        $data["log"] &= "Error:" & $err & @LF & "Out:" & @LF & $new
        ConsoleWrite($new)
        $data["log"] = StringRight($data["log"],10000)
    Else
        $data["isRunning"] = False
        if $data["wasRunning"] = True Then
            $data["wasRunning"] = False
            $data["crashed"] = True
            MsgBox(16, "DataInterface", "Datainterface closed unexpectidly" & @CRLF & "Logfile might provide data")
            FileWrite(@ScriptDir & "\" & $data["pid"] & "-log.txt", $data["log"])
        EndIf
    EndIf
EndFunc
Func _CloseAllDatainterfaces()
    for $pid in $__PIDArray
        if ProcessExists($pid) then
            $processname = _ProcessGetName($pid)
            if $processname = "DataInterfaceConsole.exe" Then
                _ProcessClose($pid)
            EndIf
        EndIf
    Next
    _ArrayDelete($__PIDArray,UBound($__PIDArray))
EndFunc


Func _settingOptions(ByRef $data, $setting, $opt, $sleep = 100)
    $run = $data["pid"]
	StdinWrite($run, "4" & @LF)
	Sleep($sleep)
	StdinWrite($run, "" & $setting & @LF)
	Sleep($sleep)
	StdinWrite($run, "" & $opt & @LF)
EndFunc

Func _optionsOrTriggers(ByRef $data, $setting, $opt = False, $sleep = 100)
    $run = $data["pid"]
	StdinWrite($run, "5" & @LF)
	Sleep($sleep)
	StdinWrite($run, "" & $setting & @LF)
	Sleep($sleep)
    If $opt Then StdinWrite($run, "" & $opt & @LF)
EndFunc

Func _waitForResponse(ByRef $data,$response)
    $new = StdoutRead($data["pid"])
    While Not StringInStr($new, $response)
        $new = StdoutRead($data["pid"])
		ConsoleWrite($new)
        Sleep(10)
    WEnd
EndFunc
Func _runPGN(ByRef $data, $pgn)
    $run = $data["pid"]
    StdinWrite($run, "3" & @LF)
    _waitForResponse($data, "Discord")
    $pgn = StringSplit($pgn,@LF,2)
    for $line in $pgn
        StdinWrite($run, $line & @LF)
        Sleep(10)
    Next
    StdinWrite($run,@LF)
EndFunc

Func _runVariant(ByRef $data, $variant)
    $run = $data["pid"]
    StdinWrite($run, "1" & @LF)
    StdinWrite($run, $variant & @LF)
EndFunc


Func _loadVariants(ByRef $data)
    Local $variantsstring, $variantsarray
    $f_variantloader = $data["jsonFile"]
    $time = _ArrayToString(FileGetTime($f_variantloader))
    If $time <> $data["jsonFileLastChanged"] Then
        $data["jsonFileLastChanged"] = $time

        $variantsstring = _readvariants($data)
        $variantsarray = StringSplit($variantsstring, "|")
        local $variants[]
        $variants["string"] = $variantsstring
        $variants["array"] = $variantsarray
        $variants["true"] = True
        Return $variants
    EndIf
    local $j[]
    $j["true"] = False
    Return $j
EndFunc

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
EndFunc


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

EndFunc

func _removeVariantFromJson(ByRef $data, $variant )
    Local $h_file, $skip = 0, $string = ""
    _FileReadToArray($data["jsonFile"], $h_file)

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
EndFunc

func _ProcessClose($pid)
    If _ProcessGetName($pid) = "DataInterfaceConsole.exe" Then
        ProcessClose($pid)
    EndIf
EndFunc
