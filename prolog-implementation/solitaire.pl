:- initialization(main).

card(Value, Suit, Color, IsValid, IsTurned).

genereate_deck(concat(generateCardsList(13, 'O', 'R'),
		generateCardsList(13, 'C', 'R'),
		generateCardsList(13, 'P', 'B'),
		generateCardsList(13, 'E', 'B'))).


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

main :-

	read(Value), nl,
	card_to_string(Value, 'O', 'R', true, false, ToString1),
	card_to_string(Value, 'O', 'R', true, true, ToString2),
	card_to_string(Value, 'O', 'R', false, true, ToString3),
	write(ToString1),nl,
	write(ToString2), nl,
	write(ToString3), nl,

halt(0).
