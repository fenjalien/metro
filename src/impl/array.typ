#import "num.typ"
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

#let process-numbers(typ, numbers, joiner, options) = {
  let exponents = options.at(typ + "-exponents")
  let exponent = if exponents != "individual" {
    let first = num.parse-number(num.get-options(options), numbers.first(), full: true)
    
    num.process(num.get-options(options), ..first, none).at(3)
    
    options.fixed-exponent = int(first.at(3))
    options.exponent-mode = "fixed"
    options.drop-exponent = true
  }

  let result = joiner(numbers.map(n => num.num(n, options)))
  if exponents == "combine-bracket" { 
    result = math.lr(options.at(typ + "-open-bracket") + result + options.at(typ + "-close-bracket"))
  }
  return result + exponent
}

#let num-list(numbers, options) = {
  options = combine-dict(options, default-options)
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
    options
  )

}

#let num-product(numbers, options) = {
  options = combine-dict(options, default-options, only-update: true)
  return process-numbers(
    "product",
    numbers,
    numbers => if options.product-mode == "symbol" {
      math.equation(numbers.join(options.product-symbol))
    } else {
      numbers.join(options.product-phrase)
    },
    options
  )

}

#let num-range(n1, n2, options) = {
  options = combine-dict(options, default-options, only-update: true)

  return process-numbers(
    "range",
    (n1, n2),
    numbers => {
      options.range-open-phrase
      numbers.join(options.range-phrase)
    },
    options
  )
}