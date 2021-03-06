module Main where
import Control.Monad
import System.Environment
import Text.ParserCombinators.Parsec hiding (spaces)
import Numeric (readOct, readHex)

main :: IO ()
main = do
     args <- getArgs
     putStrLn (show $ readExpr (args !! 0))

data LispVal = Atom String
             | List [LispVal]
             | DottedList [LispVal] LispVal
             | Number Integer
             | String String
             | Bool Bool
             deriving (Eq, Show)

parseString :: Parser LispVal
parseString = do
            char '"'
            x <- many (escapedChars <|> (noneOf ['\\', '"']))
            char '"'
            return $ String x

escapedChars :: Parser Char
escapedChars = do
             char '\\'
             c <- oneOf ['\\', '"', 'n', 'r', 't']
             return $ case c of
                    '\\' -> c
                    '"'  -> c
                    'n'  -> '\n'
                    'r'  -> '\r'
                    't'  -> '\t'

parseAtom :: Parser LispVal
parseAtom = do
          first <- letter <|> symbol
          rest <- many (letter <|> digit <|> symbol)
          let atom = first:rest
          return $ Atom atom

parseBool :: Parser LispVal
parseBool = do
          char '#'
          (char 't' >> return (Bool True)) <|> (char 'f' >> return (Bool False))

parseNumber :: Parser LispVal
parseNumber = parsePlainNumber <|> parseDecimal <|> parseOctal <|> parseHex 
           <|> parseBinary

parsePlainNumber :: Parser LispVal
parsePlainNumber = (many1 digit) >>= (\x -> return ((Number . read) x))

parseDecimal :: Parser LispVal
parseDecimal = do
             try $ string "#d"
             n <- many1 digit
             (return . Number . read) n

parseBinary :: Parser LispVal
parseBinary = do
            try $ string "#b"
            n <- many $ oneOf "01"
            (return . Number . binaryToInt) n

parseOctal :: Parser LispVal
parseOctal = do
           try $ string "#o"
           n <- many $ oneOf "01234567"
           return (Number (fst (readOct n !! 0)))

parseHex :: Parser LispVal
parseHex = do
         try $ string "#x"
         n <- many $ oneOf "0123456789abcdefABCDEF"
         return (Number (fst (readHex n !! 0)))

readWith f s = fst $ f s !! 0

binaryToInt :: String -> Integer
binaryToInt str = foldl1 ((+) . (*2)) $ map val (reverse str)
                where val '0' = 0
                      val '1' = 1

parseExpr :: Parser LispVal
parseExpr = parseAtom 
         <|> parseString 
         <|> parseNumber
         <|> parseBool

symbol :: Parser Char
symbol = oneOf "!$%&|*+-/:<=>?@^_~"

spaces :: Parser ()
spaces = skipMany1 space

readExpr :: String -> LispVal
readExpr input = case parse parseExpr "lisp" input of
         Left err -> String $ "No match: " ++ show err
         Right val -> val