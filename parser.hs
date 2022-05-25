{-# LANGUAGE LambdaCase #-}

module Parser where

newtype Parser a = Parser (String -> [(a, String)])

parse :: Parser a -> String -> [(a, String)]
parse (Parser p) = p

instance Functor Parser where
  fmap f p = Parser $ \cs -> [ (f a, cs') | (a, cs') <- parse p cs ]

instance Applicative Parser where
  pure a = Parser $ \cs -> [(a, cs)]
  pf <*> px = Parser $ \cs ->
    [ (f a, cs'') | (f, cs') <- parse pf cs, (a, cs'') <- parse px cs' ]

instance Monad Parser where
  return a = Parser $ \cs -> [(a, cs)]
  p >>= f = Parser $ \cs -> concat [ parse (f a) cs' | (a, cs') <- parse p cs ]

item :: Parser Char
item = Parser $ \case
  []       -> []
  (c : cs) -> [(c, cs)]

twoItems :: Parser (Char, Char)
twoItems = item >>= (\c1 -> item >>= (\c2 -> return (c1, c2)))

twoItems' :: Parser (Char, Char)
twoItems' = do
  c1 <- item
  c2 <- item
  return (c1, c2)