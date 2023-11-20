import tables

import ../lexer/tokenType

let keywords: Table[string, TokenType] = {
    "and": TT_AND,
    "class": TT_CLASS,
    "else": TT_ELSE,
    "false": TT_FALSE,
    "for": TT_FOR, 
    "fun": TT_FUN,
    "if": TT_IF,
    "nil": TT_NIL,
    "or": TT_OR,
    "print": TT_PRINT,
    "return": TT_RETURN,
    "super": TT_SUPER,
    "this": TT_THIS,
    "true": TT_TRUE,
    "var": TT_VAR,
    "while": TT_WHILE,
}.toTable

proc getKeywords*(): Table[string, TokenType] =
    return keywords