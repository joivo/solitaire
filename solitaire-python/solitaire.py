# -*- coding: utf-8 -*-

"""
 This game run in Portuguese interface but the code are implemented
 in english. Therefore, the suits are been
 displayed with different char from implementation.
 Note:
 	Club equal to 'P' of 'Paus' in portuguese;
 	Diamond equal to 'O' of 'Ouro' in portuguese;
 	Spade equal to 'E' of 'Espada' in portuguese;
 	Heart equal to 'C' of 'Copas' in portuguese.
"""
import random

deck = []
discard = []
club_fund = []
diamond_fund = []
spade_fund = []
heart_fund = []
columns = []

WHITEBACKGROUND = '\x1b[6;%s;47m %s \x1b[0m'
ALTERNATE_WHITEBACKGROUND = '\x1b[5;31;47m %s \x1b[0m'
BLACK_CODE = '30'
RED_CODE = '31'

def generate_card(value, suit, color, isTurned=True, isValid=True):
	return {
		'value': value,
		'suit': suit,
		'color': color,
		'isTurned': isTurned,
		'isValid': isValid
	}

def generate_suit_cards(suit, color):
	return [generate_card(x+1, suit, color) for x in range(13)]

def generate_deck():
	global deck
	club_cards = generate_suit_cards('P', BLACK_CODE)
	spade_cards = generate_suit_cards('E', BLACK_CODE)
	diamond_cards = generate_suit_cards('O', RED_CODE)
	heart_cards = generate_suit_cards('C', RED_CODE)
	deck = club_cards + spade_cards + diamond_cards + heart_cards
	random.shuffle(deck, random.random)

def generate_board():
	generate_deck()
	global deck
	global columns
	for i in range(7):
		columns.append(deck[0:(i+1)])
		columns[i][-1]['isTurned'] = False
		columns[i] = columns[i] + [generate_card(x, 'X', BLACK_CODE, True, False) for x in range(12-i)]
		del deck[0:(i+1)]

def card_to_string(card):
	if not card['isValid']:
		return WHITEBACKGROUND % (BLACK_CODE, '[------]')
	elif card['isTurned']:
		return WHITEBACKGROUND % (BLACK_CODE, '[??????]')
	elif card['value'] >= 10:
		return WHITEBACKGROUND % (card['color'], '[-' + str(card['value']) + '-' + card['suit'] + '-]')
	else:
		return WHITEBACKGROUND % (card['color'], '[-0' + str(card['value']) + '-' + card['suit'] + '-]')

def cards_to_string(cards):
	if len(cards) == 0:
		return card_to_string({'isValid': False})
	else:
		return card_to_string(cards[-1])

def print_upside():
	global deck
	global discard
	global club_fund
	global diamond_fund
	global spade_fund
	global heart_fund
	divider = WHITEBACKGROUND % (BLACK_CODE, '--------')
	print (cards_to_string(deck) + cards_to_string(discard) + divider
			+ cards_to_string(club_fund) + cards_to_string(diamond_fund)
			+ cards_to_string(spade_fund) + cards_to_string(heart_fund) + '\n'
			+ WHITEBACKGROUND % (BLACK_CODE, '--------------------------------------------------------------------'))

def print_columns():
	global columns
	output = ''
	for i in range(13):
		for j in range(7):
			if j < 6:
				output += card_to_string(columns[j][i])
			else :
				output += card_to_string(columns[j][i]) + '\n'

	print output
	print WHITEBACKGROUND % (BLACK_CODE, '--COL1------COL2------COL3------COL4------COL5------COL6------COL7--')

def print_board():
	print_upside()
	print_columns()

def main_menu():
	print WHITEBACKGROUND % (BLACK_CODE, '--------------------------------------------------------------------')
	print WHITEBACKGROUND % (BLACK_CODE, '----------------------Opcao(1): Iniciar Jogo------------------------')
	print WHITEBACKGROUND % (BLACK_CODE, '----------------------Opcao(2): Encerrar Jogo-----------------------')
	print WHITEBACKGROUND % (BLACK_CODE, '--------------------------------------------------------------------')

def main_actions_menu():
	print WHITEBACKGROUND % (BLACK_CODE, '--------------------------------------------------------------------')
	print WHITEBACKGROUND % (BLACK_CODE, '----------------------Opcao(1): Puxar uma carta do estoque----------')
	print WHITEBACKGROUND % (BLACK_CODE, '----------------------Opcao(2): Fazer um movimento------------------')
	print WHITEBACKGROUND % (BLACK_CODE, '----------------------Opcao(3): Encerrar Jogo-----------------------')
	print WHITEBACKGROUND % (BLACK_CODE, '--------------------------------------------------------------------')

def main_moves_menu():
	print WHITEBACKGROUND % (BLACK_CODE, '--------------------------------------------------------------------')
	print WHITEBACKGROUND % (BLACK_CODE, '----------------------Opcao(1): Mover do descarte para colunas------')
	print WHITEBACKGROUND % (BLACK_CODE, '----------------------Opcao(2): Mover do descarte para fundacoes----')
	print WHITEBACKGROUND % (BLACK_CODE, '----------------------Opcao(3): Mover entre colunas-----------------')
	print WHITEBACKGROUND % (BLACK_CODE, '----------------------Opcao(4): Mover das colunas para fundacoes----')
	print WHITEBACKGROUND % (BLACK_CODE, '----------------------Opcao(5): Mover das fundacoes para colunas----')
	print WHITEBACKGROUND % (BLACK_CODE, '----------------------Opcao(6): Resetar o estoque-------------------')
	print WHITEBACKGROUND % (BLACK_CODE, '----------------------Opcao(outro digito): Voltar-------------------')
	print WHITEBACKGROUND % (BLACK_CODE, '--------------------------------------------------------------------')

def end_game(winner, points=0):
	end_msg = "Jogo encerrado."

	if winner:
		end_msg = "Parabéns, você venceu! Pontuação: %d." % points

	print ALTERNATE_WHITEBACKGROUND % end_msg 
	print ALTERNATE_WHITEBACKGROUND % "     .-~~-.      "
	print ALTERNATE_WHITEBACKGROUND % "    {      }     "
	print ALTERNATE_WHITEBACKGROUND % " .-~-.    .-~-.  "
	print ALTERNATE_WHITEBACKGROUND % "{              } "
	print ALTERNATE_WHITEBACKGROUND % " `.__.'||`.__.'  "
	print ALTERNATE_WHITEBACKGROUND % "       ||        "
	print ALTERNATE_WHITEBACKGROUND % "      '--`       "

def turn_on_or_turn_off_card(card):
	card['isTurned'] = not card['isTurned']
	return card

def winner():
	global club_fund
	global diamond_fund
	global spade_fund
	global heart_fund
	if len(club_fund) == 13 and len(diamond_fund) == 13 and len(spade_fund) == 13 and len(heart_fund) == 13:
		return True
	return False

def index_of_empty(column):
	for i in range(13):
		if not column[i]['isValid']:
			return i
	return 13

def index_of_turned(column):
	for i in range(12, -1, -1):
		if not column[i]['isTurned']:
			return i
	return 13

def index_of_first_turned(column):
	for i in range(13):
		if not column[i]['isTurned']:
			return i
	return 13

def reset_deck():
	global deck
	global discard
	deck, discard = discard, deck
	deck = map(turn_on_or_turn_off_card, deck)
	random.shuffle(deck, random.random)

def deck_to_discard():
	global deck
	global discard
	if len(deck) > 0:
		card = deck.pop()
		card['isTurned'] = False
		discard.append(card)
	else:
		print ALTERNATE_WHITEBACKGROUND % 'Estoque vazio. Deseja reiniciar?'
		answer = raw_input(ALTERNATE_WHITEBACKGROUND % 'S para Sim. N para não.')
		if answer.lower() == 's':
			reset_deck()
		print '\n'

def discard_to_columns():
	global discard
	global columns
	if len(discard) > 0:
		col = int(raw_input('Para qual coluna deseja mover (1 a 7): '))
		if col > 0 and col < 8:
			index = index_of_empty(columns[col-1])
			if index > 0 and index < 13:
				if (discard[-1]['value'] == columns[col-1][index-1]['value'] - 1
					and discard[-1]['color'] != columns[col-1][index-1]['color']):
					card = discard.pop()
					columns[col-1][index] = card
			elif index == 0 and discard[-1]['value'] == 13:
				card = discard.pop()
				columns[col-1][index] = card
		else:
			print ALTERNATE_WHITEBACKGROUND % 'Coluna inválida!'
			discard_to_columns()
	else:
		print ALTERNATE_WHITEBACKGROUND % 'Descarte vazio! Puxe alguma carta.'

def discard_to_fundations():
	global discard
	global club_fund
	global diamond_fund
	global spade_fund
	global heart_fund
	if len(discard) > 0:
		if discard[-1]['suit'] == 'P':
			if (len(club_fund) > 0 and club_fund[-1]['value'] == discard[-1]['value'] -1
				or len(club_fund) == 0 and discard[-1]['value'] == 1):
				card = discard.pop()
				club_fund.append(card)
		elif discard[-1]['suit'] == 'O':
			if (len(diamond_fund) > 0 and diamond_fund[-1]['value'] == discard[-1]['value'] -1
				or len(diamond_fund) == 0 and discard[-1]['value'] == 1):
				card = discard.pop()
				diamond_fund.append(card)
		elif discard[-1]['suit'] == 'E':
			if (len(spade_fund) > 0 and spade_fund[-1]['value'] == discard[-1]['value'] -1
				or len(spade_fund) == 0 and discard[-1]['value'] == 1):
				card = discard.pop()
				spade_fund.append(card)
		else:
			if (len(heart_fund) > 0 and heart_fund[-1]['value'] == discard[-1]['value'] -1
				or len(heart_fund) == 0 and discard[-1]['value'] == 1):
				card = discard.pop()
				heart_fund.append(card)
	else:
		print ALTERNATE_WHITEBACKGROUND % 'Descarte vazio! Puxe alguma carta.'


def is_turned_on_and_valid(card):
	return card['isTurned'] and card['isValid']

def is_turned_off_and_valid(card):
	return not card['isTurned'] and card['isValid']

def between_columns():
	global columns
	colFrom = int(raw_input('Qual a coluna de origem (1-7): '))
	colTo = int(raw_input('Qual a coluna de destino (1-7): '))
	qnt = int(raw_input('Quantas cartas deseja mover? '))
	if colFrom > 0 and colFrom < 8 and colTo > 0 and colTo < 8 and colFrom != colTo:
		cardsFrom = filter(is_turned_off_and_valid, columns[colFrom-1])
		turned_cards_from = filter(is_turned_on_and_valid, columns[colFrom-1])
		cardsTo = filter(is_turned_off_and_valid, columns[colTo -1])
		turned_cards_to = filter(is_turned_on_and_valid, columns[colTo-1])
		filtered = cardsFrom
		diff = 0
		if len(cardsFrom) > 0 and qnt > 0:
			if qnt > len(cardsFrom):
				qnt = len(cardsFrom)
			if qnt < len(cardsFrom):
				filtered = cardsFrom[-qnt:(len(cardsFrom))]
				del cardsFrom[-qnt:(len(cardsFrom))]
			if qnt == len(cardsFrom):
				cardsFrom = []
			if len(cardsTo) == 0 and filtered[0]['value'] == 13:
				columns[colTo-1] = filtered
				columns[colTo-1][len(filtered):13] = [generate_card(x, 'X', BLACK_CODE, True, False) for x in range(13 - len(filtered))]
				columns[colFrom-1] = turned_cards_from + cardsFrom
				if len(columns[colFrom-1]) > 0 and columns[colFrom-1][-1]['isValid']:
						columns[colFrom-1][-1]['isTurned'] = False
				columns[colFrom-1][len(columns[colFrom-1]):13] = [generate_card(x, 'X', BLACK_CODE, True, False) for x in range(13 - len(columns[colFrom-1]))]
			else:
				if cardsTo[-1]['value'] - 1 == filtered[0]['value'] and cardsTo[-1]['color'] != filtered[0]['color']:
					columns[colTo-1] = turned_cards_to + cardsTo + filtered
					columns[colTo-1][len(columns[colTo-1]):13] = [generate_card(x, 'X', BLACK_CODE, True, False) for x in range(13 - len(columns[colTo-1]))]
					columns[colFrom-1] = turned_cards_from + cardsFrom
					if len(columns[colFrom-1]) > 0 and columns[colFrom-1][-1]['isValid']:
						columns[colFrom-1][-1]['isTurned'] = False
					columns[colFrom-1][len(columns[colFrom-1]):13] = [generate_card(x, 'X', BLACK_CODE, True, False) for x in range(13 - len(columns[colFrom-1]))]		

def columns_to_fundations():
	global columns
	global club_fund
	global diamond_fund
	global spade_fund
	global heart_fund
	colFrom = int(raw_input('Qual a coluna de origem (1-7): '))
	if colFrom > 0 and colFrom < 8:
		index_last_valid = index_of_turned(columns[colFrom-1])
		if index_last_valid < 13:
			card = columns[colFrom-1][index_last_valid]
			if card['suit'] == 'P':
				if (len(club_fund) > 0 and club_fund[-1]['value'] == card['value'] -1
					or len(club_fund) == 0 and card['value'] == 1):
					club_fund.append(card)
					columns[colFrom-1][index_last_valid] = generate_card(0, 'X', BLACK_CODE, True, False)
					if index_last_valid -1 >= 0:
						columns[colFrom-1][index_last_valid-1]['isTurned'] = False
			elif card['suit'] == 'O':
				if (len(diamond_fund) > 0 and diamond_fund[-1]['value'] == card['value'] -1
					or len(diamond_fund) == 0 and card['value'] == 1):
					diamond_fund.append(card)
					columns[colFrom-1][index_last_valid] = generate_card(0, 'X', BLACK_CODE, True, False)
					if index_last_valid -1 >= 0:
						columns[colFrom-1][index_last_valid-1]['isTurned'] = False
			elif card['suit'] == 'E':
				if (len(spade_fund) > 0 and spade_fund[-1]['value'] == card['value'] -1
					or len(spade_fund) == 0 and card['value'] == 1):
					spade_fund.append(card)
					columns[colFrom-1][index_last_valid] = generate_card(0, 'X', BLACK_CODE, True, False)
					if index_last_valid -1 >= 0:
						columns[colFrom-1][index_last_valid-1]['isTurned'] = False
			else:
				if (len(heart_fund) > 0 and heart_fund[-1]['value'] == card['value'] -1
					or len(heart_fund) == 0 and card['value'] == 1):
					heart_fund.append(card)
					columns[colFrom-1][index_last_valid] = generate_card(0, 'X', BLACK_CODE, True, False)
					if index_last_valid -1 >= 0:
						columns[colFrom-1][index_last_valid-1]['isTurned'] = False

def fundations_to_columns():
	global columns
	global club_fund
	global diamond_fund
	global spade_fund
	global heart_fund
	fundFrom = raw_input('Qual a fundação de origem (SIGLAS: P - O - E- C): ')
	colTo = int(raw_input('Qual a coluna de destino (1-7): '))
	if colTo > 0 and colTo < 8:
		index_last_turned = index_of_turned(columns[colTo-1])
		if index_last_turned < 13:
			card = columns[colTo-1][index_last_turned]
			if fundFrom.upper() == 'P':
				if (len(club_fund) > 0 and club_fund[-1]['value'] == card['value'] -1
					and club_fund[-1]['color'] != card['color'] or len(club_fund) == 0 and card['value'] == 1):
					card_fund = club_fund.pop()
					columns[colTo-1][index_last_turned+1] = card_fund
			elif fundFrom.upper() == 'O':
				if (len(diamond_fund) > 0 and diamond_fund[-1]['value'] == card['value'] -1
					and diamond_fund[-1]['color'] != card['color'] or len(diamond_fund) == 0 and card['value'] == 1):
					card_fund = diamond_fund.pop()
					columns[colTo-1][index_last_turned+1] = card_fund
			elif fundFrom.upper() == 'E':
				if (len(spade_fund) > 0 and spade_fund[-1]['value'] == card['value'] -1
					and spade_fund[-1]['color'] != card['color'] or len(spade_fund) == 0 and card['value'] == 1):
					card_fund = spade_fund.pop()
					columns[colTo-1][index_last_turned+1] = card_fund
			elif fundFrom.upper() == 'C':
				if (len(heart_fund) > 0 and heart_fund[-1]['value'] == card['value'] -1
					and heart_fund[-1]['color'] != card['color'] or len(heart_fund) == 0 and card['value'] == 1):
					card_fund = heart_fund.pop()
					columns[colTo-1][index_last_turned+1] = card_fund
	else:
		print ALTERNATE_WHITEBACKGROUND % 'Opção inválida'

def move():
	main_moves_menu()
	option = raw_input('Opção: ')
	if option == '1':
		discard_to_columns()
	elif option == '2':
		discard_to_fundations()
	elif option == '3':
		between_columns()
	elif option == '4':
		columns_to_fundations()
	elif option == '5':
		fundations_to_columns()
	elif option == '6':
		reset_deck()
	else:
		print ALTERNATE_WHITEBACKGROUND % 'Opção inválida'
		move()

def play_game(points):
	while not winner():
		print_board()
		main_actions_menu()
		option = raw_input('Opção: ')
		if option == '1':
			deck_to_discard()
			points -= 1
		elif option == '2':
			move()
			points -= 1
		elif option == '3':
			end_game(False)
			break
		else:
			print ALTERNATE_WHITEBACKGROUND % 'Opção inválida'
	if winner():
		end_game(True, points)

def main():
	main_menu()
	option = raw_input('Opção: ')
	if option == '1':
		generate_board()
		play_game(10000)
	elif option == '2':
		end_game(False)
	else:
		print ALTERNATE_WHITEBACKGROUND % 'Opção inválida'
		main()

if __name__ == "__main__":
	main()