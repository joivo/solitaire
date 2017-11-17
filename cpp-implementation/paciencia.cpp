#include <iostream>
#include <stdlib.h>
#include <string>
#include <stack>
#include <algorithm>
#include <vector>
#include <iterator>

using namespace std;

const string NO_CARDS = "Não há cartas nesta posição!";
const string INVALID_CMD = "Comando inválido!";
const string HEART = "C";
const string CLUB = "P";
const string DIAMOND = "O";
const string SPADE = "E";

struct card {
    int value;
    string suit;
    bool is_turned;
	bool is_valid;
};

vector<card> deck;
stack<card> stock;
stack<card> discard;

stack<card> col1;
stack<card> col2;
stack<card> col3;
stack<card> col4;
stack<card> col5;
stack<card> col6;
stack<card> col7;

stack<card> fundation_heart;
stack<card> fundation_club;
stack<card> fundation_diamond;
stack<card> fundation_spade;

string toString(card element) {
		if (element.is_valid == false) {
			return "---";
		} else if (element.is_turned == true) {
			return "???";
		} else if(element.value < 10) {
			return "0" + to_string(element.value) + element.suit;
		} else {
			return to_string(element.value) + element.suit;
		}
}

void assign_cards(string suit) {
	card c;
	for (int i = 0; i < 13; i++)  {
		c.suit = suit;
		c.value = (i+1);
		c.is_turned = true;
		c.is_valid = true;
		deck.push_back(c);
	}		
}

void build_deck() {
	assign_cards(HEART); 
	assign_cards(CLUB);
	assign_cards(DIAMOND);
	assign_cards(SPADE);
}

void build_stock() {
	for (int i = 0; i < 24; i++) {
		stock.push(deck.data()[i]);
		deck.erase(deck.begin() + i);
	}	
}

void build_column(stack<card>* column, int quantity) {
	for(int i = 0; i < quantity; i++) {
		card c = deck.data()[i];
		if(i == quantity -1) {
			c.is_turned = false;
		}
		column->push(c);
		deck.erase(deck.begin() + i);
	}

	for(int i = 0; i < 13 - quantity; i++) {
		card c;
		c.is_valid = false;
		column->push(c);
	}
}

void build_columns() {
	build_column(&col1, 1);
	build_column(&col2, 2);
	build_column(&col3, 3);
	build_column(&col4, 4);
	build_column(&col5, 5);
	build_column(&col6, 6);
	build_column(&col7, 7);
}

void replace_stock() {
  for (int i = 0; i < discard.size(); i++) {
    card c = discard.top();
    discard.pop();
	c.is_turned = false;
    stock.push(c);
	
  }
}

bool acess_stock(bool flag) {
	card c;
	flag = false;
	if (!stock.empty()) {	
		c = stock.top();
		stock.top().is_turned = false;
		stock.pop();			
		discard.push(c);		
	} else {
		flag = true;
		if (!discard.empty()) {
			replace_stock();
		}
  	}
	return flag;	
}

void discard_to_fundation_heart() {
	if (!discard.empty()) {
		card c = discard.top();
		if (fundation_heart.empty()) {
			fundation_heart.push(c);
			discard.pop();
		} else if (c.is_valid && 
						c.is_turned &&
						fundation_heart.top().value < c.value &&
						fundation_heart.top().suit.compare(c.suit)) {

			fundation_heart.push(c);
			discard.pop();
		}	
	}	
}

void discard_to_fundation_club() {
	if (!discard.empty()) {
		card c = discard.top();
		if (fundation_club.empty()) {
			fundation_club.push(c);
			discard.pop();
		} else if (c.is_valid && 
						c.is_turned &&
						fundation_club.top().value < c.value &&
						fundation_club.top().suit.compare(c.suit)) {

			fundation_club.push(c);
			discard.pop();
		}	
	}	
}

void discard_to_fundation_diamond() {
	if (!discard.empty()) {
		card c = discard.top();
		if (fundation_diamond.empty()) {
			fundation_diamond.push(c);
			discard.pop();
		} else if (c.is_valid && 
						c.is_turned &&
						fundation_diamond.top().value < c.value &&
						fundation_diamond.top().suit.compare(c.suit)) {

			fundation_diamond.push(c);
			discard.pop();
		}	
	}	
}

void discard_to_fundation_spade() {
	if (!discard.empty()) {
		card c = discard.top();
		if (fundation_spade.empty()) {
			fundation_spade.push(c);
			discard.pop();
		} else if (c.is_valid && 
						c.is_turned &&
						fundation_spade.top().value < c.value &&
						fundation_spade.top().suit.compare(c.suit)) {

			fundation_spade.push(c);
			discard.pop();
		}	
	}	
}

bool suits_compatibles(string suit1, string suit2) {
	bool flag = false;

	if (suit1.compare(HEART) || suit1.compare(DIAMOND) && ((suit2.compare(CLUB)) || suit2.compare(SPADE))) {
		flag = true;
	} else if ((suit1.compare(CLUB) || suit1.compare(SPADE)) && (suit2.compare(HEART) || suit2.compare(DIAMOND))) {
		flag = true;
	}

	return flag;
}

void discard_to_fundation() {
	cout << "Escolha uma opção de nipe da fundação." << endl << endl;
	cout << "(1) Copas" << endl;
	cout << "(2) Ouro" << endl;
	cout << "(3) Paus" << endl;
	cout << "(4) Espada" << endl;
	int option;
	cin >> option;

	if (option == 1) {
		discard_to_fundation_heart();
	} else if (option == 2) {
		discard_to_fundation_diamond();
	} else if (option == 3) {
		discard_to_fundation_club();
	} else if (option == 4) {
		discard_to_fundation_spade();
	} else {
		cout << endl << INVALID_CMD << endl;
	}
}

void discard_to_colunm(stack <card>* colunm) {
	if (!discard.empty()) {
		card c = discard.top();
		if (colunm->empty() && discard.top().value == 13) { // Se for um rei e a coluna tiver vazia, coloca			
			colunm->push(c);
		} else {
			stack<card> aux;
			card aux_card;
			for(int i = 0; i < 13; i++) {
				if(!colunm->top().is_valid) {
					aux_card = colunm->top();
					aux.push(aux_card);
					colunm->pop();
				}
			}
			// Ando nos espaços vazios até chegar num lugar com carta 
			
			if (c.value +1 == aux_card.value && suits_compatibles(c.suit, aux_card.suit)) {
				c.is_turned = false;
				colunm->push(c);
				discard.pop();							 
			}

			while (colunm->size() < 13) {
				aux_card = aux.top();
				colunm->push(aux_card);
				aux.pop();
			}	
		}
	}
}

void discard_to_colunm_options() {
	cout << "Para qual das colunas você deseja mover?" << endl;
	cout << "1" << endl;
	cout << "2" << endl;
	cout << "3" << endl;
	cout << "4" << endl;
	cout << "5" << endl;
	cout << "6" << endl;
	cout << "7" << endl;	

	int option;
	cin >> option;
	if (option == 1) {	
		discard_to_colunm(&col1);
	} else if(option == 2) {
		discard_to_colunm(&col2);
	} else if (option == 3) {
		discard_to_colunm(&col3);
	} else if (option == 4) {
		discard_to_colunm(&col4);
	} else if (option == 5) {
		discard_to_colunm(&col5);
	} else if (option == 6) {
		discard_to_colunm(&col6);
	} else if (option == 7) {
		discard_to_colunm(&col7);
	} else {
		cout << endl << INVALID_CMD << endl;
	}
}

void column_to_fundation(stack<card>* column) {
	if (!column->empty()) {
		stack<card> reserve;
		card aux;
		while (!column->top().is_valid && !column->empty()) {
			aux = column->top();
			reserve.push(aux);
			column->pop();
			if (column->top().is_turned == true) {
				column->top().is_turned = false;
			}
		}

		if (aux.suit.compare("C")) {
			if (fundation_heart.empty() && aux.value == 1) {
				fundation_heart.push(aux);
			} else {
				card top_fundation = fundation_heart.top();

				if (top_fundation.value == (aux.value+1)) {
					fundation_heart.push(aux);
				}
			}
		} else if (aux.suit.compare("P")) {
			if (fundation_club.empty() && aux.value == 1) {
				fundation_club.push(aux);
			} else {
				card top_fundation = fundation_club.top();

				if (top_fundation.value == (aux.value+1)) {
					fundation_club.push(aux);				
				}
			}

		} else if (aux.suit.compare("O")) {
			if (fundation_diamond.empty() && aux.value == 1) {
				fundation_diamond.push(aux);
			} else {
				card top_fundation = fundation_diamond.top();

				if (top_fundation.value == (aux.value+1)) {
					fundation_diamond.push(aux);
				}
			}

		} else if (aux.suit.compare("E")) {
			if (fundation_spade.empty() && aux.value == 1) {
				fundation_spade.push(aux);
			} else {
				card top_fundation = fundation_spade.top();

				if (top_fundation.value == (aux.value+1)) {
					fundation_spade.push(aux);
				}
			}
		}

		while (column->size() <= 13 && !reserve.empty()) {
			aux = reserve.top();
			column->push(aux);
			reserve.pop();
		}		
	}
}

void between_colunms(stack<card>* col_part, stack<card>* col_cheg, int qntd_cards) {
	if (qntd_cards > 0 && qntd_cards < 13) {
		stack<card> helper_column_part;
		card aux_part;
		for(int i = 0; i < 13; i++) {
			if(!col_part->top().is_valid && !col_part->top().is_turned) {
				aux_part = col_part->top();
				helper_column_part.push(aux_part);
				col_part->pop(); 
			}
		}

		stack<card> helper_column_cheg;
		card aux_cheg;
		for(int i = 0; i < 13; i++) {
			if(!col_cheg->top().is_valid && !col_part->top().is_turned) {
				aux_cheg = col_cheg->top();
				helper_column_cheg.push(aux_cheg);
				col_cheg->pop();
			}
		}	 
		
		stack<card> transfer_stack;
		card card_to_transfer;
		if(helper_column_part.size() <= qntd_cards) {
			for(int i = 0; i < qntd_cards; i++) {
				card_to_transfer = col_part->top();
				transfer_stack.push(card_to_transfer);
				col_part->pop();
			}
		}

		if (col_cheg->empty()) {
			if (transfer_stack.top().value == 13) {
				while (!transfer_stack.empty()) {
					card_to_transfer = transfer_stack.top();
					col_cheg->push(card_to_transfer);
				}
			}
		} else {
			if (col_cheg->top().value > transfer_stack.top().value && (suits_compatibles(col_cheg->top().suit, transfer_stack.top().suit))) {
				while (!transfer_stack.empty()) {
					card_to_transfer = transfer_stack.top();
					col_cheg->push(card_to_transfer);
				}
			}
		}
		while (col_part->size() < 13 && !helper_column_part.empty()) {
			aux_part = helper_column_part.top();
			col_part->push(aux_part);
			helper_column_part.pop();
		}

		while (col_cheg->size() < 13 && !helper_column_cheg.empty()) {
			aux_cheg = helper_column_cheg.top();
			col_cheg->push(aux_cheg);
			helper_column_cheg.pop();
		}		
	}
}

void fundation_options() {
	cout << "Escolha uma das fundações pelo nipe." << endl << endl;
	cout << "[C]opas" << endl;
	cout << "[P]aus" << endl;
	cout << "[O]uro" << endl;
	cout << "[E]spadas" << endl;
}

void column_to_fundation_option() {
	cout << "De qual das colunas você deseja mover?" << endl;
	cout << "1" << endl;
	cout << "2" << endl;
	cout << "3" << endl;
	cout << "4" << endl;
	cout << "5" << endl;
	cout << "6" << endl;
	cout << "7" << endl;	

	int option_col;
	cin >> option_col;

	fundation_options();

	if (option_col == 1) {	
		column_to_fundation(&col1);
	} else if(option_col == 2) {
		column_to_fundation(&col2);
	} else if (option_col == 3) {
		column_to_fundation(&col3);
	} else if (option_col == 4) {
		column_to_fundation(&col4);
	} else if (option_col == 5) {
		column_to_fundation(&col5);
	} else if (option_col == 6) {
		column_to_fundation(&col6);
	} else if (option_col == 7) {
		column_to_fundation(&col7);
	} else {
		cout << endl << INVALID_CMD << endl;
	}
}

void between_colunms_options() {
	cout << "Diga-nos qual a coluna de partida [Opções no intervalo fechado: 1-7]: " << endl;
	int col_part;
	cin >> col_part;

	cout << "Diga-nos qual a coluna de chegada [Opções no intervalo fechado: 1-7]: " << endl;
	int col_cheg;
	cin >> col_cheg;

	cout << "Diga-nos quantas cartas você deseja mover [Opções no intervalo fechado: 1-13]: " << endl;
	int qntd_cards;
	cin >> qntd_cards;

	if (col_part != col_cheg) {
		stack<card>* guard1;
		if (col_part == 1) {
			guard1 = &col1;
		} else if (col_part == 2) {
			guard1 = &col2;		
		} else if (col_part == 3) {
			guard1 = &col3;
		} else if (col_part == 4 ) {
			guard1 = &col4;
		} else if (col_part == 5) {
			guard1 = &col5;
		} else if (col_part == 6) {
			guard1 = &col6;
		} else if (col_part == 7) {
			guard1 = &col7;
		} else {
			cout << endl << INVALID_CMD << endl;
		}
	
		stack<card>* guard2;
		if (col_cheg == 1) {
			guard2 = &col1;
		} else if (col_cheg == 2) {
			guard2 = &col2;		
		} else if (col_cheg == 3) {
			guard2 = &col3;
		} else if (col_cheg == 4 ) {
			guard2 = &col4;
		} else if (col_cheg == 5) {
			guard2 = &col5;
		} else if (col_cheg == 6) {
			guard2 = &col6;
		} else if (col_cheg == 7) {
			guard2 = &col7;
		} else {
			cout << endl << INVALID_CMD << endl;
		}

		between_colunms(guard1, guard2, qntd_cards);
	}
}

void fundation_to_colunms(stack<card>* column, stack<card>* fundation) {
	if (!fundation->empty()) {
		card c = fundation->top();
		stack<card> helper;
		card aux;
		while (!column->top().is_valid && !column->empty()) {
			aux = column->top();
			helper.push(aux);
			column->pop();
		}

		if (c.value > aux.value && suits_compatibles(c.suit, aux.suit)) {
			column->push(c);
		}

		while (column->size() <= 13 && !helper.empty()) {
			aux = helper.top();
			column->push(aux);
			helper.pop();
		}
	}
}

void fundation_to_colunms_options() {
	fundation_options();
	string option;
	cin >> option;
	transform(option.begin(), option.end(), option.begin(), ::tolower);

	cout << "Escolha para qual coluna voce quer mover a carta" << endl;
	int col_result;
	cin >> col_result;

	stack<card>* guard;
	if (col_result == 1) {
		guard = &col1;
	} else if (col_result == 2) {
		guard = &col2;		
	} else if (col_result == 3) {
		guard = &col3;
	} else if (col_result == 4 ) {
		guard = &col4;
	} else if (col_result == 5) {
		guard = &col5;
	} else if (col_result == 6) {
		guard = &col6;
	} else if (col_result == 7) {
		guard = &col7;
	} else {
		cout << endl << INVALID_CMD << endl;
	}

	if (option.compare("c")) {
		fundation_to_colunms(guard,&fundation_heart);
	} else if (option.compare("p")) {
		fundation_to_colunms(guard,&fundation_club);
	} else if (option.compare("o")) {
		fundation_to_colunms(guard,&fundation_diamond);
	} else if (option.compare("e")) {
		fundation_to_colunms(guard,&fundation_spade);
	} 
}

void move_cards() {
		cout << "Escolha uma opcao de movimentacao:" << endl << endl;
		cout << "Opcao (1): mover do descarte para as fundacoes." << endl;
		cout << "Opcao (2): mover do descarte para coluna" << endl;
		cout << "Opcao (3): mover das colunas para as fundacoes." << endl;
		cout << "Opcao (4): mover entre colunas." << endl;
		cout << "Opcao (5): mover das fundacoes para colunas" << endl << endl;
		int option;
		
		cout << "Opcao: ";
		cin >>  option;
		cout << endl;
		
		if (option == 1) {
			discard_to_fundation();
		} else if(option == 2) {
			discard_to_colunm_options();
		} else if (option == 3) {			
			column_to_fundation_option();
		} else if (option == 4) {
			between_colunms_options();
		} else if (option == 5) {
			fundation_to_colunms_options();
		} else {
			cout << endl << INVALID_CMD << endl;
		}		 
}

void actual_state() {
	stack<card> aux1;
	stack<card> aux2;
	stack<card> aux3;
	stack<card> aux4;
	stack<card> aux5;
	stack<card> aux6;
	stack<card> aux7;

	for(int i = 0; i < 13; i++) {
		card c1 = col1.top();
		card c2 = col2.top();
		card c3 = col3.top();
		card c4 = col4.top();
		card c5 = col5.top();
		card c6 = col6.top();
		card c7 = col7.top();
		col1.pop();
		col2.pop();
		col3.pop();
		col4.pop();
		col5.pop();
		col6.pop();
		col7.pop();
		aux1.push(c1);
		aux2.push(c2);
		aux3.push(c3);
		aux4.push(c4);
		aux5.push(c5);
		aux6.push(c6);
		aux7.push(c7);
	}

	for(int i = 0; i < 13; i++) {
		int j = i+1;
		string col;
		if(j < 10) {
			col = "0" + to_string(j);
		} else {
			col = to_string(j);
		}
		card c1 = aux1.top();
		card c2 = aux2.top();
		card c3 = aux3.top();
		card c4 = aux4.top();
		card c5 = aux5.top();
		card c6 = aux6.top();
		card c7 = aux7.top();
		cout << "--" + col +"--  ["+toString(c1)+"] ["+toString(c2)+"] ["+toString(c3)+"] ["+toString(c4)+"] ["+toString(c5)+"] ["+toString(c6)+"] ["+toString(c7)+"]" << endl;
		aux1.pop();
		aux2.pop();
		aux3.pop();
		aux4.pop();
		aux5.pop();
		aux6.pop();
		aux7.pop();
		col1.push(c1);
		col2.push(c2);
		col3.push(c3);
		col4.push(c4);
		col5.push(c5);
		col6.push(c6);
		col7.push(c7);
	}
}

void update_discard() {
	card c;
	if (!discard.empty()) {
		c = discard.top();		
		c.is_turned = false;		
	}
	cout << "------  ["+ toString(c) + "] <=> Descarte                       " << endl;
};

void update_fundations() {
	card c, d, e, f;
	if (!fundation_heart.empty() && !fundation_club.empty() &&
		 !fundation_diamond.empty() && !fundation_spade.empty()) {
			 c = fundation_heart.top();
			 d = fundation_club.top();
			 e = fundation_diamond.top();
			 f = fundation_spade.top();			 			 
		 }
		 cout << "------  [" + toString(c) + "] ["+ toString(d) +"] ["+ toString(e) +"] ["+ toString(f) +"] <=> Fundacoes    " << endl << endl;
}

bool winner() {
	return fundation_club.empty() &&
	 	fundation_diamond.empty() &&
		  fundation_heart.empty() &&
		   fundation_spade.empty() &&
		   	stock.empty() && discard.empty();
}

void club_symbol() {
	cout << "     .-~~-." << endl;
	cout << "    {      }" << endl;
	cout << " .-~-.    .-~-." << endl;
	cout << "{              }" << endl;
	cout << " `.__.'||`.__.'" << endl;
	cout << "       ||" << endl;
	cout << "      '--`" << endl;
}

void menu() {
	bool update_stock = false;
	while(true) {	
		if (winner()) {
			cout << endl << "Parabens, voce venceu!" << endl << endl;
			club_symbol();	
			break;
		}

		cout << endl;	  		
		cout << "        --1-- --2-- --3-- --4-- --5-- --6-- --7--" << endl;
		if (update_stock) {
			cout << "------  [???] <=> ESTOQUE ATUALIZADO!            " << endl;
		} else {
			cout << "------  [???] <=> Estoque                        " << endl;
		}
		update_discard();
		cout << endl;
		actual_state();
		cout << endl;
		update_fundations();
		cout << "------   <C>   <P>   <O>   <E>" << endl;
		cout << "------   <O>   <A>   <U>   <S>" << endl;
		cout << "------   <P>   <U>   <R>   <P>" << endl;
		cout << "------   <A>   <S>   <O>   <A>" << endl;
		cout << "------   <S>   <->   <->   <D>" << endl;
		cout << "------   <->   <->   <->   <A>" << endl << endl;
		cout << "Escolha uma opcao:" << endl;
		cout << "Opcao (1): puxar uma carta do estoque." << endl;
		cout << "Opcao (2): mover uma carta." << endl;
		cout << "Opcao (qualquer outro digito): sair do jogo." << endl << endl;
		int option;
		
		cout << "Opcao: ";
		cin >>  option;
		cout << endl;
		
		if (option == 1) {
			update_stock = acess_stock(update_stock);
		} else if(option == 2) {
			move_cards();
		} else {
			cout << "Jogo encerrado." << endl;
			club_symbol();
			break;
		}
	}
}

int main() {
	build_deck();
	random_shuffle(deck.begin(), deck.end());
	build_stock();    
	build_columns();
	menu();		
	
	return 0;
}
