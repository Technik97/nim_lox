import options
import std/strutils
import tables

import ../lexer/token
import ../lexer/tokenType
import ../lexer/literal
import ../core/error
import ./keywords


type
  Scanner* = object
    source: string
    tokens: seq[Token]
    current: int
    start: int  
    line: int
    keywords: Table[string, TokenType]

proc newScanner*(self: Scanner, source: string): Scanner =
    return Scanner(tokens: @[], current: 0, start: 0, line: 1, keywords: getKeywords() )

proc isAtEnd(self: Scanner): bool =
    return self.current >= self.source.len()

proc advance(self: var Scanner): char =
    return self.source[self.current + 1]

proc addToken(self: var Scanner, tokenType: TokenType, literal: Option[LiteralValue]) = 
    var text: string = self.source[self.start ..< self.current]
    self.tokens.add(newToken(tokenType, text, literal, self.line))

proc addToken(self: var Scanner, tokenType: TokenType) = 
    addToken(self, tokenType, none(LiteralValue))

proc match(self: var Scanner, expected: char): bool = 
    if self.isAtEnd():
        return false

    if self.source[self.current] != expected:
        return false

    self.current += 1
    return true

proc peek(self: Scanner): char = 
    if self.isAtEnd():
        return '\0'
    return self.source[self.current]
 
proc string(self: var Scanner) = 
    while self.peek() != '"' and not self.isAtEnd(): 
        if self.peek() == '\n':
            self.line += 1
        discard self.advance()

    if self.isAtEnd():
        error(self.line, "Unterminated string.")

    let value: string = self.source[self.start + 1 ..< self.current - 1]
    self.addToken(TT_STRING, some(LiteralValue(literalType: StringValue, s: value)))

proc peekNext(self: Scanner): char = 
    if self.current + 1 >= self.source.len():
        return '\0'

    return self.source[self.current + 1]

proc number(self: var Scanner) = 
    while isDigit(self.peek()):
        discard self.advance()

    if self.peek() == '.' and isDigit(self.peekNext()):
        discard self.advance()

    while isDigit(self.peek()):
        discard self.advance()

proc identifier(self: var Scanner) = 
    while isAlphaNumeric(self.peek()):
        discard self.advance()

    let text: string = self.source[self.start ..< self.current]
    
    if self.keywords.contains(text):
        self.addToken(self.keywords[text])
    else:
        self.addToken(TT_IDENTIFIER)

proc scanToken(self: var Scanner) = 
    let c: char = self.advance()
    case c
    of '(': self.addToken(TT_LEFT_PAREN)
    of ')': self.addToken(TT_RIGHT_PAREN)
    of '{': self.addToken(TT_LEFT_BRACE)
    of '}': self.addToken(TT_RIGHT_BRACE)
    of ',': self.addToken(TT_COMMA)
    of '.': self.addToken(TT_DOT)
    of '-': self.addToken(TT_MINUS)
    of '+': self.addToken(TT_PLUS)
    of ';': self.addToken(TT_SEMICOLON)
    of '*': self.addToken(TT_STAR)
    of '!':
        self.addToken(if self.match('='): TT_BANG_EQUAL else: TT_BANG)
    of '=':
        self.addToken(if self.match('='): TT_EQUAL_EQUAL else: TT_EQUAL)
    of '<':
        self.addToken(if self.match('='): TT_LESS_EQUAL else: TT_LESS)
    of '>':
        self.addToken(if self.match('='): TT_GREATER_EQUAL else: TT_GREATER)
    of '/':
        if self.match('/'):
            while self.peek() != '\n' and not self.isAtEnd():
                discard self.advance()
        else:
            self.addToken(TT_SLASH)
    of ' ', '\r', '\t': 
        discard
    of '\n':
        self.line += 1
    of '"': self.string()
    else:
        if isDigit(c):
            self.number()
        elif isAlphaAscii(c):
            self.identifier()
        else:
            error(self.line, "Unexpected character")

proc scanTokens*(self: var Scanner): seq[Token] = 
    while not self.isAtEnd():
        self.start = self.current 
        self.scanToken()

    self.tokens.add(newToken(TT_EOF, "", none(LiteralValue), self.line))

