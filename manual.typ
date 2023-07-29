#import "src/lib.typ": *

#show link: set text(blue)

#let param(term, t, default: none, description) = {
  let types = (
    b: `boolean`,
    s: `string`,
    i: `integer`,
    d: `dictionary`,
    a: `array`,
    n: `number`,
    c: `content`,
    f: `float`
  )
  if type(t) == "string" {
    t = t.replace("?", "|none")
    t = `<` + t.split("|").map(s => types.at(s, default: raw(s))).join(`|`) + `>`
  }

  stack(dir: ltr, [/ #term: #t \ #description], align(right, if default != none {[(default: #default)]}))
}

#align(center, text(16pt)[Metro])

#outline()

#pagebreak()

#set heading(numbering: (..a) => if a.pos().len() < 3 {
  numbering("1.1", ..a)
})

// #show heading.where(level: 4): pad.with(left: 1em)

= Introduction

The Metro package aims to be a port of the Latex package siunitx. It allows easy typesetting of numbers and units with options. This package is very early in development and many features are missing, so any feature requests or bug reports are welcome!

Metro's name comes from Metrology, the study scientific study of measurement.

= Usage

== Options

```typ
#metro-setup(..options)
```

Options for Metro's can be modified by using the `metro-setup` function. It takes an argument sink and saves any named parameters found. The options for each function are specified in their respective sections.

== Numbers
```typ
#num(number, e: none, pm: none, ..options)
```
Formats a number.

#param("number", "f|i|c", "The number to format.")
#param("pm", "f|i|c?", "Uncertainty of the number.")
#param("e", "i?", "Exponent. The exponent is applied to both the number and the uncertainty if given.")

=== Options

#param("times", "c", "The symbol")


== Units

```typ
#unit(unit, ..options)
```

Typsets a unit and provides full control over output format for the unit. This function can be used in two different ways

== Quantities

$ unit(kilo (m/s^2)) $
$ unit(g_"polymer" mol_"cat" s^(-1)) $

#metro-setup(power-half-as-sqrt: true)


#unit("#kilo#metre#cubed#second")

#unit("#kilo#gram#metre#per#square#second")

#unit("#gram#per#cubic#centi#metre")

#unit("#square#volt#cubic#lumen#per#farad")

#declare-unit("meter", $m$)

#unit("#meter#squared#per#gray#cubic#lux")

#unit("#henry#second")

#unit("#henry#tothe(5)")

#unit("#raiseto(4.5)#radian")

#unit("#joule#per#mole#per#kelvin")

#unit("#joule#per#mole#kelvin")

#unit("#per#henry#tothe(5)")

#unit("#per#square#becquerel")

#unit("#kilogram#of(metal)")

#qty(0.1, "#milli#mole#of(cat)#per#kilogram#of(prod)")

#unit("#farad#squared#lumen#candela")

#unit("#farad#squared#lumen#candela", inter-unit-product: $dot.c$)

#unit("#joule#per#mole#per#kelvin")

#unit("#metre#per#second#squared")

#unit("#joule#per#mole#per#kelvin", per-mode: "fraction")

#unit("#metre#per#second#squared", per-mode: "fraction")

#metro-setup(per-mode: "symbol")

#unit("#joule#per#mole#per#kelvin")

#unit("#metre#per#second#squared")

#unit("#joule#per#mole#per#kelvin", per-symbol: [ div ])

#unit("#joule#per#mole#per#kelvin", bracket-unit-denominator: false)

#[
  #show math.equation: it => {
    metro-setup(per-mode: if it.block {
      "fraction"
    } else { "symbol" })
    it
  }
$#unit("#joule#per#mole#per#kelvin")$
$ #unit("#joule#per#mole#per#kelvin") $
]

#metro-setup(per-mode: "power")
#unit("#pascal#per#gray#henry")

#unit("#pascal#per#gray#henry", sticky-per: true)

#unit("#kilogram#of(pol)#squared#per#mole#of(cat)#per#hour")

#unit("#kilogram#of(pol)#squared#per#mole#of(cat)#per#hour", qualifier-mode: "bracket")

#unit("#deci#bel#of(i)", qualifier-mode: "combine")

#metro-setup(qualifier-mode: "phrase", qualifier-phrase: sym.space)

#unit("#kilogram#of(pol)#squared#per#mole#of(cat)#per#hour")

#metro-setup(qualifier-phrase: " of ")

#unit("#kilogram#of(pol)#squared#per#mole#of(cat)#per#hour")

#unit("#Hz#tothe(0.5)")

#unit("#Hz#tothe(0.5)", power-half-as-sqrt: true)

