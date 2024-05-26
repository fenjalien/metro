#import "/src/lib.typ"
#import lib: *
#import units: *
#import prefixes: *

#let example(it, dir) = {
  set text(size: 1.25em)
  let (a, b) = (
    eval(
      "#set text(font: \"Linux Libertine\")\n" + it.text, 
      mode: "markup",
      scope: dictionary(units) + dictionary(prefixes) + dictionary(lib)
    ),
    raw(it.text.replace("\\\n", "\\\n"), lang: "typ")
  )
  block(
    breakable: false,
    spacing: 0em,
    pad(
      left: 1em,
      stack(
        dir: dir,
        ..if dir == ltr {
          (a, 1fr, par(leading: 0.9em, b), 1fr)
        } else {
          (b, linebreak(), a)
        }
      )
    )
  )
  metro-reset()
}

#show raw.where(lang: "example"): it => {
  example(it, ltr)
}

#show raw.where(lang: "example-stack"): it => {
  example(it, ttb)
}

#show link: set text(blue)

#let param(term, t, default: none, description) = {
  if type(term) != array {
    term = (term,)
  }
  let types = (
    ch: "Choice",
    nu: "Number",
    li: "Literal",
    sw: "Switch",
    "in": "Integer"
  )


  if default != none {
    if t == "ch" {
      default = repr(default)
    }
    default = [(default: #raw(default))]
    // default = align(top + right, [(default: #raw(default))])
  }

  t = text(types.at(t, default: t), font: "Source Code Pro")
  block(breakable: false, {
    align(horizon, 
      stack(
        dir: ltr, 
        term.map(t => strong(t + "\n")).join(),
        h(0.6em),
        t,
        1fr,
        default
      )
    )
    block(pad(description, left: 2em), above: 0.65em)
  })
}

#align(center)[
  #text(16pt)[Metro]

  #link("https://github.com/fenjalien")[fenjalien] and #link("https://github.com/Mc-Zen")[Mc-Zen] \
  https://github.com/fenjalien/metro \
  Version 0.3.0 \
  Requires Typst 0.11+
]

#outline(indent: auto)

#pagebreak()

#set heading(numbering: "1.1")

= Introduction

The Metro package aims to be a port of the Latex package siunitx. It allows easy typesetting of numbers and units with options. This package is very early in development and many features are missing, so any feature requests or bug reports are welcome!

Metro's name comes from Metrology, the study scientific study of measurement.

= Usage
#set pad(left: 1em)

Typst 0.11.0+ is required. You can import the package using the package manager:
```typ
#import "@preview/metro:0.3.0": *
```
Or download the `src` folder and import `lib.typ`:
```typ
#import "/src/lib.typ": *
```

// The package provdides the functions:
//   - `#ang(angle, ..options)`
//   - `#num(number, ..options)`
//   - `#unit(unit, ..options)`
//   - `#qty(number, unit, ..options)`
//   - `#num-list(numbers, ..options)`
//   - `#num-product(numbers, ..options)`
//   - `#num-range(number1, number2, ..options)`
//   - `#qty-list(numbers, unit, ..options)`
//   - `#qty-product(numbers, unit, ..options)`
//   - `#qty-range(number1, number2, unit, ..options)`
//   - `#complex(number, ..options)`
//   - `#metro-setup(..options)`

== Options
```typ
#metro-setup(..options)
```

All provided functions in this package have options that can control how they parse, process and print items. They can normally be given as keyword arguments directly to the function, but this can get tedious if you want the same options to apply throughout the document. You can instead use the `metro-setup` function. Any options given as keyword arguments will then be applied to the relevant subsequent functions in the document.

All options and function arguments will use the following types:
/ Literal: Takes the given value directly. Input type is a string, content and sometimes a number.
/ Switch: On-off switches. Input type is a boolean.
/ Choice: Takes a limited number of choices, which are described separately for each option. Input type is a string.
/ Number: A float or integer.
/ Integer: An integer.


#pagebreak()
== Numbers
```typ
#num(number, e: none, pm: none, pwr: none, ..options)
```

Parses, processes then prints a number. The number can be given as an integer, a float, a string, as some plain content or math content! The different forms of input should extend to all other functions with arguments that take a number, they will be parsed all the same. However it should be noted that:
  - When giving a number as an integer or float with an exponent in the number, it will not be seen by Metro (e.g. `3.4e3` will be seen as `3400` and not "3.4 with an exponent of 3").
  - When using one of Metro's function within math mode, Typst considers dashes as subtraction symbols which breaks identifier names. So any options with dashes will not be able to be used when in math mode.

```example
#num(123)\
#num("1234")\
#num[12345]\
$num(0.123)$\
#num("0,1234")\
#num[.12345]\
#num(e: -4)[3.45]\
#num("-1", e: 10, print-unity-mantissa: false)
```

#param("number", "li")[
  The number to format.
]
#param("pm", "li", default: "none", [
  The uncertainty of the number.
])
#param("e", "li", default: "none", [
  The exponent of the number. It can also be given as an integer in the number argument when it is of type string or content. It should be prefixed with an "e" or "E".
  ```example
  #num("1e10")\
  #num[1E10]
  ```
])
#param("pwr", "li", default: "none", [
  The power of the number, it will be attached to the top. No processing is currently done to the power. It can also be passed as an integer in the number parameter when it is of type string or content. It should be prefixed after the exponent with an "^".
  ```example
  #num("1^2")\
  $num(1^2)$
  ```
])


=== Options
==== Parsing

#param("input-decimal-markers", "Array<Literal>", default: "('\.', ',')")[
  An array of characters that indicate the sepration between the integer and decimal parts of a number. More than one inupt decimal marker can be used, it will be converted by the package to the appropriate output marker.
]

#param("retain-explicit-decimal-marker", "sw", default: "false")[
  Allows a trailing decimal marker with no decimal part present to be printed.
  ```example
  #num[10.]\
  #num(retain-explicit-decimal-marker: true)[10.]
  ```
]

#param("retain-explicit-plus", "sw", default: "false")[
  Allows a leading plus sign to be printed.
  ```example
  #num[+345]\
  #num(retain-explicit-plus: true)[+345]
  ```
]

#param("retain-negative-zero", "sw", default: "false")[
  Allows a negative sign on an entirely zero value.
  ```example
  #num[-0]\
  #num(retain-negative-zero: true)[-0]
  ```
]

#param("parse-numbers", "sw", default: "auto")[
  Turns the entire parsing system on and off. It allows the use of arbitrary values in numbers. When the option is `auto`, numbers will be attempt to be parsed but will quietly stop if it fails to do so. The number will then be printed as given. If the option is `false`, no parsing will even be attempted. If `true`, Metro will panic if the number cannot be parsed.

  ```example
  $num(sqrt(3))$\
  #metro-setup(parse-numbers: false)
  $num(sqrt(4))$\
  #metro-setup(parse-numbers: true)
  // Will panic:
  // $num(sqrt(5))$\
  ```
]

==== Post Processing

#param("drop-exponent", "sw", default: "false", [
  When `true` the exponent will be dropped (_after_ the processing of exponent)

  ```example
  #num("0.01e3")\
  #num("0.01e3", drop-exponent: true)
  ```
])

#param("drop-uncertainty", "sw", default: "false")[
  When `true` the uncertainty will be dropped.
  ```example
  #num("0.01", pm: 0.02)\
  #num("0.01", pm: 0.02, drop-uncertainty: true)\
  ```
]

#param("drop-zero-decimal", "sw", default: "false")[
  When `true`, if the decimal is zero it will be dropped before setting the minimum numbers of digits.

  ```example
  #num[2.1]\
  #num[2.0]\
  #metro-setup(drop-zero-decimal: true)
  #num[2.1]\
  #num[2.0]\
  ```
]

#param("exponent-mode", "ch", default: "input")[
  How to convert the number to scientific notation. Note that the calculated exponent will be added to the given exponent for all options.

  / input: Does not perform any conversions, the exponent will be displayed as given. 
  / scientific: Converts the number such that the integer will always be a single digit.
  / fixed: Convert the number to use the exponent value given by the `fixed-exponent` option.
  / engineering: Converts the number such that the exponent will be a multiple of three.
  / threshold: Like the `scientific` option except it will only convert the number when the exponent would be outside the range given by the `exponent-thresholds` option.

  ```example
  #let nums = [
    #num[0.001]\
    #num[0.0100]\
    #num[1200]\
  ]
  #nums
  #metro-setup(exponent-mode: "scientific")
  #nums
  #metro-setup(exponent-mode: "engineering")
  #nums
  #metro-setup(exponent-mode: "fixed", fixed-exponent: 2)
  #nums
  ```
  #metro-reset()
]

#param("exponent-thresholds", "Array<Integer>", default: "(-3, 3)")[
  Used to control the range of exponents that won't trigger when the `exponent-mode` is "threshold". The first value is the minimum inclusive, and the last value is the maximum inclusive.

  ```example-stack
  #let inputs = (
    "0.001",
    "0.012",
    "0.123",
    "1",
    "12",
    "123",
    "1234"
  )

  #table(
    columns: (auto,)*3,
    [Input], [Threshold $-3:3$], [Threshold $-2:2$],
    ..for i in inputs {(
      num(i),
      num(i, exponent-mode: "threshold"),
      num(i, exponent-mode: "threshold", exponent-thresholds: (-2, 2)),
    )}
  )
  ```
]

#param("fixed-exponent", "Integer", default: "0")[
  The exponent value to use when `exponent-mode` is "fixed". When zero, this may be used to remove scientific notation from the input.

  ```example
  #num("1.23e4")\
  #num("1.23e4", exponent-mode: "fixed", fixed-exponent: 0)
  ```
]

#param("round-mode", "ch", default: "none")[
  How the package should round numerical input.

  / none: No rounding is performed.
  ```example
  #num(1.23456)\
  #num(14.23)
  ```
  / figures: Round to a number of significant figures.
  ```example
  #metro-setup(round-mode: "figures")
  #num(1.23456)\
  #num(14.23)
  ```
  / places: Round to a number of decimal places.
  ```example
  #metro-setup(round-mode: "places")
  #num(1.23456)\
  #num(14.23)
  ```
]

#param("round-precision", "Integer", default: "2")[
  Controls the number of significant figures or decimal places to round to.
  ```example
  #metro-setup(round-mode: "places", round-precision: 3)
  #num(1.23456)\
  #num(14.23)\
  #metro-setup(round-mode: "figures", round-precision: 3)
  #num(1.23456)\
  #num(14.23)\
  ```
]

#param("round-pad", "sw", default: "true")[
  Controls when rounding may "extend" a short number to more digits (or figures).
  ```example
  #metro-setup(round-mode: "figures", round-precision: 4)
  #num(12.3)\
  #num(12.3, round-pad: false)\
  ```
]

#param("round-direction", "ch", default: "nearest")[
  Determines which direction a value is rounded toward.

  / nearest: Gives the common outcome that values round depending on whether the preceding digit is greater or less than 5.
  ```example
  #metro-setup(round-mode: "places")
  #num(0.054)\
  #num(0.046)
  ```
  / down: Values are always rounded down. It may be thought of as "truncation".
  ```example
  #metro-setup(round-mode: "places", round-direction: "down")
  #num(0.054)\
  #num(0.046)
  ```
  / up: Values are always rounded up.
  ```example
  #metro-setup(round-mode: "places", round-direction: "up")
  #num(0.054)\
  #num(0.046)
  ```
]

#param("round-half", "ch", default: "up")[
  Determines how numbers that are exactly half are rounded to the the `"nearest"`.

  / up: The number is rounded up.
  ```example
  #metro-setup(round-mode: "figures", round-precision: 1)
  #num(0.055)\
  #num(0.045)\
  ```
  / even: The number is rounded to the nearest even part.
  ```example
  #metro-setup(
    round-mode: "figures",
    round-precision: 1,
    round-half: "even"
  )
  #num(0.055)\
  #num(0.045)\
  ```
]

#param("round-minimum", "nu", default: "0")[
  There are cases in which rounding will result in the number reaching zero. It may be desirable to show results as below a threshold value. This can be achieved by setting this option to the threshold value. There will be no effect when rounding to a number of significant figures as it is not possible to obtain the value zero in these cases.

  ```example
  #metro-setup(round-mode: "places")
  #num(0.0055)\
  #num(0.0045)\
  #metro-setup(round-minimum: 0.01)
  #num(0.0055)\
  #num(0.0045)\
  ```
]

#param("round-zero-positive", "sw", default: "true")[
  When rounding negative numbers to a fixed number of places, a zero value may result. Usually this is expressed as an unsigned value, but in some cases retaining the negative sign may be desirable. This behaviour can be controlled using this option.

  ```example
  #metro-setup(round-mode: "places")
  #num(-0.001)\
  #metro-setup(round-zero-positive: false)
  #num(-0.001)
  ```
]

#param("minimum-decimal-digits", "Integer", default: "0")[
  May be used to pad the decimal component of a number to a given size.
  ```example
  #num(0.123)\
  #num(0.123, minimum-decimal-digits: 2)\
  #num(0.123, minimum-decimal-digits: 4)
  ```
]

#param("minimum-integer-digits", "Integer", default: "0")[
  May be used to pad the integer component of a number to a given size.
  ```example
  #num(123)\
  #num(123, minimum-integer-digits: 2)\
  #num(123, minimum-integer-digits: 4)
  ```
]

==== Printing

#param("group-digits", "ch", default: "all")[
  Whether to group digits into blocks to increase the ease of reading of numbers. Takes the values `all`, `none`, `decimal` and `integer`. Grouping can be acitivated separately for the integer and decimal parts of a number using the appropriately named values.

  ```example
  #num[12345.67890]\
  #num(group-digits: "none")[12345.67890]\
  #num(group-digits: "decimal")[12345.67890]\
  #num(group-digits: "integer")[12345.67890]
  ```
]

#param("group-separator", "li", default: "sym.space.thin")[
  The separator to use between groups of digits.
  ```example
  #num[12345]\
  #num(group-separator: ",")[12345]\
  #num(group-separator: " ")[12345]
  ```
]

#param("group-minimum-digits", "in", default: "5")[
  Controls how many digits must be present before grouping is applied. The number of digits is considered separately for the integer and decimal parts of the number: grouping does not "cross the boundary".

  ```example
  #num[1234]\
  #num[12345]\
  #num(group-minimum-digits: 4)[1234]\
  #num(group-minimum-digits: 4)[12345]\
  #num[1234.5678]\
  #num[12345.67890]\
  #num(group-minimum-digits: 4)[1234.5678]\
  #num(group-minimum-digits: 4)[12345.67890]
  ```
]

#param("digit-group-size", "in", default: "3")[
  Controls the number of digits in each group. Finer control can be achieved using `digit-group-first-size` and `digit-group-other-size`: the first group is that immediately by the decimal point, the other value applies to the second and subsequent groupings.

  ```example
  #num[1234567890]\
  #num(digit-group-size: 5)[1234567890]\
  #num(digit-group-other-size: 2)[1234567890]
  ```
]

#param("output-decimal-marker", "li", default: ".")[
  The decimal marker used in the output. This can differ from the input marker.

  ```example
  #num(1.23)\
  #num(output-decimal-marker: ",")[1.23]
  ```
]

#param("exponent-base", "li", default: "10")[
  The base of an exponent.
  ```example
  #num(exponent-base: "2", e: 2)[1]
  ```
]

#param("exponent-product", "li", default: "sym.times")[
  The symbol to use as the product between the number and its exponent.
  ```example
  #num(e: 2, exponent-product: sym.times)[1]\
  #num(e: 2, exponent-product: sym.dot)[1]
  ```
]

#param("output-exponent-marker", "li", default: "none")[
  When not `none`, the value stored will be used in place of the normal product and base combination.
  ```example
  #num(output-exponent-marker: "e", e: 2)[1]\
  #num(output-exponent-marker: "E", e: 2)[1]
  ```
]

#param("bracket-ambiguous-numbers", "sw", default: "true")[
  There are certain combinations of numerical input which can be ambiguous. This can be corrected by adding brackets in the appropriate place.

  ```example
  #num(e: 4, pm: 0.3)[1.2]\
  #num(bracket-ambiguous-numbers: false, e: 4, pm: 0.3)[1.2]
  ```
]

#param("bracket-negative-numbers", "sw", default: "false")[
  Whether or not to display negative numbers in brackets.

  ```example
  #num[-15673]\
  #num(bracket-negative-numbers: true)[-15673]
  ```
]

#param("tight-spacing", "sw", default: "false")[
  Compresses spacing where possible.

  ```example
  #num(e: 3)[2]\
  #num(e: 3, tight-spacing: true)[2]
  ```
]

#param("print-implicit-plus", "sw", default: "false")[
  Force the number to have a sign. This is used if given and if no sign was present in the input.
  ```example
  #num(345)\
  #num(345, print-implicit-plus: true)
  ```
  It is possible to set this behaviour for the exponent and mantissa independently using `print-mantissa-implicit-plus` and `print-exponent-implicit-plus` respectively.
]

#param("print-unity-mantissa", "sw", default: "true")[
  Controls the printing of a mantissa of 1.
  ```example
  #num(e: 4)[1]\
  #num(e: 4, print-unity-mantissa: false)[1]
  ```
]

#param("print-zero-exponent", "sw", default: "false")[
  Controls the printing of an exponent of 0.
  ```example
  #num(e: 0)[444]\
  #num(e: 0, print-zero-exponent: true)[444]
  ```
]

#param("print-zero-integer", "sw", default: "true")[
  Controls the printing of an integer component of 0.
  ```example
  #num(0.123)\
  #num(0.123, print-zero-integer: false)
  ```
]

#param("zero-decimal-as-symbol", "sw", default: "false")[
  Whether to show entirely zero decimal parts as a symbol. Uses the symbol stroed using `zero-symbol` as the replacement.

  ```example
  #num[123.00]\
  #metro-setup(zero-decimal-as-symbol: true)
  #num[123.00]\
  #num(zero-symbol: [[#sym.bar.h]])[123.00]
  ```
]

#param("zero-symbol", "li", default: "sym.bar.h")[
  The symbol to use when `zero-decimal-as-symbol` is `true`.
]

#pagebreak()
== Units

```typ
#unit(unit, ..options)
```

Typsets a unit and provides full control over output format for the unit. The type passed to the function can be either a string or some math content.

When using the function in math mode, Typst accepts single characters but multiple characters together are expected to be variables. So Metro defines units and prefixes which be can imported to be used. #pad[
  ```typ
  #import "@preview/metro:0.2.0": unit, units, prefixes
  #unit($units.kg m/s^2$)
  // because `units` and `prefixes` here are modules you can import what you need
  #import units: gram, metre, second
  #import prefixes: kilo
  $unit(kilo gram metre / second^2)$
  // You can also just import everything instead
  #import units: *
  #import prefixes: *
  $unit(joule / mole / kelvin)$
  ```

  #unit($units.kg m/s^2$)\
  $unit(kilo gram metre / second^2)$\
  $unit(joule / mole / kelvin)$
]

When using strings there is no need to import any units or prefixes as the string is parsed. Additionally several variables have been defined to allow the string to be more human readable. You can also use the same syntax as with math mode. 
```example-stack
// String
#unit("kilo gram metre per square second")\
// Math equivalent
#unit($kilo gram metre / second^2$)\
// String using math syntax
#unit("kilo gram metre / second^2")
```

`per` used as in "metres _per_ second" is equivalent to a slash `/`. When using this in a string you don't need to specify a numerator.
```example-stack
#unit("metre per second")\
$unit(metre/second)$\

#unit("per square becquerel")\
#unit("/becquerel^2")
```

`square` and `cubic` apply their respective powers to the units after them, while `squared` and `cubed` apply to units before them. 
```example-stack
#unit("square becquerel")\
#unit("joule squared per lumen")\
#unit("cubic lux volt tesla cubed")
```

Generic powers can be inserted using the `tothe` and `raiseto` functions. `tothe` specifically is equivalent to using caret `^`.
```example-stack
#unit("henry tothe(5)")\
#unit($henry^5$)\
#unit("henry^5")

#unit("raiseto(4.5) radian")\
#unit($radian^4.5$)\
#unit("radian^4.5")
```

You can also use the `sqrt` function for half powers. If you want to maintain the square root, you must set the `power-half-as-sqrt` option.

```example
$unit(sqrt(H))$\
#unit("sqrt(H)", power-half-as-sqrt: true)\
```

Generic qualifiers are available using the `of` function which is equivalent to using an underscore `_`. Note that when using an underscore for qualifiers in a string with a space, to capture the whole qualifier use brackets `()`.
```example-stack
#unit("kilogram of(metal)")\
#unit($kilogram_"metal"$)\
#unit("kilogram_metal")

#metro-setup(qualifier-mode: "bracket")
#unit("milli mole of(cat) per kilogram of(prod)")\
#unit($milli mole_"cat" / kilogram_"prod"$)\
#unit("milli mole_(cat) / kilogram_(prod)")
```

=== Options

#param("inter-unit-product", "li", default: "sym.space.thin", [
The separator between each unit. The default setting is a thin space: another common choice is a centred dot.
```example
#unit("farad squared lumen candela")\
#unit("farad squared lumen candela", inter-unit-product: $dot.c$)
```
])


#param("per-mode", "ch", default: "power", [
  Use to alter the handling of `per`. 

  / power: Reciprocal powers
  ```example
  #unit("joule per mole per kelvin")\
  #unit("metre per second squared")
  ```

  / fraction: Uses the `math.frac` function (also known as `$ / $`) to typeset positive and negative powers of a unit separately.
  ```example
  #unit("joule per mole per kelvin", per-mode: "fraction")\
  #unit("metre per second squared", per-mode: "fraction")
  ```

  / symbol: Separates the two parts of a unit using the symbol in `per-symbol`. This method for displaying units can be ambiguous, and so brackets are added unless `bracket-unit-denominator` is set to `false`. Notice that `bracket-unit-denominator` only applies when `per-mode` is set to symbol.
  ```example
  #metro-setup(per-mode: "symbol")
  #unit("joule per mole per kelvin")\
  #unit("metre per second squared")
  ```
])

#param("per-symbol", "li", default: "sym.slash")[
  The symbol to use to separate the two parts of a unit when `per-symbol` is `"symbol"`.
  ```example-stack
  #unit("joule per mole per kelvin", per-mode: "symbol", per-symbol: [ div ])
  ```
]

#param("bracket-unit-denominator", "sw", default: "true")[
  Whether or not to add brackets to unit denominators when `per-symbol` is `"symbol"`.
  ```example-stack
  #unit("joule per mole per kelvin", per-mode: "symbol", bracket-unit-denominator: false)
  ```
]

#metro-setup(per-mode: "power")

#param("sticky-per", "sw", default: "false")[
  Normally, `per` applies only to the next unit given. When `sticky-per` is `true`, this behaviour is changed so that `per` applies to all subsequent units.
  ```example
  #unit("pascal per gray henry")\
  #unit("pascal per gray henry", sticky-per: true)
  ```
]

#param("qualifier-mode", "ch", default: "subscript")[
  Sets how unit qualifiers can be printed.
  / subscript:
  ```example-stack
  #unit("kilogram of(pol) squared per mole of(cat) per hour")
  ```

  / bracket:
  ```example-stack
  #unit("kilogram of(pol) squared per mole of(cat) per hour", qualifier-mode: "bracket")
  ```

  / combine: Powers can lead to ambiguity and are automatically detected and brackets added as appropriate.
  ```example
  #unit("deci bel of(i)", qualifier-mode: "combine")
  ```

  / phrase: Used with `qualifier-phrase`, which allows for example a space or other linking text to be inserted.
  ```example-stack
  #metro-setup(qualifier-mode: "phrase", qualifier-phrase: sym.space)
  #unit("kilogram of(pol) squared per mole of(cat) per hour")\
  #metro-setup(qualifier-phrase: [ of ])
  #unit("kilogram of(pol) squared per mole of(cat) per hour")
  ```
]

#param("power-half-as-sqrt", "sw", default: "false")[
  When `true` the power of $0.5$ is shown by giving the unit sumbol as a square root. This 
  ```example
  #unit("Hz tothe(0.5)")\
  #unit("Hz tothe(0.5)", power-half-as-sqrt: true)
  ```
]

#metro-reset()

#pagebreak()
== Quantities

```typ
#qty(number, unit, ..options)
```

This function combines the functionality of `num` and `unit` and formats the number and unit together. The `number` and `unit` arguments work exactly like those for the `num` and `unit` functions respectively.

```example
#qty(1.23, "J / mol / kelvin")\
$qty(.23, candela, e: 7)$\
#qty(1.99, "per kilogram", per-mode: "symbol")\
#qty(1.345, "C/mol", per-mode: "fraction")
```

=== Options

#param("allow-quantity-breaks", "sw", default: "false")[
  Controls whether the combination of the number and unit can be split across lines.
  ```example-stack
  #box(width: 3.25cm)[
    Some filler text #qty(10, "m")\
    #metro-setup(allow-quantity-breaks: true)
    Some filler text #qty(10, "m")
  ]
  ```
]

#param("quantity-product", "li", default: "sym.space.thin")[
  The product symbol between the number and unit.
  ```example-stack
  #qty(2.67, "farad")\
  #qty(2.67, "farad", quantity-product: sym.space)\
  #qty(2.67, "farad", quantity-product: none)
  ```
]

#param("separate-uncertainty", "ch", default: "bracket")[
  When a number has multiple parts, then the unit must apply to all parts of the number.

  / bracket: Places the entire numerical part in brackets and use a single unit symbol.
  ```example
  #qty(12.3, "kg", pm: 0.4)
  ```

  / repeat: Prints the unit for each part of the number.
  ```example
  #qty(12.3, "kg", pm: 0.4, separate-uncertainty: "repeat")
  ```

  / single: Prints only one unit symbol: mathematically incorrect.
  ```example
  #qty(12.3, "kg", pm: 0.4, separate-uncertainty: "single")
  ```
]

#pagebreak()
== List, Products and Ranges

```typ
#num-list(..numbers-options)
```

Lists of numbers may be processed using the `num-list` function. Each number should be given as a positional argument. The numbers are formatted using `num`.

```example
#num-list(10, 30, 50, 70)
```

```typ
#num-product(..numbers-options)
```

Runs of products can be created using the `num-product` function. It acts in the same way `num-list` does.

```example
#num-product(10, 30)
```

```typ
#num-range(number1, number2, ..options)
```

Simple ranges of numbers can be handled using the `num-range` function. It inserts a phrase or other text between the two numbers.

```example
#num-range(10, 30)
```

The above list, product and range functions also have a `qty` variant where the last positional argument will be considered as a unit.

```example
#qty-list(10, 30, 45, metre)\
#qty-product(10, 30, 45, metre)\
#qty-range(10, 30, metre)\
```

The above function names cannot be used in math mode, instead equivalently named functions are provided that have the dash removed (e.g. `num-list` and `numlist`).

=== Options

#param("list-separator", "li", default: "[, ]")[
  The separator to place between each item in the a list of numbers.

  ```example
  #num-list(0.1, 0.2, 0.3) \
  #num-list(
    list-separator: [; ],
    0.1, 0.2, 0.3,
  )
  ```
]

#param("list-final-separator", "li", default: "[ and ]")[
  The separator before the last item of a list.

  ```example
  #num-list(
    list-final-separator: [, ],
    0.1, 0.2, 0.3
  ) \ 
  #num-list(
    list-separator: [ and ],
    list-final-separator: [ and ],
    0.1, 0.2, 0.3
  )
  ```
]

#param("list-pair-separator", "li", default: "[ and ]")[
  The to use for exactly two items of a list.

  ```example
  #num-list(0.1, 0.2) \ 
  #num-list(
    list-pair-separator: [, and ],
    0.1, 0.2
  )
  ```
]

#param("product-mode", "ch", default: "symbol")[
  Products of numbers can be output using either a product symbol or a phrase.

  / symbol: The symbol in `product-symbol` is used.
  ```example
  #num-product(5, 100, 2)
  ```
  / phrase: The phrase in `product-phrase` is used.
  ```example
  #num-product(5, 100, 2, product-mode: "phrase")
  ```
]
#param("product-symbol", "li", default: "sym.times")[
  The symbol to use when `product-mode` is `"symbol"`.

  ```example
  #num-product(5, 100, 2, product-symbol: sym.dot.c)
  ```
]

#param("product-phrase", "li", default: "[ by ]")[
  The phrase to use when `product-mode` is `"phrase"`.

  ```example
  #num-product(5, 100, 2, product-symbol: [ BY ])
  ```
]

#param("range-open-phrase", "li", default: "none")[
  The phrase to open ranges with.

  ```example
  #num-range(10, 12)\
  #num-range(5, 100, range-open-phrase: "from ")
  ```
]

#param("range-phrase", "li", default: "[ to ]")[
  The word or symbol to be inserted between the two entries of the range.

  ```example
  #num-range(5, 100)\
  #num-range(5, 100, range-phrase: sym.dash)\
  ```
]

#param(("list-exponents", "product-exponents", "range-exponents"), "ch", default: "individual")[
  Controls how lists, products and ranges can be "compressed" by combining the exponent parts. 

  / individual: Leaves the exponent with the matching value.
  ```example
  #num-list("5e3", "7e3", "9e3", "1e4")\
  #num-product("5e3", "7e3", "9e3", "1e4")\
  #num-range("5e3", "7e3")
  ```
  / combine: The first exponent entry is taken and applied to all other entries, with the exponent itself placed at the end.
  ```example
  #metro-setup(
    list-exponents: "combine",
    product-exponents: "combine",
    range-exponents: "combine",
  )
  #num-list("5e3", "7e3", "9e3", "1e4")\
  #num-product("5e3", "7e3", "9e3", "1e4")\
  #num-range("5e3", "7e3")
  ```
  / combine-bracket: Like `"combine"` but the list, product or range is wrapped in brackets, with the exponent outside.
  ```example
  #metro-setup(
    list-exponents: "combine-bracket",
    product-exponents: "combine-bracket",
    range-exponents: "combine-bracket",
  )
  #num-list("5e3", "7e3", "9e3", "1e4")\
  #num-product("5e3", "7e3", "9e3", "1e4")\
  #num-range("5e3", "7e3")
  ```
]
#param(("list-units", "product-units", "range-units"), "ch", default: "repeat")[
  Determines how `qty-list`, `qty-product` and `qty-range` functions print units.

  / repeat: Each number will be printed with a unit.
  ```example
  #qty-list(2, 4, 6, 8, tesla)\
  #qty-product(2, 4, metre)\
  #qty-range(2, 4, degreeCelsius)
  ```

  / single: The unit will only be placed at the end of the collection.
  ```example
  #metro-setup(
    list-units: "single",
    product-units: "single",
    range-units: "single",
  )
  #qty-list(2, 4, 6, 8, tesla)\
  #qty-product(2, 4, metre)\
  #qty-range(2, 4, degreeCelsius)
  ```

  / bracket: Like `"single"` except brackets are placed around the collection.
  ```example
  #metro-setup(
    list-units: "bracket",
    product-units: "bracket",
    range-units: "bracket",
  )
  #qty-list(2, 4, 6, 8, tesla)\
  #qty-product(2, 4, metre)\
  #qty-range(2, 4, degreeCelsius)
  ```
  // no it doesn't, at least not yet
  // The option `product-units` also offers the settings *bracket-power* and *power*.
  // ```example
  // #qty-product(2, 4, metre, product-units: "bracket-power")\
  // #qty-product(2, 4, metre, product-units: "power")\
  // ```
]

#param(("list-open-bracket", "product-open-bracket", "range-open-bracket"), "li", default: "sym.paren.l")[
  The opening bracket to be used when the collection is placed in brackets.
]

#param(("list-close-bracket", "product-close-bracket", "range-close-bracket"), "li", default: "sym.paren.r")[
  The closing bracket to be used when the collection is placed in brackets.
]

#pagebreak()

== Complex Numbers
```typ
#complex(real, imag, ..unit-options)
```

Typesets the complex number, the first positional argument will be the real component and the second will be the coefficient of the imaginary component. If the second argument is either of the #link("https://typst.app/docs/reference/layout/angle/")[angle type] or ends in "deg" or "rad", the complex number will be considered to be in polar form and the first argument will be the radius. A unit can be optionally given as the third positional argument.

Note that when giving the angle as an angle type in radains, it will be output in degrees by default. This is due to angle types being unit agnostic. This behaviour can be changed with the `complex-angle-unit` option.

=== Options

#param("complex-mode", "ch", default: "input")[
  The format in which complex values are printed.

  / input: The complex value is printed as-given.
  ```example
  #complex(1, 1)\
  #complex(1, 45deg)\
  ```
  / cartesian: The output will be formatted in Cartesian form.
  ```example
  #metro-setup(complex-mode: "cartesian")
  #complex(1, 1)\
  #complex(1, 45deg, round-mode: "places")\
  ```
  / polar: The output will be formatted in polar form.
  ```example
  #metro-setup(complex-mode: "polar")
  #complex(1, 1, round-mode: "places", round-pad: false)\
  #complex(1, 45deg)\
  ```
]

#param("output-complex-root", "li", default: "math.upright(\"i\")")[
  The output complex root symbol.

  ```example
  #complex(1, 2, output-complex-root: "i")\
  #complex(1, 2, output-complex-root: "j")\
  ```
]

#param("complex-root-position", "ch", default: "after-number")[
  The position of the complex root can be adjusted to place it either before or after the associated numeral in a complex number by using this option.

  ```example
  #complex(67, -0.9)\
  #complex(67, -0.9, complex-root-position: "before-number")\
  ```
]

#param("complex-angle-unit", "ch", default: "degrees")[
  The output unit of the angle component of a complex number in polar form.
  ```example
  #complex(1, 1rad, ohm)\
  #complex(1, 1rad, complex-angle-unit: "radians", ohm)
  ```
]

#param("complex-symbol-angle", "li", default: "sym.angle")[
  The symbol used to denote the angle of a complex number in polar form.
  ```example
  #complex(1, 1deg, ohm, complex-symbol-angle: math.upright("A"))
  ```
]

#param("complex-symbol-degree", "li", default: "sym.degree")[
  The symbol use for the units of degrees of a complex number in polar form.
  ```example
  #complex(1, 1deg, ohm, complex-symbol-degree: math.upright("d"))
  ```
]

#param("print-complex-unity", "sw", default: "false")[
  When the complex part of a number is exactly 1, it is possible to either print or suppress the value.

  ```example
  #complex(0, 1, ohm)\
  #complex(0, 1, ohm, print-complex-unity: true)\
  ```
]

#pagebreak()

== Angles
```typ
#ang(..ang-options)
```

Typsets angles. The angle can be given as a single decimal number or 2 to 3 positional arguments of degrees, minutes and second, which is called the "arc format" in this document.

```example
#ang(10)\
#ang(12.3)\
#ang("4,5")\
#ang(1, 2, 3)\
#ang(0, 0, 1)\
#ang(10, 0, 0)\
#ang(0, 1)\
```

=== Options

#param("angle-mode", "ch", default: "input")[
  The format in which angles are printed.

  / input: The angle is printed as given.
  ```example
  #ang(2.67)\
  #ang(2, 3, 4)\
  ```
  / arc: The output will be formatted as an arc (degrees/minutes/seconds).
  ```example
  #metro-setup(angle-mode: "arc")
  #ang(2.67)\
  #ang(2,3,4)
  ```
  / decimal: The output will be formatted as a decimal value.
  ```example
  #metro-setup(angle-mode: "decimal")
  #ang(2.67)\
  #ang(2,3,4)
  ```
]

#param("number-angle-product", "li", default: "none")[
  The separator between the number and angle symbol. This is independent of the related `quantity-product` option used by the `qty` function.

  ```example
  #ang(2.67)\
  #ang(2.67, number-angle-product: sym.space)
  ```
]

#param("angle-separator", "li", default: "none")[
  The separation of the different parts of an angle when printed in arc format.
  ```example
  #ang(6, 7, 6.5)\
  #ang(6, 7, 6.5, angle-separator: sym.space)
  ```
]

#param("angle-symbol-degree", "li", default: "sym.degree")[
  The symbol to use for the degree unit of an arc angle.
]

#param("angle-symbol-minute", "li", default: "units.arcminute")[
  The symbol to use for the minute unit of an arc angle.
]

#param("angle-symbol-second", "li", default: "sym.arcsecond")[
  The symbol to use for the second unit of an arc angle.

  ```example
  #metro-setup(
    angle-symbol-degree: math.upright("d"),
    angle-symbol-minute: math.upright("m"),
    angle-symbol-second: math.upright("s"),
  )
  #ang(6, 7, 6.5)
  ```
]

#pagebreak()
= Meet the Units

The following tables show the currently supported prefixes, units and their abbreviations. Note that unit abbreviations that have single letter commands are not available for import for use in math. This is because math mode already accepts single letter variables.

#{
set figure(kind: "Table", supplement: "Table")

let generate(..units) = {
  units.pos().map(x => {
    let (name, command) = if type(x) == "array" {
      x
    } else {
      (x, x)
    }
    (name, raw(command), unit(command))
  }).join()
}

let headers = ([Unit], [Command], [Symbol])

figure(
  table(
    columns: 3,
    stroke: none,
    table.hline(),
    ..headers,
    table.hline(),
    ..generate(
      "ampere",
      "candela",
      "kelvin",
      "kilogram",
      "metre",
      "mole",
      "second"
    ),
    table.hline(),
  ),
  caption: [SI base units.]
)

figure(
  table(
    columns: 6,
    stroke: none,
    table.hline(),
    ..headers * 2,
    table.hline(),
    ..generate(
      "becquerel", "newton",
      ("degree Celsius", "degreeCelsius"), "ohm",
      "coulomb", "pascal",
      "farad", "radian",
      "gray", "siemens",
      "hertz", "sievert",
      "henry", "steradian",
      "joule", "tesla",
      "lumen", "volt",
      "katal", "watt",
      "lux", "weber"
    ),
    table.hline()
  ),
  caption: [Coherent derived units in the SI with special names and symbols.]
)

figure(
  table(
    columns: 3,
    stroke: none,
    table.hline(),
    ..headers,
    table.hline(),
    ..generate(
      "astronomicalunit",
      "bel",
      "dalton",
      "day",
      "decibel",
      "degree",
      "electronvolt",
      "hectare",
      "hour",
      "litre",
      ("", "liter"),
      ("minute (plane angle)", "arcminute"),
      ("minute (time)", "minute"),
      ("second (plane angle)", "arcsecond"),
      "neper",
      "tonne"
    ),
    table.hline(),
  ),
  caption: [Non-SI units accepted for use with the International System of Units.]
)

figure(
  table(
    columns: 3,
    stroke: none,
    table.hline(),
    ..headers,
    table.hline(),
    ..generate(
      "byte",
    ),
    table.hline(),
  ),
  caption: [Non-SI units.]
)

figure(
  table(
    columns: 8,
    stroke: none,
    table.hline(),
    ..([Prefix], [Command], [Symbol], [$10^x$]) * 2,
    table.hline(),
    ..((
      ("quecto", -30), ("deca", 1),
      ("ronto", -27), ("hecto", 2),
      ("yocto", -24), ("kilo", 3), 
      ("atto", -21), ("mega", 6),
      ("zepto", -18), ("giga", 9),
      ("femto", -15), ("tera", 12),
      ("pico", -12), ("peta", 15),
      ("nano", -9), ("exa", 18),
      ("micro", -6), ("zetta", 21),
      ("milli", -3), ("yotta", 24),
      ("centi", -2), ("ronna", 27),
      ("deci", -1), ("quetta", 30)
    ).map(x => (x.first(), raw(x.first()), unit(x.first()), num(x.last()))).join()),
    table.hline(),
  ),
  caption: [SI prefixes]
)
figure(
  table(
    columns: 4,
    stroke: none,
    table.hline(),
    [Prefix], [Command], [Symbol], [$2^x$],
    table.hline(),
    ..((
      ("kibi", 10),
      ("mebi", 20),
      ("gibi", 30),
      ("tebi", 40),
      ("pebi", 50),
      ("exbi", 60),
      ("zebi", 70),
      ("yobi", 80),
    ).map(x => (x.first(), raw(x.first()), unit(x.first()), num(x.last()))).join()),
    table.hline(),
  ),
  caption: [Binary prefixes]
)

let ge(..xs) = {
  let xs = xs.pos()
  for i in range(0, xs.len()-1, step: 2) {
    let name = xs.at(i)
    let abbr = xs.at(i+1)
    (name, raw(abbr), unit(abbr))
  }
}

page(
  margin: 1cm,
  figure(
    caption: [Unit abbreviations],
    stack(
      dir: ltr,
      table(
        columns: 3,
        stroke: none,
        table.hline(),
        [Unit], [Abbreviation], [Symbol],
        table.hline(),
        ..ge(
          "femtogram", "fg",
          "picogram", "pg",
          "nanogram", "ng",
          "microgram", "ug",
          "milligram", "mg",
          "gram", "g",
          "kilogram", "kg"
        ),
        table.hline(),
        ..ge(
          "picometre", "pm",
          "nanometre", "nm",
          "micrometre", "um",
          "millimetre", "mm",
          "centimetre", "cm",
          "decimetre", "dm",
          "metre", "m",
          "kilometre", "km",
        ),
        table.hline(),
        ..ge(
          "attosecond", "as",
          "femtosecond", "fs",
          "picosecond", "ps",
          "nanosecond", "ns",
          "microsecond", "us",
          "millisecond", "ms",
          "second", "s",
        ),
        table.hline(),
        ..ge(
          "femtomole", "fmol",
          "picomole", "pmol",
          "nanomole", "nmol",
          "micromole", "umol",
          "millimole", "mmol",
          "mole", "mol",
          "kilomole", "kmol",
        ),
        table.hline(),
        ..ge(
          "picoampere", "pA",
          "nanoampere", "nA",
          "microampere", "uA",
          "milliampere", "mA",
          "ampere", "A",
          "kiloampere", "kA",
        ),
        table.hline(),
        ..ge(
          "microlitre", "uL",
          "millilitre", "mL",
          "litre", "L",
          "hectolitre", "hL",
        )
      ),
      table(
        columns: 3,
        stroke: none,
        table.vline(),
        table.hline(),
        [Unit], [Abbreviation], [Symbol],
        table.hline(),
        ..ge(
          "millihertz", "mHz",
          "hertz", "Hz",
          "kilohertz", "kHz",
          "megahertz", "MHz",
          "gigahertz", "GHz",
          "terahertz", "THz",
        ),
        table.hline(),
        ..ge(
          "millinewton", "mN",
          "newton", "N",
          "kilonewton", "kN",
          "meganewton", "MN",
        ),
        table.hline(),
        ..ge(
          "pascal", "Pa",
          "kilopascal", "kPa",
          "megapascal", "MPa",
          "gigapascal", "GPa",
        ),
        table.hline(),
        ..ge(
          "milliohm", "mohm",
          "kilohm", "kohm",
          "megohm", "Mohm",
        ),
        table.hline(),
        ..ge(
          "picovolt", "pV",
          "nanovolt", "nV",
          "microvolt", "uV",
          "millivolt", "mV",
          "volt", "V",
          "kilovolt", "kV",
        ),
        table.hline(),
        ..ge(
          "watt", "W",
          "nanowatt", "nW",
          "microwatt", "uW",
          "milliwatt", "mW",
          "kilowatt", "kW",
          "megawatt", "MW",
          "gigawatt", "GW",
        ),
        table.hline(),
        ..ge(
          "joule", "J",
          "microjoule", "uJ",
          "millijoule", "mJ",
          "kilojoule", "kJ",
        ),
        table.hline(),
        ..ge(
          "electronvolt", "eV",
          "millielectronvolt", "meV",
          "kiloelectronvolt", "keV",
          "megaelectronvolt", "MeV",
          "gigaelectronvolt", "GeV",
          "teraelectronvolt", "TeV",
        ),
        table.hline(),
        ..ge(
          "kilowatt hour", "kWh"
        )
      ),
      table(
        columns: 3,
        stroke: none,
        table.vline(),
        table.hline(),
        [Unit], [Abbreviation], [Symbol],
        table.hline(),
        ..ge(
          "farad", "F",
          "femtofarad", "fF",
          "picofarad", "pF",
          "nanofarad", "nF",
          "microfarad", "uF",
          "millifarad", "mF",
        ),
        table.hline(),
        ..ge(
          "henry", "H",
          "femtohenry", "fH",
          "picohenry", "pH",
          "nanohenry", "nH",
          "millihenry", "mH",
          "microhenry", "uH",
        ),
        table.hline(),
        ..ge(
          "coulomb", "C",
          "nanocoulomb", "nC",
          "millicoulomb", "mC",
          "microcoulomb", "uC",
        ),
        table.hline(),
        ..ge(
          "kelvin", "K",
          "decibel", "dB",
          "astrnomicalunit", "au",
          "becquerel", "Bq",
          "candela", "cd",
          "dalton", "Da",
          "gray", "Gy",
          "hectare", "ha",
          "katal", "kat",
          "lumen", "lm",
          "neper", "Np",
          "radian", "rad",
          "sievert", "Sv",
          "steradian", "sr",
          "weber", "Wb"
        ),
        table.hline(),
        ..ge(
          "kilobyte", "kB",
          "megabyte", "MB",
          "gigabyte", "GB",
          "terabyte", "TB",
          "petabyte", "PB",
          "exabyte", "EB",
          "kibibyte", "KiB",
          "mebibyte", "MiB",
          "gibibyte", "GiB",
          "tebibyte", "TiB",
          "pebibyte", "PiB",
          "exbibyte", "EiB",
        ),
      )
    )
  )
)
}
= Creating 

The following functions can be used to define custom units, prefixes, powers and qualifiers that can be used with the `unit` function.

== Units
```typ
#declare-unit(unit, symbol, ..options)
```

Declare's a custom unit to be used with the `unit` and `qty` functions.

#param("unit", "string")[The string to use to identify the unit for string input.]
#param("symbol", "li")[The unit's symbol. A string or math content can be used. When using math content it is recommended to pass it through `unit` first.]

```example-stack
#let inch = "in"
#declare-unit("inch", inch)
#unit("inch / s")\
#unit($inch / s$)
```

== Prefixes
```typ
#create-prefix(symbol)
```
Use this function to correctly create the symbol for a prefix. Metro uses Typst's #link("https://typst.app/docs/reference/math/class/", `math.class`) function with the `class` parameter `"unary"` to designate a prefix. This function does it for you.

#param("symbol", "li")[The prefix's symbol. A string or math content can be used. When using math content it is recommended to pass it through `unit` first.]

```typ
#declare-prefix(prefix, symbol, power-tens)
```

Declare's a custom prefix to be used with the `unit` and `qty` functions.

#param("prefix", "string")[The string to use to identify the prefix for string input.]
#param("symbol", "li")[The prefix's symbol. This should be the output of the `create-prefix` function specified above.]
#param("power-tens", "nu")[The power ten of the prefix.]

```example-stack
#let myria = create-prefix("my")
#declare-prefix("myria", myria, 4)
#unit("myria meter")\
#unit($myria meter$)
```

== Powers
```typ
#declare-power(before, after, power)
```

This function adds two symbols for string input, one for use before a unit, the second for use after a unit, both of which are equivalent to the `power`. 

#param("before", "string")[The string that specifies this power before a unit.]
#param("after", "string")[The string that specifies this power after a unit.]
#param("power", "nu")[The power.]

```example-stack
#declare-power("quartic", "tothefourth", 4)
#unit("kilogram tothefourth")\
#unit("quartic metre")
```

== Qualifiers
```typ
#declare-qualifier(qualifier, symbol)
```

This function defines a custom qualifier for string input.

#param("qualifier", "string")[The string that specifies this qualifier.]
#param("symbol", "li")[The qualifier's symbol. Can be string or content.]

```example-stack
#declare-qualifier("polymer", "pol")
#declare-qualifier("catalyst", "cat")
#unit("gram polymer per mole catalyst per hour")
```