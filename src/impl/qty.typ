#import "num.typ": num
#import "unit.typ": unit as unit_

#let qty(
  number,
  unit,
  e: none,
  pm: none,
  pw: none,
  allow-quantity-breaks: false,
  quantity-product: sym.space.thin,
  separate-uncertainty: "bracket",
  ..options
) = {
  let result = {
    let u = unit_(
      unit,
      quantity-product: quantity-product,
      ..options
    )
    num(
      number,
      exponent: e,
      uncertainty: pm,
      power: pw,
      separate-uncertainty: separate-uncertainty,
      separate-uncertainty-unit: if separate-uncertainty == "repeat" { u },
      ..options
    )
    u
  }
  return if allow-quantity-breaks {
    result
  } else {
    box(result)
  }

}

#let qty-range(
  left-number,
  right-number,
  unit,
  range-units: "repeat",
  range-phrase: " to ",
  range-open-phrase: none,
  ..options
) = {
  if range-units == "repeat" {
    if range-open-phrase == none {
      [#qty(left-number, unit)#range-phrase#qty(right-number, unit)]
    } else {
      [#range-open-phrase#qty(left-number, unit)#range-phrase#qty(right-number, unit)]
    }
  }
  if range-units == "bracket" {
    if range-open-phrase == none {
      [(#num(left-number)#range-phrase#num(right-number)) #unit_(unit)]
    } else {
      [(#range-open-phrase#num(left-number)#range-phrase#num(right-number)) #unit_(unit)]
    }
  }
  if range-units == "single" {
    [#num(left-number)#range-phrase#num(right-number) #unit_(unit)]
  }
}
