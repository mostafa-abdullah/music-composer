import MusicResources


-- Generate whole string from training list separated by dots
concat2 :: [[Char]] -> [Char]

concat2 [x] = x
concat2 (x:xs) = x ++"."++ concat2 xs
---------------------------------------------------------------

input = concat2 training
---------------------------------------------------------------
-- Collecting the characters following a specific one packed (similar chars grouped together)
followers :: Char -> [Char] -> [Char]

followers _ [_] = []
followers c (x:y:xs)
			| x==c && y /= '.' = insertChar y (followers c (y:xs))
			| y == '.' = followers c xs
			| otherwise = followers c (y:xs)
---------------------------------------------------------------

-- Inserting a character in a string in a correct position to be placed beside similar characters				
insertChar :: Char -> [Char] -> [Char]

insertChar x [] = [x]
insertChar x (y:ys)
			| x==y = x:(y:ys)
			| otherwise = y:(insertChar x ys)
---------------------------------------------------------------

--Counts number of occurunce of a certain character in the first part of the list until meeting a different char
countCharInAList :: Char -> [Char] -> Int

countCharInAList _ [] = 0
countCharInAList c (x:xs)
			| c == x = 1+ (countCharInAList c xs)
			| otherwise = 0
---------------------------------------------------------------

--Remomves the first substring formed from the same character from the input
getRest :: Char -> [Char] -> [Char]

getRest _ [] = []
getRest c (x:xs)
		| c == x = getRest c xs
		| otherwise = (x:xs)
---------------------------------------------------------------

--Generate pairs of the character and its number of occurrences  in the input char list
generatePairs :: [Char] -> [(Int,Char)]

generatePairs [] = []
generatePairs (x:xs) = (n, x):(generatePairs (getRest x (x:xs))) where n = countCharInAList x (x:xs)
---------------------------------------------------------------

--Insert a pair in the correct position in a sorted list of pairs. The higher priority is to the frequency of the char, and then to the lexographical order of the char
insertsorted :: (Int,Char) -> [(Int,Char)] -> [(Int,Char)]

insertsorted x [] = [x] 
insertsorted (n1,c1) ((n2,c2):ys) 
                     | n1 > n2 = (n1,c1):(n2,c2):ys
                     | n1 == n2 && c1<=c2 = (n2,c2) : insertsorted (n1,c1) (ys)
                     | n1 == n2 && c1>c2 = (n1,c1):(n2,c2):ys
                     | otherwise = (n2,c2) : insertsorted (n1,c1) (ys)
---------------------------------------------------------------

--Sorts a list of pairs according to frequency of the chars, then to their lexographical order
insertionsort :: [(Int,Char)] -> [(Int,Char)]

insertionsort [] = [] 
insertionsort (x:xs) = insertsorted x (insertionsort xs)
---------------------------------------------------------------

--Takes an input char, and generates pairs of characters following this input char and their frequency sorted
generateSortedPairs :: Char -> (Char,[(Int,Char)])

generateSortedPairs c = (c,insertionsort (generatePairs l)) where l = (followers c input)
---------------------------------------------------------------

--generate a list of statistics according to the content of the training list
makeStatsList :: [(Char,[(Int,Char)])]

makeStatsList = makeStatsListHelper chars
---------------------------------------------------------------

makeStatsListHelper :: [Char] -> [(Char,[(Int,Char)])]

makeStatsListHelper [] = []
makeStatsListHelper (x:xs) = (generateSortedPairs x):(makeStatsListHelper xs)
---------------------------------------------------------------

--Count the total frequency of all characters in the given list of pairs
countTotalFrequency :: [(Int,Char)] -> Int

countTotalFrequency [] = 0
countTotalFrequency ((n,_):xs) = n + countTotalFrequency xs
---------------------------------------------------------------

--Returns a char from the list of pairs randomly with probability according to its frequency
generateRandomChar :: [(Int,Char)] -> Int -> Char

generateRandomChar ((n,c):xs) randomVariable
						| randomVariable < n = c
						| otherwise = generateRandomChar xs (randomVariable-n)
---------------------------------------------------------------

--Returns a list of pairs generated in makeStatsList corresponding to the input char
findPair :: Char -> [(Char,[(Int,Char)])] -> [(Int,Char)]

findPair x ((c,pairs):xs) 
			| x==c = pairs
			| otherwise = findPair x xs
---------------------------------------------------------------

--Generetes the composed string
compose :: Char -> Int -> [Char]

compose _ 0 = []
compose start length
			| (findPair start makeStatsList) == [] = error "Reached a dead end! Try again" 
			| otherwise = start:(compose c (length-1)) where c = (generateRandomChar (pairs) (randomZeroToX ((countTotalFrequency pairs)-1)))
														 	 			where pairs = findPair start makeStatsList
---------------------------------------------------------------					