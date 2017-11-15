#include <iostream>
#include <stdlib.h>
#include <string>
#include <cstring>
using namespace std;

struct carta {
    string simbolo_numero;
    string naipe;
};

struct baralho {
    // <3
    carta copas[13];
    //  / \
    //   |
    carta espada[13];
    // /\
    // \/
    carta ouro[13];
    // _\|/_
    carta paus[13];
};

struct mesa {
	baralho baralho;

	carta fundo[24];
	carta cemiterio[24];
	// onde sera montado a sequencia com mesmo naipe
	carta naipe1[13];
	carta naipe2[13];
	carta naipe3[13];
	carta naipe4[13];

	// colunas onde ira montar a sequencia com naipes alternados
	carta coluna1[13];
	carta coluna2[13];
	carta coluna3[13];
	carta coluna4[13];
	carta coluna5[13];
	carta coluna6[13];
	carta coluna7[13];
};

int main() {
	return 0;
}
