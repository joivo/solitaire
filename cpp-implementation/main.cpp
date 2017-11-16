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

// Vai fundo e coloca no montante de descarte 
card acess_stock(stack<card>* stock, stack<card>* discard) {
	card c;
	if (!stock->empty()) {	
		c = stock->top();
		stock->pop();
	
		discard->push(c);
	}
	return c;
}

// Inserir numa fundacao especifica (fundacao eh o nome dado aos
// montantes de despejo (ha 4, um para cada nipe);
void insert_in_fundation(card c, stack<card>* fundation) {
	if (!fundation->empty()) {
				card temp = fundation->top();
		if (temp->value < c->value && temp->suit.compare(c->suit)) {
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

int main() {
	
	vector<card> c;	
	
	// Cria o baralho com 52 cartas e distribui os nipes e valores
	build_deck(&c);
	
	// Embaralha as cartas
	random_shuffle(c.begin(), c.end());	
	
	stack<card> stock; 
	
	// Cria o 'fundo', apos buildar o fundo,
	// o deck de cartas ficará apenas com 28 elementos
	build_stock(&stock, &c);

	stack<card> discard;			
		
	// TODO
	// distribuir 28 para as colunas (que sao 7)	
	
	return 0;
}
