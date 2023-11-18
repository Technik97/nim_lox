import std/strutils

import error

proc run(source: string) = 
    let tokens = source.splitWhitespace()
    for token in tokens:
      echo token

proc runFile*(path: string) =
  run(readFile(path))

proc runPrompt* = 
  while true:
    stdout.write("> ")
    let line = readLine(stdin)
    if line == "":
      break

    if hadError:
      quit(65)

    run(line)