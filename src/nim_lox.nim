import os

import core/startup

when isMainModule:
  let argsCount = paramCount()
  let args = commandLineParams()

  case argsCount:
  of 0:
    runPrompt()
  of 1:
    runFile(args[0])
  else:
    echo "Usage: nimlox [script]"
    quit(64)