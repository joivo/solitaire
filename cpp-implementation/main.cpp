#include <stdio.h>
#include <iostream>
#include <string>
#include <string.h>
using namespace std;

/*

	Quando for ler saiba: 

	- Existe três estruturas principais que representam o topo, 
		o tabuleiro e a lista de fundação
	- Há muita função repetida, vide as de converter os valores especiais da carta e do naipe
		--> podem ser refatoradas para virarem funções e ficar algo mais bonitinho
	- O jogo se inicia lendo as cartas (solitaire.txt) e jogando ela no sistema
	- Estuda um fluxo que tu vai entender todo o código

	- SIGA UM FLUXO 

	SUMARIO: 
	strcmp = comparação de strings
	strcpy = copia de string
	atoi = calcula o valor numerico de uma string

*/

struct topNode{													// doubly list
	char color[6];
	char suit[6];
	char symbol[6];
	char turned[6];
	topNode *next;
	topNode *prev;
	topNode *bottom;
}; topNode *headtop = NULL;										//global headtop

struct boardNode{												//multilist
	char color[6];
	char suit[6];
	char symbol[6];
	char turned[6];
	char list[6];
	int listnumber;
	boardNode *next;
	boardNode *bottom;
};	boardNode *headboard = NULL;								//global headboard

struct foundationNode{											//multilist
	char color[6];
	char suit[6];
	char symbol[6];
	char turned[6];
	char suits[10];
	foundationNode *next;
	foundationNode *bottom;
};	foundationNode *headfoundation = NULL;						//global headfoundation

//conta as cartas que estao na fundação, qnd chegar a 52 o jogo foi vencido
int countfoundation = 0;												//global counter(number of cards at foundationlist)

void addTopNode(char *color, char *type, char *value, char *sideDown);
void addBoardNode(char *color, char *type, char *value, char *sideDown, int order);
void addHeadBoardNode(int i);
void addHeaderFoundationNode(char *type);
void printElementAtTopNode();
void printElementAtBoardNode();
void printElementAtFoundationNode();
void readFromFile();
bool topToFoundation(char *, char *, char *);
bool addFoundationNodeFromTop(topNode *toAdd);
bool addBoardNodeFromTop(topNode *toAdd, int d);
bool topToBoard(char *a, char *b, char *c, int d);
bool boardToBoard(char *a, char *b, char *c, int d, int e);
bool addBoardToBoard(boardNode *toAdd, int e);
bool boardToFoundation(int d);
void deleteAll();

int main()
{
	readFromFile();
	char a[2], b[2], c[2];
	int column, column2;
	char choice;
	do{
		cout << endl << "Escolha uma Operação:" << endl;
		cout << "	1.Selecione da lista do Topo para a lista da Fundação" << endl;
		cout << "	2.Selecione da lista do Topo para o Tabuleiro" << endl;
		cout << "	3.Mover cartas no tabuleiro" << endl;
		cout << "	4.Mover do Tabuleiro para a Fundação" << endl;
		cout << "	Por favor, escolha uma das opções(1, 2, 3, or 4):"; cin >> choice;
		switch (choice)
		{
		case '1':
			cout << "	Selecione uma carta do Topo :"; scanf("%s %s %s", &a, &b, &c);
			if (topToFoundation(a, b, c) == false)
			{
				cout << "	Movimento Inválido" << endl;
				cout << "**********************************" << endl;
				printElementAtTopNode();
				printElementAtBoardNode();
				printElementAtFoundationNode();

				break;
			}
			printElementAtTopNode();
			printElementAtBoardNode();
			printElementAtFoundationNode();

			break;
		case '2':
			cout << "	Selecione uma carta do Topo :"; scanf("%s %s %s", &a, &b, &c);
			cout << "	Selecione o numero da coluna de destino do Tabuleiro:"; cin >> column;
			if (topToBoard(a, b, c, column) == false)
			{
				cout << "	Movimento Inválido" << endl;
				cout << "**********************************" << endl;
				printElementAtTopNode();
				printElementAtBoardNode();
				printElementAtFoundationNode();

				break;
			}
			printElementAtTopNode();
			printElementAtBoardNode();
			printElementAtFoundationNode();

			break;
		case '3':
			cout << "	Selecione o número da coluna inicial:"; cin >> column;
			cout << "	Selecione o número da coluna de destino :"; cin >> column2;
			cout << "	Selecione a carta da coluna inicial (Cor Tipo Valor):"; scanf("%s %s %s", &a, &b, &c);

			if (boardToBoard(a, b, c, column, column2) == false)
			{
				cout << "	Movimento Inválido" << endl;
				cout << "**********************************" << endl;
				printElementAtTopNode();
				printElementAtBoardNode();
				printElementAtFoundationNode();

				break;
			}
			printElementAtTopNode();
			printElementAtBoardNode();
			printElementAtFoundationNode();

			break;
		case '4':
			cout << "	Selecione o numero da coluna inicial:"; cin >> column;
			if (boardToFoundation(column) == false)
			{
				cout << "	Movimento Inválido" << endl;
				cout << "**********************************" << endl;
				printElementAtTopNode();
				printElementAtBoardNode();
				printElementAtFoundationNode();

				break;
		default:
			cout << "Escolha entre 1-4!" << endl;
			}
			printElementAtTopNode();
			printElementAtBoardNode();
			printElementAtFoundationNode();

			break;

		}
	} while (countfoundation != 52);								//congrats when foundation node has 52 cards

	cout << "     .-~~-." << endl;
	cout << "    {      }" << endl;
	cout << " .-~-.    .-~-." << endl;
	cout << "{              }" << endl;
	cout << " `.__.'||`.__.'" << endl;
	cout << "       ||" << endl;
	cout << "      '--`" << endl;
	cout << "PARABAINS VOCE WIN!" << endl;
	cin >> column;
	deleteAll();								// deallocate memory
	return 0;


}

void addTopNode(char *color, char *type, char *value, char *sideDown)			//add function to doubly list
{
	topNode *temp = new topNode;
	strcpy(temp->color, color);
	strcpy(temp->suit, type);
	strcpy(temp->symbol, value);
	strcpy(temp->turned, sideDown);
	temp->next = NULL;
	temp->prev = NULL;
	temp->bottom = NULL;
	if (headtop == NULL)
	{
		headtop = temp;
		return;
	}
	topNode *traverse = headtop;
	while (traverse->next != NULL)
		traverse = traverse->next;
	traverse->next = temp;
	temp->prev = traverse;
}

bool addFoundationNodeFromTop(topNode *toAdd)				// top to foundation add
{
	char value[6];
	int say = 1;
	//converte as cartas "especiais" para valor de 1 a 13
	if (strcmp(toAdd->symbol, "A") == 0)					// converts sysbols to number in order to easy check
		strcpy(value, "1");
	else if (strcmp(toAdd->symbol, "J") == 0)
		strcpy(value, "11");
	else if (strcmp(toAdd->symbol, "Q") == 0)
		strcpy(value, "12");
	else if (strcmp(toAdd->symbol, "K") == 0)
		strcpy(value, "13");
	else
		strcpy(value, toAdd->symbol);
	int asagiilerle = atoi(value);
	int sagailerle;

	//converte o valor dos naipes para valor numero
	if (strcmp(toAdd->suit, "S") == 0)
		sagailerle = 1;
	else if (strcmp(toAdd->suit, "H") == 0)
		sagailerle = 2;
	else if (strcmp(toAdd->suit, "D") == 0)
		sagailerle = 3;
	else if (strcmp(toAdd->suit, "C") == 0)
		sagailerle = 4;

	foundationNode *traverse = headfoundation;							//finds list

	for (int i = 1; i < sagailerle; i++)
		traverse = traverse->next;

	foundationNode *traversesideDown = traverse;

	while (traversesideDown->bottom != NULL)
	{
		traversesideDown = traversesideDown->bottom;
		say++;
	}
	if (say != asagiilerle) return false;								//if card number isnt equal with row order return false

	//faz update na nova carta
	foundationNode *temp = new foundationNode;							//add last node
	strcpy(temp->suit, toAdd->suit);
	strcpy(temp->color, toAdd->color);
	strcpy(temp->symbol, toAdd->symbol);
	temp->next = NULL;
	temp->bottom = NULL;
	traversesideDown->bottom = temp;
	return true;
}

bool addFoundationNodeFromBoard(boardNode *toAdd)				// BOARD to foundation add
{
	char value[6];
	int say = 1;
	if (strcmp(toAdd->symbol, "A") == 0)					// converts sysbols to number in order to easy check
		strcpy(value, "1");
	else if (strcmp(toAdd->symbol, "J") == 0)
		strcpy(value, "11");
	else if (strcmp(toAdd->symbol, "Q") == 0)
		strcpy(value, "12");
	else if (strcmp(toAdd->symbol, "K") == 0)
		strcpy(value, "13");
	else
		strcpy(value, toAdd->symbol);
	int asagiilerle = atoi(value);
	int sagailerle;

	if (strcmp(toAdd->suit, "S") == 0)							//in order to track list
		sagailerle = 1;
	else if (strcmp(toAdd->suit, "H") == 0)
		sagailerle = 2;
	else if (strcmp(toAdd->suit, "D") == 0)
		sagailerle = 3;
	else if (strcmp(toAdd->suit, "C") == 0)
		sagailerle = 4;

	foundationNode *traverse = headfoundation;

	for (int i = 1; i < sagailerle; i++)						//find list
		traverse = traverse->next;

	foundationNode *traversesideDown = traverse;

	while (traversesideDown->bottom != NULL)
	{
		traversesideDown = traversesideDown->bottom;
		say++;
	}
	if (say != asagiilerle) return false;						//if card number isnt equal with row order return false

	foundationNode *temp = new foundationNode;					//add last node
	strcpy(temp->suit, toAdd->suit);
	strcpy(temp->color, toAdd->color);
	strcpy(temp->symbol, toAdd->symbol);
	temp->next = NULL;
	temp->bottom = NULL;
	traversesideDown->bottom = temp;
	return true;
}
bool addBoardNodeFromTop(topNode *toAdd, int d)            // top to board add
{
	char value[6];
	char value2[6];
	int say = 1;
	if (strcmp(toAdd->symbol, "A") == 0)
		strcpy(value, "1");
	else if (strcmp(toAdd->symbol, "J") == 0)
		strcpy(value, "11");
	else if (strcmp(toAdd->symbol, "Q") == 0)
		strcpy(value, "12");
	else if (strcmp(toAdd->symbol, "K") == 0)
		strcpy(value, "13");
	else
		strcpy(value, toAdd->symbol);
	int toAddvaluei = atoi(value);

	boardNode *traverse = headboard;

	for (int i = 1; i < d; i++)										//find list
		traverse = traverse->next;

	boardNode *traversesideDown = traverse;
	while (traversesideDown->bottom != NULL)							//find last node
		traversesideDown = traversesideDown->bottom;
	if (strcmp(traversesideDown->symbol, "A") == 0)
		strcpy(value2, "1");
	else if (strcmp(traversesideDown->symbol, "J") == 0)
		strcpy(value2, "11");
	else if (strcmp(traversesideDown->symbol, "Q") == 0)
		strcpy(value2, "12");
	else if (strcmp(traversesideDown->symbol, "K") == 0)
		strcpy(value2, "13");
	else
		strcpy(value2, traversesideDown->symbol);
	int kartvaluei = atoi(value2);

	if (traverse->bottom == NULL && toAddvaluei == 13)
	{
		boardNode *temp = new boardNode;
		strcpy(temp->suit, toAdd->suit);
		strcpy(temp->color, toAdd->color);
		strcpy(temp->symbol, toAdd->symbol);
		strcpy(temp->turned, "Up");
		temp->next = NULL;
		temp->bottom = NULL;
		traverse->bottom = temp;
		return true;
	}
	else if (traverse->bottom == NULL && toAddvaluei != 13)		
		return false;
	

	if (!(kartvaluei == toAddvaluei + 1))								//card must 1 less from upper card and different color
		return false;
	
	if (!(strcmp(toAdd->color,traversesideDown->color)!=0))
	{
		return false;
	}

	boardNode *temp = new boardNode;
	strcpy(temp->suit, toAdd->suit);
	strcpy(temp->color, toAdd->color);
	strcpy(temp->symbol, toAdd->symbol);
	strcpy(temp->turned, "Up");
	temp->next = NULL;
	temp->bottom = NULL;
	traversesideDown->bottom = temp;
	return true;


}
bool addBoardToBoard(boardNode *toAdd, int e)
{
	char value[6];
	char value2[6];
	int say = 1;
	if (strcmp(toAdd->symbol, "A") == 0)							// converts sysbols to number in order to easy check
		strcpy(value, "1");
	else if (strcmp(toAdd->symbol, "J") == 0)
		strcpy(value, "11");
	else if (strcmp(toAdd->symbol, "Q") == 0)
		strcpy(value, "12");
	else if (strcmp(toAdd->symbol, "K") == 0)
		strcpy(value, "13");
	else
		strcpy(value, toAdd->symbol);
	int toAddvaluei = atoi(value);

	boardNode *traverse = headboard;

	for (int i = 1; i < e; i++)										//finds the list
		traverse = traverse->next;

	boardNode *traversesideDown = traverse;
	while (traversesideDown->bottom != NULL)							//finds the card
		traversesideDown = traversesideDown->bottom;

	if (traverse->bottom == NULL && toAddvaluei == 13)			//if list is empty you can add King
	{
		boardNode *temp = new boardNode;
		strcpy(temp->suit, toAdd->suit);
		strcpy(temp->color, toAdd->color);
		strcpy(temp->symbol, toAdd->symbol);
		strcpy(temp->turned, "Up");
		temp->next = NULL;
		temp->bottom = toAdd->bottom;
		traversesideDown->bottom = temp;
		return true;
	}
	else if (traverse->bottom == NULL && toAddvaluei != 13)			//yeni toAddndi.  if list is empty you cannot add other than king 
		return false;

	if (strcmp(traversesideDown->symbol, "A") == 0)							// converts sysbols to number in order to easy check
		strcpy(value2, "1");
	else if (strcmp(traversesideDown->symbol, "J") == 0)
		strcpy(value2, "11");
	else if (strcmp(traversesideDown->symbol, "Q") == 0)
		strcpy(value2, "12");
	else if (strcmp(traversesideDown->symbol, "K") == 0)
		strcpy(value2, "13");
	else
		strcpy(value2, traversesideDown->symbol);						
	int kartvaluei = atoi(value2);

	if (!(kartvaluei == toAddvaluei + 1))								//card must 1 less from upper card and different color
		return false;

	if (!(strcmp(toAdd->color, traversesideDown->color) != 0))
	{
		return false;
	}

	boardNode *temp = new boardNode;						//add last node
	strcpy(temp->suit, toAdd->suit);
	strcpy(temp->color, toAdd->color);
	strcpy(temp->symbol, toAdd->symbol);
	strcpy(temp->turned, "Up");
	temp->next = NULL;
	temp->bottom = toAdd->bottom;
	traversesideDown->bottom = temp;
	return true;


}

void addBoardNode(char *color, char *type, char *value, char *sideDown, int order)	 //file to board multilist
{
	boardNode *temp = new boardNode;
	strcpy(temp->color, color);
	strcpy(temp->suit, type);
	strcpy(temp->symbol, value);
	strcpy(temp->turned, sideDown);
	temp->next = NULL;
	temp->bottom = NULL;
	int goforward;
	boardNode *traverseforward = headboard;
	for (goforward = 1; goforward < order; goforward++)
		traverseforward = traverseforward->next;
	boardNode *traversesideDown = traverseforward;
	while (traversesideDown->bottom != NULL)
		traversesideDown = traversesideDown->bottom;
	traversesideDown->bottom = temp;
}
void addHeadBoardNode(int i)
{
	boardNode *temp = new boardNode;
	temp->listnumber = i;
	strcpy(temp->list, ". list");
	temp->next = NULL;
	temp->bottom = NULL;
	if (headboard == NULL)
	{
		headboard = temp;
		return;
	}
	boardNode *traverse = headboard;
	while (traverse->next != NULL)
		traverse = traverse->next;
	traverse->next = temp;
}
void addHeaderFoundationNode(char *type)
{
	foundationNode *temp = new foundationNode;
	strcpy(temp->suits, type);
	temp->next = NULL;
	temp->bottom = NULL;
	if (headfoundation == NULL)
	{
		headfoundation = temp;
		return;
	}
	foundationNode *traverse = headfoundation;
	while (traverse->next != NULL)
		traverse = traverse->next;
	traverse->next = temp;
}
void printElementAtTopNode()									// list top node
{
	topNode *traverse = headtop->next;
	cout << endl << "Lista de Cartas do Topo" << endl;
	while (traverse->next != NULL)
	{

		cout << traverse->color << "," << traverse->suit << "," << traverse->symbol << "|";
		traverse = traverse->next;
	}
	cout << endl;
}
void printElementAtBoardNode()
{
	boardNode *traverse[7];						//7 traverse pointers for 7 lists
	boardNode *assign = headboard;
	int i = 0;
	while (assign != NULL)
	{
		traverse[i] = assign->bottom;
		assign = assign->next;
		i++;
	}
	cout << endl << "Tabuleiro" << endl;
	cout << "1.Coluna   2.Coluna   3.Coluna   4.Coluna   5.Coluna   6.Coluna   7.Coluna" << endl;
	for (int i = 1; i < 14; i++)
	{
		if (traverse[0] == NULL &&traverse[1] == NULL &&traverse[2] == NULL &&traverse[3] == NULL &&traverse[4] == NULL &&traverse[5] == NULL &&traverse[6] == NULL)
			break;
		if (traverse[0] != NULL)
		{
			if (strcmp(traverse[0]->turned, "Up") == 0)
				cout << traverse[0]->color << "," << traverse[0]->suit << "," << traverse[0]->symbol << "    ";
			else cout << "X         ";
			traverse[0] = traverse[0]->bottom;

		}
		else{ cout << "         "; }
		if (traverse[1] != NULL)
		{
			if (strcmp(traverse[1]->turned, "Up") == 0)
				cout <<  traverse[1]->color << "," << traverse[1]->suit << "," << traverse[1]->symbol << "    ";
			else cout << "X        ";
			traverse[1] = traverse[1]->bottom;
		}
		else{ cout << "         "; }
		if (traverse[2] != NULL)
		{
			if (strcmp(traverse[2]->turned, "Up") == 0)
				cout << traverse[2]->color << "," << traverse[2]->suit << "," << traverse[2]->symbol << "    ";
			else cout << "X        ";
			traverse[2] = traverse[2]->bottom;
		}
		else{ cout << "         "; }
		if (traverse[3] != NULL)
		{
			if (strcmp(traverse[3]->turned, "Up") == 0)
				cout << traverse[3]->color << "," << traverse[3]->suit << "," << traverse[3]->symbol << "    ";
			else cout << "X        ";
			traverse[3] = traverse[3]->bottom;
		}
		else{ cout << "         "; }
		if (traverse[4] != NULL)
		{
			if (strcmp(traverse[4]->turned, "Up") == 0)
				cout << traverse[4]->color << "," << traverse[4]->suit << "," << traverse[4]->symbol << "    ";
			else cout << "X        ";
			traverse[4] = traverse[4]->bottom;
		}
		else{ cout << "         "; }
		if (traverse[5] != NULL)
		{
			if (strcmp(traverse[5]->turned, "Up") == 0)
				cout << traverse[5]->color << "," << traverse[5]->suit << "," << traverse[5]->symbol << "    ";
			else cout << "X        ";
			traverse[5] = traverse[5]->bottom;
		}
		else{ cout << "         "; }
		if (traverse[6] != NULL)
		{
			if (strcmp(traverse[6]->turned, "Up") == 0)
				cout << traverse[6]->color << "," << traverse[6]->suit << "," << traverse[6]->symbol;
			else cout << "X        ";
			traverse[6] = traverse[6]->bottom;
		}
		else{ cout << "         "; }
		cout << endl;

	}

}

void printElementAtFoundationNode()
{
	foundationNode *traverse[4];					//4 traverse pointers for 4 list
	foundationNode *assign = headfoundation;
	int i = 0;
	while (assign != NULL)
	{
		traverse[i] = assign->bottom;
		assign = assign->next;
		i++;
	}
	cout << endl << "Lista de Fundação" << endl;
	cout << "Spades   Hearts   Diamonds  Clubs" << endl;
	for (int i = 1; i < 14; i++)
	{
		if (traverse[0] == NULL &&traverse[1] == NULL &&traverse[2] == NULL &&traverse[3] == NULL)
			break;

		if (traverse[0] != NULL)
		{
			cout << traverse[0]->color << "," << traverse[0]->suit << "," << traverse[0]->symbol << "    ";
			traverse[0] = traverse[0]->bottom;
		}
		else{ cout << "         "; }
		if (traverse[1] != NULL)
		{
			cout << traverse[1]->color << "," << traverse[1]->suit << "," << traverse[1]->symbol << "    ";
			traverse[1] = traverse[1]->bottom;
		}
		else{ cout << "         "; }
		if (traverse[2] != NULL)
		{
			cout << traverse[2]->color << "," << traverse[2]->suit << "," << traverse[2]->symbol << "    ";
			traverse[2] = traverse[2]->bottom;
		}
		else{ cout << "         "; }
		if (traverse[3] != NULL)
		{
			cout << traverse[3]->color << "," << traverse[3]->suit << "," << traverse[3]->symbol;
			traverse[3] = traverse[3]->bottom;
		}
		else{ cout << "         "; }
		cout << endl;
	}

}
void readFromFile()
{
	char a[6], b[6], c[6], d[6], star[10];								// ex: D S A sideDown ****

	FILE *txtFile;
	txtFile = fopen("solitaire.txt", "r");
	addTopNode("A", "A", "A", "A");										//topNode head starts with A A A A but never shown in console
	for (int i = 0; i < 24; i++)
	{
		fscanf(txtFile, "%s %s %s %s", a, b, c, d);
		addTopNode(a, b, c, d);											//add from file to top list
	}
	addTopNode("Z", "Z", "Z", "Z");
	fscanf(txtFile, "%s", star);											//skip stars

	addHeadBoardNode(1);												//boardlist starts with numbers but never shown in console
	for (int i = 0; i < 1; i++)
	{
		fscanf(txtFile, "%s %s %s %s", a, b, c, d);						//1. list from file to top list
		addBoardNode(a, b, c, d, 1);
	}
	fscanf(txtFile, "%s", star);

	addHeadBoardNode(2);
	for (int i = 0; i < 2; i++)
	{
		fscanf(txtFile, "%s %s %s %s", a, b, c, d);						//2. list from file to top list
		addBoardNode(a, b, c, d, 2);
	}
	fscanf(txtFile, "%s", star);

	addHeadBoardNode(3);
	for (int i = 0; i < 3; i++)
	{
		fscanf(txtFile, "%s %s %s %s", a, b, c, d);						//3. list from file to top list
		addBoardNode(a, b, c, d, 3);
	}
	fscanf(txtFile, "%s", star);

	addHeadBoardNode(4);
	for (int i = 0; i < 4; i++)
	{
		fscanf(txtFile, "%s %s %s %s", a, b, c, d);						//4. list from file to top list
		addBoardNode(a, b, c, d, 4);
	}
	fscanf(txtFile, "%s", star);

	addHeadBoardNode(5);
	for (int i = 0; i < 5; i++)
	{
		fscanf(txtFile, "%s %s %s %s", a, b, c, d);						//5. list from file to top list
		addBoardNode(a, b, c, d, 5);
	}
	fscanf(txtFile, "%s", star);

	addHeadBoardNode(6);
	for (int i = 0; i < 6; i++)
	{
		fscanf(txtFile, "%s %s %s %s", a, b, c, d);						//6. list from file to top list
		addBoardNode(a, b, c, d, 6);
	}
	fscanf(txtFile, "%s", star);

	addHeadBoardNode(7);
	for (int i = 0; i < 7; i++)
	{
		fscanf(txtFile, "%s %s %s %s", a, b, c, d);						//7. list from file to top list
		addBoardNode(a, b, c, d, 7);
	}
	addHeaderFoundationNode("Spades");									//foundations node starts with Symbols never shown in console
	addHeaderFoundationNode("Hearts");
	addHeaderFoundationNode("Diamonds");
	addHeaderFoundationNode("Clubs");

	fclose(txtFile);
	printElementAtTopNode();
	printElementAtBoardNode();
	printElementAtFoundationNode();
}
bool topToFoundation(char *a, char *b, char *c)
{
	bool gonder = false;
	topNode *traverse = headtop;
	while (traverse != NULL)								//checks the card
	{
		if (strcmp(traverse->color, a) == 0 && strcmp(traverse->suit, b) == 0 && strcmp(traverse->symbol, c) == 0)
		{
			gonder = true;
			break;
		}
		traverse = traverse->next;
	}
	if (gonder == true)										// if card on the top list send
	{
		if (addFoundationNodeFromTop(traverse) == false)			//if not appropriate card return false
			return false;
		traverse->prev->next = traverse->next;				//break nodes
		traverse->next->prev = traverse->prev;
		cout << "Movimento Perfeito !" << endl;
		cout << "***************************" << endl;
		countfoundation++;

	}
	else                                                    //if card not on the top list return false
		return false;
	return true;
}
bool topToBoard(char *a, char *b, char *c, int d)
{
	bool gonder = false;
	topNode *traverse = headtop;
	while (traverse != NULL)
	{
		if (strcmp(traverse->color, a) == 0 && strcmp(traverse->suit, b) == 0 && strcmp(traverse->symbol, c) == 0)
		{
			gonder = true;
			break;
		}
		traverse = traverse->next;
	}
	if (gonder == true)
	{
		if (addBoardNodeFromTop(traverse, d) == false)
			return false;
		traverse->prev->next = traverse->next;
		traverse->next->prev = traverse->prev;
		cout << "Movimento Perfeito !" << endl;
		cout << "***************************" << endl;

	}
	else
		return false;
	return true;
}
bool boardToBoard(char *a, char *b, char *c, int d, int e)
{
	bool gonder = false;
	boardNode *traverse = headboard;
	boardNode *traverse2 = headboard;					//never used
	boardNode *traversebottom;
	boardNode *traversebottom2;							//never used
	boardNode *tut = headboard;
	for (int i = 1; i < d; i++)							//finds the list
		traverse = traverse->next;
	for (int i = 1; i < e; i++)
		traverse2 = traverse2->next;

	traversebottom = traverse->bottom;
	tut = traverse;							// traversin �ncesini tutar
	while (traversebottom != NULL)			//finds the card and checks
	{
		if (strcmp(traversebottom->color, a) == 0 && strcmp(traversebottom->suit, b) == 0 && strcmp(traversebottom->symbol, c) == 0)
		{
			gonder = true;
			break;
		}
		traversebottom = traversebottom->bottom;
		tut = tut->bottom;
	}
	if (gonder == true)
	{
		if (addBoardToBoard(traversebottom, e) == false)	//checks if appropriate card if true breaks node
			return false;
		tut->bottom = NULL;									// prev node =NULL
		strcpy(tut->turned, "Up");							// prev node =Up
		cout << "Movimento Perfeito !" << endl;
		cout << "***************************" << endl;
	}
	else
		return false;
	return true;
}
bool boardToFoundation(int d)
{
	bool gonder = false;
	boardNode *traverse = headboard;
	for (int i = 1; i < d; i++)						//finds column
		traverse = traverse->next;
	boardNode *traversebottom;
	traversebottom = traverse->bottom;
	boardNode *tut = traverse;
	if (traversebottom == NULL)						//if list is empty return false
		return false;
	while (traversebottom->bottom != NULL)			//finds the last card
	{
		traversebottom = traversebottom->bottom;
		tut = tut->bottom;
	}

	gonder = true;
	if (gonder == true)
	{
		if (addFoundationNodeFromBoard(traversebottom) == false)	// check if appropriate card and breaks node
			return false;
		tut->bottom = NULL;									//prev node->bottom NULL
		strcpy(tut->turned, "Up");							//prev node = Up
		cout << "Movimento Perfeito !" << endl;
		countfoundation++;
		cout << "***************************" << endl;
	}
	else
		return false;
	return true;
}


void deleteAll()
{
		foundationNode *traverse[4],*sil[4];					//4 traverse pointers for 4 list
		foundationNode *assign = headfoundation;
		int i = 0;
		while (assign != NULL)
		{
			traverse[i] = assign->bottom;
			assign = assign->next;
			i++;
		}
		for (int i = 1; i < 14; i++)
		{
			if (traverse[0] == NULL &&traverse[1] == NULL &&traverse[2] == NULL &&traverse[3] == NULL)
				break;

			if (traverse[0] != NULL)
			{
				sil[0] = traverse[0];
				traverse[0] = traverse[0]->bottom;
				delete sil[0];
			}
			if (traverse[1] != NULL)
			{
				sil[1] = traverse[1];
				traverse[1] = traverse[1]->bottom;
				delete sil[1];
			}
			if (traverse[2] != NULL)
			{
				sil[2] = traverse[2];
				traverse[2] = traverse[2]->bottom;
				delete sil[2];
			}
			if (traverse[3] != NULL)
			{
				sil[3] = traverse[3];
				traverse[3] = traverse[3]->bottom;
				delete sil[3];
			}
		}

}


// #include <iostream>
// #include <stdlib.h>
// #include <string>
// #include <stack>
// #include <algorithm>
// #include <vector>
// #include <iterator>

// #define HEART "H" // Copas
// #define CLUB "C" // Paus
// #define DIAMOND "D" // Ouro
// #define SPADE "S" // Espada

// using namespace std;

// struct card {
//     int value;
//     string suit;
//     bool is_turned;
// };

// void assign_cards(string suit, vector <card>* cards) {
// 	card c;
// 	for (int i = 0; i < 13; i++)  {
// 		c.suit = suit;
// 		c.value = (i+1);
// 		c.is_turned = false;
// 		cards->push_back(c);
// 	}		
// }

// void build_deck(vector<card>* cards) {
// 	assign_cards(HEART, cards); 
// 	assign_cards(CLUB, cards);
// 	assign_cards(DIAMOND, cards);
// 	assign_cards(SPADE, cards);
// }

// void build_stock(stack<card>* stock, vector<card>* deck) {
// 	for (int i = 0; i < 24; i++) {
// 		stock->push(deck->data()[i]);
// 		deck->erase(deck->begin() + i);
// 	}	
// }

// // Movimentos possiveis

// // Vai fundo e coloca no montante de descarte 
// card acess_stock(stack<card>* stock, stack<card>* discard) {
// 	card c;
// 	if (!stock->empty()) {	
// 		c = stock->top();
// 		stock->pop();
	
// 		discard->push(c);
// 	}
// 	return c;
// }

// // Inserir numa fundacao especifica (fundacao eh o nome dado aos
// // montantes de despejo (ha 4, um para cada nipe);
// void insert_in_fundation(card c, stack<card>* fundation) {
// 	if (!fundation->empty()) {
// 				card temp = fundation->top();
// 		if (temp->value < c->value && temp->suit.compare(c->suit)) {
// 				fundation->push(c);
// 		}
// 	}

// }

// struct table {
// 	card fundo[24];
// 	card cemiterio[24];
// 	// onde sera montado a sequencia com mesmo naipe
// 	card naipe1[13];
// 	card naipe2[13];
// 	card naipe3[13];
// 	card naipe4[13];

// 	// colunas onde ira montar a sequencia com naipes alternados
// 	card coluna1[13];
// 	card coluna2[13];
// 	card coluna3[13];
// 	card coluna4[13];
// 	card coluna5[13];
// 	card coluna6[13];
// 	card coluna7[13];
// };

// int main() {
	
// 	vector<card> c;	
	
// 	// Cria o baralho com 52 cartas e distribui os nipes e valores
// 	build_deck(&c);
	
// 	// Embaralha as cartas
// 	random_shuffle(c.begin(), c.end());	
	
// 	stack<card> stock; 
	
// 	// Cria o 'fundo', apos buildar o fundo,
// 	// o deck de cartas ficará apenas com 28 elementos
// 	build_stock(&stock, &c);

// 	stack<card> discard;			
		
// 	// TODO
// 	// distribuir 28 para as colunas (que sao 7)	
	
// 	return 0;
// }
