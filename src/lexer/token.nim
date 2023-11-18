import options

import tokenType
import literal

type Token* = object  
    lexeme: string 
    line: int 
    literal: Option[LiteralValue]
    tokenType: TokenType

proc newToken*(tokenType: TokenType, lexeme: string, literal: Option[LiteralValue], line: int): Token = 
    return Token(lexeme: lexeme, line: line , literal: none(LiteralValue), tokenType: tokenType)