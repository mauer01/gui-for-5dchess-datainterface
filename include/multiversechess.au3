#include-once
#include <Array.au3>
#include <File.au3>



Func _multiverse_create($mode = "t0",$opt = "",$opt2 = -1,$opt3 = 1)
	local $i_multiverse[4]
	dim $array[0][0]
	dim $array2[0]
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
		case "t0"
			$board = _createboard()
			$i_multiverse[0].cosmeticturnoffset = 1
			$i_multiverse[0].gamebuilder = 1
			$i_multiverse[0].boardwidth = 8
			$i_multiverse[0].boardheight = 8
			_ArrayAdd($i_multiverse[3],"["&_boardtofen($board)&":0:0:b]")
			_ArrayAdd($i_multiverse[3],"["&_boardtofen($board)&":0:1:w]")
			_multiverseaddtimelineatturn($i_multiverse,$board,_turntoply(0,2,$i_multiverse[0].cosmeticturnoffset),"0")
			_multiverseturnadd($i_multiverse,$board,"0")

		Case "standard"
			$board = _createboard()
			_multiverseaddtimelineatturn($i_multiverse,$board,1,"0")
			$i_multiverse[0].gamebuilder = 1
			$i_multiverse[0].boardwidth = 8
			$i_multiverse[0].boardheight = 8
			_ArrayAdd($i_multiverse[3],"["&_boardtofen($board)&":0:1:w]")
		Case "dp"
			$board = _createboard("dp")
			_multiverseaddtimelineatturn($i_multiverse,$board,1,"0")
			$i_multiverse[0].gamebuilder = 1
			$i_multiverse[0].boardwidth = 8
			$i_multiverse[0].boardheight = 8
			_ArrayAdd($i_multiverse[3],"["&_boardtofen($board)&":0:1:w]")
		Case "princess"
			$board = _createboard("princess")
			_multiverseaddtimelineatturn($i_multiverse,$board,1,"0")
			$i_multiverse[0].boardwidth = 8
			$i_multiverse[0].boardheight = 8
			$i_multiverse[0].gamebuilder = 1
			_ArrayAdd($i_multiverse[3],"["&_boardtofen($board)&":0:1:w]")
		Case "two timelines"
			$board = _createboard()
			_multiverseaddtimelineatturn($i_multiverse,$board,1,"-0")
			_multiverseaddtimelineatturn($i_multiverse,$board,1,"+0")
			$i_multiverse[0].boardwidth = 8
			$i_multiverse[0].boardheight = 8
			$i_multiverse[0].gamebuilder = 2
			_ArrayAdd($i_multiverse[3],"["&_boardtofen($board)&":-0:1:w]")
			_ArrayAdd($i_multiverse[3],"["&_boardtofen($board)&":+0:1:w]")
		Case "custom"
			$lines = StringSplit($opt,"|")
			for $i = 1 to $lines[0]
				$fens = StringSplit($lines[$i],":",2)
				if ($fens[2]-1 < 0 And $i_multiverse[0].cosmeticturnoffset = 0) Then
					$i_multiverse[0].cosmeticturnoffset = ($fens[2]-1) * (-1)
				EndIf
				$fens[3] = StringReplace($fens[3],"w","1")
				$fens[3] = StringReplace($fens[3],"b","2")
				$board = _createboard("custom",$fens[0])
				_multiverse_setboard($i_multiverse, $board, $fens[1], $fens[2], StringLeft($fens[3],1))
				$i_multiverse[0].gamebuilder = 1
				If ($fens[1] == "+0" or $fens[1] == "-0") Then $i_multiverse[0].gamebuilder = 2
			Next
			$i_multiverse[0].boardheight = UBound($board)
			$i_multiverse[0].boardwidth = UBound($board)
			$i_multiverse[3] = $lines
			_ArrayDelete($i_multiverse[3],0)
		Case "pgn"
			$i_multiverse = _multiversefrompgn($opt,$opt2,$opt3)

	EndSwitch

	Return $i_multiverse
EndFunc

Func _createboard($mode = "standard", $fen = "",$bool = True)
	dim $chessboard
	Switch $mode
		case "standard"
			For $i = 1 to 8
				_boardaddcolumn($chessboard)
				_boardaddrow($chessboard)
			Next
			dim $blackpieces[8] = ["r","n","b","q","k","b","n","r"]
			dim $whitepieces[8] = ["R","N","B","Q","K","B","N","R"]

			For $i = 1 to 8
				$j = $i-1
				$chessboard = _pieceadd($chessboard,$blackpieces[$j],AlphabeticalNumberToLetter($i) & "8")
				$chessboard = _pieceadd($chessboard,"P",AlphabeticalNumberToLetter($i) & "2")
				$chessboard = _pieceadd($chessboard,"p",AlphabeticalNumberToLetter($i) & "7")
				$chessboard = _pieceadd($chessboard,$whitepieces[$j],AlphabeticalNumberToLetter($i) & "1")
			Next
		Case "princess"
			dim $blackpieces[8] = ["r","n","b","s","k","b","n","r"]
			dim $whitepieces[8] = ["R","N","B","S","K","B","N","R"]

			For $i = 1 to 8
				_boardaddcolumn($chessboard)
				_boardaddrow($chessboard)
			Next
			For $i = 1 to 8
				$j = $i-1
				$chessboard = _pieceadd($chessboard,$blackpieces[$j],AlphabeticalNumberToLetter($i) & "8")
				$chessboard = _pieceadd($chessboard,"P",AlphabeticalNumberToLetter($i) & "2")
				$chessboard = _pieceadd($chessboard,"p",AlphabeticalNumberToLetter($i) & "7")
				$chessboard = _pieceadd($chessboard,$whitepieces[$j],AlphabeticalNumberToLetter($i) & "1")
			Next
		Case "dp"
			dim $blackpieces[8] = ["r","q","b","n","k","b","n","r"]
			dim $whitepieces[8] = ["R","Q","B","N","K","B","N","R"]

			For $i = 1 to 8
				_boardaddcolumn($chessboard)
				_boardaddrow($chessboard)
			Next
			For $i = 1 to 8
				$j = $i-1
				$chessboard = _pieceadd($chessboard,$blackpieces[$j],AlphabeticalNumberToLetter($i) & "8")
				$chessboard = _pieceadd($chessboard,"P",AlphabeticalNumberToLetter($i) & "2")
				$chessboard = _pieceadd($chessboard,"p",AlphabeticalNumberToLetter($i) & "7")
				$chessboard = _pieceadd($chessboard,$whitepieces[$j],AlphabeticalNumberToLetter($i) & "1")
			Next
		Case "custom"
			local $k = 0
			If $bool Then
				$row = StringSplit($fen,"/")
				for $i = 1 to $row[0]
					_boardaddcolumn($chessboard)
					_boardaddrow($chessboard)
				Next
				For $i = $row[0] to 1 step -1
					$piece = StringRegExp($row[$i],"[a-zA-Z1-8]",3)
					$k = 0
					for $j = 0 to UBound($piece)-1
						If Number($piece[$j]) = 1 Then
							$chessboard = _pieceadd($chessboard,$piece[$j],AlphabeticalNumberToLetter($j+$k+1) & Abs($i-$row[0]) + 1)
						ElseIf Number($piece[$j]) > 1 Then
							$k += Number($piece[$j])-1
						Else
							$chessboard = _pieceadd($chessboard,$piece[$j],AlphabeticalNumberToLetter($j+$k+1) & Abs($i-$row[0]) + 1)
						EndIf
					Next
				Next


			EndIf
	EndSwitch

	Return $chessboard
EndFunc
Func _arrayaddcount(ByRef $i_array)
	local $max = UBound($i_array)
	local $array[$max+1]
	For $i = 1 to $max
		$array[$i] = $i_array[$i-1]
	Next
	$array[0] = UBound($i_array)
	$i_array = $array
EndFunc

Func _multiversefrompgn($i_pgn, $stopmove = -1,$includeblackmove = 1)
	local $i = 0, $f_lines, $result, $whiteuser, $blackuser, $date, $time, $event, $game
	Select
		Case FileExists($i_pgn)
			_FileReadToArray($i_pgn,$f_lines)
		Case IsArray($i_pgn)
			If (not IsNumber($i_pgn[0])) Then _arrayaddcount($i_pgn)
			$f_lines = $i_pgn
		Case IsString($i_pgn)
			$f_lines = StringSplit($i_pgn,@CRLF,1)
	EndSelect

	If $stopmove = -1 Then
		$stopmove = StringRegExp($f_lines[$f_lines[0]], "[0-9]+",3)[0]
	EndIf
	do
		$i += 1
		Switch StringRegExp($f_lines[$i],"[a-zA-Z]+",3)[0]
			Case "Result"
				$result = StringRegExp($f_lines[$i],'[01]-[01]',3)[0]
			Case "Date"
				$date = StringRegExp($f_lines[$i],'[0-9]+.[0-9]+.[0-9]+',3)[0]
			Case "Time"
				$time = StringRegExp($f_lines[$i],'[0-9]+:[0-9]+:[0-9]+ \(\+[0-9]+:[0-9]+\)',3)[0]
			Case "White"
				$whiteuser = StringRegExp($f_lines[$i],'"(.)+"',2)[0]
				$whiteuser = StringTrimRight($whiteuser,1)
				$whiteuser = StringTrimLeft($whiteuser,1)
			Case "Black"
				$blackuser = StringRegExp($f_lines[$i],'"(.)+"',2)[0]
				$blackuser = StringTrimRight($blackuser,1)
				$blackuser = StringTrimLeft($blackuser,1)
			Case "Event"
				$event = StringRegExp($f_lines[$i],'"(.)+"',2)
				$event = StringTrimRight($event,1)
				$event = StringTrimLeft($event,1)
			Case "Game"
				$game = StringRegExp($f_lines[$i],'"(.)+"',2)[0]
				$game = StringTrimRight($game,1)
				$game = StringTrimLeft($game,1)
		EndSwitch
	until StringLeft($f_lines[$i],6) = "[Board"
	$fen = ""
	$i += 1
	while (StringLeft($f_lines[$i],2) = "1.") = False

		$fen &= $f_lines[$i] & "|"


		$i += 1
		if $i > $f_lines[0] Then
			ExitLoop
		EndIf
	WEnd
	$fen = StringTrimRight($fen,1)
	$multiverse = _multiverse_create("custom",$fen)
#region metadata
	$multiverse[0].playerwhite = $whiteuser
	$multiverse[0].playerback = $blackuser
	$multiverse[0].date = $date
	$multiverse[0].time = $time
	$multiverse[0].event = $event
	$multiverse[0].result = $result
	$multiverse[0].game = $game
#EndRegion
	while ($i <= $f_lines[0] And StringRegExp($f_lines[$i], "[0-9]+",3)[0] <> $stopmove+1)
		$ply = StringSplit($f_lines[$i],"/",2)
		if @error = 1 then $includeblackmove = 0
		$whitemoves = $ply[0]

		While (StringLeft($whitemoves,1) = "(") = False
			$whitemoves = StringTrimLeft($whitemoves,1)
		WEnd

		$whitemove = StringRegExp($whitemoves, "[Ta-z0-9->]+", 3)

		For $j = 0 to UBound($whitemove)-1 step +2
			$whitesply = $whitemove[$j] & $whitemove[$j+1]

			If Stringright($whitesply,1) = ">" Then
				$whitesply &= $whitemove[$j+2] & $whitemove[$j+3]
				$j += 2
			EndIf
			_multiversemove($multiverse,_moveconvert($whitesply,1),_moveconvert($whitesply,0),1)
		Next
		if ($includeblackmove = 1 or StringRegExp($f_lines[$i], "[0-9]+",3)[0] <> $stopmove) Then
			$blackmoves = $ply[1]
			While (StringLeft($blackmoves,1) = "(") = False
				$blackmoves = StringTrimLeft($blackmoves,1)
			WEnd
			$blackmove = StringRegExp($blackmoves, "[Ta-z0-9->]+", 3)


			For $j = 0 to UBound($blackmove)-1 step +2
				$blacksply = $blackmove[$j] & $blackmove[$j+1]
				If Stringright($blacksply,1) = ">" Then
					$blacksply &= $blackmove[$j+2] & $blackmove[$j+3]
					$j += 2
				EndIf

				_multiversemove($multiverse,_moveconvert($blacksply,1),_moveconvert($blacksply,0),2)
			Next
		EndIf
			$i+=1
	WEnd

	Return $multiverse
EndFunc

Func _multiverse_setboard(ByRef $i_multiverse,$board,$timelinename,$turn, $color)

	$timelines = UBound($i_multiverse[1],2) -1
	$maxturns = UBound($i_multiverse[1]) -1
	$ply = _turntoply($turn,$color,$i_multiverse[0].cosmeticturnoffset)
	local $timeline = _multiverse_gettimelinebyname($i_multiverse,$timelinename)
	if string($timeline) <> "not found" then
		if $ply > $maxturns Then
			dim $newmultiverse[$ply+1][$timelines+1]
			For $i = 0 to $timelines
				for $j = 0 to $maxturns
					$newmultiverse[$j][$i] = ($i_multiverse[1])[$j][$i]
				Next
			Next
			For $i = $maxturns+1 to $ply
				$newmultiverse[$i][$timeline] = "null"
			Next
			$newmultiverse[$ply][$timeline] = $board

			$i_multiverse[1] = $newmultiverse
		Else
			_multiverse_changeboard($i_multiverse[1],$ply,$timeline,$board)
		EndIf
	Else
		_multiverseaddtimelineatturn($i_multiverse,$board,$ply, $timelinename)
	EndIf
EndFunc

func _boardaddrow(ByRef $i_chessboard)
	local $count = UBound($i_chessboard,2)
	dim $row[1][$count]
	for $i = 0 to UBound($i_chessboard,2)-1
		$row[0][$i] = "1"
	Next
	_ArrayAdd($i_chessboard, $row)
EndFunc

Func _boardaddcolumn(ByRef $i_chessboard)
    Local $rowCount = UBound($i_chessboard)
    Local $colCount = UBound($i_chessboard, 2) + 1

    Dim $newChessboard[$rowCount][$colCount]

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
EndFunc

Func _multiverseturnadd(ByRef $i_multiverse,$board,$timeline)
	local $c_longesttimeline = UBound($i_multiverse[1]), $c_width = UBound($i_multiverse[1],2),$addturn = 0,$rowcount, $linecount
	local $longesttimelines = _multiversegetlongesttimelines($i_multiverse)
	For $i = 1 to $longesttimelines[0]
		If $timeline = $longesttimelines[$i] Then
			$addturn = 1
			ExitLoop
		EndIf
	Next

	$rowcount = $c_longesttimeline + $addturn
	$linecount = $c_width
	Dim $newmultiverse[$rowcount][$linecount]
	For $i = 0 To $linecount-1
		For $j = 0 To $rowcount-(1+$addturn)
			$newmultiverse[$j][$i] = ($i_multiverse[1])[$j][$i]
		Next
	Next
	For $i = $rowcount-(1+$addturn) to 1 step -1
		if IsArray(($i_multiverse[1])[$i][$timeline]) Then
			$j = $i + 1
			$newmultiverse[$j][$timeline] = $board
			ExitLoop
		EndIf
	Next
	$i_multiverse[1] = $newmultiverse
EndFunc

Func _multiverseaddtimelineatturn(ByRef $i_multiverse, $board, $ply, $timelinename)
	local $c_longesttimeline = UBound($i_multiverse[1]),$rowcount
	$byebye = $ply - $c_longesttimeline +1
	If $ply < $c_longesttimeline Then $byebye = 0

	$rowcount = $c_longesttimeline+$byebye
	Local $linecount = UBound($i_multiverse[1], 2) + 1
    Local $linecount2 = $linecount - 1
    Dim $newmultiverse[$rowcount][$linecount]
    $newmultiverse[0][$linecount2] = $timelinename
    For $i = 0 To $linecount2-1
        For $j = 0 To $c_longesttimeline-1
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
EndFunc

Func _multiversemove(ByRef $i_multiverse,$startmove,$endmove,$movecolor)
	local $i_startboard[2], $i_startsquare[2], $endboard[2], $endsquare[2],$i_starttimeline,$endtimeline,$board,$board2,$newtimelinename,$i,$moves = $i_multiverse[2],$piecenotation,$move
	local $width = _multiverse_getwidth($i_multiverse)

	if $movecolor = 1 Then
		$newtimelinename = $width[0]+1
	Else
		$newtimelinename = number($width[1])-1
	EndIf
	$startarray = StringSplit($startmove,"|",2)
	$endarray = StringSplit($endmove,"|",2)
	$i_startboard[0] = $startarray[0]
	$i_startboard[1] = _turntoply($startarray[1],$movecolor,$i_multiverse[0].cosmeticturnoffset)
	$i_startsquare[0] = $startarray[2]
	$i_startsquarenumber = LetterToAlphabeticalNumber($i_startsquare[0])-1
	$i_startsquare[1] = $startarray[3]
	$endboard[0] = $endarray[0]
	$endboard[1] = _turntoply($endarray[1],$movecolor,$i_multiverse[0].cosmeticturnoffset)
	$endsquare[0] = $endarray[2]
	$endsquare[1] = $endarray[3]
	$endsquarenumber = LetterToAlphabeticalNumber($endsquare[0])-1
	$i_starttimeline = _multiverse_gettimelinebyname($i_multiverse,$i_startboard[0])
	$endtimeline = _multiverse_gettimelinebyname($i_multiverse,$endboard[0])
	$piece = (($i_multiverse[1])[$i_startboard[1]][$i_starttimeline])[$i_startsquare[1]-1][$i_startsquarenumber]
	$piecenotation = StringUpper($piece)
	if ($piecenotation == "P" or $piecenotation = "W") Then $piecenotation = ""
	$board = _pieceadd(($i_multiverse[1])[$endboard[1]][$endtimeline],$piece,$endsquare[0]&$endsquare[1])

	$board2 = _removepiece(($i_multiverse[1])[$i_startboard[1]][$i_starttimeline],$i_startsquare[0]&$i_startsquare[1])
	Select
		Case ($i_starttimeline = $endtimeline And $i_startboard[1] = $endboard[1])
			_multiverseturnadd($i_multiverse,_movepiece(($i_multiverse[1])[$i_startboard[1]][$i_starttimeline],$i_startsquare[0]&$i_startsquare[1],$endsquare[0]&$endsquare[1]),$i_starttimeline)

			$move = "("&$i_starttimeline&"T"&$startarray[1]&")"&$piecenotation&$i_startsquare[0]&$i_startsquare[1]&$endsquare[0]&$endsquare[1]

		Case $endboard[1] = _multiverse_findendboard($i_multiverse,$endtimeline)
			_multiverseturnadd($i_multiverse,$board2,$i_starttimeline)
			_multiverseturnadd($i_multiverse,$board,$endtimeline)

			$move = "("&$i_starttimeline&"T"&$startarray[1]&")"&$piecenotation&$i_startsquare[0]&$i_startsquare[1]&">" & "("&$endtimeline&"T"&$endarray[1]&")" & $endsquare[0]&$endsquare[1]

		Case Else
			if ($piece == "w" and $endsquare[1] = 1) Then
				$board = _pieceadd($board,"q",$endsquare[0]&$endsquare[1])
			ElseIf ($piece == "W" and $endsquare[1] = 8) Then
				$board = _pieceadd($board,"Q",$endsquare[0]&$endsquare[1])
			EndIf

			_multiverseaddtimelineatturn($i_multiverse,$board,$endboard[1]+1,$newtimelinename)
			_multiverseturnadd($i_multiverse,$board2,$i_starttimeline)


			$move = "("&$i_starttimeline&"T"&$startarray[1]&")"&$piecenotation&$i_startsquare[0]&$i_startsquare[1]&">>" & "("&$endtimeline&"T"&$endarray[1]&")" &$endsquare[0]&$endsquare[1]

	EndSelect

	If $piece == "K" Then
		if $i_startsquarenumber - $endsquarenumber = 2 Then
			$rook = _chessboard_scanrowforpiece(($i_multiverse[1])[$i_startboard[1]][$i_starttimeline],$i_startsquare[1]-1,"R")
			$i = $rook[0]
			While $rook[$i] > $endsquarenumber
				_ArrayDelete($rook,$i)
				$rook[0] -= 1
				$i -= 1
			WEnd
			_multiverse_changeboard($i_multiverse[1],$i_startboard[1]+1,$i_starttimeline,_removepiece(($i_multiverse[1])[$i_startboard[1]+1][$i_starttimeline],AlphabeticalNumberToLetter($rook[$i]+1) & $endsquare[1]))
			_multiverse_changeboard($i_multiverse[1],$i_startboard[1]+1,$i_starttimeline,_pieceadd(($i_multiverse[1])[$i_startboard[1]+1][$i_starttimeline],"R",AlphabeticalNumberToLetter($endsquarenumber+2) & $endsquare[1]))


		ElseIf $i_startsquarenumber - $endsquarenumber = -2 Then

			$rook = _chessboard_scanrowforpiece(($i_multiverse[1])[$i_startboard[1]][$i_starttimeline],$i_startsquare[1]-1,"R")
			$i = 1
			While $rook[0] > 1

				If $rook[$i] < $endsquarenumber-1 Then
					_ArrayDelete($rook,$i)
					$rook[0] -= 1
				EndIf
				$i += 1

			WEnd
			_multiverse_changeboard($i_multiverse[1],$i_startboard[1]+1,$i_starttimeline,_removepiece(($i_multiverse[1])[$i_startboard[1]+1][$i_starttimeline],AlphabeticalNumberToLetter($rook[1]+1) & $endsquare[1]))
			_multiverse_changeboard($i_multiverse[1],$i_startboard[1]+1,$i_starttimeline,_pieceadd(($i_multiverse[1])[$i_startboard[1]+1][$i_starttimeline],"R",AlphabeticalNumberToLetter($endsquarenumber) & $endsquare[1]))

		EndIf

	ElseIf $piece == "k" Then
		if $i_startsquarenumber - $endsquarenumber = 2 Then
			$rook = _chessboard_scanrowforpiece(($i_multiverse[1])[$i_startboard[1]][$i_starttimeline],$i_startsquare[1]-1,"r")
			$i = $rook[0]
			While $rook[$i] > $endsquarenumber
				_ArrayDelete($rook,$i)
				$rook[0] -= 1
				$i -= 1
			WEnd

			_multiverse_changeboard($i_multiverse[1],$i_startboard[1]+1,$i_starttimeline,_removepiece(($i_multiverse[1])[$i_startboard[1]+1][$i_starttimeline],AlphabeticalNumberToLetter($rook[$i]+1) & $endsquare[1]))
			_multiverse_changeboard($i_multiverse[1],$i_startboard[1]+1,$i_starttimeline,_pieceadd(($i_multiverse[1])[$i_startboard[1]+1][$i_starttimeline],"r",AlphabeticalNumberToLetter($endsquarenumber+2) & $endsquare[1]))


		ElseIf $i_startsquarenumber - $endsquarenumber = -2 Then

			$rook = _chessboard_scanrowforpiece(($i_multiverse[1])[$i_startboard[1]][$i_starttimeline],$i_startsquare[1]-1,"r")
			$i = 1
			While $rook[0] > 1

				If $rook[$i] < $endsquarenumber-1 Then
					_ArrayDelete($rook,$i)
					$rook[0] -= 1
				EndIf
				$i += 1

			WEnd
			_multiverse_changeboard($i_multiverse[1],$i_startboard[1]+1,$i_starttimeline,_removepiece(($i_multiverse[1])[$i_startboard[1]+1][$i_starttimeline],AlphabeticalNumberToLetter($rook[1]+1) & $endsquare[1]))
			_multiverse_changeboard($i_multiverse[1],$i_startboard[1]+1,$i_starttimeline,_pieceadd(($i_multiverse[1])[$i_startboard[1]+1][$i_starttimeline],"r",AlphabeticalNumberToLetter($endsquarenumber) & $endsquare[1]))

		EndIf



	ElseIf $piece == "P" Then

		If $endsquare[1] = 8 Then _multiverse_changeboard($i_multiverse[1],$i_startboard[1]+1,$i_starttimeline,_pieceadd(($i_multiverse[1])[$i_startboard[1]+1][$i_starttimeline],"Q",AlphabeticalNumberToLetter($endsquarenumber+1) & $endsquare[1]))

		If $endsquarenumber & $endsquare[1] = $i_multiverse[0].enpassant Then _multiverse_changeboard($i_multiverse[1],$i_startboard[1]+1,$i_starttimeline,_removepiece(($i_multiverse[1])[$i_startboard[1]+1][$i_starttimeline],$endsquare[0] & $endsquare[1]-1))

		If $i_multiverse[0].enpassant <> -1 Then $i_multiverse[0].enpassant = -1

		If abs($i_startsquare[1] - $endsquare[1]) = 2 Then $i_multiverse[0].enpassant = $endsquarenumber & $endsquare[1]-1

	ElseIf $piece =="p" Then

		If $endsquare[1] = 1 Then _multiverse_changeboard($i_multiverse[1],$i_startboard[1]+1,$i_starttimeline,_pieceadd(($i_multiverse[1])[$i_startboard[1]+1][$i_starttimeline],"q",AlphabeticalNumberToLetter($endsquarenumber+1) & $endsquare[1]))

		If $endsquarenumber & $endsquare[1] = $i_multiverse[0].enpassant Then _multiverse_changeboard($i_multiverse[1],$i_startboard[1]+1,$i_starttimeline, _removepiece(($i_multiverse[1])[$i_startboard[1]+1][$i_starttimeline],$endsquare[0] & $endsquare[1]+1))

		If $i_multiverse[0].enpassant <> -1 Then $i_multiverse[0].enpassant = -1

		If abs($i_startsquare[1] - $endsquare[1]) = 2 Then $i_multiverse[0].enpassant =  $endsquarenumber & $endsquare[1]+1

	ElseIf $piece == "W" Then

		If $endsquare[1] = 8 Then _multiverse_changeboard($i_multiverse[1],$i_startboard[1]+1,$i_starttimeline,_pieceadd(($i_multiverse[1])[$i_startboard[1]+1][$i_starttimeline],"Q",AlphabeticalNumberToLetter($endsquarenumber+1) & $endsquare[1]))
		If $endsquarenumber & $endsquare[1] = $i_multiverse[0].enpassant Then _multiverse_changeboard($i_multiverse[1],$i_startboard[1]+1,$i_starttimeline,_removepiece(($i_multiverse[1])[$i_startboard[1]+1][$i_starttimeline],$endsquare[0] & $endsquare[1]-1))
		If $i_multiverse[0].enpassant <> -1 Then $i_multiverse[0].enpassant = -1
		If abs($i_startsquare[1] - $endsquare[1]) = 2 Then $i_multiverse[0].enpassant = $endsquarenumber & $endsquare[1]-1


	ElseIf $piece == "w" Then

		If $endsquare[1] = 1 Then _multiverse_changeboard($i_multiverse[1],$i_startboard[1]+1,$i_starttimeline,_pieceadd(($i_multiverse[1])[$i_startboard[1]+1][$i_starttimeline],"q",AlphabeticalNumberToLetter($endsquarenumber+1) & $endsquare[1]))
		If $endsquarenumber & $endsquare[1] = $i_multiverse[0].enpassant Then _multiverse_changeboard($i_multiverse[1],$i_startboard[1]+1,$i_starttimeline,_removepiece(($i_multiverse[1])[$i_startboard[1]+1][$i_starttimeline],$endsquare[0] & $endsquare[1]-1))
		If $i_multiverse[0].enpassant <> -1 Then $i_multiverse[0].enpassant = -1
		If abs($i_startsquare[1] - $endsquare[1]) = 2 Then $i_multiverse[0].enpassant = $endsquarenumber & $endsquare[1]-1

	EndIf

	If $movecolor-1 Then
		If $i_multiverse[0].lastmovecolor-1 Then
			$movenumber = UBound($i_multiverse[2])
			$moves[$movenumber-1][1] &= " " & $move
		Else
			$movenumber = UBound($i_multiverse[2])
			$moves[$movenumber-1][1] = $move
		EndIf
	Else
		If $i_multiverse[0].lastmovecolor-1 Then
			$movenumber = UBound($i_multiverse[2])
			ReDim $moves[$movenumber+1][2]
			$moves[$movenumber][0] = $move
		Else
			$movenumber = UBound($i_multiverse[2])
			$moves[$movenumber-1][0] &= " " & $move
		EndIf
	EndIf
	$i_multiverse[0].lastmovecolor = $movecolor
	$i_multiverse[2] = $moves
EndFunc

Func _multiverse_changeboard(ByRef $i_multiverse, $turn, $line, $board)
	$i_multiverse[$turn][$line] = $board
EndFunc

Func _pieceadd($i_chessboard,$piece,$square)
	local $newboard = $i_chessboard

	$y = LetterToAlphabeticalNumber(StringSplit($square,"",2)[0])-1
	$x = StringSplit($square,"",2)[1]-1

	$newboard[$x][$y] = $piece
	Return $newboard
EndFunc

Func _removepiece($i_chessboard,$square)
	local $newboard = $i_chessboard
	$xy = StringSplit($square,"",2)
	$x = LetterToAlphabeticalNumber($xy[0])-1
	$y = $xy[1]-1
	$newboard[$y][$x] = 1
	Return $newboard
EndFunc

Func _movepiece($i_chessboard,$i_startsquare,$i_endsquare)
	local $start = StringSplit($i_startsquare,"",2)
	local $end = Stringsplit($i_endsquare,"",2)
	local $startcol = LetterToAlphabeticalNumber($start[0]) -1
	local $endcol = LetterToAlphabeticalNumber($end[0]) -1
	local $startrow = $start[1] -1
	local $endrow = $end[1] -1
	$i_chessboard[$endrow][$endcol] = $i_chessboard[$startrow][$startcol]
	$i_chessboard[$startrow][$startcol] = 1
	Return $i_chessboard
EndFunc


Func _multiversegetlongesttimelines($i_multiverse)
	local $c_longesttimeline = UBound($i_multiverse[1])-1, $c_width = UBound($i_multiverse[1],2)-1
	dim $return[1] = [0]
	For $i = 0 to $c_width
		for $j = $c_longesttimeline to 0 step -1
			If (IsArray(($i_multiverse[1])[$j][$i]) And $j = $c_longesttimeline) Then
				$return[0] += 1
				_ArrayAdd($return,$i)
			EndIf
		Next
	Next
	Return $return
EndFunc



Func _moveconvert($move,$startend = 1,$method = 0)
	local $string,$fullply,$ply
	Switch $method
		case 0
			If $startend Then

				If StringInStr($move,">") > 0 Then

					While StringInStr($move,">") > 0
						$move = StringTrimRight($move,1)
					WEnd
					$string = StringReplace(Stringtrimright($move,2),"T","|") & "|"
					$string &= StringLeft(StringRight($move,2),1) & "|" & StringRight(StringRight($move,2),1)
				Else
					$string = StringReplace(StringTrimRight($move,4),"T","|") & "|"
					$string &= Stringleft(StringLeft(Stringright($move,4),2),1) & "|" & Stringright(StringLeft(Stringright($move,4),2),1)
				EndIf
			Else
				if StringInStr($move,">") > 0 Then
					While StringInStr($move,">") > 0
						$move = StringTrimLeft($move,1)
					WEnd
					$string = StringReplace(Stringtrimright($move,2),"T","|") & "|"
					$string &= StringLeft(StringRight($move,2),1) & "|" & StringRight(StringRight($move,2),1)
				Else
					$string = StringReplace(StringTrimRight($move,4),"T","|") & "|"
					$string &= Stringleft(Stringright(Stringright($move,4),2),1) & '|' & Stringright(Stringright(Stringright($move,4),2),1)


				EndIf

			EndIf
		Case 1
				$move = StringRegExp($move, "[Ta-z0-9->]+", 3)
				$ply = $move[0] & $move[1]
				If Stringright($ply,1) = ">" Then
					$ply &= $move[2] & $move[3]
				EndIf
				dim $fullply[2]
				$fullply[0] = _moveconvert($ply,1)
				$fullply[1] = _moveconvert($ply,0)
				Return $fullply
	EndSwitch
	Return $string
EndFunc

Func _chessboard_scanrowforpiece($chessboard, $row, $piece)
	dim $squares[1] = [0]
	For $i = 0 to UBound($chessboard)-1
		If $chessboard[$row][$i] == $piece Then
			_ArrayAdd($squares,$i)
			$squares[0] += 1
		EndIf
	Next

	return $squares
EndFunc

Func _multiverse_findendboard($i_multiverse,$timeline)
	for $i = UBound(($i_multiverse[1]))-1 to 1 step -1
		If IsArray(($i_multiverse[1])[$i][$timeline]) Then ExitLoop
	Next
	return $i
EndFunc

Func _multiverse_getwidth($i_multiverse)
	local $max = Number(($i_multiverse[1])[0][0])
	local $min = Number(($i_multiverse[1])[0][0])
	local $width[2]

	for $i = 0 to UBound($i_multiverse[1],2)-1
		if ($i_multiverse[1])[0][$i] > $max Then
			$max = Number(($i_multiverse[1])[0][$i])
		EndIf
		if ($i_multiverse[1])[0][$i] < $min Then
			$min = Number(($i_multiverse[1])[0][$i])
		EndIf
	Next

	$width[0] = $max
	$width[1] = $min

	Return $width
EndFunc

Func _multiverse_gettimelinebyname($i_multiverse,$timelinename)
	$return = "not found"
	for $i = 0 to UBound($i_multiverse[1],2)-1
		If $timelinename == ($i_multiverse[1])[0][$i] Then
			$return = $i
		EndIf
	Next
	Return $return
EndFunc

Func _multiverse_removeemptytimelines($i_multiverse)
	$okey = 0
	For $i = 0 to UBound($i_multiverse[1],2)-1
		for $j = 1 to Ubound(($i_multiverse[1]))-1
			If IsArray(($i_multiverse[1])[$j][$i]) Then $okey = 1
		Next
		if $okey = 0 Then
			_ArrayColDelete($i_multiverse[1],$i)
		EndIf
	Next
	Return ($i_multiverse[1])
EndFunc

Func _multiversetovariant($i_multiverse, $variant = "automatically generated",$author = "mauer01s crazy progammingskillz")
	$i_multiverse[1] = _multiverse_removeemptytimelines($i_multiverse)
	local $string = "  {" & @LF & "    " & '"Name": "' & $variant & '",' & @LF & "    " & '"Author": "'& $author & '",' & @LF & "    "  & '"Timelines": {' & @LF
	local $timelines = UBound($i_multiverse[1],2)-1
	local $turns = Ubound(($i_multiverse[1]))-1
	For $i = 0 to $timelines
		$string &= "    " & '  "' & ($i_multiverse[1])[0][$i] & 'L": [' & @LF & "    " & "   "
		$endboard = _multiverse_findendboard($i_multiverse,$i)
		For $j = 1 to $endboard
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
		if $i = $timelines Then
			$string &= "    " & "  ]" & @LF
		Else
			$string &= "    " & "  ]," & @LF
		EndIf
	Next

	$string &= "    " & "}," & @LF
	If $i_multiverse[0].cosmeticturnoffset > 0 Then
		$string &=  '  "CosmeticTurnOffset": ' & $i_multiverse[0].cosmeticturnoffset*(-1) & "," & @LF
	EndIf
	If $i_multiverse[0].gamebuilder = 2 Then
		$string &= '  "GameBuilderOverride": "GameBuilderEven"' & @LF
	Else
		$string &= '  "GameBuilderOverride": "GameBuilderOdd"' & @LF
	EndIf
	$string &=  "  }," & @LF
	return $string
EndFunc

Func _multiversetopgn($i_multiverse)
	local $lines[0],$move
	_ArrayAdd($lines,'[Mode "5D"]')
	If StringLen($i_multiverse[0].result) > 0 Then _ArrayAdd($lines,'[Result "'& $i_multiverse[0].result &'"]')
	If StringLen($i_multiverse[0].date) > 0 Then _ArrayAdd($lines,'[Date "'& $i_multiverse[0].date &'"]')
	If StringLen($i_multiverse[0].time) > 0 Then _ArrayAdd($lines,'[Time "'& $i_multiverse[0].time &'"]')
	_ArrayAdd($lines,'[Size "'&$i_multiverse[0].boardwidth&"x"&$i_multiverse[0].boardheight&'"]')
	If StringLen($i_multiverse[0].playerwhite) > 0 Then _ArrayAdd($lines,'[White "'& $i_multiverse[0].playerwhite &'"]')
	If StringLen($i_multiverse[0].playerback) > 0 Then _ArrayAdd($lines,'[Black "'& $i_multiverse[0].playerback &'"]')
	If StringLen($i_multiverse[0].event) > 0 Then _ArrayAdd($lines,'[Event "'& $i_multiverse[0].event &'"]')
	If StringLen($i_multiverse[0].game) > 0 Then _ArrayAdd($lines,'[Game "'& $i_multiverse[0].game &'"]')
	_ArrayAdd($lines,'[Board "custom"]')
	For $i = 0 to UBound($i_multiverse[3])-1
		_ArrayAdd($lines,($i_multiverse[3])[$i])
	Next
	For $i = 0 to UBound($i_multiverse[2])-1
		$move = $i+1 & "." & ($i_multiverse[2])[$i][0] & " / " & ($i_multiverse[2])[$i][1]
		_ArrayAdd($lines,$move)
	Next
	Return $lines
EndFunc

Func _boardtofen($i_chessboard)
	Local $fen = "",$k
	For $i = UBound($i_chessboard)-1 to 0 step -1
		If $i < UBound($i_chessboard)-1 Then $fen = $fen & "/"
		$k = 0
		For $j = 0 to Ubound($i_chessboard,2)-1
			$c_square = $i_chessboard[$i][$j]
			If ($c_square = 1 and $j < UBound($i_chessboard,2)-1) Then
				$k = $k + 1
			ElseIf $c_square = 1 Then
				$k = $k + 1
				$fen = $fen & $k
			ElseIf ($c_square <> "1" and $k > 0) Then
				$fen = $fen & $k & $c_square
				$k = 0
			Else
				$fen = $fen & $c_square
			EndIf
		Next
	Next
	Return $fen
EndFunc

Func _turntoply($turn,$movecolor,$offset = 0)
	return (($turn+$offset) - 1)*2+$movecolor
EndFunc

Func _plyToTurn($ply)
	local $movecolor = 1
	if IsEven($ply) then $movecolor = 2
    Return ($ply - $movecolor) / 2 + 1
EndFunc

#region stupid stuff
Func LetterToAlphabeticalNumber($letter)
	$letter = StringUpper($letter) ; Convert to uppercase to handle lowercase letters

	If StringRegExp($letter, "[A-Z]") = 0 Then
		; Invalid input, not a letter
		Return 0
	EndIf

	Return Asc($letter) - Asc("A") + 1
EndFunc

Func AlphabeticalNumberToLetter($number)
	If $number < 1 Or $number > 26 Then
		; Invalid input, not a valid alphabetical number
		Return ""
	EndIf

	Return Chr($number + Asc("A") - 1)
EndFunc

Func IsEven($number)
	Return Mod($number, 2) = 0
EndFunc
#EndRegion