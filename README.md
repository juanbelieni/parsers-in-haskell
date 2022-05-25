# Parsers in Haskell

Parsec, Haskell Wiki: https://wiki.haskell.org/Parsec
Monadic Parsing in Haskell: http://www.cs.nott.ac.uk/~pszgmh/pearl.pdf
Using Parsec: http://book.realworldhaskell.org/read/using-parsec.html
Parsec: Direct Style Monadic Parser Combinators For The Real World: https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.19.5187&rep=rep1&type=pdf

## Monadic Parsing in Haskell

Combine material from 3 areas:

- Functional parsers
- Use of monads to structure functional programs
- User of special syntax for monadic programs in Haskell.

This method (recursive descent parsers) is not the most efficient one, but it is completely extensible.

### A type for parsers

```hs
newtype Parser a = Parser (String -> [(a, string)])
```

Here, a parser is a function that:

- Takes a string of characters as its argument.
- Return a list of results, where:
  - Empty list denotes failure.
  - Non-empty list denotes success.

Each result (`(a, string)`) is a pair composed of:

- Parsed and processed prefix of the argument.
- Unparsed suffix of the argument.

> Returning a list of results allows us to build parsers for ambiguous grammars, with many results being returned if the argument can be parsed in many different ways.

### A monad of parsers

The `item` parser:

```hs
item :: Parser Char
item = Parser
  (\cs -> case cs of
    []       -> []
    (c : cs) -> [(c, cs)]
  )
```

Now, we will define two combinators that reflect the monadic structure of parsers. First, we have to make the Parser a Monad:

```hs
instance Monad Parser where
  return a = Parser (\cs -> [(a, cs)])
  p >>= f = Parser (\cs -> concat [ parse (f a) cs' | (a, cs') <- parse p cs ])
```

Where `parse` is a function defined by `parse (Parser p) = p`.

### The do notation

