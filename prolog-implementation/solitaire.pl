
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

generateCardsList(Count, Suit, Color, List, X):- Count >= 14, X = List.
	

generate_deck(T, X):-
		generateCardsList(1, 'O', 'R', [], O),
		generateCardsList(1, 'C', 'R', [], C),
		generateCardsList(1, 'P', 'B', [], P),
		generateCardsList(1, 'E', 'B', [], E),
		append(O, C, L1),
		append(P, E, L2),
		append(L1, L2, Deck),
		random_permutation(Deck, X).


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

	generate_deck(true, X),
	write(X), nl.
