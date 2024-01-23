#import "/src/lib.typ": unit, metro-setup
#set page(width: auto, height: auto)

#unit("kilogram of(pol) squared per mole of(cat) per hour")

#unit("kilogram of(pol) squared per mole of(cat) per hour", qualifier-mode: "bracket")

#unit("deci bel of(i)", qualifier-mode: "combine")

#metro-setup(qualifier-mode: "phrase", qualifier-phrase: sym.space)

#unit("kilogram of(pol) squared per mole of(cat) per hour")

#unit("kilogram of(pol) squared per mole of(cat) per hour", qualifier-phrase: [ of ])
