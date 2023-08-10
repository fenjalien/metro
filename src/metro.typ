#import "units.typ"
#import "prefixes.typ"
#import "parsers.typ": display-units, parse-math-units, parse-string-units

#let _state = state("metro-setup", (
  units: units._dict,
  prefixes: prefixes._dict,


  // quantites
  times: sym.dot,

  // Unit outupt options
  inter-unit-product: sym.space.thin,
  per-symbol: sym.slash,
  bracket-unit-denominator: true,
  per-mode: "power",
  power-half-as-sqrt: false,
  qualifier-mode: "subscript",
  qualifier-phrase: "",
  sticky-per: false,

  interpreted-delimeter: "#",

  delimiter: " ",
))

#let _update-dict(new, old) = {
  for (k, v) in new {
    old.insert(k, v)
  }
  return old
}



#let metro-setup(..options) = _state.update(s => {
  return _update-dict(options.named(), s)
})




#let _unit(input, options) = {
  // return parse-string-units(input, options)
  let t = type(input)
  return display-units(
    if t == "content" {
      parse-math-units(input, options)
    } else if t == "string" {
      parse-string-units(input, options)
    } else {
      panic("Cannot parse input type " + t)
    },
    options, 
    top: true
  )
}

#let unit(input, ..options) = _state.display(s => {
  return _unit(input, _update-dict(options.named(), s))
})

#let declare-unit(unt, symbol, ..options) = _state.update(s => {
  s.units.insert(unt, unit(symbol, options))
  return s
})

#let declare-prefix(prefix, symbol, ..options) = _state.update(s => {
  s.prefixes.insert(prefix, unit(symbol, options))
  return s
})

#let _num(number, e, pm, options) = {
  assert(type(number) in ("float", "integer"))
  number = str(number)
  if pm != none {
    if type(pm) in ("float", "integer") { 
      pm = str(pm)
    }
    number = "(" + number + sym.plus.minus + pm + ")"
  }

  number = number.replace("-", sym.minus)
  $number$

  if e == none {
    none
  } else {
    $#s.times 10^#e$
  }
}

#let num(number, e: none, pm: none, ..options) = _state.display(s => {
  return _num(number, e, pm, _update-dict(options.named(), s))
})

#let qty(
  number, 
  units, 
  e: none, 
  pm: none,
  ..options
) = _state.display(s => {
  let options = _update-dict(options.named(), s)

  let result = {
    _num(number, e, pm, options)
    sym.space.thin
    _unit(units, options)
  }
  // if not allowbreaks { 
  //   result = $#result$
  // }

  result
})
