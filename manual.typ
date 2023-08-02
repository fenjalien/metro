#import "src/lib.typ": *

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

Typsets a unit and provides full control over output format for the unit. This function can be used in two different ways. 

The first way is "literally" in math mode, where the math content is parsed and any non-prefixes are separated by the `inter-unit-product` (by default a thin space) option and fractions are modified depending on the `frac-mode` option. Units within the `unit` function can be specified in three ways: a single letter (`$unit(m)$`, $unit(m)$); a string (`$unit("mol"^2)$`, $unit("mol"^2)$); or by importing the units as variable definitions: #pad[
  ```typ  
  #import "@preview/metro:0.1.0": unit, kg, mol
  #unit($kg m/s^2$)
  $unit(g_"polymer" mol_"cat" s^(-1))$
  ```
  #unit($kg m/s^2$)\
  $unit(g_"polymer" mol_"cat" s^(-1))$
]

The second way is an "intrepreted" system by passing the function a string delimited by the `interpreted-delimeter` option (default is "\#" to reflect Typst's equivalent of Latex's backslash).
#pad[
  ```typ
  #unit("#kilo#metre#cubed#second")\
  #unit("#kilo#gram#metre#per#square#second")\
  #unit("#gram#per#cubic#centi#metre")\
  #unit("#square#volt#cubic#lumen#per#farad")\
  #unit("#metre#squared#per#gray#cubic#lux")\
  #unit("#henry#second")
  ```
  #unit("#kilo#metre#cubed#second")\
  #unit("#kilo#gram#metre#per#square#second")\
  #unit("#gram#per#cubic#centi#metre")\
  #unit("#square#volt#cubic#lumen#per#farad")\
  #unit("#metre#squared#per#gray#cubic#lux")\
  #unit("#henry#second")
]
On its own, this is less convenient than the literal method. However, the package allows you to alter a variety of options.

=== Using Interpreted Mode
I'm not sure what to call these as in siunitx they are macros but here they are strings. But to not hurt my brain further trying to create a new name (apart from "thingymajigs") I'll call them macros for now.

When writing in interpreted mode several macros have been defined.

`#per` used as in "metres _per_ second".
#pad[
  ```typ
  #unit("#metre#per#second")
  ```
  #unit("#metre#per#second")
]

`#square` and `#cubic` apply their respective powers to the units after them, while `#squared` and `#cubed` apply to units before them. 
#pad[
  ```typ
  #unit("#square#becquerel")\
  #unit("#joule#squared#per#lumen")\
  #unit("#cubic#lux#volt#tesla#cubed")
  ```
  #unit("#square#becquerel")\
  #unit("#joule#squared#per#lumen")\
  #unit("#cubic#lux#volt#tesla#cubed")
]
Generic powers can be inserted using the `#tothe` and `#raiseto` macros. These act as functions and whatever is wrapped in its parantheses are taken as its argument.
#pad[
  ```typ
  #unit("#henry#tothe(5)")\
  #unit("#raiseto(4.5)#radian")
  ```
  #unit("#henry#tothe(5)")\
  #unit("#raiseto(4.5)#radian")
]

Generic qualifiers are available using the `#of` macro:
#pad[
  ```typ
  #unit("#kilogram#of(metal)")\
  #unit("#milli#mole#of(cat)#per#kilogram#of(prod)", qualifier-mode: "bracket")
  ```
  #unit("#kilogram#of(metal)")\
  #unit("#milli#mole#of(cat)#per#kilogram#of(prod)", qualifier-mode: "bracket")
]


=== Options
The following options affect both literal and interpreted mode.

#param("inter-unit-product", "li", default: "sym.space.thin", [
The separator between each unit. The default setting is a thin space: another common choice is a centred dot.
```typ
#unit("#farad#squared#lumen#candela")\
#unit("#farad#squared#lumen#candela", inter-unit-product: $dot.c$)
```
#unit("#farad#squared#lumen#candela")\
#unit("#farad#squared#lumen#candela", inter-unit-product: $dot.c$)
])

#param("per-symbol", "li", default: "h(0pt) + sym.slash + h(0pt)")[
  The symbol to use to separate the two parts of a unit when `per-symbol` is `"symbol"`.
  #pad[
    ```typ
    #unit("#joule#per#mole#per#kelvin", per-mode: "symbol", per-symbol: [ div ])
    ```
    #unit("#joule#per#mole#per#kelvin", per-mode: "symbol", per-symbol: [ div ])
  ]
]

#line(length: 100%)

The following option affects only literal mode.

#param("frac-mode", "ch", default: "symbol")[
  Use to alter the handling of a `math.frac` function. These are normally created in math mode by using a slash `/`.

  / symbol: Separates the numerator and the denominator using the symbol in `per-symbol`.
  #pad[
    ```typ
    $unit(joule / \(mole kelvin))$\
    $unit(meter / second^2)$
    ```
    $unit(joule / \(mole kelvin))$\
    $unit(meter / second^2)$
  ]

  / frac: This leaves the `math.frac` as it is.
  #pad[
    ```typ
    #metro-setup(frac-mode: "frac")
    $unit(joule / (mole kelvin))$\
    $unit(meter / second^2)$
    ```
    #metro-setup(frac-mode: "frac")
    $unit(joule / (mole kelvin))$\
    $unit(meter / second^2)$
  ]
]

#line(length: 100%)

The following options affect only interpreted mode.

#param("per-mode", "ch", default: "power", [
  Use to alter the handling of `per`. 

  / power: Reciprocal powers
  #pad[
  ```typ
  #unit("#joule#per#mole#per#kelvin")\
  #unit("#metre#per#second#squared")
  ```
  #unit("#joule#per#mole#per#kelvin")\
  #unit("#metre#per#second#squared")]

  / fraction: Uses the `math.frac` function (also known as `$ / $`) to typeset positive and negative powers of a unit separately.
  #pad[```typ
  #unit("#joule#per#mole#per#kelvin", per-mode: "fraction")\
  #unit("#metre#per#second#squared", per-mode: "fraction")
  ```
  #unit("#joule#per#mole#per#kelvin", per-mode: "fraction")\
  #unit("#metre#per#second#squared", per-mode: "fraction")]

  / symbol: Separates the two parts of a unit using the symbol in `per-symbol`. This method for displaying units can be ambiguous, and so brackets are added unless `bracket-unit-denominator` is set to `false`. Notice that `bracket-unit-denominator` only applies when `per-mode` is set to symbol.
  #pad[```typ
  #metro-setup(per-mode: "symbol")
  #unit("#joule#per#mole#per#kelvin")\
  #unit("#metre#per#second#squared")
  ```
  #metro-setup(per-mode: "symbol")
  #unit("#joule#per#mole#per#kelvin")\
  #unit("#metre#per#second#squared")
  ]
])


#param("bracket-unit-denominator", "sw", default: "true")[
  Whether or not to add brackets to unit denominators when `per-symbol` is `"symbol"`.
  #pad[
    ```typ
    #unit("#joule#per#mole#per#kelvin", per-mode: "symbol", bracket-unit-denominator: false)
    ```
    #unit("#joule#per#mole#per#kelvin", per-mode: "symbol", bracket-unit-denominator: false)
  ]
]

#metro-setup(per-mode: "power")

#param("sticky-per", "sw", default: "false")[
  Normally, `per` applies only to the next unit given. When `sticky-per` is `true`, this behaviour is changed so that `per` applies to all subsequent units.
  #pad[
    ```typ
    #unit("#pascal#per#gray#henry")\
    #unit("#pascal#per#gray#henry", sticky-per: true)
    ```
    #unit("#pascal#per#gray#henry")\
    #unit("#pascal#per#gray#henry", sticky-per: true)
  ]
]

#param("qualifier-mode", "ch", default: "subscript")[
  Sets how unit qualifiers can be printed.
  / subscript:
  #pad[
    ```typ
    #unit("#kilogram#of(pol)#squared#per#mole#of(cat)#per#hour")
    ```
    #unit("#kilogram#of(pol)#squared#per#mole#of(cat)#per#hour")
  ]

  / bracket:
  #pad[
    ```typ
    #unit("#kilogram#of(pol)#squared#per#mole#of(cat)#per#hour", qualifier-mode: "bracket")
    ```
    #unit("#kilogram#of(pol)#squared#per#mole#of(cat)#per#hour", qualifier-mode: "bracket")
  ]

  / combine: Powers can lead to ambiguity and are automatically detected and brackets added as appropriate.
  #pad[
    ```typ
    #unit("#deci#bel#of(i)", qualifier-mode: "combine")
    ```
    #unit("#deci#bel#of(i)", qualifier-mode: "combine")
  ]

  /phrase: Used with `qualifier-phrase`, which allows for example a space or othre linking text to be inserted.
  #pad[
    ```typ
    #metro-setup(qualifier-mode: "phrase", qualifier-phrase: sym.space)
    #unit("#kilogram#of(pol)#squared#per#mole#of(cat)#per#hour")\
    #metro-setup(qualifier-phrase: " of ")
    #unit("#kilogram#of(pol)#squared#per#mole#of(cat)#per#hour")
    ```
    #metro-setup(qualifier-mode: "phrase", qualifier-phrase: sym.space)
    #unit("#kilogram#of(pol)#squared#per#mole#of(cat)#per#hour")\
    #metro-setup(qualifier-phrase: " of ")
    #unit("#kilogram#of(pol)#squared#per#mole#of(cat)#per#hour")
  ]
]

#param("power-half-as-sqrt", "sw", default: "false")[
  When `true` the power of $0.5$ is shown by giving the unit sumbol as a square root.
  #pad[
    ```typ
    #unit("#Hz#tothe(0.5)")\
    #unit("#Hz#tothe(0.5)", power-half-as-sqrt: true)
    ```
    #unit("#Hz#tothe(0.5)")\
    #unit("#Hz#tothe(0.5)", power-half-as-sqrt: true)
  ]
]

#param("interpreted-delimeter", "string", default: "#")[
  The delimeter to use to separate the macros in intepreted mode.
  #pad[
    ```typ
    #unit("#joule#per#mole#per#kelvin")\
    #unit("joule per mole per kelvin", interpreted-delimeter: " ")
    ```
    #unit("#joule#per#mole#per#kelvin")\
    #unit("joule per mole per kelvin", interpreted-delimeter: " ")
  ]
  Note that the first macro does not actually need the delimeter.
]

== Quantities

= Meet the Units

The following tables show the currently supported prefixes, units and their abbreviations. Note that unit abbreviations that have single letter commands are not available for import for use in literal mode as math mode accepts single letters.

// Turn off tables while editing docs as compiling tablex is very slow
#if true {

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
      "quecto", "deca",
      "ronto", "hecto",
      "yocto", "kilo", 
      "atto", "mega",
      "zepto", "giga",
      "femto", "tera",
      "pico", "peta",
      "nano", "exa",
      "micro", "zetta",
      "milli", "yotta",
      "centi", "ronna",
      "deci", "quetta"
    ).map(x => (x, raw(x), unit(prefixes._dict.at(x).symbol), num(prefixes._dict.at(x).power))).join()),
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
