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
  milli: milli,
  centi: centi,
  kilo: kilo,
)


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
