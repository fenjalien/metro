#import "num/num.typ"
#import "qty.typ"
#import "unit.typ" as unit_
#import "/src/utils.typ": combine-dict


#let default-options = (
  list-close-bracket: sym.paren.r,
  list-exponents: "individual",
  list-final-separator: [ and ],
  list-independent-prefix: false,
  list-open-bracket: sym.paren.l,
  list-pair-separator: [ and ],
  list-separator: [, ],
  list-units: "repeat",
  product-close-bracket: sym.paren.r,
  product-exponents: "individual",
  product-independent-prefix: false,
  product-mode: "symbol",
  product-open-bracket: sym.paren.l,
  product-phrase: [ by ],
  product-symbol: sym.times,
  product-units: "repeat",
  range-close-bracket: sym.paren.r,
  range-exponents: "individual",
  range-independent-prefix: false,
  range-open-bracket: sym.paren.l,
  range-open-phrase: none,
  range-phrase: [ to ],
  range-units: "repeat"
)

#let process-numbers(typ, numbers, joiner, options, unit: none) = {
  let exponents = options.at(typ + "-exponents")
  let units = options.at(typ + "-units")

  if unit != none {
    unit = unit_.unit(unit, options + qty.get-options(options))
  }

  let exponent = if exponents != "individual" {
    let first = num.parse(num.get-options(options), numbers.first(), full: true)

    num.process(num.get-options(options), ..first, none).at(3)

    options.fixed-exponent = int(first.at(3))
    options.exponent-mode = "fixed"
    options.drop-exponent = true
  }

  let repeated-unit = if units == "repeat" { unit }
  let result = joiner(numbers.map(n => num.num(n, options) + repeated-unit))
  
  if exponents == "combine-bracket" or (unit != none and units == "bracket") { 
    result = math.lr(options.at(typ + "-open-bracket") + result + options.at(typ + "-close-bracket"))
  }

  return result + exponent + if repeated-unit == none { unit }
}


#let qty-list(numbers, unit: none, options) = {
  options = combine-dict(options,  default-options)
  return process-numbers(
    "list",
    numbers,
    numbers => if numbers.len() == 2 {
      numbers.join(options.list-pair-separator)
    } else {
      let last = numbers.pop()
      numbers.join(options.list-separator)
      options.list-final-separator
      last
    },
    options,
    unit: unit
  )
}

#let num-list = qty-list.with(unit: none) 

#let qty-product(numbers, options, unit: none) = {
  options = combine-dict(options, default-options)
  return process-numbers(
    "product",
    numbers,
    numbers => if options.product-mode == "symbol" {
      math.equation(numbers.join(options.product-symbol))
    } else {
      numbers.join(options.product-phrase)
    },
    options,
    unit: unit
  )
}

#let num-product = qty-product.with(unit: none)

#let qty-range(n1, n2, options, unit: none) = {
  options = combine-dict(options, default-options)

  return process-numbers(
    "range",
    (n1, n2),
    numbers => {
      options.range-open-phrase
      numbers.join(options.range-phrase)
    },
    options,
    unit: unit
  )
}

#let num-range = qty-range.with(unit: none)