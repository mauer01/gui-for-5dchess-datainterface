#include-once
#include <Array.au3>
#include <moreArray.au3>
#include <File.au3>
#include <JSON.au3>


Func _multiverse_create($mode = "t0", $opt = "", $opt2 = -1, $opt3 = 1)
	Local $i_multiverse[]
	Local $array[0][0]
	Local $array2[0]
	$i_multiverse[3] = $array2
	$i_multiverse[2] = $array
	$i_multiverse[1] = $array
	$i_multiverse[0] = DllStructCreate( _
			"int cosmeticturnoffset;" _
			 & "int enpassant;" _
			 & "int gamebuilder;" _
			 & "int boardwidth;" _
			 & "int boardheight;" _
			 & "int lastmovecolor;" _
			 & "char playerwhite[128];" _
			 & "char playerback[128];" _
			 & "char date[10];" _
			 & "char time[17];" _
			 & "char event[128];" _
			 & "char result[3];" _
			 & "char game[128];" _
			)
	$i_multiverse[0].cosmeticturnoffset = 0
	Switch $mode
		Case "t0"
			$board = _createboard()
			$i_multiverse[0].cosmeticturnoffset = 1
			$i_multiverse[0].gamebuilder = 1
			$i_multiverse[0].boardwidth = 8
			$i_multiverse[0].boardheight = 8
			_ArrayAdd($i_multiverse[3], "[" & _boardtofen($board) & ":0:0:b]")
			_ArrayAdd($i_multiverse[3], "[" & _boardtofen($board) & ":0:1:w]")
			_multiverseaddtimelineatturn($i_multiverse, $board, _turntoply(0, 2, $i_multiverse[0].cosmeticturnoffset), "0")
			_multiverseturnadd($i_multiverse, $board, "0")

		Case "standard"
			$board = _createboard()
			_multiverseaddtimelineatturn($i_multiverse, $board, 1, "0")
			$i_multiverse[0].gamebuilder = 1
			$i_multiverse[0].boardwidth = 8
			$i_multiverse[0].boardheight = 8
			_ArrayAdd($i_multiverse[3], "[" & _boardtofen($board) & ":0:1:w]")
		Case "dp"
			$board = _createboard("dp")
			_multiverseaddtimelineatturn($i_multiverse, $board, 1, "0")
			$i_multiverse[0].gamebuilder = 1
			$i_multiverse[0].boardwidth = 8
			$i_multiverse[0].boardheight = 8
			_ArrayAdd($i_multiverse[3], "[" & _boardtofen($board) & ":0:1:w]")
		Case "princess"
			$board = _createboard("princess")
			_multiverseaddtimelineatturn($i_multiverse, $board, 1, "0")
			$i_multiverse[0].boardwidth = 8
			$i_multiverse[0].boardheight = 8
			$i_multiverse[0].gamebuilder = 1
			_ArrayAdd($i_multiverse[3], "[" & _boardtofen($board) & ":0:1:w]")
		Case "two timelines"
			$board = _createboard()
			_multiverseaddtimelineatturn($i_multiverse, $board, 1, "-0")
			_multiverseaddtimelineatturn($i_multiverse, $board, 1, "+0")
			$i_multiverse[0].boardwidth = 8
			$i_multiverse[0].boardheight = 8
			$i_multiverse[0].gamebuilder = 2
			_ArrayAdd($i_multiverse[3], "[" & _boardtofen($board) & ":-0:1:w]")
			_ArrayAdd($i_multiverse[3], "[" & _boardtofen($board) & ":+0:1:w]")
		Case "custom"
			$lines = StringSplit($opt, "|")
			For $i = 1 To $lines[0]
				$fens = StringSplit($lines[$i], ":", 2)
				If ($fens[2] - 1 < 0 And $i_multiverse[0].cosmeticturnoffset = 0) Then
					$i_multiverse[0].cosmeticturnoffset = ($fens[2] - 1) * (-1)
				EndIf
				$fens[3] = StringReplace($fens[3], "w", "1")
				$fens[3] = StringReplace($fens[3], "b", "2")
				$board = _createboard("custom", $fens[0])
				_multiverse_setboard($i_multiverse, $board, $fens[1], $fens[2], StringLeft($fens[3], 1))
				$i_multiverse[0].gamebuilder = 1
				If ($fens[1] == "+0" Or $fens[1] == "-0") Then $i_multiverse[0].gamebuilder = 2
			Next
			$i_multiverse[0].boardheight = UBound($board)
			$i_multiverse[0].boardwidth = UBound($board)
			$i_multiverse[3] = $lines
			_ArrayDelete($i_multiverse[3], 0)
		Case "pgn"
			$i_multiverse = _multiversefrompgn($opt, $opt2, $opt3)
		Case "variant"
			_multiversefromvariant($i_multiverse, $opt)
	EndSwitch

	Return $i_multiverse
EndFunc   ;==>_multiverse_create

Func _createboard($mode = "standard", $fen = "", $bool = True)
	Local $chessboard
	Switch $mode
		Case "standard"
			For $i = 1 To 8
				_boardaddcolumn($chessboard)
				_boardaddrow($chessboard)
			Next
			Local $blackpieces[8] = ["r", "n", "b", "q", "k", "b", "n", "r"]
			Local $whitepieces[8] = ["R", "N", "B", "Q", "K", "B", "N", "R"]

			For $i = 1 To 8
				$j = $i - 1
				$chessboard = _pieceadd($chessboard, $blackpieces[$j], _AlphabeticalNumberToLetter($i) & "8")
				$chessboard = _pieceadd($chessboard, "P", _AlphabeticalNumberToLetter($i) & "2")
				$chessboard = _pieceadd($chessboard, "p", _AlphabeticalNumberToLetter($i) & "7")
				$chessboard = _pieceadd($chessboard, $whitepieces[$j], _AlphabeticalNumberToLetter($i) & "1")
			Next
		Case "princess"
			Local $blackpieces[8] = ["r", "n", "b", "s", "k", "b", "n", "r"]
			Local $whitepieces[8] = ["R", "N", "B", "S", "K", "B", "N", "R"]

			For $i = 1 To 8
				_boardaddcolumn($chessboard)
				_boardaddrow($chessboard)
			Next
			For $i = 1 To 8
				$j = $i - 1
				$chessboard = _pieceadd($chessboard, $blackpieces[$j], _AlphabeticalNumberToLetter($i) & "8")
				$chessboard = _pieceadd($chessboard, "P", _AlphabeticalNumberToLetter($i) & "2")
				$chessboard = _pieceadd($chessboard, "p", _AlphabeticalNumberToLetter($i) & "7")
				$chessboard = _pieceadd($chessboard, $whitepieces[$j], _AlphabeticalNumberToLetter($i) & "1")
			Next
		Case "dp"
			Local $blackpieces[8] = ["r", "q", "b", "n", "k", "b", "n", "r"]
			Local $whitepieces[8] = ["R", "Q", "B", "N", "K", "B", "N", "R"]

			For $i = 1 To 8
				_boardaddcolumn($chessboard)
				_boardaddrow($chessboard)
			Next
			For $i = 1 To 8
				$j = $i - 1
				$chessboard = _pieceadd($chessboard, $blackpieces[$j], _AlphabeticalNumberToLetter($i) & "8")
				$chessboard = _pieceadd($chessboard, "P", _AlphabeticalNumberToLetter($i) & "2")
				$chessboard = _pieceadd($chessboard, "p", _AlphabeticalNumberToLetter($i) & "7")
				$chessboard = _pieceadd($chessboard, $whitepieces[$j], _AlphabeticalNumberToLetter($i) & "1")
			Next
		Case "custom"
			Local $k = 0
			If $bool Then
				$row = StringSplit($fen, "/")
				For $i = 1 To $row[0]
					_boardaddcolumn($chessboard)
					_boardaddrow($chessboard)
				Next
				For $i = $row[0] To 1 Step -1
					$piece = StringRegExp($row[$i], "[a-zA-Z1-8]", 3)
					$k = 0
					For $j = 0 To UBound($piece) - 1
						If Number($piece[$j]) = 1 Then
							$chessboard = _pieceadd($chessboard, $piece[$j], _AlphabeticalNumberToLetter($j + $k + 1) & Abs($i - $row[0]) + 1)
						ElseIf Number($piece[$j]) > 1 Then
							$k += Number($piece[$j]) - 1
						Else
							$chessboard = _pieceadd($chessboard, $piece[$j], _AlphabeticalNumberToLetter($j + $k + 1) & Abs($i - $row[0]) + 1)
						EndIf
					Next
				Next


			EndIf
	EndSwitch

	Return $chessboard
EndFunc   ;==>_createboard
Func _arrayaddcount(ByRef $i_array)
	Local $max = UBound($i_array)
	Local $array[$max + 1]
	For $i = 1 To $max
		$array[$i] = $i_array[$i - 1]
	Next
	$array[0] = UBound($i_array)
	$i_array = $array
EndFunc   ;==>_arrayaddcount

Func _multiversefromvariant(ByRef $i_multiverse, $variant)
	$timelines = MapKeys($variant["Timelines"])
	If $variant["CosmeticTurnOffset"] Then $i_multiverse[0].cosmeticturnoffset = $variant["CosmeticTurnOffset"]
	If $variant["GameBuilderOverride"] = "GameBuilderOdd" Then
		$i_multiverse[0].gamebuilder = 1
	ElseIf $variant["GameBuilderOverride"] = "GameBuilderEven" Then
		$i_multiverse[0].gamebuilder = 2
	Else
		$i_multiverse[0].gamebuilder = _IsEven(UBound($timelines)) - 1 + 2
	EndIf

	For $i = 0 To UBound($variant["Timelines"]) - 1
		$timelinename = $timelines[$i]
		$timelinetocopy = $variant["Timelines"][$timelinename]
		$j = 0
		While $j < UBound($timelinetocopy)
			If $timelinetocopy[$j] = Null Then
				$j += 1
				ContinueLoop
			EndIf
			If _IsEven($j) Then
				$movecolor = 1
			Else
				$movecolor = 2
			EndIf
			$board = _createboard("custom", $timelinetocopy[$j])
			_multiverse_setboard($i_multiverse, $board, $timelinename, _plyToTurn($j + 1), $movecolor)
			$j += 1
		WEnd
	Next
	$i_multiverse[0].boardheight = UBound($board)
	$i_multiverse[0].boardwidth = UBound($board)
EndFunc   ;==>_multiversefromvariant

Func _multiversefrompgn($i_pgn, $stopmove = -1, $includeblackmove = 1)
	Local $i = 0, $f_lines, $result, $whiteuser, $blackuser, $date, $time, $event, $game
	Select
		Case FileExists($i_pgn)
			_FileReadToArray($i_pgn, $f_lines)
		Case IsArray($i_pgn)
			If (Not IsNumber($i_pgn[0])) Then _arrayaddcount($i_pgn)
			$f_lines = $i_pgn
		Case IsString($i_pgn)
			$f_lines = StringSplit($i_pgn, @LF, 1)
	EndSelect

	$lastline = $f_lines[0]
	If $stopmove = -1 Then
		While Not StringRegExp($f_lines[$lastline], "[0-9]+.")
			$lastline -= 1
		WEnd
		$stopmove = StringRegExp($f_lines[$lastline], "[0-9]+", 3)[0]
	EndIf
	While Not StringRegExp($f_lines[$i], "\[[a-zA-Z]+")
		$i += 1
	WEnd
	While Not StringRegExp($f_lines[$i], ":[+-]?\d+:\d+:[wb]\]$")
		Switch StringRegExp($f_lines[$i], "[a-zA-Z]+", 3)[0]
			Case "Result"
				$result = StringRegExp($f_lines[$i], '[01]-[01]', 3)[0]
			Case "Date"
				$date = StringRegExp($f_lines[$i], '[0-9]+.[0-9]+.[0-9]+', 3)[0]
			Case "Time"
				$time = StringRegExp($f_lines[$i], '[0-9]+:[0-9]+:[0-9]+ \([\+\-][0-9]+:[0-9]+\)', 3)[0]
			Case "White"
				$whiteuser = StringRegExp($f_lines[$i], '"(.)+"', 2)[0]
				$whiteuser = StringTrimRight($whiteuser, 1)
				$whiteuser = StringTrimLeft($whiteuser, 1)
			Case "Black"
				$blackuser = StringRegExp($f_lines[$i], '"(.)+"', 2)[0]
				$blackuser = StringTrimRight($blackuser, 1)
				$blackuser = StringTrimLeft($blackuser, 1)
			Case "Event"
				$event = StringRegExp($f_lines[$i], '"(.)+"', 2)
				$event = StringTrimRight($event, 1)
				$event = StringTrimLeft($event, 1)
			Case "Game"
				$game = StringRegExp($f_lines[$i], '"(.)+"', 2)[0]
				$game = StringTrimRight($game, 1)
				$game = StringTrimLeft($game, 1)
		EndSwitch
		$i += 1
	WEnd
	$fen = ""
	While (StringLeft($f_lines[$i], 2) = "1.") = False

		$fen &= $f_lines[$i] & "|"
		$i += 1
		If $i > $lastline Then
			ExitLoop
		EndIf
	WEnd
	$fen = StringTrimRight($fen, 1)
	$multiverse = _multiverse_create("custom", $fen)
	#Region metadata
	$multiverse[0].playerwhite = $whiteuser
	$multiverse[0].playerback = $blackuser
	$multiverse[0].date = $date
	$multiverse[0].time = $time
	$multiverse[0].event = $event
	$multiverse[0].result = $result
	$multiverse[0].game = $game
	#EndRegion metadata
	$brokenWhiteMoves = False
	While ($i <= $lastline And StringRegExp($f_lines[$i], "[0-9]+", 3)[0] <> $stopmove + 1)
		$ply = StringSplit($f_lines[$i], "/", 2)
		If @error = 1 Then $includeblackmove = 0
		$whitemoves = $ply[0]
		While (StringLeft($whitemoves, 1) = "(") = False
			If $whitemoves = "" Then
				$brokenWhiteMoves = True
				ExitLoop
			EndIf
			$whitemoves = StringTrimLeft($whitemoves, 1)
		WEnd

		$whitemove = StringRegExp($whitemoves, "[Ta-z0-9->]+", 3)

		For $j = 0 To UBound($whitemove) - 1 Step +2
			$whitesply = $whitemove[$j] & $whitemove[$j + 1]

			If StringRight($whitesply, 1) = ">" Then
				$whitesply &= $whitemove[$j + 2] & $whitemove[$j + 3]
				$j += 2
			EndIf
			_multiversemove($multiverse, _moveconvert($whitesply, 1), _moveconvert($whitesply, 0), 1)
		Next
		If ($includeblackmove = 1 Or StringRegExp($f_lines[$i], "[0-9]+", 3)[0] <> $stopmove) Then
			$blackmoves = $ply[1]
			While (StringLeft($blackmoves, 1) = "(") = False And ($blackmoves <> "")
				$blackmoves = StringTrimLeft($blackmoves, 1)
			WEnd
			$blackmove = StringRegExp($blackmoves, "[Ta-z0-9->]+", 3)


			For $j = 0 To UBound($blackmove) - 1 Step +2
				$blacksply = $blackmove[$j] & $blackmove[$j + 1]
				If StringRight($blacksply, 1) = ">" Then
					$blacksply &= $blackmove[$j + 2] & $blackmove[$j + 3]
					$j += 2
				EndIf
				_multiversemove($multiverse, _moveconvert($blacksply, 1), _moveconvert($blacksply, 0), 2)
			Next
		EndIf
		$i += 1
	WEnd
	If $brokenWhiteMoves Then $multiverse["brokenWhite"] = True
	Return $multiverse
EndFunc   ;==>_multiversefrompgn

Func _multiverse_setboard(ByRef $i_multiverse, $board, $timelinename, $turn, $color)

	$timelines = UBound($i_multiverse[1], 2) - 1
	$maxturns = UBound($i_multiverse[1]) - 1
	$ply = _turntoply($turn, $color, $i_multiverse[0].cosmeticturnoffset)
	Local $timeline = _multiverse_gettimelinebyname($i_multiverse, $timelinename)
	If String($timeline) <> "not found" Then
		If $ply > $maxturns Then
			Local $newmultiverse[$ply + 1][$timelines + 1]
			For $i = 0 To $timelines
				For $j = 0 To $maxturns
					$newmultiverse[$j][$i] = ($i_multiverse[1])[$j][$i]
				Next
			Next
			For $i = $maxturns + 1 To $ply
				$newmultiverse[$i][$timeline] = "null"
			Next
			$newmultiverse[$ply][$timeline] = $board

			$i_multiverse[1] = $newmultiverse
		Else
			_multiverse_changeboard($i_multiverse[1], $ply, $timeline, $board)
		EndIf
	Else
		_multiverseaddtimelineatturn($i_multiverse, $board, $ply, $timelinename)
	EndIf
EndFunc   ;==>_multiverse_setboard

Func _boardaddrow(ByRef $i_chessboard)
	Local $count = UBound($i_chessboard, 2)
	Local $row[1][$count]
	For $i = 0 To UBound($i_chessboard, 2) - 1
		$row[0][$i] = "1"
	Next
	_ArrayAdd($i_chessboard, $row)
EndFunc   ;==>_boardaddrow

Func _boardaddcolumn(ByRef $i_chessboard)
	Local $rowCount = UBound($i_chessboard)
	Local $colCount = UBound($i_chessboard, 2) + 1

	Local $newChessboard[$rowCount][$colCount]

	For $i = 0 To $rowCount - 1
		For $j = 0 To $colCount - 1
			If $j = $colCount - 1 Then
				$newChessboard[$i][$j] = "1"
			Else
				$newChessboard[$i][$j] = $i_chessboard[$i][$j]
			EndIf
		Next
	Next

	$i_chessboard = $newChessboard
EndFunc   ;==>_boardaddcolumn

Func _multiverseturnadd(ByRef $i_multiverse, $board, $timeline)
	Local $c_longesttimeline = UBound($i_multiverse[1]), $c_width = UBound($i_multiverse[1], 2), $addturn = 0, $rowCount, $linecount
	Local $longesttimelines = _multiversegetlongesttimelines($i_multiverse)
	For $i = 1 To $longesttimelines[0]
		If $timeline = $longesttimelines[$i] Then
			$addturn = 1
			ExitLoop
		EndIf
	Next

	$rowCount = $c_longesttimeline + $addturn
	$linecount = $c_width
	Local $newmultiverse[$rowCount][$linecount]
	For $i = 0 To $linecount - 1
		For $j = 0 To $rowCount - (1 + $addturn)
			$newmultiverse[$j][$i] = ($i_multiverse[1])[$j][$i]
		Next
	Next
	For $i = $rowCount - (1 + $addturn) To 1 Step -1
		If IsArray(($i_multiverse[1])[$i][$timeline]) Then
			$j = $i + 1
			$newmultiverse[$j][$timeline] = $board
			ExitLoop
		EndIf
	Next
	$i_multiverse[1] = $newmultiverse
EndFunc   ;==>_multiverseturnadd

Func _multiverseaddtimelineatturn(ByRef $i_multiverse, $board, $ply, $timelinename)
	Local $c_longesttimeline = UBound($i_multiverse[1]), $rowCount
	$byebye = $ply - $c_longesttimeline + 1
	If $ply < $c_longesttimeline Then $byebye = 0

	$rowCount = $c_longesttimeline + $byebye
	Local $linecount = UBound($i_multiverse[1], 2) + 1
	Local $linecount2 = $linecount - 1
	Local $newmultiverse[$rowCount][$linecount]
	$newmultiverse[0][$linecount2] = $timelinename
	For $i = 0 To $linecount2 - 1
		For $j = 0 To $c_longesttimeline - 1
			$newmultiverse[$j][$i] = ($i_multiverse[1])[$j][$i]
		Next
	Next

	For $i = 1 To $ply
		If $i = $ply Then
			$newmultiverse[$ply][$linecount2] = $board
		Else
			$newmultiverse[$i][$linecount2] = "null"
		EndIf
	Next

	$i_multiverse[1] = $newmultiverse
EndFunc   ;==>_multiverseaddtimelineatturn

Func _multiversemove(ByRef $i_multiverse, $startmove, $endmove, $movecolor)
	Local $i_startboard[2], $i_startsquare[2], $endboard[2], $endsquare[2], $i_starttimeline, $endtimeline, $board, $board2, $newtimelinename, $i, $moves = $i_multiverse[2], $piecenotation, $move
	Local $width = _multiverse_getwidth($i_multiverse)

	If $movecolor = 1 Then
		$newtimelinename = $width[0] + 1
	Else
		$newtimelinename = Number($width[1]) - 1
	EndIf
	$startarray = StringSplit($startmove, "|", 2)
	$endarray = StringSplit($endmove, "|", 2)
	$i_startboard[0] = $startarray[0]
	$i_startboard[1] = _turntoply($startarray[1], $movecolor, $i_multiverse[0].cosmeticturnoffset)
	$i_startsquare[0] = $startarray[2]
	$i_startsquarenumber = _LetterToAlphabeticalNumber($i_startsquare[0]) - 1
	$i_startsquare[1] = $startarray[3]
	$endboard[0] = $endarray[0]
	$endboard[1] = _turntoply($endarray[1], $movecolor, $i_multiverse[0].cosmeticturnoffset)
	$endsquare[0] = $endarray[2]
	$endsquare[1] = $endarray[3]
	$endsquarenumber = _LetterToAlphabeticalNumber($endsquare[0]) - 1
	$i_starttimeline = _multiverse_gettimelinebyname($i_multiverse, $i_startboard[0])
	$endtimeline = _multiverse_gettimelinebyname($i_multiverse, $endboard[0])
	$piece = (($i_multiverse[1])[$i_startboard[1]][$i_starttimeline])[$i_startsquare[1] - 1][$i_startsquarenumber]
	$piecenotation = StringUpper($piece)
	If ($piecenotation == "P" Or $piecenotation = "W") Then $piecenotation = ""
	$board = _pieceadd(($i_multiverse[1])[$endboard[1]][$endtimeline], $piece, $endsquare[0] & $endsquare[1])

	$board2 = _removepiece(($i_multiverse[1])[$i_startboard[1]][$i_starttimeline], $i_startsquare[0] & $i_startsquare[1])
	Select
		Case ($i_starttimeline = $endtimeline And $i_startboard[1] = $endboard[1])
			_multiverseturnadd($i_multiverse, _movepiece(($i_multiverse[1])[$i_startboard[1]][$i_starttimeline], $i_startsquare[0] & $i_startsquare[1], $endsquare[0] & $endsquare[1]), $i_starttimeline)

			$move = "(" & $i_starttimeline & "T" & $startarray[1] & ")" & $piecenotation & $i_startsquare[0] & $i_startsquare[1] & $endsquare[0] & $endsquare[1]

		Case $endboard[1] = _multiverse_findendboard($i_multiverse, $endtimeline)
			_multiverseturnadd($i_multiverse, $board2, $i_starttimeline)
			_multiverseturnadd($i_multiverse, $board, $endtimeline)

			$move = "(" & $i_starttimeline & "T" & $startarray[1] & ")" & $piecenotation & $i_startsquare[0] & $i_startsquare[1] & ">" & "(" & $endtimeline & "T" & $endarray[1] & ")" & $endsquare[0] & $endsquare[1]

		Case Else
			If ($piece == "w" And $endsquare[1] = 1) Then
				$board = _pieceadd($board, "q", $endsquare[0] & $endsquare[1])
			ElseIf ($piece == "W" And $endsquare[1] = 8) Then
				$board = _pieceadd($board, "Q", $endsquare[0] & $endsquare[1])
			EndIf

			_multiverseaddtimelineatturn($i_multiverse, $board, $endboard[1] + 1, $newtimelinename)
			_multiverseturnadd($i_multiverse, $board2, $i_starttimeline)


			$move = "(" & $i_starttimeline & "T" & $startarray[1] & ")" & $piecenotation & $i_startsquare[0] & $i_startsquare[1] & ">>" & "(" & $endtimeline & "T" & $endarray[1] & ")" & $endsquare[0] & $endsquare[1]

	EndSelect

	If $piece == "K" Then
		If $i_startsquarenumber - $endsquarenumber = 2 Then
			$rook = _chessboard_scanrowforpiece(($i_multiverse[1])[$i_startboard[1]][$i_starttimeline], $i_startsquare[1] - 1, "R")
			$i = $rook[0]
			While $rook[$i] > $endsquarenumber
				_ArrayDelete($rook, $i)
				$rook[0] -= 1
				$i -= 1
			WEnd
			_multiverse_changeboard($i_multiverse[1], $i_startboard[1] + 1, $i_starttimeline, _removepiece(($i_multiverse[1])[$i_startboard[1] + 1][$i_starttimeline], _AlphabeticalNumberToLetter($rook[$i] + 1) & $endsquare[1]))
			_multiverse_changeboard($i_multiverse[1], $i_startboard[1] + 1, $i_starttimeline, _pieceadd(($i_multiverse[1])[$i_startboard[1] + 1][$i_starttimeline], "R", _AlphabeticalNumberToLetter($endsquarenumber + 2) & $endsquare[1]))


		ElseIf $i_startsquarenumber - $endsquarenumber = -2 Then

			$rook = _chessboard_scanrowforpiece(($i_multiverse[1])[$i_startboard[1]][$i_starttimeline], $i_startsquare[1] - 1, "R")
			$i = 1
			While $rook[0] > 1

				If $rook[$i] < $endsquarenumber - 1 Then
					_ArrayDelete($rook, $i)
					$rook[0] -= 1
				EndIf
				$i += 1

			WEnd
			_multiverse_changeboard($i_multiverse[1], $i_startboard[1] + 1, $i_starttimeline, _removepiece(($i_multiverse[1])[$i_startboard[1] + 1][$i_starttimeline], _AlphabeticalNumberToLetter($rook[1] + 1) & $endsquare[1]))
			_multiverse_changeboard($i_multiverse[1], $i_startboard[1] + 1, $i_starttimeline, _pieceadd(($i_multiverse[1])[$i_startboard[1] + 1][$i_starttimeline], "R", _AlphabeticalNumberToLetter($endsquarenumber) & $endsquare[1]))

		EndIf

	ElseIf $piece == "k" Then
		If $i_startsquarenumber - $endsquarenumber = 2 Then
			$rook = _chessboard_scanrowforpiece(($i_multiverse[1])[$i_startboard[1]][$i_starttimeline], $i_startsquare[1] - 1, "r")
			$i = $rook[0]
			While $rook[$i] > $endsquarenumber
				_ArrayDelete($rook, $i)
				$rook[0] -= 1
				$i -= 1
			WEnd

			_multiverse_changeboard($i_multiverse[1], $i_startboard[1] + 1, $i_starttimeline, _removepiece(($i_multiverse[1])[$i_startboard[1] + 1][$i_starttimeline], _AlphabeticalNumberToLetter($rook[$i] + 1) & $endsquare[1]))
			_multiverse_changeboard($i_multiverse[1], $i_startboard[1] + 1, $i_starttimeline, _pieceadd(($i_multiverse[1])[$i_startboard[1] + 1][$i_starttimeline], "r", _AlphabeticalNumberToLetter($endsquarenumber + 2) & $endsquare[1]))


		ElseIf $i_startsquarenumber - $endsquarenumber = -2 Then

			$rook = _chessboard_scanrowforpiece(($i_multiverse[1])[$i_startboard[1]][$i_starttimeline], $i_startsquare[1] - 1, "r")
			$i = 1
			While $rook[0] > 1

				If $rook[$i] < $endsquarenumber - 1 Then
					_ArrayDelete($rook, $i)
					$rook[0] -= 1
				EndIf
				$i += 1

			WEnd
			_multiverse_changeboard($i_multiverse[1], $i_startboard[1] + 1, $i_starttimeline, _removepiece(($i_multiverse[1])[$i_startboard[1] + 1][$i_starttimeline], _AlphabeticalNumberToLetter($rook[1] + 1) & $endsquare[1]))
			_multiverse_changeboard($i_multiverse[1], $i_startboard[1] + 1, $i_starttimeline, _pieceadd(($i_multiverse[1])[$i_startboard[1] + 1][$i_starttimeline], "r", _AlphabeticalNumberToLetter($endsquarenumber) & $endsquare[1]))

		EndIf



	ElseIf $piece == "P" Then

		If $endsquare[1] = 8 Then _multiverse_changeboard($i_multiverse[1], $i_startboard[1] + 1, $i_starttimeline, _pieceadd(($i_multiverse[1])[$i_startboard[1] + 1][$i_starttimeline], "Q", _AlphabeticalNumberToLetter($endsquarenumber + 1) & $endsquare[1]))

		If $endsquarenumber & $endsquare[1] = $i_multiverse[0].enpassant Then _multiverse_changeboard($i_multiverse[1], $i_startboard[1] + 1, $i_starttimeline, _removepiece(($i_multiverse[1])[$i_startboard[1] + 1][$i_starttimeline], $endsquare[0] & $endsquare[1] - 1))

		If $i_multiverse[0].enpassant <> -1 Then $i_multiverse[0].enpassant = -1

		If Abs($i_startsquare[1] - $endsquare[1]) = 2 Then $i_multiverse[0].enpassant = $endsquarenumber & $endsquare[1] - 1

	ElseIf $piece == "p" Then

		If $endsquare[1] = 1 Then _multiverse_changeboard($i_multiverse[1], $i_startboard[1] + 1, $i_starttimeline, _pieceadd(($i_multiverse[1])[$i_startboard[1] + 1][$i_starttimeline], "q", _AlphabeticalNumberToLetter($endsquarenumber + 1) & $endsquare[1]))

		If $endsquarenumber & $endsquare[1] = $i_multiverse[0].enpassant Then _multiverse_changeboard($i_multiverse[1], $i_startboard[1] + 1, $i_starttimeline, _removepiece(($i_multiverse[1])[$i_startboard[1] + 1][$i_starttimeline], $endsquare[0] & $endsquare[1] + 1))

		If $i_multiverse[0].enpassant <> -1 Then $i_multiverse[0].enpassant = -1

		If Abs($i_startsquare[1] - $endsquare[1]) = 2 Then $i_multiverse[0].enpassant = $endsquarenumber & $endsquare[1] + 1

	ElseIf $piece == "W" Then

		If $endsquare[1] = 8 Then _multiverse_changeboard($i_multiverse[1], $i_startboard[1] + 1, $i_starttimeline, _pieceadd(($i_multiverse[1])[$i_startboard[1] + 1][$i_starttimeline], "Q", _AlphabeticalNumberToLetter($endsquarenumber + 1) & $endsquare[1]))
		If $endsquarenumber & $endsquare[1] = $i_multiverse[0].enpassant Then _multiverse_changeboard($i_multiverse[1], $i_startboard[1] + 1, $i_starttimeline, _removepiece(($i_multiverse[1])[$i_startboard[1] + 1][$i_starttimeline], $endsquare[0] & $endsquare[1] - 1))
		If $i_multiverse[0].enpassant <> -1 Then $i_multiverse[0].enpassant = -1
		If Abs($i_startsquare[1] - $endsquare[1]) = 2 Then $i_multiverse[0].enpassant = $endsquarenumber & $endsquare[1] - 1


	ElseIf $piece == "w" Then

		If $endsquare[1] = 1 Then _multiverse_changeboard($i_multiverse[1], $i_startboard[1] + 1, $i_starttimeline, _pieceadd(($i_multiverse[1])[$i_startboard[1] + 1][$i_starttimeline], "q", _AlphabeticalNumberToLetter($endsquarenumber + 1) & $endsquare[1]))
		If $endsquarenumber & $endsquare[1] = $i_multiverse[0].enpassant Then _multiverse_changeboard($i_multiverse[1], $i_startboard[1] + 1, $i_starttimeline, _removepiece(($i_multiverse[1])[$i_startboard[1] + 1][$i_starttimeline], $endsquare[0] & $endsquare[1] - 1))
		If $i_multiverse[0].enpassant <> -1 Then $i_multiverse[0].enpassant = -1
		If Abs($i_startsquare[1] - $endsquare[1]) = 2 Then $i_multiverse[0].enpassant = $endsquarenumber & $endsquare[1] - 1

	EndIf

	If $movecolor - 1 Then
		If $i_multiverse[0].lastmovecolor - 1 Then
			$movenumber = UBound($i_multiverse[2])
			$moves[$movenumber - 1][1] &= " " & $move
		Else
			$movenumber = UBound($i_multiverse[2])
			$moves[$movenumber - 1][1] = $move
		EndIf
	Else
		If $i_multiverse[0].lastmovecolor - 1 Then
			$movenumber = UBound($i_multiverse[2])
			ReDim $moves[$movenumber + 1][2]
			$moves[$movenumber][0] = $move
		Else
			$movenumber = UBound($i_multiverse[2])
			$moves[$movenumber - 1][0] &= " " & $move
		EndIf
	EndIf
	$i_multiverse[0].lastmovecolor = $movecolor
	$i_multiverse[2] = $moves
EndFunc   ;==>_multiversemove

Func _multiverse_changeboard(ByRef $i_multiverse, $turn, $line, $board)
	$i_multiverse[$turn][$line] = $board
EndFunc   ;==>_multiverse_changeboard

Func _pieceadd($i_chessboard, $piece, $square)
	Local $newboard = $i_chessboard

	$y = _LetterToAlphabeticalNumber(StringSplit($square, "", 2)[0]) - 1
	$x = StringSplit($square, "", 2)[1] - 1

	$newboard[$x][$y] = $piece
	Return $newboard
EndFunc   ;==>_pieceadd

Func _removepiece($i_chessboard, $square)
	Local $newboard = $i_chessboard
	$xy = StringSplit($square, "", 2)
	$x = _LetterToAlphabeticalNumber($xy[0]) - 1
	$y = $xy[1] - 1
	$newboard[$y][$x] = 1
	Return $newboard
EndFunc   ;==>_removepiece

Func _movepiece($i_chessboard, $i_startsquare, $i_endsquare)
	Local $start = StringSplit($i_startsquare, "", 2)
	Local $end = StringSplit($i_endsquare, "", 2)
	Local $startcol = _LetterToAlphabeticalNumber($start[0]) - 1
	Local $endcol = _LetterToAlphabeticalNumber($end[0]) - 1
	Local $startrow = $start[1] - 1
	Local $endrow = $end[1] - 1
	$i_chessboard[$endrow][$endcol] = $i_chessboard[$startrow][$startcol]
	$i_chessboard[$startrow][$startcol] = 1
	Return $i_chessboard
EndFunc   ;==>_movepiece


Func _multiversegetlongesttimelines($i_multiverse)
	Local $c_longesttimeline = UBound($i_multiverse[1]) - 1, $c_width = UBound($i_multiverse[1], 2) - 1
	Local $return[1] = [0]
	For $i = 0 To $c_width
		For $j = $c_longesttimeline To 0 Step -1
			If (IsArray(($i_multiverse[1])[$j][$i]) And $j = $c_longesttimeline) Then
				$return[0] += 1
				_ArrayAdd($return, $i)
			EndIf
		Next
	Next
	Return $return
EndFunc   ;==>_multiversegetlongesttimelines



Func _moveconvert($move, $startend = 1, $method = 0)
	Local $string, $fullply, $ply
	Switch $method
		Case 0
			If $startend Then

				If StringInStr($move, ">") > 0 Then

					While StringInStr($move, ">") > 0
						$move = StringTrimRight($move, 1)
					WEnd
					$string = StringReplace(StringTrimRight($move, 2), "T", "|") & "|"
					$string &= StringLeft(StringRight($move, 2), 1) & "|" & StringRight(StringRight($move, 2), 1)
				Else
					$string = StringReplace(StringTrimRight($move, 4), "T", "|") & "|"
					$string &= StringLeft(StringLeft(StringRight($move, 4), 2), 1) & "|" & StringRight(StringLeft(StringRight($move, 4), 2), 1)
				EndIf
			Else
				If StringInStr($move, ">") > 0 Then
					While StringInStr($move, ">") > 0
						$move = StringTrimLeft($move, 1)
					WEnd
					$string = StringReplace(StringTrimRight($move, 2), "T", "|") & "|"
					$string &= StringLeft(StringRight($move, 2), 1) & "|" & StringRight(StringRight($move, 2), 1)
				Else
					$string = StringReplace(StringTrimRight($move, 4), "T", "|") & "|"
					$string &= StringLeft(StringRight(StringRight($move, 4), 2), 1) & '|' & StringRight(StringRight(StringRight($move, 4), 2), 1)


				EndIf

			EndIf
		Case 1
			$move = StringRegExp($move, "[Ta-z0-9->]+", 3)
			$ply = $move[0] & $move[1]
			If StringRight($ply, 1) = ">" Then
				$ply &= $move[2] & $move[3]
			EndIf
			Local $fullply[2]
			$fullply[0] = _moveconvert($ply, 1)
			$fullply[1] = _moveconvert($ply, 0)
			Return $fullply
	EndSwitch
	Return $string
EndFunc   ;==>_moveconvert

Func _chessboard_scanrowforpiece($chessboard, $row, $piece)
	Local $squares[1] = [0]
	For $i = 0 To UBound($chessboard) - 1
		If $chessboard[$row][$i] == $piece Then
			_ArrayAdd($squares, $i)
			$squares[0] += 1
		EndIf
	Next

	Return $squares
EndFunc   ;==>_chessboard_scanrowforpiece

Func _multiverse_findendboard($i_multiverse, $timeline)
	For $i = UBound(($i_multiverse[1])) - 1 To 1 Step -1
		If IsArray(($i_multiverse[1])[$i][$timeline]) Then ExitLoop
	Next
	Return $i
EndFunc   ;==>_multiverse_findendboard

Func _multiverse_getwidth($i_multiverse)
	Local $max = Number(($i_multiverse[1])[0][0])
	Local $min = Number(($i_multiverse[1])[0][0])
	Local $width[2]

	For $i = 0 To UBound($i_multiverse[1], 2) - 1
		If ($i_multiverse[1])[0][$i] > $max Then
			$max = Number(($i_multiverse[1])[0][$i])
		EndIf
		If ($i_multiverse[1])[0][$i] < $min Then
			$min = Number(($i_multiverse[1])[0][$i])
		EndIf
	Next

	$width[0] = $max
	$width[1] = $min

	Return $width
EndFunc   ;==>_multiverse_getwidth

Func _multiverse_gettimelinebyname($i_multiverse, $timelinename)
	$return = "not found"
	For $i = 0 To UBound($i_multiverse[1], 2) - 1
		If $timelinename == ($i_multiverse[1])[0][$i] Then
			$return = $i
		EndIf
	Next
	Return $return
EndFunc   ;==>_multiverse_gettimelinebyname

Func _multiverse_removeemptytimelines($i_multiverse)
	$okey = 0
	For $i = 0 To UBound($i_multiverse[1], 2) - 1
		For $j = 1 To UBound(($i_multiverse[1])) - 1
			If IsArray(($i_multiverse[1])[$j][$i]) Then $okey = 1
		Next
		If $okey = 0 Then
			_ArrayColDelete($i_multiverse[1], $i)
		EndIf
	Next
	Return ($i_multiverse[1])
EndFunc   ;==>_multiverse_removeemptytimelines

Func _multiversetovariant($i_multiverse, $variant = "automatically generated", $author = "mauer01s crazy progammingskillz")
	If $i_multiverse["brokenWhite"] Then $variant &= ":noWhiteMove"
	$i_multiverse[1] = _multiverse_removeemptytimelines($i_multiverse)
	Local $string = "  {" & @LF & "    " & '"Name": "' & $variant & '",' & @LF & "    " & '"Author": "' & $author & '",' & @LF & "    " & '"Timelines": {' & @LF
	Local $timelines = UBound($i_multiverse[1], 2) - 1
	Local $turns = UBound(($i_multiverse[1])) - 1
	For $i = 0 To $timelines
		$string &= "    " & '  "' & ($i_multiverse[1])[0][$i] & 'L": [' & @LF & "    " & "   "
		$endboard = _multiverse_findendboard($i_multiverse, $i)
		For $j = 1 To $endboard
			If $j < $endboard Then
				If IsArray(($i_multiverse[1])[$j][$i]) Then
					$string &= '"' & _boardtofen(($i_multiverse[1])[$j][$i]) & '",'
				Else
					$string &= "null,"
				EndIf
			Else
				$string &= '"' & _boardtofen(($i_multiverse[1])[$j][$i]) & '"' & @LF
			EndIf
		Next
		If $i = $timelines Then
			$string &= "    " & "  ]" & @LF
		Else
			$string &= "    " & "  ]," & @LF
		EndIf
	Next

	$string &= "    " & "}," & @LF
	If $i_multiverse[0].cosmeticturnoffset > 0 Then
		$string &= '  "CosmeticTurnOffset": ' & $i_multiverse[0].cosmeticturnoffset * (-1) & "," & @LF
	EndIf
	If $i_multiverse[0].gamebuilder = 2 Then
		$string &= '  "GameBuilderOverride": "GameBuilderEven"' & @LF
	Else
		$string &= '  "GameBuilderOverride": "GameBuilderOdd"' & @LF
	EndIf
	$string &= "  }" & @LF

	Return _JSON_Parse($string)
EndFunc   ;==>_multiversetovariant

Func _multiversetopgn($i_multiverse)
	Local $lines[0], $move
	_ArrayAdd($lines, '[Mode "5D"]')
	If StringLen($i_multiverse[0].result) > 0 Then _ArrayAdd($lines, '[Result "' & $i_multiverse[0].result & '"]')
	If StringLen($i_multiverse[0].date) > 0 Then _ArrayAdd($lines, '[Date "' & $i_multiverse[0].date & '"]')
	If StringLen($i_multiverse[0].time) > 0 Then _ArrayAdd($lines, '[Time "' & $i_multiverse[0].time & '"]')
	_ArrayAdd($lines, '[Size "' & $i_multiverse[0].boardwidth & "x" & $i_multiverse[0].boardheight & '"]')
	If StringLen($i_multiverse[0].playerwhite) > 0 Then _ArrayAdd($lines, '[White "' & $i_multiverse[0].playerwhite & '"]')
	If StringLen($i_multiverse[0].playerback) > 0 Then _ArrayAdd($lines, '[Black "' & $i_multiverse[0].playerback & '"]')
	If StringLen($i_multiverse[0].event) > 0 Then _ArrayAdd($lines, '[Event "' & $i_multiverse[0].event & '"]')
	If StringLen($i_multiverse[0].game) > 0 Then _ArrayAdd($lines, '[Game "' & $i_multiverse[0].game & '"]')
	_ArrayAdd($lines, '[Board "custom"]')
	For $i = 0 To UBound($i_multiverse[3]) - 1
		_ArrayAdd($lines, ($i_multiverse[3])[$i])
	Next
	For $i = 0 To UBound($i_multiverse[2]) - 1
		$move = $i + 1 & "." & ($i_multiverse[2])[$i][0] & " / " & ($i_multiverse[2])[$i][1]
		_ArrayAdd($lines, $move)
	Next
	Return $lines
EndFunc   ;==>_multiversetopgn

Func _boardtofen($i_chessboard)
	Local $fen = "", $k
	For $i = UBound($i_chessboard) - 1 To 0 Step -1
		If $i < UBound($i_chessboard) - 1 Then $fen = $fen & "/"
		$k = 0
		For $j = 0 To UBound($i_chessboard, 2) - 1
			$c_square = $i_chessboard[$i][$j]
			If ($c_square = 1 And $j < UBound($i_chessboard, 2) - 1) Then
				$k = $k + 1
			ElseIf $c_square = 1 Then
				$k = $k + 1
				$fen = $fen & $k
			ElseIf ($c_square <> "1" And $k > 0) Then
				$fen = $fen & $k & $c_square
				$k = 0
			Else
				$fen = $fen & $c_square
			EndIf
		Next
	Next
	Return $fen
EndFunc   ;==>_boardtofen

Func _turntoply($turn, $movecolor, $offset = 0)
	Return (($turn + $offset) - 1) * 2 + $movecolor
EndFunc   ;==>_turntoply

Func _plyToTurn($ply)
	Local $movecolor = 1
	If _IsEven($ply) Then $movecolor = 2
	Return ($ply - $movecolor) / 2 + 1
EndFunc   ;==>_plyToTurn

#Region stupid stuff
Func _LetterToAlphabeticalNumber($letter)
	$letter = StringUpper($letter) ; Convert to uppercase to handle lowercase letters

	If StringRegExp($letter, "[A-Z]") = 0 Then
		; Invalid input, not a letter
		Return 0
	EndIf

	Return Asc($letter) - Asc("A") + 1
EndFunc   ;==>_LetterToAlphabeticalNumber

Func _AlphabeticalNumberToLetter($number)
	If $number < 1 Or $number > 26 Then
		; Invalid input, not a valid alphabetical number
		Return ""
	EndIf

	Return Chr($number + Asc("A") - 1)
EndFunc   ;==>_AlphabeticalNumberToLetter

Func _IsEven($number)
	Return Mod($number, 2) = 0
EndFunc   ;==>_IsEven
#EndRegion stupid stuff


Func _checkVariant($JSON)
	$initialKeys = MapKeys($JSON)
	If Not _some($initialKeys, "StringInStr", "Name") Then Return "No Name"
	If Not _some($initialKeys, "StringInStr", "Author") Then Return "No Author"
	If Not _some($initialKeys, "StringInStr", "Timelines") Then Return "No Timelines"
	$timelines = MapKeys($JSON["Timelines"])
	$counting = 0
	For $line In $timelines
		If StringRegExp($line, "^([+-]?(0|[1-9]\d*))L$") Then
			$counting += 1
		EndIf
	Next
	If Not ($counting = UBound($timelines)) Then Return "Ungültige Zeitliniennamen"
	Local $multiverse = _multiverse_create("variant", $JSON)
	$multiversum = $multiverse[1]
	For $i = 0 To UBound($multiversum) - 1
		For $j = 0 To UBound($multiversum, 2) - 1
			If Not IsArray($multiversum[$i][$j]) Then ContinueLoop
			$board = $multiversum[$i][$j]
			$boardheight = UBound($board)
			If $boardheight > 8 Then MsgBox(0, "", "")
			$boardwidth = UBound($board, 2)
			If Not IsDeclared("oldboardheight") Then $oldboardheight = $boardheight
			If $boardheight <> $boardwidth Then
				Return "Board at timeline " & $j & " and at position " & $i + 1 & " isnt a square"
			EndIf
			If $boardheight <> $oldboardheight Then
				Return "Board at timeline " & $j & " and at position " & $i + 1 & " has a different height"
			EndIf
			$oldboardheight = $boardheight
		Next
	Next
	Return True
EndFunc   ;==>_checkVariant
