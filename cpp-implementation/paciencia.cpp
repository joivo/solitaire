#include <iostream>
#include <stdlib.h>
#include <string>
#include <stack>
#include <algorithm>
#include <vector>
#include <iterator>

#define HEART "H" // Copas
#define CLUB "C" // Paus
#define DIAMOND "D" // Ouro
#define SPADE "S" // Espada

using namespace std;

struct card {
    int value;
    string suit;
    bool is_turned;
};

void assign_cards(string suit, vector <card>* cards) {
	card c;
	for (int i = 0; i < 13; i++)  {
		c.suit = suit;
		c.value = (i+1);
		c.is_turned = false;
		cards->push_back(c);
	}		
}

void build_deck(vector<card>* cards) {
	assign_cards(HEART, cards); 
	assign_cards(CLUB, cards);
	assign_cards(DIAMOND, cards);
	assign_cards(SPADE, cards);
}

void build_stock(stack<card>* stock, vector<card>* deck) {
	for (int i = 0; i < 24; i++) {
		stock->push(deck->data()[i]);
		deck->erase(deck->begin() + i);
	}	
}

// Movimentos possiveis

void replace_stock(stack<card>* stock, stack<card>* discard) {
  for (int i = 0; i < discard->size(); i++) {
    card c = discard->top();
    discard->pop();
    stock->push(c);
  }
}

// Vai fundo e coloca no montante de descarte 
card acess_stock(stack<card>* stock, stack<card>* discard) {
	card c;
	if (!stock->empty()) {	
		c = stock->top();
		stock->pop();	
		discard->push(c);
	} else {
    if (!discard->empty()) {
      replace_stock(stock, discard);
    }
  }
	return c;
}



/* Inserir numa fundacao especifica (fundacao eh o nome dado aos
 * montantes de despejo (ha 4, um para cada nipe);
 */
void insert_in_fundation(card c, stack<card>* fundation) {
	if (!fundation->empty()) {
			card temp = fundation->top();
		if (temp.value < c.value && temp.suit.compare(c.suit)) {
				fundation->push(c);
		}
	}
}

struct table {
	card fundo[24];
	card cemiterio[24];
	// onde sera montado a sequencia com mesmo naipe
	card naipe1[13];
	card naipe2[13];
	card naipe3[13];
	card naipe4[13];

	// colunas onde ira montar a sequencia com naipes alternados
	card coluna1[13];
	card coluna2[13];
	card coluna3[13];
	card coluna4[13];
	card coluna5[13];
	card coluna6[13];
	card coluna7[13];
};

void move_cards() {
		cout << "Escolha uma opcao de movimentacao:" << endl << endl;
		cout << "Opcao (1): mover do descarte para as pilhas." << endl;
		cout << "Opcao (2): mover do descarte para as fundacoes." << endl;
		cout << "Opcao (3): mover entre pilhas." << endl;
		cout << "Opcao (4): mover das pilhas para as fundacoes." << endl;
		cout << "Opcao (5): mover das fundacoes para as pilhas." << endl << endl;
		int opcao;
		
		cout << "Opcao: ";
		cin >>  opcao;
		cout << endl;
		
		if (opcao == 1) {
			// discard_to_stack();
		} else if(opcao == 2) {
			// discard_to_fundation();
		} else if (opcao == 3) {
			// stack_to_stack()
		} else if (opcao == 4) {
			// stack_to_fundation()
		} else if (opcao == 5) {
			// fundation_to_stack()
		}		 
}

void menu() {
	
	while(true) {
		cout << endl;	  
		cout << "       --1-- --2-- --3-- --4-- --5-- --6-- --7--" << endl;
		cout << "-----  [???] <=> Estoque                        " << endl;
		cout << "-----  [---] <=> Descarte           " << endl;
		cout << endl;
		cout << "--1--  [---] [---] [---] [---] [---] [---] [---]" << endl;
		cout << "--2--  [---] [---] [---] [---] [---] [---] [---]" << endl;
		cout << "--3--  [---] [---] [---] [---] [---] [---] [---]" << endl;
		cout << "--4--  [---] [---] [---] [---] [---] [---] [---]" << endl;
		cout << "--5--  [---] [---] [---] [---] [---] [---] [---]" << endl;
		cout << "--6--  [---] [---] [---] [---] [---] [---] [---]" << endl;
		cout << "--7--  [---] [---] [---] [---] [---] [---] [---]" << endl;
		cout << "--8--  [---] [---] [---] [---] [---] [---] [---]" << endl;
		cout << "--9--  [---] [---] [---] [---] [---] [---] [---]" << endl;
		cout << "--10-  [---] [---] [---] [---] [---] [---] [---]" << endl;
		cout << "--11-  [---] [---] [---] [---] [---] [---] [---]" << endl;
		cout << "--12-  [---] [---] [---] [---] [---] [---] [---]" << endl;
		cout << "--13-  [---] [---] [---] [---] [---] [---] [---]" << endl << endl;
		cout << "--14-  [---] [---] [---] [---] <=> Fundacoes    " << endl << endl;
		cout << "Escolha uma opcao:" << endl;
		cout << "Opcao (1): puxar uma carta do estoque." << endl;
		cout << "Opcao (2): mover uma carta." << endl;
		cout << "Opcao (3): sair do jogo." << endl << endl;
		int opcao;
		
		cout << "Opcao: ";
		cin >>  opcao;
		cout << endl;
		
		if (opcao == 1) {
			// access_stock();
		} else if(opcao == 2) {
			move_cards();
		} else if (opcao == 3) {
			cout << endl << "Jogo encerrado." << endl << endl;
			break;
		} else {
			cout << endl << "Opcao invalida" << endl << endl;
		}
	}
	

}

int main() {
	menu();
	vector<card> deck;	
	
	// Cria o baralho com 52 cartas e distribui os nipes e valores
	build_deck(&deck);
	
	// Embaralha as cartas
	random_shuffle(deck.begin(), deck.end());	
	
	stack<card> stock; 
	
	// Cria o 'fundo', apos buildar o fundo,
	// o deck de cartas ficará apenas com 28 elementos
	build_stock(&stock, &deck);

  // Campo onde o 'fundo' vai interagir
	stack<card> discard;			
		
	// TODO
	// distribuir 28 para as colunas (que sao 7)	
	
	return 0;
}
