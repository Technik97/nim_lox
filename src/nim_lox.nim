import os 
import std/strutils

proc run(source: string) = 
    let tokens = source.splitWhitespace()
    for token in tokens:
      echo token

proc runFile(path: string) =
  run(readFile(path))

proc runPrompt() = 
  while true:
    stdout.write("> ")
    let line = readLine(stdin)
    if line == "":
      break
    run(line)

when isMainModule:
  let args = commandLineParams()
  if args.len > 1:
    echo "Usage: nimlox [script]"
    quit(64)
  elif args.len == 1:
    runFile(args[0])
  else:
    runPrompt()