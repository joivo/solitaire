-- Projeto de Aplicações de Paradigmas de Linguagens de Programação - 2017.2 - UFCG. 
-- Grupo : Arthur Sampaio; Emanuel Joivo; Taigo Lima Pereira;

import Data.List
import System.Random.Shuffle

-- Card Type
data Card = Card { 
  value :: Int -- 1 to 13
, suit :: String -- C of 'Copas' to Heart, O of 'Ouro' to Diamond, P of 'Paus' to Club and E of 'Espada' to Spade * (suits are in portuguese-Brazil)
, is_turned :: Bool -- True to turned off or False to turned up
, is_valid :: Bool -- True if a card of stock or False if 'generic' card * (for display purposes)
, color :: String -- R to Red or B to Black
} deriving (Show)

main :: IO ()
main = do
    principalMenu

    input <- getLine
    let option = read input
    gameInitializer option

    if (option /= 2) 
        then main 
        else endGamePrint

runGame :: IO ()
runGame = do     
    actionMenu

    input <- getLine
    let moviment = read input    

    if (moviment == 1) 
        then putStrLn "Puxou carta do estoque"  -- função de pegar do estoque                
    else if (moviment == 2)
        then putStrLn "Fazer algum movimento"   -- função pra fazer algum movimento               
    else main

generateSuitCard :: Int -> String -> String -> Card
generateSuitCard v s c = 
    Card { value = v,
        suit = s,
        is_turned = True,
        is_valid = True,
        color = c    
    }

populateListWithCards :: Int -> String -> String -> [Card]
populateListWithCards value suit color  
    | value <= 0 = []
    | otherwise = genericCard:populateListWithCards (value-1) suit color
        
    where genericCard = (generateSuitCard value suit color)

generateSuitCardsList :: String -> String -> [Card]
generateSuitCardsList suit color = populateListWithCards 13 suit color

generateDeck :: [Card]
generateDeck = concat [generateSuitCardsList "C" "RED",
                generateSuitCardsList "O" "RED",
                generateSuitCardsList "P" "BLACK",
                generateSuitCardsList "E" "BLACK"]

generateDefaultBoard :: [Card] -> [[Card]]
generateDefaultBoard deck = [[]]

updateBoard :: [[Card]] -> [[Card]]
updateBoard currentBoard = [[]]
		
gameInitializer :: Int -> IO ()
gameInitializer 1 = runGame
gameInitializer _ = putStrLn ""

-- TODO recebe o estado do jogo e imprime a mesa toString [[Card]] -> IO String

toString :: Card -> String
toString (Card {value = value, suit = suit, is_turned = is_turned, is_valid = is_valid, color = color})
    | is_valid == False = "[----]"
    | is_valid && is_turned = "[????]"
    | otherwise = cardString
    where cardString
                | value < 10 = "[" ++ color ++ "0" ++ show value ++ suit ++ "]"
                | otherwise = "[" ++ color ++ show value ++ suit ++ "]"

principalMenu :: IO ()
principalMenu = do
    let deckShuffle = shuffle generateDeck [1..]

    print deckShuffle
    putStrLn "(------)(------)(------)(------)(------)(------)(------)(------)"
    putStrLn "(------)(------)(------)(------)(------)(------)(------)(------)"
    putStrLn "(------)                                                (------)"
    putStrLn "(------)                  Solitaire                     (------)"
    putStrLn "(------)                                                (------)"
    putStrLn "(------)(------)(------)(------)(------)(------)(------)(------)"
    putStrLn "(------)(------)(------)(------)(------)(------)(------)(------)"
    putStrLn "(------)                                                (------)"
    putStrLn "(------)           Opcao (1) - Iniciar jogo             (------)"
    putStrLn "(------)           Opcao (2) - Fechar jogo              (------)"
    putStrLn "(------)                                                (------)"
    putStrLn "(------)(------)(------)(------)(------)(------)(------)(------)"
    putStrLn "(------)(------)(------)(------)(------)(------)(------)(------)"    

actionMenu :: IO ()
actionMenu = do
    putStrLn "(------)(------)(------)(------)(------)(------)(------)(------)"
    putStrLn "(------)(------)(------)(------)(------)(------)(------)(------)"
    putStrLn "(------)                                                (------)"
    putStrLn "(------)  Escolha uma das opões a seguir                (------)"
    putStrLn "(------)                                                (------)"
    putStrLn "(------)(------)(------)(------)(------)(------)(------)(------)"
    putStrLn "(------)(------)(------)(------)(------)(------)(------)(------)"
    putStrLn "(------)                                                (------)"
    putStrLn "(------)  Opção (1) - Puxar uma carta do estoque.       (------)"
    putStrLn "(------)  Opção (2) - Mover uma carta.                  (------)"
    putStrLn "(------)  Opção (3) - Sair do jogo.                     (------)"
    putStrLn "(------)                                                (------)"
    putStrLn "(------)(------)(------)(------)(------)(------)(------)(------)"
    putStrLn "(------)(------)(------)(------)(------)(------)(------)(------)"
    putStrLn " "   

endGamePrint :: IO ()
endGamePrint = do
    putStrLn "Jogo encerrado."
    putStrLn "     .-~~-."
    putStrLn "    {      }"
    putStrLn " .-~-.    .-~-."
    putStrLn "{              }"
    putStrLn " `.__.'||`.__.'"
    putStrLn "       ||"
    putStrLn "      '--`"
    putStrLn " "

-- main = do
--    let invalid_card = Card { value = 1, suit = "C", is_turned = False, is_valid = False, color = "R"};
--    let turned_off_card = Card { value = 1, suit = "C", is_turned = True, is_valid = True, color = "R"};
--    let common_card = Card {value = 1, suit = "C", is_turned = False, is_valid = True, color = "R"};
--    
--    let col1 = [common_card] ++ take 12 (repeat invalid_card);
--    let col2 = [turned_off_card, common_card] ++ take 11 (repeat invalid_card) ;
--    let col3 = (take 2 (repeat turned_off_card) ++ [common_card]) ++ take 10 (repeat invalid_card);
--    let col4 = (take 3 (repeat turned_off_card) ++ [common_card]) ++ take 9 (repeat invalid_card);
--    let col5 = (take 4 (repeat turned_off_card) ++ [common_card]) ++ take 8 (repeat invalid_card);
--    let col6 = (take 5 (repeat turned_off_card) ++ [common_card]) ++ take 7 (repeat invalid_card);
--    let col7 = (take 6 (repeat turned_off_card) ++ [common_card]) ++ take 6 (repeat invalid_card);

    -- define "loop" as a recursive IO action
    
--    numbers <- forM [1..13] (\a -> do
--        putStrLn $ "--" ++ (if a < 10 then "0" ++ show a else show a)
--        ++ "--  " ++ (toString (col1 !! (a-1))) ++ " " ++ (toString (col2 !! (a-1))) ++ " " ++ (toString (col3 !! (a-1))) ++ " "
--        ++ (toString (col4 !! (a-1))) ++ " " ++ (toString (col5 !! (a-1))) ++ " " ++ (toString (col6 !! (a-1))) ++ " " ++ (toString (col7 !! (a-1))));