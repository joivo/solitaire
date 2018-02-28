:- initialization(main).

/*
	The card representation is a List that the positions, from 0 to 4 is
	[Value, Suit, Color, IsValid, IsTurned], respectively.
	[--0--,--1--,---2,-,----3---,-----4---].
*/
card(Value, Suit, Color, IsValid, IsTurned, [Value, Suit, Color, IsValid, IsTurned]).

generateCardsList(Count, Suit, Color, _, X):- Count == 1,
	card(Count, Suit, Color, true, true, Card),
	C is Count + 1,
	generateCardsList(C, Suit, Color, [Card], X).

generateCardsList(Count, Suit, Color, List, X):- Count < 14, 
	card(Count, Suit, Color, true, true, Card),
	append(List, [Card], L),
	C is Count + 1,
	generateCardsList(C, Suit, Color, L, X).

generateCardsList(Count, _, _, List, X):- Count >= 14, X = [List].
	
generateInvalidCards(Count, _, X):- Count == 1,
	card(Count, 'X', 'X', false, false, Card),
	C is Count + 1,
	generateInvalidCards(C, [Card], X).

generateInvalidCards(Count, List, X):- Count < 27,
	card(Count, 'X', 'X', false, false, Card),
	append(List, [Card], L),
	C is Count + 1,
	generateInvalidCards(C, L, X).

generateInvalidCards(Count, List, X):- Count >= 27, X = List.

generate_deck(X):-
		generateCardsList(1, 'O', 'R', [], O),
		generateCardsList(1, 'C', 'R', [], C),
		generateCardsList(1, 'P', 'B', [], P),
		generateCardsList(1, 'E', 'B', [], E),
		nth0(0, O, O1),
		nth0(0, C, C1),
		nth0(0, P, P1),
		nth0(0, E, E1),
		append(O1, C1, L1),
		append(P1, E1, L2),
		append(L1, L2, Deck),
		random_permutation(Deck, X).

valid_cards_amount(Count, Cards, X):- 
	length(Cards, Len),
	Len =< Count, X = Count.

valid_cards_amount(Count, Cards, X):- 
	length(Cards, Len),
	Len > Count,
	nth0(Count, Cards, Card),
	nth0(3, Card, IsValid),
	IsValid == false,
	X = Count.

valid_cards_amount(Count, Cards, X):- 
	length(Cards, Len),
	Len > Count,
	nth0(Count, Cards, Card),
	nth0(3, Card, IsValid),
	IsValid == true,
	C is Count + 1,
	valid_cards_amount(C, Cards, X).

turn_off_last(Cards, X):-
	valid_cards_amount(0, Cards, Num),
	Num == 0,
	X = Cards.

turn_off_last(Cards, X):-
	valid_cards_amount(0, Cards, Num),
	Num > 0,
	nth1(Num, Cards, Elem, Rest),
	nth0(0, Elem, Value), nth0(1, Elem, Suit),
	nth0(2, Elem, Color), card(Value, Suit, Color, true, false, Card),
	nth1(Num, X, Card, Rest).
	
generate_board(BoardGame):-
	generate_deck(Deck),
	append([[]], [[]], L2),
	append(L2, [[]], L3),
	append(L3, [[]], L4),
	append(L4, [[]], L5),
	droppp(0, 0, Deck, [], Col1, Deck1),
	droppp(0, 1, Deck1, [], Col2, Deck2),
	droppp(0, 2, Deck2, [], Col3, Deck3),
	droppp(0, 3, Deck3, [], Col4, Deck4),
	droppp(0, 4, Deck4, [], Col5, Deck5),
	droppp(0, 5, Deck5, [], Col6, Deck6),
	droppp(0, 6, Deck6, [], Col7, Deck7),
	turn_off_last(Col1, C1),
	turn_off_last(Col2, C2),
	turn_off_last(Col3, C3),
	turn_off_last(Col4, C4),
	turn_off_last(Col5, C5),
	turn_off_last(Col6, C6),
	turn_off_last(Col7, C7),
	generateInvalidCards(0, [], InvalidCards),
	append(C1, InvalidCards, Cl1),
	append(C2, InvalidCards, Cl2),
	append(C3, InvalidCards, Cl3),
	append(C4, InvalidCards, Cl4),
	append(C5, InvalidCards, Cl5),
	append(C6, InvalidCards, Cl6),
	append(C7, InvalidCards, Cl7),
	append(L5, [Cl1], L6),
	append(L6, [Cl2], L7),
	append(L7, [Cl3], L8),
	append(L8, [Cl4], L9),
	append(L9, [Cl5], L10),
	append(L10, [Cl6], L11),
	append(L11, [Cl7], L12),
	append([Deck7], L12, BoardGame).

droppp(To, From, List, Elems, Elements, L):- To == From,
	nth0(To, List, Elem, L),
	append(Elems, [Elem], Elements).

droppp(To, From, List, Elems, Elements, L):- To < From,
	nth0(To, List, Elem, Rest),
	F is From - 1,
	append(Elems, [Elem], Result),
	droppp(To, F, Rest, Result, Elements, L).

card_to_string(Card, ToString):-
	length(Card, Len), Len == 0, ToString = '[----]'.

card_to_string(Card, ToString):- 
	length(Card, Len), Len > 0,
	nth0(0, Card, Value),
	nth0(1, Card, Suit),
	nth0(2, Card, Color),
	nth0(3, Card, IsValid),
	nth0(4, Card, IsTurned),
	card_to_string(Value, Suit, Color, IsValid, IsTurned, ToString).

card_to_string(_, _, _, IsValid, _, ToString):-
	IsValid == false, ToString = '[----]'.

card_to_string(_, _, _, IsValid, IsTurned, ToString):- 
	IsValid == true, IsTurned == true, ToString = '[????]'.

card_to_string(Value, Suit, Color, _, _, ToString):- 
	Value < 10, atom_concat('[0', Value, X),
		atom_concat(X, Suit, Y),
		atom_concat(Y, Color, Z),
		atom_concat(Z, ']', ToString).

card_to_string(Value, Suit, Color, _, _, ToString):- 
	Value > 10, atom_concat('[', Value, X),
		atom_concat(X, Suit, Y),
		atom_concat(Y, Color, Z),
		atom_concat(Z, ']', ToString).

print_upside(List, String):-
	length(List, L), L == 0, String = '[----]'.

print_upside(List, String):-
	length(List, L), L > 0,
	last(List, Last),
	card_to_string(Last, String).

print_downside(Count, _, String, Output):-
	Count >= 13, Output = String.

print_downside(Count, BoardGame, String, Output):- 
	Count < 13,
	nth0(6, BoardGame, C1),
	nth0(7, BoardGame, C2),
	nth0(8, BoardGame, C3),
	nth0(9, BoardGame, C4),
	nth0(10, BoardGame, C5),
	nth0(11, BoardGame, C6),
	nth0(12, BoardGame, C7),
	nth0(Count, C1, E1),
	nth0(Count, C2, E2),
	nth0(Count, C3, E3),
	nth0(Count, C4, E4),
	nth0(Count, C5, E5),
	nth0(Count, C6, E6),
	nth0(Count, C7, E7),
	card_to_string(E1, Str1),
	card_to_string(E2, Str2),
	card_to_string(E3, Str3),
	card_to_string(E4, Str4),
	card_to_string(E5, Str5),
	card_to_string(E6, Str6),
	card_to_string(E7, Str7),
	atom_concat(String, Str1, Out1),
	atom_concat(Out1, Str2, Out2),
	atom_concat(Out2, Str3, Out3),
	atom_concat(Out3, Str4, Out4),
	atom_concat(Out4, Str5, Out5),
	atom_concat(Out5, Str6, Out6),
	atom_concat(Out6, Str7, Out7),
	atom_concat(Out7, '\n', Out8),
	C is Count + 1,
	print_downside(C, BoardGame, Out8, Output).

print_upside(Deck, Discard, F1, F2, F3, F4, Output):-
	print_upside(Deck, DeckStr),
	print_upside(Discard, DiscardStr),
	print_upside(F1, F1Str),
	print_upside(F2, F2Str),
	print_upside(F3, F3Str),
	print_upside(F4, F4Str),
	atom_concat(DeckStr, DiscardStr, Str1),
	atom_concat(Str1, '------', Str2),
	atom_concat(Str2, F1Str, Str3),
	atom_concat(Str3, F2Str, Str4),
	atom_concat(Str4, F3Str, Str5),
	atom_concat(Str5, F4Str, Str6),
	atom_concat(Str6, '\n', Str7),
	atom_concat(Str7, '------------------------------------------\n', Str8),
	Output = Str8.
	
print_current_board(BoardGame):-
	nth0(0, BoardGame, Deck), nth0(1, BoardGame, Discard), nth0(2, BoardGame, F1),
	nth0(3, BoardGame, F2), nth0(4, BoardGame, F3), nth0(5, BoardGame, F4),
	print_upside(Deck, Discard, F1, F2, F3, F4, UpSide),
	print_downside(0, BoardGame, '', DownSide),
	atom_concat(UpSide, DownSide, BoardString),
	write(BoardString).
	
main:-

	generate_board(BoardGame),
	print_current_board(BoardGame),

halt(0).
