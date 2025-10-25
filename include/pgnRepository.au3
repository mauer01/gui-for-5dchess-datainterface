#include-once
#include <moreArray.au3>
#include <JSON.au3>

Func _loadPgnRepository()
	Local $pgnRepository[]
	$pgnRepository["path"] = @ScriptDir & "\savedpgns.csv"
	$pgnRepository["data"] = _loadCsv($pgnRepository)
	Return $pgnRepository
EndFunc   ;==>_loadPgnRepository


Func _loadCsv(ByRef $pgnRepository)
	$data = FileReadToArray($pgnRepository["path"])
	$linecount = @extended
	If Not FileExists($pgnRepository["path"]) Then
		Return _newMap()
	EndIf
	Local $map[]
	$mapkeys = StringSplit($data[0], ";", 2)
	For $i = 1 To $linecount - 1
		$line = $data[$i]
		$fields = StringSplit($line, ";", 2)

		For $j = 0 To UBound($fields) - 1
			$fields[$j] = StringReplace($fields[$j], '""', '"')
			$fields[$j] = StringTrimLeft($fields[$j], 1)
			$fields[$j] = StringTrimRight($fields[$j], 1)
		Next
		$map[$fields[0]] = _newMap()
		$map[$fields[0]][$mapkeys[1]] = _JSON_Parse($fields[1])
		$map[$fields[0]][$mapkeys[2]] = _JSON_Parse($fields[2])
		$map[$fields[0]][$mapkeys[3]] = _JSON_Parse($fields[3])

	Next
	Return $map
EndFunc   ;==>_loadCsv

Func _addPgnToMap(ByRef $pgnRepository, $filepath)
	Local $pgnMap = _pgnAsMap($filepath)
	Local $filename = $pgnMap["filename"]
	MapRemove($pgnMap, "filename")
	If MapExists($pgnRepository["data"], $filename) Then
		Local $count = 2
		$filename &= "_" & $count
		While MapExists($pgnRepository["data"], $filename)
			$filename = StringReplace($filename, "_" & $count, "_" & ($count + 1))
			$count += 1
		WEnd
	EndIf
	$pgnRepository["data"][$filename] = $pgnMap
EndFunc   ;==>_addPgnToMap

Func _removePgnFromMap(ByRef $pgnRepository, $filename)
	If MapExists($pgnRepository["data"], $filename) Then
		MapRemove($pgnRepository["data"], $filename)
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>_removePgnFromMap

Func _savePgnMapinCsv(ByRef $pgnRepository)
	Local $pgnMap = $pgnRepository["data"]
	Local $file = FileOpen($pgnRepository["path"], 2)
	If ($file = -1) Or @error Then
		Return SetError(1, 0, "Failed to open file for writing: " & $pgnRepository["path"])
	EndIf
	FileWriteLine($file, "filename;tags;fen;moves")
	If @error Then Return SetError(1, 0, "Failed to write to file: " & $pgnRepository["path"])
	For $filename In MapKeys($pgnMap)
		Local $pgnData = $pgnMap[$filename]
		Local $tagsJson = _JSON_GenerateCompact($pgnData["tags"])
		Local $fenJson = _JSON_GenerateCompact($pgnData["fen"])
		Local $movesJson = _JSON_GenerateCompact($pgnData["moves"])
		$tagsJson = StringReplace($tagsJson, '"', '""')
		$fenJson = StringReplace($fenJson, '"', '""')
		$movesJson = StringReplace($movesJson, '"', '""')
		Local $csvLine = '"' & $filename & '";"' & $tagsJson & '";"' & $fenJson & '";"' & $movesJson & '"'
		FileWriteLine($file, $csvLine)
		If @error Then Return SetError(1, 0, "Failed to write to file: " & $pgnRepository["path"])
	Next

	FileClose($file)
	Return True
EndFunc   ;==>_savePgnMapinCsv

Func _pgnAsMap($filepath)
	$filename = StringTrimLeft($filepath, StringInStr($filepath, "\", 0, -1))
	Local $map[]
	$map["filename"] = $filename
	$map["tags"] = _newMap()
	$map["fen"] = _newArray()
	$map["moves"] = _newArray()
	$file = FileReadToArray($filepath)
	$linecount = @extended

	Local $inMoves = False

	For $i = 0 To $linecount - 1
		$line = StringStripWS($file[$i], 3)

		If StringLen($line) = 0 Then
			ContinueLoop
		EndIf

		If StringLeft($line, 1) = "[" And StringRight($line, 1) = "]" Then
			$content = StringMid($line, 2, StringLen($line) - 2)
			If StringInStr($content, ":") > 0 And Not StringInStr($content, " ") Then
				_ArrayAdd($map["fen"], $content)
			Else
				$spacePos = StringInStr($content, " ")
				If $spacePos > 0 Then
					$tagName = StringLeft($content, $spacePos - 1)
					$tagValue = StringMid($content, $spacePos + 1)
					If StringLeft($tagValue, 1) = '"' And StringRight($tagValue, 1) = '"' Then
						$tagValue = StringMid($tagValue, 2, StringLen($tagValue) - 2)
					EndIf
					$map["tags"][$tagName] = $tagValue
				EndIf
			EndIf
		Else
			If Not $inMoves And StringInStr($line, "1.") > 0 Then
				$inMoves = True
			EndIf
			If $inMoves Then
				_ArrayAdd($map["moves"], $line)
			EndIf
		EndIf
	Next
	Return $map
EndFunc   ;==>_pgnAsMap

Func _fromMapToPGN($pgnMap)
	Local $pgnText = ""
	For $tagName In MapKeys($pgnMap["tags"])
		$pgnText &= "[" & $tagName & ' "' & $pgnMap["tags"][$tagName] & '"]' & @CRLF
	Next
	For $fen In $pgnMap["fen"]
		$pgnText &= "[" & $fen & "]" & @CRLF
	Next
	For $move In $pgnMap["moves"]
		$pgnText &= $move & @CRLF
	Next
	Return $pgnText
EndFunc   ;==>_fromMapToPGN

