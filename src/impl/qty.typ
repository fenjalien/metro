#import "num.typ": num
#import "unit.typ": unit

#let qty(
  number,
  unt,
  e: none,
  pm: none,
  allow-quantity-breaks: false,
  quantity-product: sym.space.thin,
  separate-uncertainty: "bracket",
  ..options
) = {
  let result = {
    let u = {
      $#quantity-product$
      unit(unt, ..options)
    }
    num(number, e: e, pm: pm, separate-uncertainty: separate-uncertainty, separate-uncertainty-unit: if separate-uncertainty == "repeat" { u }, ..options)
    u
  }
  return if allow-quantity-breaks {
    result
  } else {
    box(result)
  }

}