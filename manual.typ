#import "src/lib.typ": *

// #let u-dict = units._dict
// #u-dict.insert("meter", units.metre)
// $ unit(kilo/1) $
// #u
$ unit(kg m/s^2) $
$ unit(g_"polymer" mol_"cat" s^(-1)) $

#unit("#kilo#metre#cubed#second")

#unit("#kilo#gram#metre#per#square#second")

#unit("#gram#per#cubic#centi#metre")

#unit("#square#volt#cubic#lumen#per#farad")

#declare-unit("meter", $m$)

#unit("#meter#squared#per#gray#cubic#lux")

#unit("#henry#second")

#unit("#henry#tothe(5)")

#unit("#raiseto(4.5)#radian")

#unit("#joule#per#mole#per#kelivn")

#unit("#joule#per#mole#kelivn")

#unit("#per#henry#tothe(5)")

#unit("#per#square#becquerel")

#unit("#kilogram#of(metal)")

#qty(0.1, "#milli#mole#of(cat)#per#kilogram#of(prod)")

#unit("#farad#squared#lumen#candela")

#unit("#farad#squared#lumen#candela", inter-unit-product: $dot.c$)

