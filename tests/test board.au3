#include <multiversechess.au3>

$pgn1 = "test.txt"
$pgn2 = "D:\5d chess\games\dreamer\e3 b4 sneaked through.txt"
$pgn3 = "D:\5d chess\games\romad\WC22 Romad vs Mauer01 game 2.txt"
$pgn4 = "D:\5d chess\games\cirtus\anti exile.txt"
$pgn5 = "D:\5d chess\games\theoretical games\ mauer01 vs theoretical games game e3 attack tones defense.txt"
$multiverse = _multiverse_create("pgn",$pgn5)
_square_getpossiblemoves($multiverse,"0|1|e|2",1)

;~ ClipPut(_multiversetovariant($multiverse))
Exit
_ArrayDisplay(_multiverse_getmoves($multiverse))

Func _multiverse_getmoves($i_multiverse)
	local $movenumber = 0,$moves[1][2], $board, $board2,$pausing = 0,$acceptmove,$ply
	local $turn, $offset = $i_multiverse[0].cosmeticturnoffset, $height = $i_multiverse[0].boardheight -1, $width = $i_multiverse[0].boardwidth -1,$movecarry[0][4],$pause[1] = [0],$present,$multiversemove,$softlockcounter,$softlocked = 1
	$temporarymultiverse = _multiverse_create("custom",_ArrayToString($multiverse[3]))
	$start = _multiverse_getearliestboard($i_multiverse,0)
	$end = UBound($i_multiverse[1])-1
	$ply = $start
	dim $lines[0]
	For $k = 0 to UBound($i_multiverse[1],2)-1
		_ArrayAdd($lines,_multiverse_gettimelinename($i_multiverse,$k))
	Next
	while $ply <= $end
		$plypresent = _multiverse_getpresent($temporarymultiverse)[0]
		$movecolor = isEven($ply)+1
		If $movecolor = 1 Then
			$movenumber += 1
		EndIf
		$turn = _plytoturn($ply)-$offset
		For $i = 0 to UBound($lines)-1

			$timeline = _multiverse_gettimelinebyname($i_multiverse,$lines[$i])
			$present = _multiverse_getpresent($temporarymultiverse)
			For $l = 1 to $pause[0]
				if $lines[$i] == $pause[$l] Then
					$pausing = 1
					ExitLoop
				EndIf
			Next
			If $pausing = 1 Then
				For $presentline = 1 to UBound($present)-1
					If $present[$presentline] == $lines[$i] Then
						$pausing = 0
					EndIf
				Next
			EndIf
			If $pausing = 0 Then
				$turn = _plytoturn($ply)-$offset
				$board = ($i_multiverse[1])[$ply][$timeline]
				If _multiverse_findendboard($i_multiverse,$timeline) = $ply Then
					$board2 = $board
					$acceptmove = 1
				Elseif ($i_multiverse[1])[$ply+1][$timeline] = "null" then
					$acceptmove = 0
				Else
					$board2 = ($i_multiverse[1])[$ply+1][$timeline]
					$acceptmove = 1
				EndIf
				if $acceptmove Then
					if $board = "null" Then
						$x = UBound($movecarry)
						$previouslines = _multiverse_getboardsatturn($i_multiverse,$turn,$movecolor)
						$counter = 0
						ReDim $movecarry[$x+1][4]
						do
							$liners = _multiverse_gettimelinebyname($i_multiverse,$previouslines[$counter])
							$board = ($i_multiverse[1])[$ply][$liners]
							$testmove = _turn_getmove($board,$board2,$height,$width,$turn,_multiverse_gettimelinename($i_multiverse,$liners))
							$extended = @extended
							$counter += 1
						Until $extended = 2
						$movecarry[$x][1] = $ply
						$movecarry[$x][2] = $lines[$i]
						_ArrayAdd($pause,$lines[$i])
						$pause[0] += 1
						$movecarry[$x][3] = StringRight($testmove,1)
						$testmove = StringTrimRight($testmove,1)
						$movecarry[$x][0] = $testmove
					else
						$x = UBound($movecarry)
						ReDim $movecarry[$x+1][4]
						$movecarry[$x][0] = _turn_getmove($board,$board2,$height,$width,$turn,$lines[$i])
						$extended = @extended
						$movecarry[$x][1] = $ply
						$movecarry[$x][2] = $i
						Switch $extended
							Case 0

								if $movecolor-1 Then
									$moves[$movenumber-1][1] &= $movecarry[$x][0] & " "

									$multiversemove = _moveconvert($movecarry[$x][0],Default,1)
									_multiversemove($temporarymultiverse,$multiversemove[0],$multiversemove[1],$movecolor)
									_ArrayDelete($movecarry,$x)
								Else
									ReDim $moves[$movenumber][2]
									$moves[$movenumber-1][0] &= $movecarry[$x][0] & " "

									$multiversemove = _moveconvert($movecarry[$x][0],Default,1)
									_multiversemove($temporarymultiverse,$multiversemove[0],$multiversemove[1],$movecolor)

									_ArrayDelete($movecarry,$x)
								EndIf

							Case 1
								$movecarry[$x][3] = "extra"
								local $candidates[0]
									If $movecolor-1 Then
										$checkpieces = StringLower(StringRight(StringTrimRight($movecarry[$x][0],2),1))
									Else
										$checkpieces = StringRight(StringTrimRight($movecarry[$x][0],2),1)
									EndIf
								For $c = 0 to $x
									If $checkpieces == $movecarry[$c][3] Then
										_ArrayAdd($candidates,$c)
									EndIf
								Next
								if UBound($candidates) > 0 Then
									$max = _multiverse_getwidth($i_multiverse)
									$max = $max[0] - $max[1]
									$endingtimeline = 0
									For $c = 0 to UBound($candidates)-1
										If abs($max) >= Abs($movecarry[$candidates[$c]][2]) Then
											$max = $movecarry[$candidates[$c]][2]
											$endingtimeline = $candidates[$c]
										EndIf
									Next
									$max = $endingtimeline

									if _multiverse_findendboard($temporarymultiverse,_multiverse_gettimelinebyname($temporarymultiverse,$movecarry[$max][2])) = $movecarry[$max][1] Then
										$newtimeline = 0
									Else
										$newtimeline = 1
									EndIf
									if $newtimeline Then
										If $movecolor-1 Then
											$moves[$movenumber-1][1] &= $movecarry[$x][0] & ">>" & $movecarry[$max][0] & " "
											$multiversemove = _moveconvert($movecarry[$x][0] & ">>" & $movecarry[$max][0],Default,1)
											_multiversemove($temporarymultiverse,$multiversemove[0],$multiversemove[1],$movecolor)
											$present = _multiverse_getpresent($temporarymultiverse)


											If $ply > $present[0] Then
												$ply = $present[0]-1
												_ArrayAdd($pause,$lines[$i])
												$pause[0] += 1
												_ArrayDelete($movecarry,$x)
												_ArrayDelete($movecarry,$max)

												ExitLoop
											EndIf
											_ArrayDelete($movecarry,$x)
											_ArrayDelete($movecarry,$max)
										Else
											ReDim $moves[$movenumber][2]
											$moves[$movenumber-1][0] &= $movecarry[$x][0] & ">>" & $movecarry[$max][0] & " "
											$multiversemove = _moveconvert($movecarry[$x][0] & ">>" & $movecarry[$max][0],Default,1)
											_multiversemove($temporarymultiverse,$multiversemove[0],$multiversemove[1],$movecolor)
											$present = _multiverse_getpresent($temporarymultiverse)

											If $ply > $present[0] Then
												$ply = $present[0]-1
												_ArrayAdd($pause,$lines[$i])
												$pause[0] += 1
												_ArrayDelete($movecarry,$x)
												_ArrayDelete($movecarry,$max)
												ExitLoop
											EndIf
											_ArrayDelete($movecarry,$x)
											_ArrayDelete($movecarry,$max)
										EndIf
									Else
										If $movecolor-1 Then
											$moves[$movenumber-1][1] &= $movecarry[$x][0] & ">" & $movecarry[$max][0] & " "
											$multiversemove = _moveconvert($movecarry[$x][0] & ">" & $movecarry[$max][0],Default,1)
											_multiversemove($temporarymultiverse,$multiversemove[0],$multiversemove[1],$movecolor)
											$present = _multiverse_getpresent($temporarymultiverse)


											If $ply > $present[0] Then
												$ply = $present[0]-1
												_ArrayAdd($pause,$lines[$i])
												$pause[0] += 1
												_ArrayDelete($movecarry,$x)
												_ArrayDelete($movecarry,$max)

												ExitLoop
											EndIf
											_ArrayDelete($movecarry,$x)
											_ArrayDelete($movecarry,$max)
										Else
											ReDim $moves[$movenumber][2]
											$moves[$movenumber-1][0] &= $movecarry[$x][0] & ">" & $movecarry[$max][0] & " "
											$multiversemove = _moveconvert($movecarry[$x][0] & ">" & $movecarry[$max][0],Default,1)
											_multiversemove($temporarymultiverse,$multiversemove[0],$multiversemove[1],$movecolor)
											$present = _multiverse_getpresent($temporarymultiverse)

											If $ply > $present[0] Then
												$ply = $present[0]-1
												_ArrayAdd($pause,$lines[$i])
												$pause[0] += 1
												_ArrayDelete($movecarry,$x)
												_ArrayDelete($movecarry,$max)
												ExitLoop
											EndIf
											_ArrayDelete($movecarry,$x)
											_ArrayDelete($movecarry,$max)
										EndIf
									EndIf
								EndIf
							case 2
								local $candidates[0]
								$movecarry[$x][3] = StringRight($movecarry[$x][0],1)
								$movecarry[$x][0] = StringTrimRight($movecarry[$x][0],1)
								For $c = 0 to $x
									If $movecarry[$c][3] == "extra" Then
										If StringRight(StringTrimRight($movecarry[$c][0],2),1) == $movecarry[$x][3] Then
										EndIf
									EndIf
								Next



						EndSwitch
					EndIf

				EndIf

			EndIf
			$pausing = 0
		Next
		If $plypresent = _multiverse_getpresent($temporarymultiverse)[0]  Then
			If UBound($temporarymultiverse[2]) > 0 Then
				$ply -= 1
				If $softlocked Then
					$softlockcounter += 1
				Else
					$softlockcounter = 1
				EndIf
				$softlocked = 1
			Else
				$softlocked = 0
			EndIf
		EndIf
		$ply += 1
		If $softlockcounter > 1 Then
			_ArrayDisplay($moves)
			_ArrayDisplay($movecarry)
			_ArrayDisplay(_multiverse_getpresent($temporarymultiverse))
			Exit
		EndIf

	WEnd
	Return $moves
EndFunc


Func _multiverse_getearliestboard(ByRef Const $i_multiverse,$timeline)
	$timeline = _multiverse_gettimelinebyname($i_multiverse,$timeline)
	For $i = 1 to UBound($i_multiverse[1])
		If IsArray(($i_multiverse[1])[$i][$timeline]) Then
			Return $i
		EndIf
	Next
	SetError(1)
EndFunc

Func _multiverse_getactivetimelines(ByRef Const $i_multiverse)
	local $activetimelines[0], $names[0] ,$timeline ,$whitetimelines[0], $blacktimelines[0],$error = 0
	If $i_multiverse[0].gamebuilder == 2 Then
		_ArrayAdd($activetimelines,0)
		_ArrayAdd($activetimelines,"-0")
	Else
		_ArrayAdd($activetimelines,0)
	EndIf
	For $i = 0 to UBound($i_multiverse[1],2)-1
		_ArrayAdd($names,($i_multiverse[1])[0][$i])
	Next
	for $i = 0 to Ubound($names)-1
		If $names[$i] > 0 Then
			_ArrayAdd($whitetimelines,$names[$i])
		Elseif $names[$i] < 0 Then
			_arrayadd($blacktimelines,$names[$i])
		EndIf
	Next
	_ArraySort($blacktimelines)
	if @error = 5 Then
		$error = "w"
	EndIf
	_ArraySort($whitetimelines,1)
	if @error = 5 Then
		if $error = "w" Then
			$error = 2
		Else
			$error = "b"
		EndIf
	EndIf
	Switch $error

		case "0"
			if $whitetimelines[0] > abs($blacktimelines[0]) Then
				while $whitetimelines[0] > abs($blacktimelines[0])+1
				_ArrayDelete($whitetimelines,0)
				WEnd
			Elseif abs($blacktimelines[0]) > $whitetimelines[0] Then
			If UBound($i_multiverse[1],2) = 2 Then
				_ArrayDisplay($i_multiverse[1])
			EndIf
			while $whitetimelines[0] < abs($blacktimelines[0])+1
				_ArrayDelete($blacktimelines,0)
			WEnd
			EndIf
		Case "w"
			while $whitetimelines[0] > 1
				_ArrayDelete($whitetimelines,0)
			WEnd
		Case "b"
			while Abs($blacktimelines[0]) > 1
				_ArrayDelete($blacktimelines,0)
			WEnd
	EndSwitch

	_ArrayAdd($activetimelines,$whitetimelines)
	_ArrayAdd($activetimelines,$blacktimelines)
	Return $activetimelines
EndFunc


Func _multiverse_getpresent(ByRef Const $i_multiverse)
	local $min, $activetimelines, $present[0], $old
	$min = UBound($i_multiverse[1])
	$activetimelines = _multiverse_getactivetimelines($i_multiverse)
	For $i = 0 to UBound($activetimelines)-1
		$ply = _multiverse_findendboard($i_multiverse,_multiverse_gettimelinebyname($i_multiverse,$activetimelines[$i]))
		If $ply < $min Then
			$min = $ply
		EndIf
	Next
	_ArrayAdd($present,$min)
	For $i = 0 to UBound($activetimelines)-1
		if $min = _multiverse_findendboard($i_multiverse,_multiverse_gettimelinebyname($i_multiverse,$activetimelines[$i])) Then
			_ArrayAdd($present,$activetimelines[$i])
		EndIf
	Next
	Return $present
EndFunc

Func _multiverse_gettimelinename($i_multiverse,$timeline)
	Return ($i_multiverse[1])[0][$timeline]
EndFunc


Func _multiverse_getboardsatturn($i_multiverse,$turn,$movecolor)
	local $ply = _turntoply($turn,$movecolor,$i_multiverse[0].cosmeticturnoffset),$return[0]
	For $i = 0 to UBound($i_multiverse[1],2)-1
		If IsArray(($i_multiverse[1])[$ply][$i]) Then
			_ArrayAdd($return,_multiverse_gettimelinename($i_multiverse,$i))
		EndIf
	Next
	Return $return
EndFunc


Func _turn_getmove($board, $board2,$height,$width,$turn,$timeline)
	local $allchanges[1] = [0]
	for $i = 0 to $height
		for $j = 0 to $width
			$piece = $board[$i][$j]
			$piece2 = $board2[$i][$j]
			if (not ($piece == $piece2)) Then
				_ArrayAdd($allchanges,$piece&$i&$j&$piece2)
				$allchanges[0] += 1
			EndIf
		Next
	Next
	Switch $allchanges[0]
		case 2
			If StringRight($allchanges[1],1) = 1 Then
				$piece = StringUpper(StringLeft($allchanges[1],1))
				if $piece = "P" Then $piece = ""

				$allchanges[1] = StringTrimLeft($allchanges[1],1)
				$allchanges[1] = StringTrimRight($allchanges[1],1)
				$startsquare = StringLower(AlphabeticalNumberToLetter(StringRight($allchanges[1]+1,1))&StringLeft($allchanges[1],1)+1)
				$allchanges[2] = StringMid($allchanges[2],2,2)
				$endsquare = StringLower(AlphabeticalNumberToLetter(StringRight($allchanges[2]+1,1))&StringLeft($allchanges[2],1)+1)
				$move = "("&$timeline&"T"&$turn&")"&$piece&$startsquare&$endsquare
			Else
				$piece = Stringupper(StringLeft($allchanges[2],1))
				if $piece = "P" Then $piece = ""
				$allchanges[2] = StringTrimLeft($allchanges[2],1)
				$allchanges[2] = StringTrimRight($allchanges[2],1)
				$startsquare = StringLower(AlphabeticalNumberToLetter(StringRight($allchanges[2]+1,1))&StringLeft($allchanges[2],1)+1)
				$allchanges[1] = StringMid($allchanges[1],2,2)
				$endsquare = StringLower(AlphabeticalNumberToLetter(StringRight($allchanges[1]+1,1))&StringLeft($allchanges[1],1)+1)
				$move = "("&$timeline&"T"&$turn&")"&$piece&$startsquare&$endsquare

			EndIf
		Case 4
			$piece = "K"
			$true = False
			For $i = 1 to 4
				if StringUpper(StringLeft($allchanges[$i],1)) = "K" Then
					$startchange = $i
					$true = True
				ElseIf StringUpper(StringRight($allchanges[$i],1)) = "K" Then
					$endchange = $i
					$true = True
				EndIf
			Next
			if $true Then
			$startsquare = StringMid($allchanges[$startchange],2,2)
			$startsquare = StringLower(AlphabeticalNumberToLetter(StringRight($startsquare,1)+1)&StringLeft($startsquare,1)+1)
			$endsquare = StringMid($allchanges[$endchange],2,2)
			$endsquare = StringLower(AlphabeticalNumberToLetter(StringRight($endsquare,1)+1)&StringLeft($endsquare,1)+1)
			$move = "("&$timeline&"T"&$turn&")"&$piece&$startsquare&$endsquare
			Else
			return SetExtended(5,-1)
			EndIf
		Case 3
			For $i = 1 to 3
				$piece = StringRight($allchanges[$i],1)
				if ($piece = "w" or $piece = "p") Then
					$oldpiece = $piece
					ExitLoop
				EndIf
			Next

			$endsquare = StringMid($allchanges[$i],2,2)
			$endsquare = StringLower(AlphabeticalNumberToLetter(StringRight($endsquare,1)+1)&StringLeft($endsquare,1)+1)
			For $i = 1 to 3
				$piece = StringLeft($allchanges[$i],1)
				If $piece == $oldpiece Then
					$startsquare = StringMid($allchanges[$i],2,2)
					$startsquare = StringLower(AlphabeticalNumberToLetter(StringRight($startsquare,1)+1)&StringLeft($startsquare,1)+1)
				EndIf
			Next
			$move = "("&$timeline&"T"&$turn&")"&StringUpper($piece)&$startsquare&$endsquare
		Case 1
			if StringRight($allchanges[1],1) = 1 Then
				$piece = StringLeft($allchanges[1],1)
				$startsquare = StringMid($allchanges[1],2,2)
				$startsquare = StringLower(AlphabeticalNumberToLetter(StringRight($startsquare,1)+1)&StringLeft($startsquare,1)+1)
				$move = "("&$timeline&"T"&$turn&")"&StringUpper($piece)&$startsquare
				return SetExtended(1,$move)
			Else
				$piece = StringRight($allchanges[1],1)
				$endsquare = StringMid($allchanges[1],2,2)
				$endsquare = Stringlower(AlphabeticalNumberToLetter(StringRight($endsquare,1)+1)&StringLeft($endsquare,1)+1)
				$move = "("&$timeline&"T"&$turn&")"&$endsquare&$piece
				return SetExtended(2,$move)
			EndIf
		Case 0
			return SetExtended(3,-1)
		Case Else
			return SetExtended(4,-1)
	EndSwitch
	return $move
EndFunc

Func _square_getpossiblemoves($i_multiverse,$square,$movecolor = 1)
	local $piece = _multiversegetpiece($i_multiverse,$square,$movecolor)
	If (StringIsUpper($piece) <> $movecolor Or StringIsLower($piece)+1 <> $movecolor) Then
		Return SetError(2,0,-1)
	EndIf
	local $possiblemoves[0]

	Switch $piece
		Case "1"
			Return SetError(1,0,-1)
		Case "p"



		Case "r"

		Case "s"

		Case "q"

		Case "b"

		Case "n"

		Case "w"

		Case "k"

		Case "
	EndSwitch
EndFunc

Func _multiversegetpiece($i_multiverse,$square,$movecolor)
	local $piece
	$square = StringSplit($square,"|",2)
	local $x = Lettertoalphabeticalnumber($square[2])-1, $timeline = _multiverse_gettimelinebyname($i_multiverse,$square[0]),$y = $square[3]-1,$ply = _turntoply($square[1],$movecolor,$i_multiverse[0].cosmeticturnoffset)
	$piece = (($i_multiverse[1])[$ply][$timeline])[$y][$x]
	Return $piece
EndFunc


Func _ArraySortDblDel(ByRef $ARRAY, $CASESENS=0, $iDESCENDING=0, $iDIM=0, $iSORT=0)
Local $arTmp1D[1], $arTmp2D[1][2], $dbl = 0
    $arTmp1D[0] = ""
    $arTmp2D[0][0] = ""
    If $iDIM = 0 Then $iDIM = 1
    _ArraySort($ARRAY,$iDESCENDING,0,0,$iDIM,$iSORT)
    Switch $iDIM
        Case 1 ; 1D
            For $i = 0 To UBound($ARRAY)-1
                $dbl = 0
                For $k = 0 To UBound($arTmp1D)-1
                    Switch $CASESENS
                        Case 0
                            If $arTmp1D[$k] = $ARRAY[$i] Then $dbl = 1
                        Case 1
                            If $arTmp1D[$k] == $ARRAY[$i] Then $dbl = 1
                    EndSwitch
                Next
                If $dbl = 0 Then
                    If $arTmp1D[0] = "" Then
                        $arTmp1D[0] = $ARRAY[$i]
                    Else
                        _ArrayAdd($arTmp1D, $ARRAY[$i])
                    EndIf
                Else
                    $dbl = 0
                EndIf
            Next
            $ARRAY = $arTmp1D
        Case 2 ; 2D
            For $i = 0 To UBound($ARRAY)-1
                $dbl = 0
                For $k = 0 To UBound($arTmp2D)-1
                    Switch $CASESENS
                        Case 0
                            If  ( $arTmp2D[$k][0] = $ARRAY[$i][0] ) And _
                                ( $arTmp2D[$k][1] = $ARRAY[$i][1] ) Then $dbl = 1
                        Case 1
                            If  ( $arTmp2D[$k][0] == $ARRAY[$i][0] ) And _
                                ( $arTmp2D[$k][1] == $ARRAY[$i][1] ) Then $dbl = 1
                    EndSwitch
                Next
                If $dbl = 0 Then
                    If $arTmp2D[0][0] = "" Then
                        $arTmp2D[0][0] = $ARRAY[$i][0]
                        $arTmp2D[0][1] = $ARRAY[$i][1]
                    Else
                        ReDim $arTmp2D[UBound($arTmp2D)+1][2]
                        $arTmp2D[UBound($arTmp2D)-1][0] = $ARRAY[$i][0]
                        $arTmp2D[UBound($arTmp2D)-1][1] = $ARRAY[$i][1]
                    EndIf
                Else
                    $dbl = 0
                EndIf
            Next
            $ARRAY = $arTmp2D
    EndSwitch
EndFunc ; ==>_ArraySortDblDel

