#import "/src/utils.typ": combine-dict, content-to-string

#let default-options = (
  // parsing
  input-decimal-markers: ("\.", ","),
  retain-explicit-decimal-marker: false,
  retain-explicit-plus: false,
  retain-negative-zero: false,
  retain-zero-uncertainty: false,
  parse-numbers: auto,

  // post-processing
  drop-exponent: false,
  drop-uncertainty: false,
  drop-zero-decimal: false,
  exponent-mode: "input",
  exponent-thresholds: (-3, 3),
  fixed-exponent: 0,
  minimum-integer-digits: 0,
  minimum-decimal-digits: 0,

  // Printing
  bracket-negative-numbers: false,
  digit-group-size: 3,
  digit-group-first-size: 3,
  digit-group-other-size: 3,
  exponent-base: "10",
  exponent-product: sym.times,
  group-digits: "all",
  group-minimum-digits: 5,
  group-separator: sym.space.thin,
  output-close-uncertainty: ")",
  output-decimal-marker: ".",
  output-exponent-marker: none,
  output-open-uncertainty: "(",
  print-implicit-plus: false,
  print-exponent-implicit-plus: false,
  print-mantissa-implicit-plus: false,
  print-unity-mantissa: true,
  print-zero-exponent: false,
  print-zero-integer: true,
  tight-spacing: false,
  bracket-ambiguous-numbers: true,
  zero-decimal-as-symbol: false,
  zero-symbol: sym.bar.h,

  // qty
  separate-uncertainty: "",
  separate-uncertainty-unit: none,
)


#let parse-number(options, number, full: false) = {
  let typ = type(number)
  let result = if typ == content {
    content-to-string(number)
  } else if typ in (int, float) {
    str(number)
  } else if typ == str {
    number
  }

  if result == none {
    if options.parse-numbers == true {
      panic("Unknown number format: ", number)
    }
    return (auto,) * 5
  }

  let input-decimal-markers = str(options.input-decimal-markers.join("|")).replace(sym.minus, "-").replace(sym.plus, "+")
  let basic-float = "([-+]?\d*(?:(?:" + input-decimal-markers + ")\d*)?)"
  result = result.replace(sym.minus, "-").replace(sym.plus, "+").replace(" ", "").match(regex({
    "^"
    // Sign
    "([-+])?"
    // Integer
    "(\d+)?"
    // Decimal
    "(?:"
      "(?:"
        input-decimal-markers
      ")"
      "(\d*)"
    ")?" 
    if full {
      // Exponent
      "(?:[eE](.*?))?"
      // Power
      "(?:\^(.*?))?"
    }
    "$"
  }))

  return if result == none {
    if options.parse-numbers == true {
      panic("Cannot match number: " + repr(number))
    }
    (auto,) * 5
  } else {
   result.captures
  }
}


#let group-digits(options, input, rev: true) = {
  let (first, other) = if options.digit-group-size != 3 {
    (options.digit-group-size,) * 2
  } else {
    (options.digit-group-first-size, options.digit-group-other-size)
  }

  let input = if rev {
    input.split("").slice(1, -1).rev()
  } else {
    input
  }

  let len = input.len()
  let start = calc.rem(first, input.len())
  let result = (
    input.slice(0, start),
    ..for i in range(start, len, step: other) {
      (input.slice(i, calc.min(i + other, len)),)
    }
  )

  return if rev {
    result.map(x => x.rev().join()).rev()
  } else {
    result
  }.join(options.group-separator)
}

#let check-exponent-thresholds(options, exp) = (options.exponent-mode == "scientific" or exp - 1 < options.exponent-thresholds.first() or exp+1 > options.exponent-thresholds.last())

#let non-zero-integer-regex = regex("[^0]")

#let process-exponent(options, exp) = {
    let exponent = parse-number(options, exp)
    if exponent.all(x => x == auto) {
      exponent = (
        none, // sign
        exp, // The not parsed exponent
        none // Decimal
      )
    }

    if exponent.at(2) != none {
      exponent.insert(2, options.output-decimal-marker)
    }
    let sign = exponent.first()
    exponent = exponent.slice(1).join()
    if exponent != "0" or options.print-zero-exponent {
      if sign == "-" or options.print-implicit-plus or options.print-exponent-implicit-plus {
        exponent = if sign == "-" { sym.minus } else {sym.plus} + exponent
      }
      exponent = if options.output-exponent-marker != none {
        options.output-exponent-marker + exponent
      } else {
        math.attach(if options.print-mantissa {options.spacing + options.exponent-product + options.spacing } + options.exponent-base, t: exponent)
      }
    } else {
      exponent = none
    }
    return exponent
}

#let process-power(options, pwr) = {
  let power = parse-number(options, pwr)
  if power.all(x => x == auto) {
    return pwr
  }

  if power.at(2) != none {
    power.insert(2, options.output-decimal-marker)
  }
  return power.join()
}

#let process-uncertainty(options, pm) = {
  let uncertainty = parse-number(options, pm)
  if uncertainty.all(x => x == auto) {
    uncertainty = (
      none,
      pm,
      none
    )
  }
  if uncertainty.at(2) != none {
    uncertainty.insert(2, options.output-decimal-marker)
  }
  uncertainty = options.spacing + if uncertainty.first() == "-" { sym.minus.plus } else { sym.plus.minus } + options.spacing + uncertainty.slice(1).join()
  return uncertainty
}

#let process(options, sign, integer, decimal, exponent, power, uncertainty) = {
  
  let parse-numbers = not (integer == auto and decimal == auto)
  if not parse-numbers {
    (sign, integer, decimal, exponent, power) = (sign, integer, decimal, exponent, power).map(x => if x != auto { x })
  }
  if integer == none {
    integer = ""
  }
  if decimal == none {
    decimal = ""
  }

  if options.exponent-mode != "input" {
    exponent = if exponent == none { 0 } else { int(exponent) }
    if options.exponent-mode in ("scientific", "threshold") {
      let i = integer.position(non-zero-integer-regex)
      if i != none and i < integer.len() {
        let exp = integer.len() - i - 1 + exponent
        if check-exponent-thresholds(options, exp) {
          exponent = exp
          decimal = integer.slice(i+1) + decimal
          integer = integer.slice(i, i+1)
        }
      } else if integer.len() > 1 or integer == "0" {
        let i = decimal.position(non-zero-integer-regex)
        let exp = exponent - i - 1
        if check-exponent-thresholds(options, exp) {
          integer = decimal.slice(i, i+1)
          decimal = decimal.slice(i+1)
          exponent = exp
        }
      }
    } else if options.exponent-mode == "engineering" {
      if integer.len() > 1 {
        let l = calc.rem(integer.len(), 3)
        if l == 0 { l = 3 }
        exponent += integer.slice(l).len()
        decimal = integer.slice(l) + decimal
        integer = integer.slice(0, l)
      } else if integer == "0" {
        let i = decimal.position(non-zero-integer-regex)
        let l = 3 - calc.rem(i, 3)
        integer = decimal.slice(i, i+l)
        decimal = decimal.slice(i+l)
        exponent -= i+l
      }
    } else if options.exponent-mode == "fixed" {
      let n = options.fixed-exponent
      let i = exponent - n
      exponent = n
      if i < 0 {
        if integer.len() < -i {
          integer = "0" * -(i - integer.len()) + integer
        }
        decimal = integer.slice(i) + decimal
        integer = integer.slice(0, i)
      } else if i > 0 {
        if decimal.len() < i {
          decimal += "0" * (i - decimal.len())
        }
        integer += decimal.slice(0, i)
        decimal = decimal.slice(i)
      }
    }
  }

  if options.drop-zero-decimal and decimal.match(non-zero-integer-regex) == none {
    decimal = ""
  }

  // Minimum digits
  if integer.len() < options.minimum-integer-digits {
    integer = "0" * (options.minimum-integer-digits - integer.len()) + integer
  }
  if decimal.len() < options.minimum-decimal-digits {
    decimal += "0" * (options.minimum-decimal-digits - decimal.len())
  }

  if options.group-digits in ("all", "decimal", "integer") {
    let group-digits = group-digits.with(options)
    if options.group-digits in ("all", "integer") and integer.len() >= options.group-minimum-digits {
      integer = group-digits(integer)
    }
    if options.group-digits in ("all", "decimal") and decimal.len() >= options.group-minimum-digits {
      decimal = group-digits(decimal, rev: false)
    }
  }

  
  let mantissa = if parse-numbers {
    ""
    if (integer.len() == 0 or integer != "0") or options.print-zero-integer {
      if integer.len() == 0 {
        "0"
      } else {
        integer
      }
    }
    if decimal != "" or options.retain-explicit-decimal-marker {
      options.output-decimal-marker
      if options.zero-decimal-as-symbol and int(decimal) == 0 {
        options.zero-symbol
      } else {
        decimal
      }
    }
  } else {
    options.number
  }

  options.print-mantissa = options.print-unity-mantissa or mantissa not in ("1", "")
  
  options.spacing = if not options.tight-spacing {
    sym.space.thin
  }

  if options.drop-uncertainty {
    uncertainty = none 
  }
  if uncertainty != none {
    uncertainty = process-uncertainty(options, uncertainty)
  }

  if options.drop-exponent {
    exponent = none
  }

  if exponent != none {
    exponent = process-exponent(options, exponent)
  }

  if power != none {
    power = process-power(options, power)
  }

  return (options, sign, mantissa, exponent, power, uncertainty)
}

#let build(options, sign, mantissa, exponent, power, uncertainty) = {

  let is-negative = sign == "-" and (mantissa != "0" or options.retain-negative-zero)

  let bracket-ambiguous-numbers = options.bracket-ambiguous-numbers and exponent != none and uncertainty != none
  let bracket-negative-numbers = options.bracket-negative-numbers and is-negative

  // Return
  return math.equation({
    let output = if options.print-mantissa {
      math.attach(mantissa, t: power)
    }

    if bracket-negative-numbers {
      output = math.lr("(" + output + ")")
    } else if is-negative {
      output = sym.minus + output
    } else if options.print-implicit-plus or options.print-mantissa-implicit-plus or (sign == "+" and options.retain-explicit-plus) {
      output = sym.plus + output
    }

    if options.separate-uncertainty == "repeat" and uncertainty != none {
      output += options.separate-uncertainty-unit
    }

    output += uncertainty

    if bracket-ambiguous-numbers {
      output = math.lr("(" + output + ")")
    }

    output += exponent

    if options.separate-uncertainty == "bracket" and uncertainty != none {
      output = math.lr("(" + output + ")")
    }

    return output
  })
}

#let get-options(options) = combine-dict(options, default-options, only-update: true)

#let num(
  number,
  exponent: none, 
  uncertainty: none,
  power: none,
  options
) = {

  options = get-options(options)

  let (sign, integer, decimal, exp, pwr) = if options.parse-numbers != false {
    parse-number(options, number, full: true)
  } else {
    (auto,) * 5
  }
  options.number = number
  
  if exp not in (none, auto) {
    exponent = exp
  }
  if pwr not in (none, auto) {
    power = pwr
  }

  let (options, sign, mantissa, exponent, power, uncertainty) = process(options, sign, integer, decimal, exponent, power, uncertainty)

  return build(options, sign, mantissa, exponent, power, uncertainty)

}
