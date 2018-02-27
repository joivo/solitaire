
/*
	The card representation is a List that the positions, from 0 to 4 is
	[Value, Suit, Color, IsValid, IsTurned], respectively.
	[--0--,--1--,---2,-,----3---,-----4---].
*/
card(Value, Suit, Color, IsValid, IsTurned, [Value, Suit, Color, IsValid, IsTurned]).

generateCardsList(Count, Suit, Color, List, X):- Count == 1,
	card(Count, Suit, Color, true, true, Card),
	C is Count + 1,
	generateCardsList(C, Suit, Color, [Card], X).

generateCardsList(Count, Suit, Color, List, X):- Count < 14, 
	card(Count, Suit, Color, true, true, Card),
	append(List, [Card], L),
	C is Count + 1,
	generateCardsList(C, Suit, Color, L, X).

generateCardsList(Count, Suit, Color, List, X):- Count >= 14, X = [List].
	

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
	append(L5, [Col1], L6),
	append(L6, [Col2], L7),
	append(L7, [Col3], L8),
	append(L8, [Col4], L9),
	append(L9, [Col5], L10),
	append(L10, [Col6], L11),
	append(L11, [Col7], L12),
	append(Deck7, L12, BoardGame).

droppp(To, From, List, Elems, Elements, L):- To == From,
	nth0(To, List, Elem, L),
	append(Elems, [Elem], Elements).

droppp(To, From, List, Elems, Elements, L):- To < From,
	nth0(To, List, Elem, Rest),
	F is From - 1,
	append(Elems, [Elem], Result),
	droppp(To, F, Rest, Result, Elements, L).
	
card_to_string(Value, Suit, Color, IsValid, IsTurned, ToString):- 
	IsValid == false, ToString = "[----]".

card_to_string(Value, Suit, Color, IsValid, IsTurned, ToString):- 
	IsValid == true, IsTurned == true, ToString = "[????]".

card_to_string(Value, Suit, Color, IsValid, IsTurned, ToString):- 
	Value < 10, atom_concat('[0', Value, X),
		atom_concat(X, Suit, Y),
		atom_concat(Y, Color, Z),
		atom_concat(Z, ']', ToString).

card_to_string(Value, Suit, Color, IsValid, IsTurned, ToString):- 
	Value > 10, atom_concat('[', Value, X),
		atom_concat(X, Suit, Y),
		atom_concat(Y, Color, Z),
		atom_concat(Z, ']', ToString).

:- initialization(main).
main:-

/*	read(Value), nl,
	read(Suit), nl,
	read(Color), nl,
	card(Value, Suit, Color, true, false, X),
	write(X), nl,
	nth0(0, X, V), nth0(1, X, S),
	nth0(2, X, C), nth0(3, X, I), nth0(4, X, T),
	card_to_string(V, S, C, I, T, Y),
	write(Y),nl,
*/

	generate_board(L),
	write(L), nl.
