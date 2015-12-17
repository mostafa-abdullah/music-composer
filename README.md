# music-composer
A random fair music pieces generator made with Haskell


# Pre-project:
-	concat2 : takes the training list as input, it concatenates the string items in the list separated by dot ‘.’.
-	input generates the result from calling concat2 on training list.
# Part A :
-	makeStatsList:  
	Calls a helper method makeStatsListHelper with chars array.
	makeStatsListHelper  calls generateSortedPairs function on every character in the chars list, and returns the result as a list of pairs.
	generateSortedPairs: takes an input char, and generates a pair of the character itself and a list of pairs of characters following this input char and their frequency sorted, it calls generatePairs function on the resulting list from followers function. The sorting is done with insertionsort function.
•	followers: Collects the characters following a specific one packed (similar chars grouped together) it takes the dots into consideration.
Example : 
Main> followers 'a' "ababccabada.cad"
"ddbbb"
•	generatePairs: Generates pairs of the character and its number of occurrences in the input char list. It counts the number of occurrences of the 1st character using countCharInAList function. Then It’s called on the rest of the characters after removing the 1st group of similar characters using getRest function.
Example:
Main> generatePairs "aaabbbcc"
[(3,'a'),(3,'b'),(2,'c')]
o	countCharInAList: Counts number of occurrence of an input character in the first part of the list until meeting a different character.
Example:
Main> countCharInAList 'a' "aaaabb"
4
o	getRest: returns the rest of the characters from an input char list after removing the 1st group of similar characters.
Example: 
Main> getRest 'a' "aaaabb"
"bb"

•	insertionsort: sorts list of pairs according to frequency appearing in the pair. If the frequency is the same, it’s sorted according to the lexographical order of the character. It calls insertSorted which adds an input pair in the correct position in a list of pairs.

# Part B:
-	compose:  it takes the starting character and the length of the desired string as input. It adds the current character to the output string and decides about the next character to be added as follows:  it gets a list of pairs of characters that can follow the current character in the input string and their frequency using findPair function. Then it generates a random character from the list of pairs taking into consideration the probability of occurrence of this random character using generateRandomChar.
If the input character to compose function has no followers, an error is thrown.
	findPair: takes a character as input and returns a list of pairs generated in makeStatsList corresponding to the input char.
Example:
Main> findPair '4' makeStatsList
[(2,'q'),(2,'8'),(1,'i')]
	generateRandomChar: Returns a char from the list of pairs randomly with probability according to its frequency. It takes an input as a list of pairs and a random number between zero and the sum of frequencies from all pairs subtracting 1 from it using randomZeroToX and countTotalFrequency functions. If the random number is less than the frequency of the 1st pair, then this character is the chosen one. Otherwise, the same function is called on the rest of the list after subtracting the frequency of the current character from the random number.
	countTotalFrequency: Counts the total frequency of all characters in the given list of pairs.
Example:
Main> countTotalFrequency [(2,'q'),(2,'8'),(1,'i')]
5
 
 
# Functions listing:
-	concat2 :: [[Char]] -> [Char]
-	followers :: Char -> [Char] -> [Char]
-	insertChar :: Char -> [Char] -> [Char]
-	countCharInAList :: Char -> [Char] -> Int
-	getRest :: Char -> [Char] -> [Char]
-	generatePairs :: [Char] -> [(Int,Char)]
-	insertsorted :: (Int,Char) -> [(Int,Char)] -> [(Int,Char)]
-	insertionsort :: [(Int,Char)] -> [(Int,Char)]
-	generateSortedPairs :: Char -> (Char,[(Int,Char)])
-	makeStatsList :: [(Char,[(Int,Char)])]
-	makeStatsListHelper :: [Char] -> [(Char,[(Int,Char)])]
-	countTotalFrequency :: [(Int,Char)] -> Int
-	generateRandomChar :: [(Int,Char)] -> Int -> Char
-	findPair :: Char -> [(Char,[(Int,Char)])] -> [(Int,Char)]
-	compose :: Char -> Int -> [Char]
