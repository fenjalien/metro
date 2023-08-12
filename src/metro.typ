#import "units.typ"
#import "prefixes.typ"
#import "parsers.typ": display-units, parse-math-units, parse-string-units, tothe, raiseto, qualifier
#import "parse_number.typ"

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
  allow-breaks: false,

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
/// Format a number.
///
/// - number (float, integer, content): The number to format.
/// - e (integer): Exponent (optional). The exponent is applied to both the
///            number and the uncertainty (pm) - if given. 
/// - pm (float, integer, content): Uncertainty of the value. 
/// - times (content): Symbol to use between number and factor 10^...
/// - decimal-marker (string): The decimal marker used in the output is controlled with this parameter. 
/// - group-digits (boolean): Whether to group digits in long numbers. 
/// - group-size (integer): The size of digit groups. 
/// - group-sep (integer): The separating token to use between digit groups. 
/// - group-min-digits (integer): The minimum number of consecutive digits for digit grouping to kick in. 
/// - tight (boolean): Whether to use tight display (reduces spaces between entities). 
/// - implicit-plus (boolean): If set to `true`, `+` will be added in front of positive numbers. 
#let num-impl(
  number,
  e: none, 
  pm: none,
  times: sym.dot,
  decimal-marker: ".",
  group-digits: true,
  group-size: 3,
  group-sep: sym.space.thin,
  group-min-digits: 5,
  tight: false,
  implicit-plus: false,
  ..options
) = {
  assert(group-size > 0, message: "The group size needs to be greater than 0")

  let num-str = parse_number.get-num-str(number, decimal-marker)
  let e-pos = num-str.position("e")
  if e-pos != none {
    let (number, exp) = num-str.split("e")
    num-str = number
    if exp.starts-with("+") { exp = $exp.slice(#1)$ }
    else if exp.starts-with("-") { exp = $-exp.slice(#1)$ }
    e = $exp$
  }

  let decimal-pos = parse_number.get-decimal-pos(num-str, decimal-marker)
  
  if pm != none {
    pm = parse_number.get-num-str(pm, decimal-marker)
    let num-decimals = parse_number.get-num-decimals(num-str, decimal-marker)
    let num-decimals-pm = parse_number.get-num-decimals(pm, decimal-marker)

    if num-decimals < num-decimals-pm {
      if num-decimals == 0 and not num-str.ends-with(".") { num-str += decimal-marker}
      num-str += "0" * (num-decimals-pm - num-decimals)
    } else if num-decimals > num-decimals-pm {
      if num-decimals-pm == 0 and not pm.ends-with(".") { pm += decimal-marker}
      pm += "0" * (num-decimals - num-decimals-pm)
    } 
    
    if group-digits {
      pm = parse_number.group-digits(pm, group-size, group-sep, group-min-digits, decimal-marker)
    }
  }

  
  
  if group-digits {
    num-str = parse_number.group-digits(num-str, group-size, group-sep, group-min-digits, decimal-marker)
  }
  
  if num-str.starts-with("-") {
    num-str = $-#num-str.slice(1)$
  } else if implicit-plus {
    num-str = $+#num-str$
  }

  
  
  let power = if e == none { none } else { 
    if tight { $#h(0pt)#times#h(0pt)10^#e$ }
    else { $#times 10^#e$ }
  }
  
  number = num-str
  if pm != none {
    if type(pm) in ("float", "integer") { pm = $#str(pm)$ }
    if type(number) in ("float", "integer") { number = $#str(number)$ }
    let pmspacing = if tight { none } else { sym.space.thin }
    number = number + pmspacing + sym.plus.minus + pmspacing + pm
    if power != none { number = $(number)$}
  }
  
  $#number#power$
}



#let num(number, e: none, pm: none, ..options) = _state.display(s => {
  return num-impl(number, e: e, pm: pm, .._update-dict(options.named(), s))
})



#let qty(
  number, 
  units, 
  e: none, 
  pm: none,
  ..options
) = _state.display(s => {
  assert(options.pos().len() == 0, message: "Unexpected positional arguments for qty()")
  let options = _update-dict(options.named(), s)

  let result = {
    let number = num(number, e: e, pm: pm, ..options)
    if pm != none and e == none { number = $(number)$ }
    number
    sym.space.thin
    unit(units, ..options)
  }
  if not options.allow-breaks { 
    result = $#result$
  }
  result
})