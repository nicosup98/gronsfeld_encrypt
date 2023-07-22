import cliche, os, strutils,tables, sequtils,algorithm, sugar, strformat

proc gronsfeldEncrypt(data: string, key: string): string=
  result = ""
  let data = data.replace(" ","")
  if data.len != key.len: raise newException(IOError,"la clave y el texto(sin espacios) deben ser del mismo tamaño")
  if data.isEmptyOrWhitespace or key.isEmptyOrWhitespace: raise newException(IOError,"debe proporcionar todos los datos requeridos")
  
  let aToj = {'a'..'j'}
  let qToz = {'q'..'z'}
  let aToz = {'a'..'z'}.toSeq

  var encryptKeys = {1: {'0'..'9','k'..'z'}.toSeq,2: aToz.reversed, 3: {'a'..'p'}.toSeq}.toTable
  encryptKeys[3].insert({'0'..'9'}.toSeq,encryptKeys[3].len)
  encryptKeys[4] = concat({'e'..'z'}.toSeq,{'a'..'d'}.toSeq)

  let auxKeys = collect:
    for i,v in aToj.toSeq.pairs: {v: $i}
  
  let auxKeys2 = collect:
    for i,v in qToz.toSeq.pairs: {v: $i}

  for i,v in data.pairs:
    if ($v).isEmptyOrWhitespace:
      result &= v
      continue

    let posKey = ($key[i]).parseInt
    let currentKeys = encryptKeys[posKey]
    var j: int
    if posKey == 1 and v.toLowerAscii in aToj: j = currentKeys.find(auxKeys[v][0])
    elif posKey == 3 and v.toLowerAscii in qToz: j = currentKeys.find(auxKeys2[v][0])
    else: 
      j = currentKeys.find(v.toLowerAscii)
      result &= aToz[j]
      continue  

    result &= currentKeys[j]


when isMainModule:
  let params = commandLineParams()
  params.getOpt (k: " ")
  let data = paramStr(2)
  echo fmt"resultado: {gronsfeldEncrypt(data.strip,k)}, data original: {data.strip}, clave: {k}"
