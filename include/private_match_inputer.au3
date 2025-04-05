#include <Array.au3>
Func convertRoomCode($codeStr)
	Local $pieceMap = _
			[ _
			[":pawn_white:"], _
			[":knight_white:"], _
			[":bishop_white:"], _
			[":rook_white:"], _
			[":queen_white:"], _
			[":king_white:"], _
			[":pawn_black:"], _
			[":knight_black:"], _
			[":bishop_black:"], _
			[":rook_black:"], _
			[":queen_black:"], _
			[":king_black:"] _
			]

	Local $tokens = StringSplit($codeStr, " ", 2)
	Local $result[0]
	For $token In $tokens
		_ArrayAdd($result, _ArraySearch($pieceMap, $token))
	Next

	Return $result
EndFunc   ;==>convertRoomCode