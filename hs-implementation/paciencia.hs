import Control.Monad  

-- Card type
data Card = Card { value :: Int -- 1 to 13
                 , suit :: String -- C of 'Copas' to Heart, O of 'Ouro' to Diamond, P of 'Paus' to Club and E of 'Espada' to Spade * (suits are in portuguese-Brazil)
                 , is_turned :: Bool -- True to turned off or False to turned up
                 , is_valid :: Bool -- True if a card of stock or False if 'generic' card * (for display purposes)
                 , color :: String -- R to Red or B to Black
                } deriving (Show)

toString :: Card -> String
toString (Card {value = value, suit = suit, is_turned = is_turned, is_valid = is_valid, color = color})
        | is_valid == False = "[----]"
        | is_valid && is_turned = "[????]"
        | otherwise = cardString
        where cardString
                    | value < 10 = "[" ++ color ++ "0" ++ show value ++ suit ++ "]"
                    | otherwise = "[" ++ color ++ show value ++ suit ++ "]"


main = do
    -- apenas para exemplo --
    let invalid_card = Card { value = 1, suit = "C", is_turned = False, is_valid = False, color = "R"}
    let turned_off_card = Card { value = 1, suit = "C", is_turned = True, is_valid = True, color = "R"}
    let common_card = Card {value = 1, suit = "C", is_turned = False, is_valid = True, color = "R"}
    
    let col1 = [common_card] ++ take 12 (repeat invalid_card)
    let col2 = [turned_off_card, common_card] ++ take 11 (repeat invalid_card) 
    let col3 = (take 2 (repeat turned_off_card) ++ [common_card]) ++ take 10 (repeat invalid_card)
    let col4 = (take 3 (repeat turned_off_card) ++ [common_card]) ++ take 9 (repeat invalid_card)
    let col5 = (take 4 (repeat turned_off_card) ++ [common_card]) ++ take 8 (repeat invalid_card)
    let col6 = (take 5 (repeat turned_off_card) ++ [common_card]) ++ take 7 (repeat invalid_card)
    let col7 = (take 6 (repeat turned_off_card) ++ [common_card]) ++ take 6 (repeat invalid_card)

    -- define "loop" as a recursive IO action
    let loop = do
            putStrLn " "
            numbers <- forM [1..13] (\a -> do
                putStrLn $ "--" ++ (if a < 10 then "0" ++ show a else show a)
                        ++ "--  " ++ (toString (col1 !! (a-1))) ++ " " ++ (toString (col2 !! (a-1))) ++ " " ++ (toString (col3 !! (a-1))) ++ " "
                        ++ (toString (col4 !! (a-1))) ++ " " ++ (toString (col5 !! (a-1))) ++ " " ++ (toString (col6 !! (a-1))) ++ " " ++ (toString (col7 !! (a-1))))

            putStrLn " "
            putStrLn "Escolha uma opcao:"
            putStrLn "Opcao (1): puxar uma carta do estoque."
            putStrLn "Opcao (2): mover uma carta."
            putStrLn "Opcao (3): sair do jogo."
            putStrLn "Opcao: "
            option <- getLine
            putStrLn " "
            -- if 'option' is different of 3, start another loop
            when (option /= "3") loop
    loop  -- start the first iteration 
    putStrLn "Jogo encerrado."
    putStrLn "     .-~~-."
    putStrLn "    {      }"
    putStrLn " .-~-.    .-~-."
    putStrLn "{              }"
    putStrLn " `.__.'||`.__.'"
    putStrLn "       ||"
    putStrLn "      '--`"
    putStrLn " "


    -- examples of card object
    putStrLn "Ás de copas"
    let as_de_copas = Card { value = 1, suit = "C", is_turned = False, is_valid = True, color = "R"}
    putStrLn (toString as_de_copas)

    putStrLn "Carta virada pra baixo"
    let carta_qualquer_virada = Card { value = 10, suit = "C", is_turned = True, is_valid = True, color = "R"}
    putStrLn (toString carta_qualquer_virada)

    putStrLn "Carta invalida"
    let carta_invalida = Card { value = 11, suit = "C", is_turned = False, is_valid = False, color = "R"}
    putStrLn (toString carta_invalida)