// SI prefixes
#let quecto = $q$
#let ronto = $r$
#let yocto = $y$
#let zepto = $z$
#let atto = $a$
#let femto = $f$
#let pico = $p$
#let nano = $n$
#let micro = $mu$
#let milli = $m$
#let centi = $c$
#let deci = $d$
#let deca = $d a$
#let deka = deca
#let hecto = $h$
#let kilo = $k$
#let mega = $M$
#let giga = $G$
#let tera = $T$
#let peta = $P$
#let exa = $E$
#let zetta = $Z$
#let yotta = $Y$
#let ronna = $R$
#let quetta = $Q$

#let _dict = (
  quecto: (quecto, -30),
  ronto: (ronto, -27),
  yocto: (yocto, -24),
  zepto: (zepto, -21),
  atto: (atto, -18),
  femto: (femto, -15),
  pico: (pico, -12),
  nano: (nano, -9),
  micro: (micro, -6),
  milli: (milli, -3),
  centi: (centi, -2),
  deci: (deci, -1),
  deca: (deca, 1),
  deka: (deka, 1),
  hecto: (hecto, 2),
  kilo: (kilo, 3),
  mega: (mega, 6),
  giga: (giga, 9),
  tera: (tera, 12),
  peta: (peta, 15),
  exa: (exa, 18),
  zetta: (zetta, 21),
  yotta: (yotta, 24),
  ronna: (ronna, 27),
  quetta: (quetta, 30)
)
#{
  for (k, v) in _dict {
    _dict.insert(k, (symbol: v.first(), power: v.last()))
  }
}


#{
  quecto += sym.zws
  ronto += sym.zws
  yocto += sym.zws
  zepto += sym.zws
  atto += sym.zws
  femto += sym.zws
  pico += sym.zws
  nano += sym.zws
  micro += sym.zws
  milli += sym.zws
  centi += sym.zws
  deci += sym.zws
  deca += sym.zws
  deka = deca
  hecto += sym.zws
  kilo += sym.zws
  // kilo = $k#sym.zws$
  mega += sym.zws
  giga += sym.zws
  tera += sym.zws
  peta += sym.zws
  exa += sym.zws
  zetta += sym.zws
  yotta += sym.zws
  ronna += sym.zws
  quetta += sym.zws
}
