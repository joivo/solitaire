-- Projeto de Aplicações de Paradigmas de Linguagens de Programação - 2017.2 - UFCG. 
-- Grupo : Arthur Sampaio; Emanuel Joivo; Taigo Pereira;

import Data.List
import System.Random
import Data.Array.IO
import Control.Monad

-- Card Type
data Card = Card { 
  value :: Int -- 1 to 13
, suit :: String -- C of 'Copas' to Heart, O of 'Ouro' to Diamond, P of 'Paus' to Club and E of 'Espada' to Spade * (suits are in portuguese-Brazil)
, is_turned :: Bool -- True to turned off or False to turned up
, is_valid :: Bool -- True if a card of stock or False if 'generic' card * (for display purposes)
, color :: String -- R to Red or B to Black
} deriving (Show, Eq)

-- Para embaralhar as cartas. Como retorna uma ação de IO, é necessário usá-la dentro de um bloco Do (ou uma ação de IO maior).
shuffle :: [a] -> IO [a]
shuffle xs = do
        ar <- newArray n xs
        forM [1..n] $ \i -> do
            j <- randomRIO (i,n)
            vi <- readArray ar i
            vj <- readArray ar j
            writeArray ar j vi
            return vj
    where
    n = length xs
    newArray :: Int -> [a] -> IO (IOArray Int a)
    newArray n xs =  newListArray (1,n) xs

takeLastValidCard :: [Card] -> Card
takeLastValidCard cards = if (length (filter (\x -> (is_valid x) == True) cards)) > 0
	then (last (filter (\x -> (is_valid x) == True) cards))
	else (cards !! 0)

takeCards :: Int -> [Card] -> [Card]
takeCards qnt cards = take qnt (filter (\x -> ((is_turned x) == False)) cards)

removeFromColumn :: Int -> Card -> [Card] -> [Card] -> [Card] -> [Card]
removeFromColumn qnt card cards columnFrom columnTo =
	if ((length cards > 0) && ((color (cards !! 0)) /= (color card)) && (((value card) - 1) == (value (cards !! 0))))
		|| ((length (filter (\x -> (is_valid x) == True) columnTo)) == 0) && (length cards > 0) && ((value (cards !! 0)) == 13)
		then turnOnLast ([columnFrom !! 0] ++ reverse (drop (length cards) (reverse (filter (\x -> (is_valid x) == True) columnFrom)))) ++ take 26 (repeat (columnFrom !! 0))		
	else columnFrom

putInColumn :: [Card] -> [Card] -> [Card] -> [Card]
putInColumn columnFrom columnTo cards =
	if (length cards > 0) && (color (cards !! 0)) /= (color (takeLastValidCard columnTo)) && (value (cards !! 0)) == ((value (takeLastValidCard columnTo)) - 1)
		then ([columnTo !! 0] ++ (filter (\x -> (is_valid x) == True) columnTo)
		++ cards ++ (take 26 (repeat (columnTo !! 0))))
	else if ((length (filter (\x -> (is_valid x) == True) columnTo)) == 0) && (length cards > 0) && ((value (cards !! 0)) == 13)
		then [columnTo !! 0] ++ cards ++ take 26 (repeat (columnTo !! 0))
	else columnTo
	
fromColumnToColumn :: [[Card]] -> Int -> Int -> Int -> IO [[Card]]
fromColumnToColumn boardGame init qnt end = do
	if init > 0 && init < 8 && end > 0 && end < 8 && qnt < 13
		then if init < end
			then return (take (init + 5) boardGame ++ [removeFromColumn qnt (takeLastValidCard (boardGame !! (end+5))) (takeCards qnt (boardGame !! (init + 5))) (boardGame !! (init + 5)) (boardGame !! (end + 5))]
				++ (take ((end + 6) - (init + 7)) (drop (init + 6) boardGame)) ++ [putInColumn (boardGame !! (end+5)) (boardGame !! (end + 5)) (takeCards qnt (boardGame !! (init + 5)))]
				++ (drop (end + 6) boardGame))
		else if init > end
			then return ((take (end + 5) boardGame) ++ [putInColumn (boardGame !! (end+5)) (boardGame !! (end + 5)) (takeCards qnt (boardGame !! (init + 5)))]
			++ (take ((init + 6) - (end + 7)) (drop (end + 6) boardGame)) ++ [removeFromColumn qnt (takeLastValidCard (boardGame !! (end+5))) (takeCards qnt (boardGame !! (init + 5))) (boardGame !! (init + 5)) (boardGame !! (end + 5))]
			++ (drop (init + 6) boardGame))
		else return boardGame
	else return boardGame

moveBetweenColumns :: [[Card]] -> IO [[Card]]
moveBetweenColumns boardGame = do

	putStrLn "Digite a coluna de origem (de 1 a 7)"
	init <- getLine
	putStrLn "Digite a quantidade de cartas"
	qnt <- getLine
	putStrLn "Digite a coluna de destino (de 1 a 7)"
	end <- getLine
	
	let board = (fromColumnToColumn boardGame (read init) (read qnt) (read end))
	board <- board
	return board

fromColumnToFundation :: Int -> [[Card]] -> IO [[Card]]
fromColumnToFundation position boardGame = do
	if (length (filter (\x -> (is_valid x) == True) (boardGame !! (position + 5)))) > 0
		then do
			let oldFundations = drop 2 . take 6 $ boardGame 
			let fundations = (updateFundations (last (filter (\x -> (is_valid x) == True) (boardGame !! (position + 5)))) oldFundations)
			fundations <- fundations
			if oldFundations /= fundations
				then do
					return (take 2 boardGame ++ fundations ++ (drop 6 (take (position + 5) boardGame))
						++ [turnOnLast ([(boardGame !! 0) !! 0] ++ reverse (drop 1 (reverse (filter (\x -> (is_valid x) == True) (boardGame !! (position + 5)))))) ++ take 26 (repeat ((boardGame !! 0) !! 0))]
						++ (drop (position + 6) boardGame))
			else return boardGame
	else return boardGame

moveFromColumnToFundation :: [[Card]] -> IO [[Card]]
moveFromColumnToFundation boardGame = do

	putStrLn "Digite a coluna de origem"
	init <- getLine
	
	let board = (fromColumnToFundation (read init) boardGame)
	board <- board
	return board

main :: IO ()
main = do
	principalMenu    

	input <- getLine
	let option = read input    

	if option == 1
		then do
			deckShuffled <- shuffle generateDeck
			let invalid_card = Card { value = 99, suit = "X", is_turned = True, is_valid = False, color = "X"};
			let gameBoard = generateDefaultBoard invalid_card deckShuffled
			runGame 0 gameBoard
	else if option == 2
		then endGamePrint 0
	else if option == 3
		then runInstructions
	else do
		putStrLn "Opcao invalida"
		main

runInstructions :: IO ()
runInstructions = do
    instructionsMenu;

    input <- getLine    

    if (null input)
        then main
    else runInstructions

runGame :: Int -> [[Card]] -> IO ()
runGame counter gameBoard = do
    actionMenu;    
	
	headerBoardGamePrint
    putStrLn (currentHaltString gameBoard)

    input <- getLine
    let moviment = read input    

    if (not (checkVictory gameBoard))
    	then do
		    if (moviment == 1) 
		        then do
					if length (gameBoard !! 0) == 1
						then do
							putStrLn "Estoque vazio"
							runGame (counter + 1) gameBoard
					else do
						gameBoard <- (getCardOfStock gameBoard)
						putStrLn (currentHaltString gameBoard)
						putStrLn "Puxou carta do estoque"  -- função de pegar do estoque
						runGame (counter + 1) gameBoard
		    else if (moviment == 2)
		        then do
					gameBoard <- moveCards gameBoard   -- função pra fazer algum movimento
					runGame (counter + 1) gameBoard
		    else main
	else endGamePrint counter		

updateFundations :: Card -> [[Card]] -> IO [[Card]]
updateFundations card fundations = do
	print fundations
	if (suit card) == "C"
		then do
			let heartFundation = fundations !! 0
			if (((length heartFundation) == 1) && ((value card) == 1)) || (value (last heartFundation)) == ((value card) - 1)
				then do
					return ([(heartFundation ++ [card])] ++ (drop 1 fundations))
			else do
				return fundations
	else if (suit card) == "O"
		then do
			let diamondFundation = fundations !! 1
			if (((length diamondFundation) == 1) && ((value card) == 1)) || (value (last diamondFundation)) == ((value card) - 1)
				then do
					return ((take 1 fundations) ++ [(diamondFundation ++ [card])] ++ (drop 2 fundations))
			else do
				return fundations
	else if (suit card) == "P"
		then do
			let clubFundation = fundations !! 2
			if (((length clubFundation) == 1) && ((value card) == 1)) || (value (last clubFundation)) == ((value card) - 1)
				then do
					return ((take 2 fundations) ++ [(clubFundation ++ [card])] ++ (drop 3 fundations))
			else do
				return fundations
	else do
		let spadeFundation = fundations !! 3
		if (((length spadeFundation) == 1) && ((value card) == 1)) || (value (last spadeFundation)) == ((value card) - 1)
			then do
				return ((take 3 fundations) ++ [(spadeFundation ++ [card])])
		else do
			return fundations

discardToFundations :: [[Card]] -> IO [[Card]]
discardToFundations boardGame = do
	if (length (boardGame !! 1)) > 1
		then do
			let card = (last (boardGame !! 1))
			let discard = (boardGame !! 1)
			let oldFundations = drop 2 . take 6 $ boardGame 
			let fundations = (updateFundations card oldFundations)
			fundations <- fundations
			if oldFundations /= fundations
				then do
					let discard = (take ((length (boardGame !! 1)) -1) (boardGame !! 1))
					return ((take 1 boardGame) ++ [discard] ++ fundations ++ (drop 6 boardGame))
			else do
				let discard = (boardGame !! 1)
				return ((take 1 boardGame) ++ [discard] ++ fundations ++ (drop 6 boardGame))
	else do
		return boardGame

resetStock :: [[Card]] -> IO [[Card]]
resetStock gameBoard = do
	if ((length (gameBoard !! 0)) == 1) && ((length (gameBoard !! 1)) > 1)
		then do
			let stock = (map turnOff (drop 1 (gameBoard !! 1)))
			let shuffledStock = (shuffle stock)
			shuffledStock <- shuffledStock
			let invalid_card = ((gameBoard !! 0) !! 0)
			return ([[invalid_card] ++ shuffledStock] ++ [[invalid_card]] ++ (drop 2 gameBoard))
	else return gameBoard

discardToColumns :: [[Card]] -> IO [[Card]]
discardToColumns gameBoard = do
	putStrLn discardToColumnsMenu

	input <- getLine
	let columnNumber = (read input)
	let currentDiscardCard = last (gameBoard !! 1)	
	let invalid_card = Card { value = 99, suit = "X", is_turned = False, is_valid = False, color = "X"}

	if ((length (gameBoard !! 1)) == 1) || (columnNumber < 1 || columnNumber > 7)
		then 
			return gameBoard
	else do		
		let currentColumn = (gameBoard !! (columnNumber + 5))
		let valid_cards = (filter (\x -> (is_valid x == True || is_turned x == True)) currentColumn)
		let lastValidCard = lastValidCardInColumn valid_cards
		print lastValidCard
		print currentDiscardCard	

		let columnChanged = changeCardInColumn currentDiscardCard invalid_card valid_cards			
		let boardChanged = [ gameBoard !! 0, take ((length (gameBoard !! 1)) - 1) (gameBoard !! 1), gameBoard !! 2, gameBoard !! 3, 
					gameBoard !! 4, gameBoard !! 5, decideChangesInColumns (6-5) columnNumber (gameBoard !! 6) columnChanged,
					decideChangesInColumns (7-5) columnNumber (gameBoard !! 7)  columnChanged,
					decideChangesInColumns (8-5) columnNumber (gameBoard !! 8) columnChanged, 
					decideChangesInColumns (9-5) columnNumber (gameBoard !! 9) columnChanged,
					decideChangesInColumns (10-5) columnNumber (gameBoard !! 10) columnChanged,
					decideChangesInColumns (11-5) columnNumber (gameBoard !! 11) columnChanged,
					decideChangesInColumns (12-5) columnNumber (gameBoard !! 12) columnChanged,
					decideChangesInColumns (13-5) columnNumber (gameBoard !! 13) columnChanged ]				

		if (discardToColumnsAccepted lastValidCard currentDiscardCard)
			then do
				putStrLn "Entrou no if"
				return boardChanged
		else return gameBoard

discardToColumnsAccepted :: Card -> Card -> Bool
discardToColumnsAccepted oldLastCard newLastCard  
	| (color oldLastCard /= color newLastCard) && value oldLastCard == (value newLastCard + 1) = True
	| otherwise = False

decideChangesInColumns :: Int -> Int -> [Card] -> [Card] -> [Card]
decideChangesInColumns columnIndex currentIndex oldColumn newColumn
	| currentIndex == columnIndex = newColumn
	| otherwise = oldColumn

changeCardInColumn :: Card -> Card -> [Card] -> [Card]
changeCardInColumn cardToAdd invalid_card valid_cards = [invalid_card] ++ valid_cards ++ [cardToAdd] ++ (replicate (13 -  (length valid_cards)) invalid_card)

lastValidCardInColumn :: [Card] -> Card 
lastValidCardInColumn currentField 
	| (length valid_cards) == 0 = currentField !! 0
	| otherwise = last valid_cards

	where valid_cards = (filter (\x -> (is_valid x) == True) currentField)

discardToColumnsMenu :: String
discardToColumnsMenu = "Selecione a coluna para a qual deseja mover a carta \n" 
	++ "Digite a coordenada da coluna [1-7]: \n"

moveCards :: [[Card]] -> IO [[Card]]
moveCards gameBoard = do
	putStrLn moveToMenu

	input <- getLine
	let option = read input

	if option == 1
		then do
			gameBoard <-(discardToFundations gameBoard)
			return gameBoard
	else if option == 2
		then do			
			gameBoard <- (discardToColumns gameBoard)
			return gameBoard
	else if option == 3
		then do
			gameBoard <- (moveBetweenColumns gameBoard)
			return gameBoard
	else if option == 4
		then do
			gameBoard <- (moveFromColumnToFundation gameBoard)
			return gameBoard
	else if option == 5
		then do
			gameBoard <- (resetStock gameBoard)
			return gameBoard
	else do
		putStrLn "Volta pra o game"
		return gameBoard

moveToMenu :: String
moveToMenu = 
	"\n(------)(------)(------)(------)(------)(------)(------)(------)"
	++ "\n(------)                                                (------)"
	++ "\n(------)  Escolha uma das opcoes a seguir               (------)"
	++ "\n(------)                                                (------)"
	++ "\n(------)(------)(------)(------)(------)(------)(------)(------)"
	++ "\n(------)                                                (------)"
	++ "\n(------)  Opcao (1) - Mover do descarte para fundacoes. (------)"
	++ "\n(------)  Opcao (2) - Mover do descarte para colunas.   (------)"
	++ "\n(------)  Opcao (3) - Mover entre as colunas.           (------)"
	++ "\n(------)  Opcao (4) - Mover das colunas para fundacoes. (------)"
	++ "\n(------)  Opcao (5) - Embaralhar descarte para estoque. (------)"
	++ "\n(------)  Outro digito - Voltar.                        (------)"
	++ "\n(------)                                                (------)"
	++ "\n(------)(------)(------)(------)(------)(------)(------)(------)"
	++ "\n "

generateSuitCard :: Int -> String -> String -> Card
generateSuitCard v s c = 
    Card { value = v,
        suit = s,
        is_turned = True,
        is_valid = True,
        color = c    
    }

checkVictory :: [[Card]] -> Bool
checkVictory gameBoard 
	| length (filter (\x -> (length x) > 13) [gameBoard !! 2, gameBoard !! 3, gameBoard !! 4, gameBoard !! 5]) == 4 = True 
	| otherwise = False

populateListWithCards :: Int -> String -> String -> [Card]
populateListWithCards value suit color  
    | value <= 0 = []
    | otherwise = genericCard:populateListWithCards (value-1) suit color
        
    where genericCard = (generateSuitCard value suit color)

generateSuitCardsList :: String -> String -> [Card]
generateSuitCardsList suit color = populateListWithCards 13 suit color

generateDeck :: [Card]
generateDeck = concat [generateSuitCardsList "C" "R",
                generateSuitCardsList "O" "R",
                generateSuitCardsList "P" "B",
                generateSuitCardsList "E" "B"]

generateSpaces :: [Card] -> Int -> [Card]
generateSpaces deck qntdCards = take qntdCards deck

updateDeck :: [Card] -> Int -> [Card]
updateDeck deck qntdCards = drop qntdCards deck    

getCardOfStock :: [[Card]] -> IO [[Card]]
getCardOfStock gameBoard = do
		if length (gameBoard !! 0) == 1
			then
				return gameBoard
		else do
			let stock = (gameBoard !! 0)
			let card = turnOn (last stock)
			let discard = (gameBoard !! 1) ++ [card]
			return ([(take ((length stock) -1)stock)] ++ ([discard] ++ (drop 2 gameBoard)))

turnOn :: Card -> Card
turnOn (Card {value = value, suit = suit, is_turned = is_turned, is_valid = is_valid, color = color}) =
        Card { value = value,
            suit = suit,
            is_turned = False,
            is_valid = is_valid,
            color = color
        }

turnOff :: Card -> Card
turnOff (Card {value = value, suit = suit, is_turned = is_turned, is_valid = is_valid, color = color}) =
        Card { value = value,
            suit = suit,
            is_turned = True,
            is_valid = is_valid,
            color = color
        }

turnOnLast :: [Card] -> [Card]
turnOnLast cards
		| length cards == 0 = []
        | length cards == 1 = [turnOn (cards !! 0)]
        | otherwise = (take ((length cards) - 1) cards) ++ [turnOn (last cards)]

generateDefaultBoard :: Card -> [Card] -> [[Card]]
generateDefaultBoard invalid_card deck = [[invalid_card] ++ (generateSpaces deck 24), [invalid_card], [invalid_card], [invalid_card], [invalid_card], [invalid_card],
        [invalid_card] ++ turnOnLast (generateSpaces (updateDeck deck 24) 1) ++ take 12 (repeat invalid_card),
        [invalid_card] ++ turnOnLast (generateSpaces (updateDeck deck 25) 2) ++ take 11 (repeat invalid_card),
        [invalid_card] ++ turnOnLast (generateSpaces (updateDeck deck 27) 3) ++ take 10 (repeat invalid_card),
        [invalid_card] ++ turnOnLast (generateSpaces (updateDeck deck 30) 4) ++ take 9 (repeat invalid_card),
        [invalid_card] ++ turnOnLast (generateSpaces (updateDeck deck 34) 5) ++ take 8 (repeat invalid_card),
        [invalid_card] ++ turnOnLast (generateSpaces (updateDeck deck 39) 6) ++ take 7 (repeat invalid_card),
        [invalid_card] ++ turnOnLast (generateSpaces (updateDeck deck 45) 7) ++ take 6 (repeat invalid_card)]

updateBoard :: [[Card]] -> [[Card]]
updateBoard currentBoard = [[]]

upSideBoardToString :: [[Card]] -> String
upSideBoardToString upSideBoard = toString (last (upSideBoard !! 0))
					++ toString (last (upSideBoard !! 1))
					++ "------"
					++ toString (last (upSideBoard !! 2))
					++ toString (last (upSideBoard !! 3))
					++ toString (last (upSideBoard !! 4))
					++ toString (last (upSideBoard !! 5))
					++ "\n" ++ "------------------------------------------"        

bottomSideBoardToString :: [[Card]] -> String -> Int -> String
bottomSideBoardToString bottomSideBoard string x 
        | x == 14 = string 
        | otherwise = bottomSideBoardToString bottomSideBoard (string ++ (toString ((bottomSideBoard !! 0) !! x) 
            ++ toString ((bottomSideBoard !! 1) !! x) 
            ++ toString ((bottomSideBoard !! 2) !! x) 
            ++ toString ((bottomSideBoard !! 3) !! x) 
            ++ toString ((bottomSideBoard !! 4) !! x) 
            ++ toString ((bottomSideBoard !! 5) !! x) 
            ++ toString ((bottomSideBoard !! 6) !! x)) ++ "\n") (x+1)

currentHaltString :: [[Card]] -> String
currentHaltString currentBoard = upSideBoardToString (take 6 currentBoard) ++ "\n" ++ (bottomSideBoardToString (drop 6 currentBoard) "" 1)

toString :: Card -> String
toString (Card {value = value, suit = suit, is_turned = is_turned, is_valid = is_valid, color = color})
    | is_valid == False = "[----]"
    | is_valid && is_turned = "[????]"
    | otherwise = cardString
    where cardString
                | value < 10 = "[" ++ color ++ "0" ++ show value ++ suit ++ "]"
                | otherwise = "[" ++ color ++ show value ++ suit ++ "]"

headerBoardGamePrint :: IO() 
headerBoardGamePrint = do
	putStrLn "A primeira linha da mesa segue a seguinte estrutura:"
	putStrLn "[Estoque] | [Descarte] | ----- | [Copas] | [Ouro] | [Paus] | [Espada]" 
	putStrLn "------------------------------------------" 
	putStrLn "Cada coluna segue a numeracao:"
	putStrLn "[Col1][Col2][Col3][Col4][Col5][Col6][Col7]"
	putStrLn "------------------------------------------" 
	putStrLn " " 

principalMenu :: IO ()
principalMenu = do       
    putStrLn "(------)(------)(------)(------)(------)(------)(------)(------)"
    putStrLn "(------)                                                (------)"
    putStrLn "(------)                  Solitaire                     (------)"
    putStrLn "(------)                                                (------)"
    putStrLn "(------)(------)(------)(------)(------)(------)(------)(------)"
    putStrLn "(------)                                                (------)"
    putStrLn "(------)           Opcao (1) - Iniciar jogo             (------)"
    putStrLn "(------)           Opcao (2) - Fechar jogo              (------)"
    putStrLn "(------)           Opcao (3) - Instrucoes               (------)"
    putStrLn "(------)                                                (------)"
    putStrLn "(------)(------)(------)(------)(------)(------)(------)(------)"
    
instructionsMenu :: IO ()
instructionsMenu = do       
    putStrLn "(------)(------)(------)(------)(------)(------)(------)(------)(------)"
    putStrLn "(------)                                                (------)(------)"
    putStrLn "(------)                  Solitaire                     (------)(------)"
    putStrLn "(------)   Esta eh uma representacao em console do jogo.(------)(------)"
    putStrLn "(------)Portanto, para executar a movimentacao das car- (------)(------)"
    putStrLn "(------)tas utilizaremos coordenadas para seleção das   (------)(------)"
    putStrLn "(------)mesmas e comandos interativos via proprio termi-(------)(------)"
    putStrLn "(------)nal para especificar o movimento desejado.      (------)(------)"
    putStrLn "(------)  A representacao da carta se da por:           (------)(------)"
    putStrLn "(------)        [Cor|Valor|Nipe]                        (------)(------)"
    putStrLn "(------)  Onde O representa o nipe de ouro, C o de copas(------)(------)"
    putStrLn "(------)seguido por E para espadas e P para paus.       (------)(------)"
    putStrLn "(------)                                                (------)(------)"
    putStrLn "(------)(------)(------)(------)(------)(------)(------)(------)(------)"
    putStrLn "(------)                                                (------)(------)"
    putStrLn "(------)        <Pressione enter para sair>             (------)(------)"
    putStrLn "(------)                                                (------)(------)"
    putStrLn "(------)(------)(------)(------)(------)(------)(------)(------)(------)"   

actionMenu :: IO ()
actionMenu = do
    putStrLn "(------)(------)(------)(------)(------)(------)(------)(------)"
    putStrLn "(------)                                                (------)"
    putStrLn "(------)  Escolha uma das opcoes a seguir               (------)"
    putStrLn "(------)                                                (------)"
    putStrLn "(------)(------)(------)(------)(------)(------)(------)(------)"
    putStrLn "(------)                                                (------)"
    putStrLn "(------)  Opcao (1) - Puxar uma carta do estoque.       (------)"
    putStrLn "(------)  Opcao (2) - Mover uma carta.                  (------)"
    putStrLn "(------)  Outro digito - Voltar ao menu principal       (------)"    
    putStrLn "(------)                                                (------)"
    putStrLn "(------)(------)(------)(------)(------)(------)(------)(------)"
    putStrLn " "   

endGamePrint :: Int -> IO ()
endGamePrint points = do
    putStrLn "Jogo encerrado."
    putStrLn "     .-~~-."
    putStrLn "    {      }"
    putStrLn " .-~-.    .-~-."
    putStrLn "{              }"
    putStrLn " `.__.'||`.__.'"
    putStrLn "       ||"
    putStrLn "      '--`"
    putStrLn " "
    putStrLn $ pontuationPrint points

pontuationPrint :: Int -> String
pontuationPrint x = "Sua pontuacao: " ++ show x 
