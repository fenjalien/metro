#import "@preview/t4t:0.3.2": is
#import "/src/utils.typ": combine-dict, content-to-string

#let default-options = (
  // parsing
  input-decimal-markers: ("\.", ","),
  retain-explicit-decimal-marker: false,
  retain-explicit-plus: false,
  retain-negative-zero: false,
  retain-zero-uncertainty: false,

  // post-processing
  // drop-exponent: false,
  // drop-uncertainty: false,
  // drop-zero-decimal: false,
  // exponent-mode: "input",
  // exponent-thresholds: (-3, 3),
  // fixed-exponent: 0,
  minimum-integer-digits: 0,
  minimum-decimal-digits: 0,
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
  separate-uncertainty: "bracket",
  separate-uncertainty-unit: none,
)

#let full-number-pattern = regex("^(?P<sign>[-+])?(?P<trunc>\d+)?(?:\.(?P<fract>\d+))?(?:[eE](?P<exp>[-+]?\d+))?(?:\^(?P<power>[-+]?\d+))?$")
#let number-pattern = regex("^(?P<sign>[-+])?(?P<trunc>\d+)?(?:\.(?P<fract>\d+))?$")

#let number-to-string(number) = {
  number = if is.content(number) {
    if is.sequence(number) {
      number.children.map(c => c.text).join()
    } else {
      number.text
    }
  } else {
    str(number)
  }.replace("-", sym.minus)

  let sign = if number.starts-with(sym.minus) {
    sym.minus
    // For some reason strings get indexed by byte? minus is unicode
    number = number.slice(3)
  } else if number.starts-with(sym.plus) {
    sym.plus
    // Plus is ascii
    number = number.slice(1)
  }

  return (sign, number)
}


#let num(
  number,
  exponent: none, 
  uncertainty: none,
  power: none,
  ..options
) = {

  options = combine-dict(options.named(), default-options, only-update: true)

  let analyse-number(number, full: false) = {
    let typ = type(number)
    if typ == content {
      number = content-to-string(number)
    } else if typ in (int, float) {
      number = str(number)
    } else if typ != str {
      panic("Unknown number format: ", number)
    }
    let input-decimal-markers = str(options.input-decimal-markers.join("|")).replace(sym.minus, "-").replace(sym.plus, "+")
    let basic-float = "([-+]?\d*(?:(?:" + input-decimal-markers + ")\d*)?)"
    let result = number.replace(sym.minus, "-").replace(sym.plus, "+").match(regex({
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
        "(?:[eE]" + basic-float + ")?"
        // Power
        "(?:\^" + basic-float + ")?"
      }
      "$"
    }))
    assert(result != none, message: "Cannot match number: " + number)
    return result.captures
    // return if full {
    //   result.captures
    // } else {
    //   result = result.captures
    //   if result.at(2) != none {
    //     result.insert(2, options.output-decimal-marker)
    //   }
    //   result.map(x => if x == none { "" } else { x }).join()
    // }
  }

  let group-digits(input, rev: true) = {
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

  let spacing = if not options.tight-spacing {
    sym.space.thin
  }

  let (sign, integer, decimal, exp, pwr) = analyse-number(number, full: true)
  if integer == none {
    integer = ""
  }
  if decimal == none {
    decimal = ""
  }
  if exp != none {
    exponent = exp
  }
  if pwr != none {
    power = pwr
  }

  if integer.len() < options.minimum-integer-digits {
    integer = "0" * (options.minimum-integer-digits - integer.len()) + integer
  }
  if decimal.len() < options.minimum-decimal-digits {
    decimal += "0" * (options.minimum-decimal-digits - decimal.len())
  }

  if options.group-digits in ("all", "decimal", "integer") {
    if options.group-digits in ("all", "integer") and integer.len() >= options.group-minimum-digits {
      integer = group-digits(integer)
    }
    if options.group-digits in ("all", "decimal") and decimal.len() >= options.group-minimum-digits {
      decimal = group-digits(decimal, rev: false)
    }
  }

  let mantissa = {
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
  }

  let print-mantissa = options.print-unity-mantissa or mantissa not in ("1", "")

  if uncertainty != none {
    uncertainty = analyse-number(uncertainty)
    if uncertainty.at(2) != none {
      uncertainty.insert(2, options.output-decimal-marker)
    }
    uncertainty = spacing + if uncertainty.first() == "-" { sym.minus.plus } else { sym.plus.minus } + spacing + uncertainty.slice(1).join()
  }

  if exponent != none {
    exponent = analyse-number(exponent)
    if exponent.at(2) != none {
      exponent.insert(2, options.output-decimal-marker)
    }
    let sign = exponent.first()
    exponent = exponent.slice(1).join()
    if exponent != "0" or options.print-zero-exponent {
      if sign == "-" or options.print-implicit-plus or options.print-exponent-implicit-plus {
        exponent = sign + exponent
      }
      exponent = if options.output-exponent-marker != none {
        options.output-exponent-marker + exponent
      } else {
        math.attach(if print-mantissa {spacing + options.exponent-product + spacing } + options.exponent-base, t: exponent)
      }
    } else {
      exponent = none
    }
  }

  if power != none {
    power = analyse-number(power)
    if power.at(2) != none {
      power.insert(2, options.output-decimal-marker)
    }
    power = power.join()
  }

  let is-negative = sign == "-" and (mantissa != "0" or options.retain-negative-zero)

  let bracket-ambiguous-numbers = options.bracket-ambiguous-numbers and exponent != none and uncertainty != none
  let bracket-negative-numbers = options.bracket-negative-numbers and is-negative

  // Return
  return math.equation({
    if bracket-ambiguous-numbers {
      "("
    }
    if options.separate-uncertainty == "bracket" and uncertainty != none {
      "("
    }
    if bracket-negative-numbers {
      "("
    } else if is-negative {
      sym.minus
    } else if options.print-implicit-plus or options.print-mantissa-implicit-plus or (sign == "+" and options.retain-explicit-plus) {
      sym.plus
    }

    if print-mantissa {
      math.attach(mantissa, t: power)
    }

    if bracket-negative-numbers {
      ")"
    }
    if options.separate-uncertainty == "repeat" and uncertainty != none {
      options.separate-uncertainty-unit
    }
    uncertainty
    if bracket-ambiguous-numbers {
      ")"
    }
    exponent
    if options.separate-uncertainty == "bracket" and uncertainty != none {
      ")"
    }
  })
}

// #let num(
//     number,
//     e: none,
//     pm: none,
//     ..options
//   ) = {
  
//   return _num(
//     number,
//     exponent: e,
//     uncertainty: pm,
//   )
// }