#import "units.typ"
#import "prefixes.typ"
#import "parsers.typ": display-units, parse-math-units, parse-string-units, tothe, raiseto, qualifier

#let _state-default = (
  units: units._dict,
  prefixes: prefixes._dict,
  prefix-power-tens: prefixes._power-tens,
  powers: (
    square: raiseto([2]),
    cubic: raiseto([3]),
    squared: tothe([2]),
    cubed: tothe([3])
  ),
  qualifiers: (:),


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

  delimiter: " ",
)

#let _state = state("metro-setup", _state-default)

#let metro-reset() = _state.update(_ => return _state-default)

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

#let declare-unit(unt, symbol) = _state.update(s => {
  s.units.insert(unt, symbol)
  return s
})

#let create-prefix = math.class.with("unary")

#let declare-prefix(prefix, symbol, power-tens) = _state.update(s => {
  s.prefixes.insert(prefix, symbol)
  s.prefix-power-tens.insert(prefix, power-tens)
  return s
})

#let declare-power(before, after, power) = _state.update(s => {
  s.powers.insert(before, raiseto([#power]))
  s.powers.insert(after, tothe([#power]))
  return s
})

#let declare-qualifier(quali, symbol) = _state.update(s => {
  s.qualifiers.insert(quali, qualifier(symbol))
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
