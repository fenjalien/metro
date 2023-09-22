#import "num.typ": num
#import "unit.typ": unit

#let qty(
  number,
  unt,
  e: none,
  pm: none,
  allow-quantity-breaks: false,
  quantity-product: sym.space.thin,
  ..options
) = {
  let result = {
    num(number, e: e, pm: pm, ..options)
    $#quantity-product$
    unit(unt, ..options)
  }
  return if allow-quantity-breaks {
    result
  } else {
    box(result)
  }

}