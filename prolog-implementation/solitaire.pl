:- dynamic
	column(_,_,_,_,_,_,_,_,_,_,_,_,_,_),
	fundation(_,_),
	stock(_),
	discard(_),
	last_elem(_),
	position_of_last(_).

:- initialization(main).
/*
	The card representation is a List that the positions, from 0 to 4 is
	[Value, Suit, Color, IsValid, IsTurned], respectively.
	[--0--,--1--,---2,-,----3---,-----4---].
*/
card(Value, Suit, Color, IsValid, IsTurned, [Value, Suit, Color, IsValid, IsTurned]).

generateCardsList(Suit, Color, X):-
	generateCL(1, Suit, Color, C1),
	generateCL(2, Suit, Color, C2),
	generateCL(3, Suit, Color, C3),
	generateCL(4, Suit, Color, C4),
	generateCL(5, Suit, Color, C5),
	generateCL(6, Suit, Color, C6),
	generateCL(7, Suit, Color, C7),
	generateCL(8, Suit, Color, C8),
	generateCL(9, Suit, Color, C9),
	generateCL(10, Suit, Color, C10),
	generateCL(11, Suit, Color, C11),
	generateCL(12, Suit, Color, C12),
	generateCL(13, Suit, Color, C13),
	append([C1], [C2], X1),
	append(X1, [C3], X2),
	append(X2, [C4], X3),
	append(X3, [C5], X4),
	append(X4, [C6], X5),
	append(X5, [C7], X6),
	append(X6, [C8], X7),
	append(X7, [C9], X8),
	append(X8, [C10], X9),
	append(X9, [C11], X10),
	append(X10, [C12], X11),
	append(X11, [C13], X).
	
generateCL(Count, Suit, Color, X):-
	card(Count, Suit, Color, true, true, X).


generateInvalidCard(Card):-
	card(0, 'X', 'X', false, false, Card).

generate_deck(X):-
		generateCardsList('O', 'R', O),
		generateCardsList('C', 'R', C),
		generateCardsList('P', 'B', P),
		generateCardsList('E', 'B', E),
		append(O, C, L1),
		append(L1, P, L2),
		append(L2, E, Deck),
		random_permutation(Deck, X).

valid_cards_amount(Cards, X):-
	vc_amount(0, Cards, X), !.

vc_amount(Count, Cards, X):-
	length(Cards, Len),
	Len =< Count, X = Count.

vc_amount(Count, Cards, X):-
	length(Cards, Len),
	Len > Count,
	nth0(Count, Cards, Card),
	nth0(3, Card, IsValid),
	IsValid == false,
	X = Count.

vc_amount(Count, Cards, X):-
	length(Cards, Len),
	Len > Count,
	nth0(Count, Cards, Card),
	nth0(3, Card, IsValid),
	IsValid == true,
	C is Count + 1,
	vc_amount(C, Cards, X).

turn_off_last(Cards, X):-
	valid_cards_amount(Cards, Num),
	Num == 0,
	X = Cards.

turn_off_last(Cards, X):-
	valid_cards_amount(Cards, Num),
	Num > 0,
	nth1(Num, Cards, Elem, Rest),
	nth0(0, Elem, Value), nth0(1, Elem, Suit),
	nth0(2, Elem, Color), card(Value, Suit, Color, true, false, Card),
	nth1(Num, X, Card, Rest).

turn_off(X, Card):-
	nth0(0, X, Value), nth0(1, X, Suit),
	nth0(2, X, Color), card(Value, Suit, Color, true, false, Card).

generate_column(1, Col):-
	generateInvalidCard(InvalidCard),
	nth0(0, Col, X),
	turn_off(X, Card),
	assertz(column(1, Card, InvalidCard, InvalidCard, InvalidCard,
	InvalidCard, InvalidCard, InvalidCard, InvalidCard, InvalidCard,
	InvalidCard, InvalidCard, InvalidCard, InvalidCard)).
	
generate_column(2, Col):-
	generateInvalidCard(InvalidCard),
	nth0(0, Col, Card1),
	nth0(1, Col, X),
	turn_off(X, Card2),
	assertz(column(2, Card1, Card2, InvalidCard, InvalidCard,
	InvalidCard, InvalidCard, InvalidCard, InvalidCard, InvalidCard,
	InvalidCard, InvalidCard, InvalidCard, InvalidCard)).

generate_column(3, Col):-
	generateInvalidCard(InvalidCard),
	nth0(0, Col, Card1),
	nth0(1, Col, Card2),
	nth0(2, Col, X),
	turn_off(X, Card3),
	assertz(column(3, Card1, Card2, Card3, InvalidCard,
	InvalidCard, InvalidCard, InvalidCard, InvalidCard, InvalidCard,
	InvalidCard, InvalidCard, InvalidCard, InvalidCard)).

generate_column(4, Col):-
	generateInvalidCard(InvalidCard),
	nth0(0, Col, Card1),
	nth0(1, Col, Card2),
	nth0(2, Col, Card3),
	nth0(3, Col, X),
	turn_off(X, Card4),
	assertz(column(4, Card1, Card2, Card3, Card4,
	InvalidCard, InvalidCard, InvalidCard, InvalidCard, InvalidCard,
	InvalidCard, InvalidCard, InvalidCard, InvalidCard)).

generate_column(5, Col):-
	generateInvalidCard(InvalidCard),
	nth0(0, Col, Card1),
	nth0(1, Col, Card2),
	nth0(2, Col, Card3),
	nth0(3, Col, Card4),
	nth0(4, Col, X),
	turn_off(X, Card5),
	assertz(column(5, Card1, Card2, Card3, Card4,
	Card5, InvalidCard, InvalidCard, InvalidCard, InvalidCard,
	InvalidCard, InvalidCard, InvalidCard, InvalidCard)).

generate_column(6, Col):-
	generateInvalidCard(InvalidCard),
	nth0(0, Col, Card1),
	nth0(1, Col, Card2),
	nth0(2, Col, Card3),
	nth0(3, Col, Card4),
	nth0(4, Col, Card5),
	nth0(5, Col, X),
	turn_off(X, Card6),
	assertz(column(6, Card1, Card2, Card3, Card4,
	Card5, Card6, InvalidCard, InvalidCard, InvalidCard,
	InvalidCard, InvalidCard, InvalidCard, InvalidCard)).

generate_column(7, Col):-
	generateInvalidCard(InvalidCard),
	nth0(0, Col, Card1),
	nth0(1, Col, Card2),
	nth0(2, Col, Card3),
	nth0(3, Col, Card4),
	nth0(4, Col, Card5),
	nth0(5, Col, Card6),
	nth0(6, Col, X),
	turn_off(X, Card7),
	assertz(column(7, Card1, Card2, Card3, Card4,
	Card5, Card6, Card7, InvalidCard, InvalidCard,
	InvalidCard, InvalidCard, InvalidCard, InvalidCard)).

generate_board():-
	generate_deck(Deck),
	droppp(0, 0, Deck, Col1, Deck1), 
	droppp(0, 1, Deck1, Col2, Deck2),
	droppp(0, 2, Deck2, Col3, Deck3),
	droppp(0, 3, Deck3, Col4, Deck4),
	droppp(0, 4, Deck4, Col5, Deck5),
	droppp(0, 5, Deck5, Col6, Deck6),
	droppp(0, 6, Deck6, Col7, Deck7),
	assertz(stock(Deck7)),
	assertz(discard([])),
	assertz(fundation(1, [])),
	assertz(fundation(2, [])),
	assertz(fundation(3, [])),
	assertz(fundation(4, [])),
	generate_column(1, Col1),
	generate_column(2, Col2),
	generate_column(3, Col3),
	generate_column(4, Col4),
	generate_column(5, Col5),
	generate_column(6, Col6),
	generate_column(7, Col7).

droppp(To, From, List, Elements, L):-
	drop(To, From, List, [], Elements, L), !.

drop(To, From, List, Elems, Elements, L):-
	To == From,
	nth0(To, List, Elem, L),
	append(Elems, [Elem], Elements), !.

drop(To, From, List, Elems, Elements, L):-
	To < From,
	nth0(To, List, Elem, Rest),
	F is From - 1,
	append(Elems, [Elem], Result),
	drop(To, F, Rest, Result, Elements, L).

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


p_downside():-
	column(1 ,E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13),
	column(2 ,F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12, F13),
	column(3 ,G1, G2, G3, G4, G5, G6, G7, G8, G9, G10, G11, G12, G13),
	column(4 ,H1, H2, H3, H4, H5, H6, H7, H8, H9, H10, H11, H12, H13),
	column(5 ,I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13),
	column(6 ,K1, K2, K3, K4, K5, K6, K7, K8, K9, K10, K11, K12, K13),
	column(7 ,J1, J2, J3, J4, J5, J6, J7, J8, J9, J10, J11, J12, J13),
	print_column(E1, F1, G1, H1, I1, K1, J1),
	print_column(E2, F2, G2, H2, I2, K2, J2),
	print_column(E3, F3, G3, H3, I3, K3, J3),
	print_column(E4, F4, G4, H4, I4, K4, J4),
	print_column(E5, F5, G5, H5, I5, K5, J5),
	print_column(E6, F6, G6, H6, I6, K6, J6),
	print_column(E7, F7, G7, H7, I7, K7, J7),
	print_column(E8, F8, G8, H8, I8, K8, J8),
	print_column(E9, F9, G9, H9, I9, K9, J9),
	print_column(E10, F10, G10, H10, I10, K10, J10),
	print_column(E11, F11, G11, H11, I11, K11, J11),
	print_column(E12, F12, G12, H12, I12, K12, J12),
	print_column(E13, F13, G13, H13, I13, K13, J13),
	write('\n').

print_column(E1, E2, E3, E4, E5, E6, E7):-
	card_to_string(E1, Str1),
	card_to_string(E2, Str2),
	card_to_string(E3, Str3),
	card_to_string(E4, Str4),
	card_to_string(E5, Str5),
	card_to_string(E6, Str6),
	card_to_string(E7, Str7),
	write(Str1), write(Str2), write(Str3), write(Str4),
	write(Str5), write(Str6), write(Str7), write('\n').
	
print_upside():-
	stock(Deck),
	discard(Discard),
	fundation(1, F1),
	fundation(2, F2),
	fundation(3, F3),
	fundation(4, F4),
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
	write(Str8).

print_current_board():-
	print_upside(),
	p_downside().

confirm_to_fund(Fund, X, Card):-
	append(X, [Card], Fundation),
	discard(Discard),
	length(Discard, Y),
	nth1(Y, Discard, Elem, NewDiscard),
	retract(discard(_)),
	retract(fundation(Fund, _)),
	assertz(discard(NewDiscard)),
	assertz(fundation(Fund, Fundation)).

discard_to_specific_fund(Fund, Card, Value):-
	fundation(Fund, X),
	length(X, Len),
		(Len == 0,
			Value == 1,
			confirm_to_fund(Fund, X, Card);
		Len > 0,
			last(X, LastCard),
			nth0(0, LastCard, ValueLastCard),
			Num is ValueLastCard + 1,
			Num == Value,
			confirm_to_fund(Fund, X, Card)).

discard_to_fundation(Card, Value, Suit):-
	(Suit == 'O',
		discard_to_specific_fund(1, Card, Value);
	Suit == 'C',
		discard_to_specific_fund(2, Card, Value);
	Suit == 'P',
		discard_to_specific_fund(3, Card, Value);
	Suit == 'E',
		discard_to_specific_fund(4, Card, Value)).

move(1):-
	discard(Discard),
	length(Discard, Len),
	Len > 0,
	last(Discard, Card),
	nth0(0, Card, Value),
	nth0(1, Card, Suit),
	discard_to_fundation(Card, Value, Suit), !,
	play(false);
	move(1).

get_last_valid_card(Num, Card, X, Y):-
	column(Num, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13),
	nth0(3, E1, IV1),
	nth0(3, E2, IV2),
	nth0(3, E3, IV3),
	nth0(3, E4, IV4),
	nth0(3, E5, IV5),
	nth0(3, E6, IV6),
	nth0(3, E7, IV7),
	nth0(3, E8, IV8),
	nth0(3, E9, IV9),
	nth0(3, E10, IV10),
	nth0(3, E11, IV11),
	nth0(3, E12, IV12),
	nth0(3, E13, IV13),
	(IV1 == false,
		discard_to_specific_col(Num, 0, Card);
	IV1 == true, IV2 == false,
		X = E1, Y = 1;
	IV2 == true, IV3 == false,
		X = E2, Y = 2;
	IV3 == true, IV4 == false,
		X = E3, Y = 3;
	IV4 == true, IV5 == false,
		X = E4, Y = 4;
	IV5 == true, IV6 == false,
		X = E5, Y = 5;
	IV6 == true, IV7 == false,
		X = E6, Y = 6;
	IV7 == true, IV8 == false,
		X = E7, Y = 7;
	IV8 == true, IV9 == false,
		X = E8, Y = 8;
	IV9 == true, IV10 == false,
		X = E9, Y = 9;
	IV10 == true, IV11 == false,
		X = E10, Y = 10;
	IV11 == true, IV12 == false,
		X = E11, Y = 11;
	IV12 == true, IV13 == false,
		X = E12, Y = 12;
	IV13 == true,
		X = [], Y = 13).

discard_to_specific_col(Num, 0, Card):-
	column(Num, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13),
	nth0(0, Card, Value),
	Value == 13,
	retract(column(Num,_,_,_,_,_,_,_,_,_,_,_,_,_)),
	assertz(column(Num, Card, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13)).

discard_to_specific_col(Num, 1, Card):-
	column(Num, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13),
	nth0(0, Card, Value),
	retract(column(Num,_,_,_,_,_,_,_,_,_,_,_,_,_)),
	assertz(column(Num, E1, Card, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13)).

discard_to_specific_col(Num, 2, Card):-
	column(Num, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13),
	nth0(0, Card, Value),
	retract(column(Num,_,_,_,_,_,_,_,_,_,_,_,_,_)),
	assertz(column(Num, E1, E2, Card, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13)).

discard_to_specific_col(Num, 3, Card):-
	column(Num, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13),
	nth0(0, Card, Value),
	retract(column(Num,_,_,_,_,_,_,_,_,_,_,_,_,_)),
	assertz(column(Num, E1, E2, E3, Card, E5, E6, E7, E8, E9, E10, E11, E12, E13)).

discard_to_specific_col(Num, 4, Card):-
	column(Num, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13),
	nth0(0, Card, Value),
	retract(column(Num,_,_,_,_,_,_,_,_,_,_,_,_,_)),
	assertz(column(Num, E1, E2, E3, E4, Card, E6, E7, E8, E9, E10, E11, E12, E13)).

discard_to_specific_col(Num, 5, Card):-
	column(Num, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13),
	nth0(0, Card, Value),
	retract(column(Num,_,_,_,_,_,_,_,_,_,_,_,_,_)),
	assertz(column(Num, E1, E2, E3, E4, E5, Card, E7, E8, E9, E10, E11, E12, E13)).

discard_to_specific_col(Num, 6, Card):-
	column(Num, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13),
	nth0(0, Card, Value),
	retract(column(Num,_,_,_,_,_,_,_,_,_,_,_,_,_)),
	assertz(column(Num, E1, E2, E3, E4, E5, E6, Card, E8, E9, E10, E11, E12, E13)).

discard_to_specific_col(Num, 7, Card):-
	column(Num, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13),
	nth0(0, Card, Value),
	retract(column(Num,_,_,_,_,_,_,_,_,_,_,_,_,_)),
	assertz(column(Num, E1, E2, E3, E4, E5, E6, E7, Card, E9, E10, E11, E12, E13)).

discard_to_specific_col(Num, 8, Card):-
	column(Num, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13),
	nth0(0, Card, Value),
	retract(column(Num,_,_,_,_,_,_,_,_,_,_,_,_,_)),
	assertz(column(Num, E1, E2, E3, E4, E5, E6, E7, E8, Card, E10, E11, E12, E13)).

discard_to_specific_col(Num, 9, Card):-
	column(Num, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13),
	nth0(0, Card, Value),
	retract(column(Num,_,_,_,_,_,_,_,_,_,_,_,_,_)),
	assertz(column(Num, E1, E2, E3, E4, E5, E6, E7, E8, E9, Card, E11, E12, E13)).

discard_to_specific_col(Num, 10, Card):-
	column(Num, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13),
	nth0(0, Card, Value),
	retract(column(Num,_,_,_,_,_,_,_,_,_,_,_,_,_)),
	assertz(column(Num, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, Card, E12, E13)).

discard_to_specific_col(Num, 11, Card):-
	column(Num, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13),
	nth0(0, Card, Value),
	retract(column(Num,_,_,_,_,_,_,_,_,_,_,_,_,_)),
	assertz(column(Num, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, Card, E13)).

discard_to_specific_col(Num, 12, Card):-
	column(Num, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13),
	nth0(0, Card, Value),
	retract(column(Num,_,_,_,_,_,_,_,_,_,_,_,_,_)),
	assertz(column(Num, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, Card)).

discard_to_column(Card, Num, Value, Color):-
	V is Value + 1,
	get_last_valid_card(Num, Card, X, Y),
	Y < 13,
	nth0(0, X, ValueLastCard),
	nth0(2, X, ColorLastCard),
	V == ValueLastCard,
	Color \= ColorLastCard,
	discard_to_specific_col(Num, Y, Card),
	discard(Discard),
	length(Discard, Len),
	nth1(Len, Discard, Elem, NewDiscard),
	retract(discard(_)),
	assertz(discard(NewDiscard)).

move(2):-
	discard(Discard),
	length(Discard, Len),
	Len > 0,
	last(Discard, Card),
	nth0(0, Card, Value),
	nth0(2, Card, Color),
	write('Digite para que coluna deseja mover\n'),
	read(Num),
	discard_to_column(Card, Num, Value, Color), !,
	play(false).

move(Option):-
	Option \= 1,
	Option \= 2,
	Option \= 3,
	Option \= 4,
	Option \= 5,
	play(false).

getFromStock():-
	stock(Stock),
	length(Stock, Len),
	Len > 0,
	last(Stock, X),
	discard(Discard),
	turn_off(X, Card),
	append(Discard, [Card], NewDiscard),
	C is Len - 1,
	nth0(C, Stock, Elem, NewStock),
	retract(stock(_)),
	retract(discard(_)),
	assertz(stock(NewStock)),
	assertz(discard(NewDiscard)).

play_game(_, 1):-
	getFromStock(), !,
	play(false);

	getFromStock().

play_game( _, 2):-
	write("Opcao (1) - Mover do descarte para fundacoes.\n
Opcao (2) - Mover do descarte para colunas.\n
Opcao (3) - Mover entre as colunas.\n
Opcao (4) - Mover das colunas para fundacoes.\n 
Opcao (5) - Embaralhar descarte para estoque. \n
Outro digito - Voltar.\n"), !,
	read(Moviment), !,
	move(Moviment).


play_game(Winner, Option):-
	Option \= 1,
	Option \= 2, start(2, false).

play(true):-
	start(0, true).

play(Winner):-
	print_current_board(),
	write("
----------------------------------------\n
Opcao (1) - Puxar uma carta do estoque\n
Opcao (2) - Fazer um movimento\n
Outro digito - Encerrar Jogo\n\n"),
	read(Option),
	play_game(Winner, Option).

start(2, _):- 
	write("Jogo encerrado.
         .-~~-.
        {      }
     .-~-.    .-~-.
    {              }
     `.__.'||`.__.'
           ||
	\n"), halt(0).

start(_, true):-
	write("Parabéns, você venceu!
         .-~~-.
        {      }
     .-~-.    .-~-.
    {              }
     `.__.'||`.__.'
           ||
	\n"), !.

start(Num, Winner):-
	generate_board(),
	write("----------------------------------------\n
		Solitaire\n
----------------------------------------\n
Opcao (1) - Iniciar Jogo\n
Opcao (2) - Encerrar Jogo\n\n"),
	read(X), 
	play(false).

main:-
	start(0, false),
halt(0).
