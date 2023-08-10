#import "src/lib.typ": *
#import units: *
#import prefixes: *

#import "@preview/tablex:0.0.4": tablex, hlinex, vlinex

#show link: set text(blue)

#let param(term, t, default: none, description) = {
  let types = (
    ch: "Choice",
    nu: "Number",
    li: "Literal",
    sw: "Switch",
  )


  if default != none {
    if t == "ch" {
      default = repr(default)
    }
    default = align(top + right, [(default: #raw(default))])
  }

  t = text(types.at(t, default: t), font: "Source Code Pro")

  stack(
    dir: ltr, 
    [*#term*#h(0.6em, weak: true)#t], 
    default
  )
  block(pad(description, left: 2em), above: 0.65em)
}

#align(center, text(16pt)[Metro])

#outline(indent: auto)

#pagebreak()

#set heading(numbering: "1.1")
// #set heading(numbering: (..a) => if a.pos().len() < 3 {
//   numbering("1.1", ..a)
// })

= Introduction

The Metro package aims to be a port of the Latex package siunitx. It allows easy typesetting of numbers and units with options. This package is very early in development and many features are missing, so any feature requests or bug reports are welcome!

Metro's name comes from Metrology, the study scientific study of measurement.

= Usage
#set pad(left: 1em)

== Options

```typ
#metro-setup(..options)
```

Options for Metro's can be modified by using the `metro-setup` function. It takes an argument sink and saves any named parameters found. The options for each function are specified in their respective sections.

All options and function parameters use the following types:
/ `Literal`: Takes the given value directly. Input type is a string, content and sometimes a number.
/ `Switch`: On-off switches. Input type is a boolean.
/ `Choice`: Takes a limited number of choices, which are described separately for each option. Input type is a string.
/ `Number`: Takes a float or integer.

== Numbers
```typ
#num(number, e: none, pm: none, ..options)
```
Formats a number.

#param("number", "nu", "The number to format.")
#param("pm", "li", default: "none", "Uncertainty of the number.")
#param("e", "nu", default: "none", "Exponent. The exponent is applied to both the number and the uncertainty if given.")

#pad[
  ```typ
  ```
  #num(123)\
  #num(-1234)\
  #num(12345)\
]

=== Options

#param("times", "c", "The symbol")


== Units

```typ
#unit(unit, ..options)
```

Typsets a unit and provides full control over output format for the unit. The type passed to the function can be either a string or some math content.

When using math Typst accepts single characters but multiple characters together are expected to be variables. So Metro defines units and prefixes which you can import to be use. #pad[
  ```typ
  #import "@preview/metro:0.1.0": unit, units, prefixes
  #unit($units.kg m/s^2$)
  // because `units` and `prefixes` here are modules you can import what you need
  #import units: gram, metre, second
  #import prefixes: kilo
  $unit(kilo gram / metre second^2)$
  // You can also just import everything instead
  #import units: *
  #import prefixes: *
  $unit(joule / mole / kelvin)$
  ```

  #unit($units.kg m/s^2$)\
  $unit(kilo gram metre / second^2)$\
  $unit(joule / mole / kelvin)$
]

When using strings there is no need to import any units or prefixes as the string is parsed. Additionally several variables have been defined to allow the string to be more human readable. You can also use the same syntax as with math mode. #pad[
  ```typ
  // String
  #unit("kilo gram metre per square second")\
  // Math equivalent
  #unit($kilo gram metre / second^2$)\
  // String using math syntax
  #unit("kilo gram metre / second^2")
  ```
  // String
  #unit("kilo gram metre per square second")\
  // Math equivalent
  #unit($kilo gram metre / second^2$)\
  // String using math syntax
  #unit("kilo gram metre / second^2")
]

`per` used as in "metres _per_ second" is equivalent to a slash `/`. When using this in a string you don't need to specify a numerator.
#pad[
  ```typ
  #unit("metre per second")\
  $unit(metre/second)$

  #unit("per square becquerel")\
  #unit("/becquerel^2")
  ```
  #unit("metre per second")\
  $unit(metre/second)$

  #unit("per square becquerel")\
  #unit("/becquerel^2")
]

`square` and `cubic` apply their respective powers to the units after them, while `squared` and `cubed` apply to units before them. 
#pad[
  ```typ
  #unit("square becquerel")\
  #unit("joule squared per lumen")\
  #unit("cubic lux volt tesla cubed")
  ```
  #unit("square becquerel")\
  #unit("joule squared per lumen")\
  #unit("cubic lux volt tesla cubed")
]
Generic powers can be inserted using the `tothe` and `raiseto` functions. `tothe` specifically is equivalent to using caret `^`.
#pad[
  ```typ
  #unit("henry tothe(5)")\
  #unit($henry^5$)\
  #unit("henry^5")

  #unit("raiseto(4.5) radian")\
  #unit($radian^4.5$)\
  #unit("radian^4.5")
  ```
  #unit("henry tothe(5)")\
  #unit($henry^5$)\
  #unit("henry^5")

  #unit("raiseto(4.5) radian")\
  #unit($radian^4.5$)\
  #unit("radian^4.5")
]

Generic qualifiers are available using the `of` function which is equivalent to using an underscore `_`. Note that when using an underscore for qualifiers in a string with a space, to capture the whole qualifier use brackets `()`.
#pad[
  ```typ
  #unit("kilogram of(metal)")\
  #unit($kilogram_"metal"$)\
  #unit("kilogram_metal")

  #metro-setup(qualifier-mode: "bracket")
  #unit("milli mole of(cat) per kilogram of(prod)")\
  #unit($milli mole_"cat" / kilogram_"prod"$)\
  #unit("milli mole_(cat) / kilogram_(prod)")
  ```
  #unit("kilogram of(metal)")\
  #unit($kilogram_"metal"$)\
  #unit("kilogram_metal")

  #metro-setup(qualifier-mode: "bracket")
  #unit("milli mole of(cat) per kilogram of(prod)")\
  #unit($milli mole_"cat" / kilogram_"prod"$)\
  #unit("milli mole_(cat) / kilogram_(prod)")
  #metro-setup(qualifier-mode: "subscript")
]

=== Options

#param("inter-unit-product", "li", default: "sym.space.thin", [
The separator between each unit. The default setting is a thin space: another common choice is a centred dot.
```typ
#unit("farad squared lumen candela")\
#unit("farad squared lumen candela", inter-unit-product: $dot.c$)
```
#unit("farad squared lumen candela")\
#unit("farad squared lumen candela", inter-unit-product: $dot.c$)
])


#param("per-mode", "ch", default: "power", [
  Use to alter the handling of `per`. 

  / power: Reciprocal powers
  #pad[
    ```typ
    #unit("joule per mole per kelvin")\
    #unit("metre per second squared")
    ```
    #unit("joule per mole per kelvin")\
    #unit("metre per second squared")
  ]

  / fraction: Uses the `math.frac` function (also known as `$ / $`) to typeset positive and negative powers of a unit separately.
  #pad[```typ
  #unit("joule per mole per kelvin", per-mode: "fraction")\
  #unit("metre per second squared", per-mode: "fraction")
  ```
  #unit("joule per mole per kelvin", per-mode: "fraction")\
  #unit("metre per second squared", per-mode: "fraction")]

  / symbol: Separates the two parts of a unit using the symbol in `per-symbol`. This method for displaying units can be ambiguous, and so brackets are added unless `bracket-unit-denominator` is set to `false`. Notice that `bracket-unit-denominator` only applies when `per-mode` is set to symbol.
  #pad[```typ
  #metro-setup(per-mode: "symbol")
  #unit("joule per mole per kelvin")\
  #unit("metre per second squared")
  ```
  #metro-setup(per-mode: "symbol")
  #unit("joule per mole per kelvin")\
  #unit("metre per second squared")
  ]
])

#param("per-symbol", "li", default: "sym.slash")[
  The symbol to use to separate the two parts of a unit when `per-symbol` is `"symbol"`.
  #pad[
    ```typ
    #unit("joule per mole per kelvin", per-mode: "symbol", per-symbol: [ div ])
    ```
    #unit("joule per mole per kelvin", per-mode: "symbol", per-symbol: [ div ])
  ]
]

#param("bracket-unit-denominator", "sw", default: "true")[
  Whether or not to add brackets to unit denominators when `per-symbol` is `"symbol"`.
  #pad[
    ```typ
    #unit("joule per mole per kelvin", per-mode: "symbol", bracket-unit-denominator: false)
    ```
    #unit("joule per mole per kelvin", per-mode: "symbol", bracket-unit-denominator: false)
  ]
]

#metro-setup(per-mode: "power")

#param("sticky-per", "sw", default: "false")[
  Normally, `per` applies only to the next unit given. When `sticky-per` is `true`, this behaviour is changed so that `per` applies to all subsequent units.
  #pad[
    ```typ
    #unit("pascal per gray henry")\
    #unit("pascal per gray henry", sticky-per: true)
    ```
    #unit("pascal per gray henry")\
    #unit("pascal per gray henry", sticky-per: true)
  ]
]

#param("qualifier-mode", "ch", default: "subscript")[
  Sets how unit qualifiers can be printed.
  / subscript:
  #pad[
    ```typ
    #unit("kilogram of(pol) squared per mole of(cat) per hour")
    ```
    #unit("kilogram of(pol) squared per mole of(cat) per hour")
  ]

  / bracket:
  #pad[
    ```typ
    #unit("kilogram of(pol) squared per mole of(cat) per hour", qualifier-mode: "bracket")
    ```
    #unit("kilogram of(pol) squared per mole of(cat) per hour", qualifier-mode: "bracket")
  ]

  / combine: Powers can lead to ambiguity and are automatically detected and brackets added as appropriate.
  #pad[
    ```typ
    #unit("deci bel of(i)", qualifier-mode: "combine")
    ```
    #unit("deci bel of(i)", qualifier-mode: "combine")
  ]

  / phrase: Used with `qualifier-phrase`, which allows for example a space or othre linking text to be inserted.
  #pad[
    ```typ
    #metro-setup(qualifier-mode: "phrase", qualifier-phrase: sym.space)
    #unit("kilogram of(pol) squared per mole of(cat) per hour")\
    #metro-setup(qualifier-phrase: [ of ])
    #unit("kilogram of(pol) squared per mole of(cat) per hour")
    ```
    #metro-setup(qualifier-mode: "phrase", qualifier-phrase: sym.space)
    #unit("kilogram of(pol) squared per mole of(cat) per hour")\
    #metro-setup(qualifier-phrase: [ of ])
    #unit("kilogram of(pol) squared per mole of(cat) per hour")
  ]
  
]

#param("power-half-as-sqrt", "sw", default: "false")[
  When `true` the power of $0.5$ is shown by giving the unit sumbol as a square root.
  #pad[
    ```typ
    #unit("Hz tothe(0.5)")\
    #unit("Hz tothe(0.5)", power-half-as-sqrt: true)
    ```
    #unit("Hz tothe(0.5)")\
    #unit("Hz tothe(0.5)", power-half-as-sqrt: true)
  ]
]

// #param("interpreted-delimeter", "string", default: "#")[
//   The delimeter to use to separate the macros in intepreted mode.
//   #pad[
//     ```typ
//     #unit("#joule#per#mole#per#kelvin")\
//     #unit("joule per mole per kelvin", interpreted-delimeter: " ")
//     ```
//     #unit("#joule#per#mole#per#kelvin")\
//     #unit("joule per mole per kelvin", interpreted-delimeter: " ")
//   ]
//   Note that the first macro does not actually need the delimeter.
// ]

#metro-reset()

== Quantities

= Meet the Units

The following tables show the currently supported prefixes, units and their abbreviations. Note that unit abbreviations that have single letter commands are not available for import for use in math it accepts single letters.


// Turn off tables while editing docs as compiling tablex is very slow
#if false {

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
  tablex(
    columns: 3,
    auto-lines: false,
    hlinex(),
    ..headers,
    hlinex(),
    ..generate(
      "ampere",
      "candela",
      "kelvin",
      "kilogram",
      "metre",
      "mole",
      "second"
    ),
    hlinex(),
  ),
  caption: [SI base units.]
)

figure(
  tablex(
    columns: 6,
    auto-lines: false,
    hlinex(),
    ..headers * 2,
    hlinex(),
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
    hlinex()
  ),
  caption: [Coherent derived units in the SI with special names and symbols.]
)

figure(
  tablex(
    columns: 3,
    auto-lines: false,
    hlinex(),
    ..headers,
    hlinex(),
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
    hlinex(),
  ),
  caption: [Non-SI units accepted for use with the International System of Units.]
)

figure(
  tablex(
    columns: 8,
    auto-lines: false,
    hlinex(),
    ..([Prefix], [Command], [Symbol], [Power]) * 2,
    hlinex(),
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
    hlinex(),
  ),
  caption: [SI prefixes]
)
let ge(..xs) = {
  let xs = xs.pos()
  for i in range(0, xs.len()-1, step: 2) {
    let abbr = xs.at(i+1)
    (xs.at(i), raw(abbr), unit(abbr))
  }
}

page(
  margin: 1cm,
  figure(
    caption: [Unit abbreviations],
    stack(
      dir: ltr,
      tablex(
        columns: 3,
        auto-lines: false,
        hlinex(),
        [Unit], [Abbreviation], [Symbol],
        hlinex(),
        ..ge(
          "femtogram", "fg",
          "picogram", "pg",
          "nanogram", "ng",
          "microgram", "ug",
          "milligram", "mg",
          "gram", "g",
          "kilogram", "kg"
        ),
        hlinex(),
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
        hlinex(),
        ..ge(
          "attosecond", "as",
          "femtosecond", "fs",
          "picosecond", "ps",
          "nanosecond", "ns",
          "microsecond", "us",
          "millisecond", "ms",
          "second", "s",
        ),
        hlinex(),
        ..ge(
          "femtomole", "fmol",
          "picomole", "pmol",
          "nanomole", "nmol",
          "micromole", "umol",
          "millimole", "mmol",
          "mole", "mol",
          "kilomole", "kmol",
        ),
        hlinex(),
        ..ge(
          "picoampere", "pA",
          "nanoampere", "nA",
          "microampere", "uA",
          "milliampere", "mA",
          "ampere", "A",
          "kiloampere", "kA",
        ),
        hlinex(),
        ..ge(
          "microlitre", "uL",
          "millilitre", "mL",
          "litre", "L",
          "hectolitre", "hL",
        )
      ),
      tablex(
        columns: 3,
        auto-lines: false,
        vlinex(),
        hlinex(),
        [Unit], [Abbreviation], [Symbol],
        hlinex(),
        ..ge(
          "millihertz", "mHz",
          "hertz", "Hz",
          "kilohertz", "kHz",
          "megahertz", "MHz",
          "gigahertz", "GHz",
          "terahertz", "THz",
        ),
        hlinex(),
        ..ge(
          "millinewton", "mN",
          "newton", "N",
          "kilonewton", "kN",
          "meganewton", "MN",
        ),
        hlinex(),
        ..ge(
          "pascal", "Pa",
          "kilopascal", "kPa",
          "megapascal", "MPa",
          "gigapascal", "GPa",
        ),
        hlinex(),
        ..ge(
          "milliohm", "mohm",
          "kilohm", "kohm",
          "megohm", "Mohm",
        ),
        hlinex(),
        ..ge(
          "picovolt", "pV",
          "nanovolt", "nV",
          "microvolt", "uV",
          "millivolt", "mV",
          "volt", "V",
          "kilovolt", "kV",
        ),
        hlinex(),
        ..ge(
          "watt", "W",
          "nanowatt", "nW",
          "microwatt", "uW",
          "milliwatt", "mW",
          "kilowatt", "kW",
          "megawatt", "MW",
          "gigawatt", "GW",
        ),
        hlinex(),
        ..ge(
          "joule", "J",
          "microjoule", "uJ",
          "millijoule", "mJ",
          "kilojoule", "kJ",
        ),
        hlinex(),
        ..ge(
          "electronvolt", "eV",
          "millielectronvolt", "meV",
          "kiloelectronvolt", "keV",
          "megaelectronvolt", "MeV",
          "gigaelectronvolt", "GeV",
          "teraelectronvolt", "TeV",
        ),
        hlinex(),
        ..ge(
          "kilowatt hour", "kWh"
        )
      ),
      tablex(
        columns: 3,
        auto-lines: false,
        vlinex(),
        hlinex(),
        [Unit], [Abbreviation], [Symbol],
        hlinex(),
        ..ge(
          "farad", "F",
          "femtofarad", "fF",
          "picofarad", "pF",
          "nanofarad", "nF",
          "microfarad", "uF",
          "millifarad", "mF",
        ),
        hlinex(),
        ..ge(
          "henry", "H",
          "femtohenry", "fH",
          "picohenry", "pH",
          "nanohenry", "nH",
          "millihenry", "mH",
          "microhenry", "uH",
        ),
        hlinex(),
        ..ge(
          "coulomb", "C",
          "nanocoulomb", "nC",
          "millicoulomb", "mC",
          "microcoulomb", "uC",
        ),
        hlinex(),
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
      )
    )
  )
)
}

= Creating 

The following functions can be used to define cutom units, prefixes, powers and qualifiers that can be used with the `unit` function.

== Units
```typ
#declare-unit(unit, symbol, ..options)
```

Declare's a custom unit to be used with the `unit` and `qty` functions.

#param("unit", "string")[The string to use to identify the unit for string input.]
#param("symbol", "li")[The unit's symbol. A string or math content can be used. When using math content it is recommended to pass it through `unit` first.]

#pad[
  ```typ
  #let inch = "in"
  #declare-unit("inch", inch)
  #unit("inch / s")\
  #unit($inch / s$)
  ```
  #let inch = "in"
  #declare-unit("inch", inch)
  #unit("inch / s")\
  #unit($inch / s$)
]

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

#pad[
  ```typ
  #let myria = create-prefix("my")
  #declare-prefix("myria", myria, 4)
  #unit("myria meter")\
  #unit($myria meter$)
  ```
  #let myria = create-prefix("my")
  #declare-prefix("myria", myria, 4)
  #unit("myria meter")\
  #unit($myria meter$)
]

== Powers
```typ
#declare-power(before, after, power)
```

This function adds two symbols for string input, one for use before a unit, the second for ues after a unit, obth of which are equivalent to the `power`. 

#param("before", "string")[The string that specifies this power before a unit.]
#param("after", "string")[The string that specifies this power after a unit.]
#param("power", "nu")[The power.]

#pad[
  ```typ
  #declare-power("quartic", "tothefourth", 4)
  #unit("kilogram tothefourth")\
  #unit("quartic metre")
  ```
  #declare-power("quartic", "tothefourth", 4)
  #unit("kilogram tothefourth")\
  #unit("quartic metre")
]

== Qualifiers
```typ
#declare-qualifier(qualifier, symbol)
```

This function defines a custom qualifier for string input.

#param("qualifier", "string")[The string that specifies this qualifier.]
#param("symbol", "li")[The qualifier's symbol. Can be string or content.]

#pad[
  ```typ
  #declare-qualifier("polymer", "pol")
  #declare-qualifier("catalyst", "cat")
  #unit("gram polymer per mole catalyst per hour")
  ```
  #declare-qualifier("polymer", "pol")
  #declare-qualifier("catalyst", "cat")
  #unit("gram polymer per mole catalyst per hour")
]