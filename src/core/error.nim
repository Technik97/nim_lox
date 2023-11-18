var hadError* = false

proc report(line: int, where: string, msg: string) = 
  stderr.write("[line " & $line & "] Error" & where & ": " & msg & "\n")
  hadError = true

proc error*(line: int, msg: string) = 
  report(line, "", msg)